m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #23 (for x64, ARM, ARM64, MIPS)')

<p>
This is another implementation of well-known library function, works only in 64-bit environment.
What the following code does?
</p>

<p>Additional questions:

<ul>
<li> The code may crash under some specific circumstances. Which are...?
<li> The code can be easily optimized using SSEx. How?
<li> The code will not work correctly on big-endian architectures. How to fix it?
</ul>

_HL2(`Optimizing GCC 4.8.2 for x64')

_PRE_BEGIN
f:
        mov     rdx, QWORD PTR [rdi]
        test    dl, dl
        je      .L18
        test    dh, 255
        je      .L19
        test    edx, 16711680
        je      .L20
        test    edx, 4278190080
        je      .L21
        movabs  r8, 1095216660480
        test    rdx, r8
        je      .L22
        movabs  r9, 280375465082880
        test    rdx, r9
        je      .L26
        xor     eax, eax
        movabs  rcx, 71776119061217280
        movabs  rsi, -72057594037927936
        jmp     .L14
.L15:
        test    rdx, rsi
        je      .L27
        add     rax, 8
        mov     rdx, QWORD PTR [rdi+rax]
        test    dl, dl
        je      .L28
        test    dh, 255
        je      .L29
        test    edx, 16711680
        je      .L30
        test    edx, 4278190080
        je      .L31
        test    rdx, r8
        je      .L32
        test    rdx, r9
        je      .L33
.L14:
        test    rdx, rcx
        jne     .L15
        add     rax, 6
        ret
.L27:
        add     rax, 7
        ret
.L28:
        rep ret
.L29:
        add     rax, 1
        ret
.L30:
        add     rax, 2
        ret
.L31:
        add     rax, 3
        ret
.L32:
        add     rax, 4
        ret
.L33:
        add     rax, 5
        ret
.L18:
        xor     eax, eax
        ret
.L20:
        mov     eax, 2
        ret
.L19:
        mov     eax, 1
        ret
.L21:
        mov     eax, 3
        ret
.L26:
        mov     eax, 5
        ret
.L22:
        mov     eax, 4
        ret
_PRE_END

_HL2(`Optimizing GCC 4.9.3 for ARM64')

_PRE_BEGIN
f:
        ldr     x1, [x0]
        and     x2, x1, 255
        cbz     x2, .L18
        tst     x1, 65280
        beq     .L19
        tst     x1, 16711680
        beq     .L20
        tst     x1, 4278190080
        beq     .L21
        tst     x1, 1095216660480
        beq     .L22
        tst     x1, 280375465082880
        mov     x2, 0
        bne     .L14
        b       .L32
.L15:
        tst     x1, -72057594037927936
        beq     .L33
        add     x2, x2, 8
        ldr     x1, [x0, x2]
        and     x3, x1, 255
        tst     x1, 65280
        cbz     x3, .L2
        beq     .L34
        tst     x1, 16711680
        beq     .L35
        tst     x1, 4278190080
        beq     .L36
        tst     x1, 1095216660480
        beq     .L37
        tst     x1, 280375465082880
        beq     .L38
.L14:
        tst     x1, 71776119061217280
        bne     .L15
        add     x0, x2, 6
        ret
.L18:
        mov     x2, 0
.L2:
        mov     x0, x2
        ret
.L33:
        add     x0, x2, 7
        ret
.L34:
        add     x0, x2, 1
        ret
.L35:
        add     x0, x2, 2
        ret
.L36:
        add     x0, x2, 3
        ret
.L37:
        add     x0, x2, 4
        ret
.L38:
        add     x0, x2, 5
        ret
.L20:
        mov     x0, 2
        ret
.L19:
        mov     x0, 1
        ret
.L21:
        mov     x0, 3
        ret
.L32:
        mov     x0, 5
        ret
.L22:
        mov     x0, 4
        ret
_PRE_END

<p>Solution is to be posted in future...</p>

_EXERCISE_FOOTER()

_BLOG_FOOTER_GITHUB(`exercise23')

_BLOG_FOOTER()

