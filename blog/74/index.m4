m4_include(`commons.m4')

_HEADER_HL1(`19-Aug-2013: Bug or typo or?..')

<p>Just found this in ftol2() standard C/C++ library function (float-to-long conversion routine) in Microsoft Visual Studio 2012.</p>

_PRE_BEGIN
.text:00000036                 public __ftol2
.text:00000036 __ftol2         proc near               ; CODE XREF: $$000000+7
.text:00000036                                         ; __ftol2_sse_excpt+7
.text:00000036                 push    ebp
.text:00000037                 mov     ebp, esp
.text:00000039                 sub     esp, 20h
.text:0000003C                 and     esp, 0FFFFFFF0h
.text:0000003F                 fld     st
.text:00000041                 fst     dword ptr [esp+18h]
.text:00000045                 fistp   qword ptr [esp+10h]
.text:00000049                 fild    qword ptr [esp+10h]
.text:0000004D                 mov     edx, [esp+18h]
.text:00000051                 mov     eax, [esp+10h]
.text:00000055                 test    eax, eax
.text:00000057                 jz      short integer_QnaN_or_zero
.text:00000059
.text:00000059 arg_is_not_integer_QnaN:                ; CODE XREF: __ftol2+69
.text:00000059                 fsubp   st(1), st
.text:0000005B                 test    edx, edx
.text:0000005D                 jns     short positive
.text:0000005F                 fstp    dword ptr [esp]
.text:00000062                 mov     ecx, [esp]
.text:00000065                 xor     ecx, 80000000h
.text:0000006B                 add     ecx, 7FFFFFFFh
.text:00000071                 adc     eax, 0
.text:00000074                 mov     edx, [esp+14h]
.text:00000078                 adc     edx, 0
.text:0000007B                 jmp     short localexit
.text:0000007D ; ---------------------------------------------------------------------------
.text:0000007D
.text:0000007D positive:                               ; CODE XREF: __ftol2+27
.text:0000007D                 fstp    dword ptr [esp]
.text:00000080                 mov     ecx, [esp]
.text:00000083                 add     ecx, 7FFFFFFFh
.text:00000089                 sbb     eax, 0
.text:0000008C                 mov     edx, [esp+14h]
.text:00000090                 sbb     edx, 0
.text:00000093                 jmp     short localexit
.text:00000095 ; ---------------------------------------------------------------------------
.text:00000095
.text:00000095 integer_QnaN_or_zero:                   ; CODE XREF: __ftol2+21
.text:00000095                 mov     edx, [esp+14h]
.text:00000099                 test    edx, 7FFFFFFFh
.text:0000009F                 jnz     short arg_is_not_integer_QnaN
.text:000000A1                 fstp    dword ptr [esp+18h]
.text:000000A5                 fstp    dword ptr [esp+18h]
.text:000000A9
.text:000000A9 localexit:                              ; CODE XREF: __ftol2+45
.text:000000A9                                         ; __ftol2+5D
.text:000000A9                 leave
.text:000000AA                 retn
.text:000000AA __ftol2         endp
_PRE_END

<p>Note two identical FSTP-s (float store with pop) and the end. 
First I thought it was compiler anomaly (I'm collecting such cases just as someone do with butterflies), but it seems, it's handwritten assembler piece, in msvcrt.lib there is an object file with this function in it, and we can find this string in it: "f:\dd\vctools\crt_bld\SELF_X86\crt\prebuild\tran\i386\ftol2.asm" - that was probably a path to the file on developer's computer where msvcrt.lib was built.</p>

<p>So, bug, text editor-induced typo, or feature?</p>

_BLOG_FOOTER_GITHUB(`74')

_BLOG_FOOTER()

