m4_include(`commons.m4')

_HEADER_HL1(`7-Dec-2010: Making C compiler generate obfuscated code')

<p>A customer of mine asked whether it is possible to protect his software from reverse engineering. I <a href="http://stackoverflow.com/questions/4111808/c-c-compiler-generating-obfuscated-code">didn't found</a> any C/C++ compiler which was able to produce obfuscated code making it hard to reverse engineer and complicate the use of such tools as <a href="http://www.hex-rays.com/decompiler.shtml">Hex-Rays Decompiler</a>, so I made a little attempt to hack <a href="http://bellard.org/tcc/">Tiny C</a> compiler's codegenerator.</p>

<p>I patched it so it produces a lot of random noise code between effective code. Of course, resulting code will work much slower. But in real life, we can obfuscate only critical parts of code containing algorithms we don't want to be easily leaked. Of course, it is virtually impossible to protect any code from reverse engineering, but it is possible to make it much more difficult.</p>

<p>Example: simple function:</p>

_PRE_BEGIN
int a (int a, int b)
{
	return a + b * 4;
};
_PRE_END

<p>On output...</p>

_PRE_BEGIN
a               proc near

var_CD500B      = byte ptr -0CD500Bh
arg_0           = dword ptr  8
arg_4           = dword ptr  0Ch
arg_1D364BDE    = byte ptr  1D364BE6h

                nop
                push    ebp
                mov     ebp, esp
                sub     esp, 0
                nop
                xor     eax, ebx
                mov     eax, 99B7A34Ah
                mov     eax, 0EC06E7ACh
                lea     edx, [esi+63h]
                mov     ebx, [ebp+arg_0]
                and     ebx, ebx

loc_800001F:
                lea     ebx, [ebp+arg_1D364BDE]
                mov     ebx, 9EF81F3Eh
                lea     eax, [ebx+3Eh]
                lea     ecx, [esi]
                mov     eax, 0FD6D5D47h
                sub     ebx, edx
                lea     ecx, [ebp+var_CD500B]
                lea     ecx, [eax]
                mov     eax, [ebp+arg_4] ; *
                shl     eax, 2          ; *
                mov     ecx, eax
                adc     ecx, edx
                mov     ecx, [ebp+arg_0]
                adc     ecx, ecx
                sub     edx, ecx
                sub     edx, eax
                lea     ebx, [esp+ecx*8]
                mov     ecx, 29262C66h
                mov     ebx, 0CC18D2C4h
                mov     ebx, 0FDB56490h
                mov     ecx, 9E709D5Eh
                mov     ecx, 73805EBFh
                mov     ecx, eax
                or      ecx, eax
                mov     ebx, 7339AD0Eh
                mov     edx, 2CA8725Ah
                lea     edx, [edi+esi*8]
                mov     ebx, 87684A89h
                mov     ebx, 52A74759h
                xor     edx, edx
                jnz     short loc_800001F
                mov     ebx, 0CCA90613h
                sub     ecx, eax
                mov     ecx, 0C6699FDh
                mov     ebx, 0A8B272A1h
                mov     ebx, eax
                sbb     ebx, ebx
                mov     ecx, [ebp+arg_0] ; *
                add     ecx, eax        ; *
                or      edx, ebx
                mov     edx, 47257B14h
                mov     edx, ecx
                add     edx, edx
                mov     eax, 9E3E878Ah
                mov     ebx, 0DAB5E429h
                mov     edx, 0ABFDB94Eh
                adc     eax, ebx
                add     edx, ebx
                lea     edx, [ebx+75A1EF29h]
                or      edx, edx
                mov     eax, ecx        ; *
                jmp     $+5
                leave
                pop     ebx
                jmp     ebx
a               endp
_PRE_END

<p>(effective code marked with asterisk)</p>

<p>One funny thing is that now the compiler uses random number generator. <i>Almost all good computer programs contain at least one random-number generator.</i> (<a href="http://fortunes.cat-v.org/plan_9/">fortune file</a> in plan 9 OS).</p>

<p>Here is also my <a href="http://crackmes.de/users/yonkie/yonkies_keygenme_4/">crackme</a> I created for testing. It was eventually reversed, though.</p>

<p>For those who are interested:</p>
<p><a href="http://conus.info/stuff/tcc-obfuscate/tcc-0.9.25-diff">Patch for Tiny C version 0.9.25</a></p>
<p><a href="http://conus.info/stuff/tcc-obfuscate/tcc-0.9.25-my-src.rar">Full source code patched</a></p>
<p><a href="http://conus.info/stuff/tcc-obfuscate/tcc-0.9.25-my-win32-bin.rar">Tiny C 0.9.25 patched win32 executables</a>.
Unfortunately, there were complaints about win32 executables, someone said antivirus detected malware in these.
So the files archived with a password: 'tcc'.</p>

<p>Update: <a href="http://groups.google.com/group/comp.compilers/browse_thread/thread/3b3049eaf7fd4a1a">comp.compilers thread</a></p>

_BLOG_FOOTER_GITHUB(`58')

_BLOG_FOOTER()

