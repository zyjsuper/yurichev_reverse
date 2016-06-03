m4_include(`commons.m4')

_HEADER_HL1(`2-Jun-2016: C/C++ pointers: pointers abuse in Windows kernel')

<p>(For those who have a hard time in understanding C/C++ pointers).</p>

<p>
(First part _HTML_LINK(`http://yurichev.com/blog/ptrs/',`here'), second is _HTML_LINK(`http://yurichev.com/blog/ptrs2/',`here')).
</p>

<p>The resource section of PE executable file in Windows OS is a section containing pictures, icons, strings, etc.
Early Windows versions allowed to address resources only by IDs, but then Microsoft added a way to address them using strings.</p>

<p>So then it would be possible to pass ID or string to 
_HTML_LINK(`https://msdn.microsoft.com/en-us/library/windows/desktop/ms648042%28v=vs.85%29.aspx',`FindResource()') function.
Which is declared like this:</p>

_PRE_BEGIN
HRSRC WINAPI FindResource(
  _In_opt_ HMODULE hModule,
  _In_     LPCTSTR lpName,
  _In_     LPCTSTR lpType
);
_PRE_END

<p><i>lpName</i> and <i>lpType</i> has <i>char*</i> or <i>wchar*</i> types, and when someone still wants to pass ID, he/she should use
_HTML_LINK(`https://msdn.microsoft.com/en-us/library/windows/desktop/ms648029%28v=vs.85%29.aspx',`MAKEINTRESOURCE') macro, like this:</p>

_PRE_BEGIN
result = FindResource(..., MAKEINTRESOURCE(1234), ...);
_PRE_END

<p>It's interesting fact that MAKEINTRESOURCE is merely casting integer to pointer.
In MSVC 2013, in the file <i>Microsoft SDKs\Windows\v7.1A\Include\Ks.h</i> we can find this:</p>

_PRE_BEGIN
...

#if (!defined( MAKEINTRESOURCE )) 
#define MAKEINTRESOURCE( res ) ((ULONG_PTR) (USHORT) res)
#endif

...
_PRE_END

<p>Sounds insane. Let's peek into ancient leaked Windows NT4 source code.
In <i>private/windows/base/client/module.c</i> we can find <i>FindResource()</i> source code:</p>

_PRE_BEGIN
HRSRC
FindResourceA(
    HMODULE hModule,
    LPCSTR lpName,
    LPCSTR lpType
    )

...

{
    NTSTATUS Status;
    ULONG IdPath[ 3 ];
    PVOID p;

    IdPath[ 0 ] = 0;
    IdPath[ 1 ] = 0;
    try {
        if ((IdPath[ 0 ] = BaseDllMapResourceIdA( lpType )) == -1) {
            Status = STATUS_INVALID_PARAMETER;
            }
        else
        if ((IdPath[ 1 ] = BaseDllMapResourceIdA( lpName )) == -1) {
            Status = STATUS_INVALID_PARAMETER;
...
_PRE_END

<p>Let's proceed to <i>BaseDllMapResourceIdA()</i> in the same source file:</p>

_PRE_BEGIN
ULONG
BaseDllMapResourceIdA(
    LPCSTR lpId
    )
{
    NTSTATUS Status;
    ULONG Id;
    UNICODE_STRING UnicodeString;
    ANSI_STRING AnsiString;
    PWSTR s;

    try {
        if ((ULONG)lpId & LDR_RESOURCE_ID_NAME_MASK) {
            if (*lpId == '#') {
                Status = RtlCharToInteger( lpId+1, 10, &Id );
                if (!NT_SUCCESS( Status ) || Id & LDR_RESOURCE_ID_NAME_MASK) {
                    if (NT_SUCCESS( Status )) {
                        Status = STATUS_INVALID_PARAMETER;
                        }
                    BaseSetLastNTError( Status );
                    Id = (ULONG)-1;
                    }
                }
            else {
                RtlInitAnsiString( &AnsiString, lpId );
                Status = RtlAnsiStringToUnicodeString( &UnicodeString,
                                                       &AnsiString,
                                                       TRUE
                                                     );
                if (!NT_SUCCESS( Status )){
                    BaseSetLastNTError( Status );
                    Id = (ULONG)-1;
                    }
                else {
                    s = UnicodeString.Buffer;
                    while (*s != UNICODE_NULL) {
                        *s = RtlUpcaseUnicodeChar( *s );
                        s++;
                        }

                    Id = (ULONG)UnicodeString.Buffer;
                    }
                }
            }
        else {
            Id = (ULONG)lpId;
            }
        }
    except (EXCEPTION_EXECUTE_HANDLER) {
        BaseSetLastNTError( GetExceptionCode() );
        Id =  (ULONG)-1;
        }
    return Id;
}
_PRE_END

<p><i>lpId</i> is ANDed with <i>LDR_RESOURCE_ID_NAME_MASK</i>. Which we can find in <i>public/sdk/inc/ntldr.h</i>:</p>

_PRE_BEGIN
...

#define LDR_RESOURCE_ID_NAME_MASK 0xFFFF0000

...
_PRE_END

<p>
So <i>lpId</i> is ANDed with <i>0xFFFF0000</i> and if some bits beyond lowest 16 bits are still present,
first half of function is executed (<i>lpId</i> is treated as a string).
Otherwise - second half (<i>lpId</i> is treated as 16-bit value).
</p>

<p>Still, this code can be found in Windows 7 kernel32.dll file:</p>

_PRE_BEGIN
....

.text:0000000078D24510 ; __int64 __fastcall BaseDllMapResourceIdA(PCSZ SourceString)
.text:0000000078D24510 BaseDllMapResourceIdA proc near         ; CODE XREF: FindResourceExA+34
.text:0000000078D24510                                         ; FindResourceExA+4B
.text:0000000078D24510
.text:0000000078D24510 var_38          = qword ptr -38h
.text:0000000078D24510 var_30          = qword ptr -30h
.text:0000000078D24510 var_28          = _UNICODE_STRING ptr -28h
.text:0000000078D24510 DestinationString= _STRING ptr -18h
.text:0000000078D24510 arg_8           = dword ptr  10h
.text:0000000078D24510
.text:0000000078D24510 ; FUNCTION CHUNK AT .text:0000000078D42FB4 SIZE 000000D5 BYTES
.text:0000000078D24510
.text:0000000078D24510                 push    rbx
.text:0000000078D24512                 sub     rsp, 50h
.text:0000000078D24516                 cmp     rcx, 10000h
.text:0000000078D2451D                 jnb     loc_78D42FB4
.text:0000000078D24523                 mov     [rsp+58h+var_38], rcx
.text:0000000078D24528                 jmp     short $+2
.text:0000000078D2452A ; ---------------------------------------------------------------------------
.text:0000000078D2452A
.text:0000000078D2452A loc_78D2452A:                           ; CODE XREF: BaseDllMapResourceIdA+18
.text:0000000078D2452A                                         ; BaseDllMapResourceIdA+1EAD0
.text:0000000078D2452A                 jmp     short $+2
.text:0000000078D2452C ; ---------------------------------------------------------------------------
.text:0000000078D2452C
.text:0000000078D2452C loc_78D2452C:                           ; CODE XREF: BaseDllMapResourceIdA:loc_78D2452A
.text:0000000078D2452C                                         ; BaseDllMapResourceIdA+1EB74
.text:0000000078D2452C                 mov     rax, rcx
.text:0000000078D2452F                 add     rsp, 50h
.text:0000000078D24533                 pop     rbx
.text:0000000078D24534                 retn
.text:0000000078D24534 ; ---------------------------------------------------------------------------
.text:0000000078D24535                 align 20h
.text:0000000078D24535 BaseDllMapResourceIdA endp

....

.text:0000000078D42FB4 loc_78D42FB4:                           ; CODE XREF: BaseDllMapResourceIdA+D
.text:0000000078D42FB4                 cmp     byte ptr [rcx], '#'
.text:0000000078D42FB7                 jnz     short loc_78D43005
.text:0000000078D42FB9                 inc     rcx
.text:0000000078D42FBC                 lea     r8, [rsp+58h+arg_8]
.text:0000000078D42FC1                 mov     edx, 0Ah
.text:0000000078D42FC6                 call    cs:__imp_RtlCharToInteger
.text:0000000078D42FCC                 mov     ecx, [rsp+58h+arg_8]
.text:0000000078D42FD0                 mov     [rsp+58h+var_38], rcx
.text:0000000078D42FD5                 test    eax, eax
.text:0000000078D42FD7                 js      short loc_78D42FE6
.text:0000000078D42FD9                 test    rcx, 0FFFFFFFFFFFF0000h
.text:0000000078D42FE0                 jz      loc_78D2452A

....

_PRE_END

<p>
If value in input pointer is greater than 0x10000, jump to string processing is occurred.
Otherwise, input value of <i>lpId</i> is returned as is.
0xFFFF0000 mask is not used here any more, because this is 64-bit code after all, but still, 0xFFFFFFFFFFFF0000 could work here.
</p>

<p>Attentive reader may ask, what if address of input string is lower than 0x10000?
This code relied on the fact that there are no pointers below 0x10000 in Windows code, well, at least in Win32 realm.</p>

<p>Raymond Chen _HTML_LINK(`https://blogs.msdn.microsoft.com/oldnewthing/20130925-00/?p=3123',`writes') about this:</p>

<blockquote>
How does MAKE­INT­RESOURCE work? It just stashes the integer in the bottom 16 bits of a pointer, leaving the upper bits zero. This relies on the convention that the first 64KB of address space is never mapped to valid memory, a convention that is enforced starting in Windows 7.
</blockquote>

<p>
In short words, this is dirty hack and probably you should use it only if you have to.
Probably, <i>FindResource()</i> function in past had <i>SHORT</i> types for its arguments, and then Microsoft has added a way to pass strings there,
but older code should also work? I'm not sure, but that's possible.
</p>

<p>Now here is my short distilled example:</p>

_PRE_BEGIN
#include &lt;stdio.h>
#include &lt;stdint.h>

void f(char* a)
{
	if (((uint64_t)a)>0x10000)
		printf ("Pointer to string has been passed: %s\n", a);
	else
		printf ("16-bit value has been passed: %d\n", (uint64_t)a);
};

int main()
{
	f("Hello!"); // pass string
	f((char*)1234); // pass 16-bit value
};
_PRE_END

<p>It works!</p>

<hr>

<p>As it has been noted in _HTML_LINK(`https://news.ycombinator.com/item?id=11823647',`comments on Hacker News'), Linux kernel also has something like that.</p>

<p>For example, this function can return both error code and pointer:</p>

_PRE_BEGIN
struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
				       const char *name,
				       struct kernfs_node *target)
{
	struct kernfs_node *kn;
	int error;

	kn = kernfs_new_node(parent, name, S_IFLNK|S_IRWXUGO, KERNFS_LINK);
	if (!kn)
		return ERR_PTR(-ENOMEM);

	if (kernfs_ns_enabled(parent))
		kn->ns = target->ns;
	kn->symlink.target_kn = target;
	kernfs_get(target);	/* ref owned by symlink */

	error = kernfs_add_one(kn);
	if (!error)
		return kn;

	kernfs_put(kn);
	return ERR_PTR(error);
}
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/torvalds/linux/blob/fceef393a538134f03b778c5d2519e670269342f/fs/kernfs/symlink.c#L25') )</p>


<p>ERR_PTR is a macro to cast integer to pointer:</p>

_PRE_BEGIN
static inline void * __must_check ERR_PTR(long error)
{
	return (void *) error;
}
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/torvalds/linux/blob/61d0b5a4b2777dcf5daef245e212b3c1fa8091ca/tools/virtio/linux/err.h') )</p>

<p>This header file also has a macro helper to distinguish error code from pointer:</p>

_PRE_BEGIN
#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
_PRE_END

<p>This mean, errors are the "pointers" which are very close to -1 and, hopefully, there are no valid addresses there.</p>

<p>Much more popular solution is to return NULL and pass error code via additional argument.
Linux authors don't do that, but everyone who use these functions must always keep in mind that returning pointer
must always be checked with IS_ERR_VALUE before dereferencing.</p>

_BLOG_FOOTER_GITHUB(`ptrs3')

_BLOG_FOOTER()

