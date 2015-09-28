m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #22 (for x64, ARM, ARM64, MIPS); solution for exercise #21')

_HL2(`Reverse engineering exercise #22 (for x64, ARM, ARM64, MIPS)')

<p>
This can be tricky, but the algorithm is well known and heavily used almost everywhere.
What the following code does?
</p>

_HL3(`Optimizing (for size: -Os switch) GCC 4.8.2 for x64')

_PRE_BEGIN
f2:
        movsx   rax, esi
        push    rbp
        xor     r8d, r8d
        lea     rcx, [rdi+rax*4]
        lea     eax, [rdx+1]
        push    rbx
        mov     ebp, DWORD PTR [rcx]
.L2:
        mov     ebx, DWORD PTR [rcx+4+r8]
        inc     esi
        cmp     ebx, ebp
        jg      .L3
        cmp     esi, edx
        jg      .L3
.L4:
        add     r8, 4
        jmp     .L2
.L3:
        movsx   r9, eax
        lea     r10, [rdi-4+r9*4]
.L6:
        mov     r9, r10
        sub     r10, 4
        mov     r11d, DWORD PTR [r10+4]
        dec     eax
        cmp     r11d, ebp
        jg      .L6
        cmp     esi, eax
        jge     .L7
        xor     r11d, ebx
        mov     DWORD PTR [rcx+4+r8], r11d
        xor     r11d, DWORD PTR [r9]
        mov     DWORD PTR [r9], r11d
        xor     DWORD PTR [rcx+4+r8], r11d
        jmp     .L4
.L7:
        xor     r11d, DWORD PTR [rcx]
        mov     DWORD PTR [rcx], r11d
        xor     r11d, DWORD PTR [r9]
        mov     DWORD PTR [r9], r11d
        xor     DWORD PTR [rcx], r11d
        pop     rbx
        pop     rbp
        ret

f1:
        push    r13
        push    r12
        mov     r12d, edx
        push    rbp
        mov     rbp, rdi
        push    rbx
        mov     ebx, esi
        push    rcx
.L12:
        cmp     ebx, r12d
        jge     .L10
        mov     esi, ebx
        mov     edx, r12d
        mov     rdi, rbp
        call    f2
        lea     edx, [rax-1]
        mov     r13d, eax
        mov     esi, ebx
        mov     rdi, rbp
        lea     ebx, [r13+1]
        call    f1
        jmp     .L12
.L10:
        pop     rax
        pop     rbx
        pop     rbp
        pop     r12
        pop     r13
        ret
_PRE_END

_HL3(`Optimizing Keil 5.05 (ARM mode)')

_PRE_BEGIN
||f2|| PROC
        PUSH     {r4-r6,lr}
        LDR      r4,[r0,r1,LSL #2]
        MOV      r12,r1
        ADD      r3,r2,#1
|L0.16|
        ADD      r12,r12,#1
        LDR      r5,[r0,r12,LSL #2]
        CMP      r5,r4
        CMPLE    r12,r2
        BLE      |L0.16|
|L0.36|
        SUB      r3,r3,#1
        LDR      r6,[r0,r3,LSL #2]
        CMP      r6,r4
        BGT      |L0.36|
        CMP      r12,r3
        BGE      |L0.96|
        EOR      r5,r5,r6
        STR      r5,[r0,r12,LSL #2]
        LDR      r6,[r0,r3,LSL #2]
        EOR      r5,r5,r6
        STR      r5,[r0,r3,LSL #2]
        LDR      r6,[r0,r12,LSL #2]
        EOR      r5,r5,r6
        STR      r5,[r0,r12,LSL #2]
        B        |L0.16|
|L0.96|
        LDR      r2,[r0,r1,LSL #2]
        EOR      r2,r2,r6
        STR      r2,[r0,r1,LSL #2]
        LDR      r12,[r0,r3,LSL #2]
        EOR      r2,r2,r12
        STR      r2,[r0,r3,LSL #2]
        LDR      r12,[r0,r1,LSL #2]
        EOR      r2,r2,r12
        STR      r2,[r0,r1,LSL #2]
        MOV      r0,r3
        POP      {r4-r6,pc}
        ENDP

||f1|| PROC
        PUSH     {r4-r7,lr}
|L0.144|
        MOV      r5,r2
        CMP      r1,r5
        MOV      r6,r1
        MOV      r7,r0
        POPGE    {r4-r7,pc}
        BL       ||f2||
        MOV      r4,r0
        SUB      r2,r0,#1
        MOV      r1,r6
        MOV      r0,r7
        BL       ||f1||
        MOV      r2,r5
        ADD      r1,r4,#1
        MOV      r0,r7
        B        |L0.144|
        ENDP
_PRE_END

_HL3(`Optimizing Keil 5.05 (Thumb mode)')

_PRE_BEGIN
||f2|| PROC
        PUSH     {r4-r7,lr}
        LSLS     r4,r1,#2
        LDR      r6,[r0,r4]
        ADDS     r3,r2,#1
        MOV      lr,r2
|L0.10|
        ADDS     r1,r1,#1
        LSLS     r7,r1,#2
        LDR      r5,[r0,r7]
        CMP      r5,r6
        BGT      |L0.24|
        CMP      r1,lr
        BLE      |L0.10|
|L0.24|
        MOVS     r2,r3
        LSLS     r2,r2,#2
        SUBS     r2,r2,#4
        LDR      r2,[r0,r2]
        SUBS     r3,r3,#1
        CMP      r2,r6
        BGT      |L0.24|
        CMP      r1,r3
        BGE      |L0.70|
        LSLS     r2,r3,#2
        MOV      r12,r2
        LDR      r2,[r0,r2]
        EORS     r5,r5,r2
        MOV      r2,r12
        STR      r5,[r0,r7]
        LDR      r2,[r0,r2]
        EORS     r5,r5,r2
        MOV      r2,r12
        STR      r5,[r0,r2]
        LDR      r2,[r0,r7]
        EORS     r2,r2,r5
        STR      r2,[r0,r7]
        B        |L0.10|
|L0.70|
        LSLS     r5,r3,#2
        LDR      r1,[r0,r4]
        LDR      r2,[r0,r5]
        EORS     r1,r1,r2
        STR      r1,[r0,r4]
        LDR      r2,[r0,r5]
        EORS     r2,r2,r1
        STR      r2,[r0,r5]
        LDR      r1,[r0,r4]
        EORS     r1,r1,r2
        STR      r1,[r0,r4]
        MOVS     r0,r3
        POP      {r4-r7,pc}
        ENDP

||f1|| PROC
        PUSH     {r4-r7,lr}
|L0.98|
        MOVS     r4,r2
        MOVS     r5,r1
        MOVS     r6,r0
        CMP      r1,r4
        BGE      |L0.132|
        BL       ||f2||
        MOVS     r7,r0
        SUBS     r2,r0,#1
        MOVS     r1,r5
        MOVS     r0,r6
        BL       ||f1||
        MOVS     r2,r4
        ADDS     r1,r7,#1
        MOVS     r0,r6
        B        |L0.98|
|L0.132|
        POP      {r4-r7,pc}
        ENDP
_PRE_END

_HL3(`Optimizing (for size: -Os switch) GCC 4.9.3 for ARM64')

_PRE_BEGIN
f2:
        sbfiz   x3, x1, 2, 32
        add     w7, w2, 1
        add     x4, x0, x3
        mov     x11, -4
        ldr     w10, [x0, x3]
.L2:
        ldr     w6, [x4, 4]
        add     w1, w1, 1
        cmp     w6, w10
        bgt     .L7
        cmp     w1, w2
        bgt     .L7
.L3:
        add     x4, x4, 4
        b       .L2
.L7:
        add     x8, x11, x7, sxtw 2
        add     x8, x0, x8
.L5:
        mov     x9, x8
        ldr     w5, [x8], -4
        sub     w7, w7, #1
        cmp     w5, w10
        bgt     .L5
        cmp     w1, w7
        bge     .L6
        eor     w5, w5, w6
        str     w5, [x4, 4]
        ldr     w6, [x9]
        eor     w5, w5, w6
        str     w5, [x9]
        ldr     w6, [x4, 4]
        eor     w5, w6, w5
        str     w5, [x4, 4]
        b       .L3
.L6:
        ldr     w2, [x0, x3]
        eor     w1, w5, w2
        str     w1, [x0, x3]
        ldr     w2, [x9]
        eor     w1, w1, w2
        str     w1, [x9]
        ldr     w2, [x0, x3]
        eor     w1, w2, w1
        str     w1, [x0, x3]
        mov     w0, w7
        ret
f1:
        stp     x29, x30, [sp, -48]!
        add     x29, sp, 0
        stp     x21, x22, [sp, 32]
        stp     x19, x20, [sp, 16]
        mov     x21, x0
        mov     w19, w1
        mov     w22, w2
.L15:
        cmp     w19, w22
        bge     .L13
        mov     w1, w19
        mov     w2, w22
        mov     x0, x21
        bl      f2
        mov     w20, w0
        sub     w2, w0, #1
        mov     w1, w19
        mov     x0, x21
        add     w19, w20, 1
        bl      f1
        b       .L15
.L13:
        ldp     x19, x20, [sp, 16]
        ldp     x21, x22, [sp, 32]
        ldp     x29, x30, [sp], 48
        ret
_PRE_END

_HL3(`Optimizing (for size: -Os switch) GCC 4.4.5 for MIPS')

_PRE_BEGIN
f2:
        movsx   rax, esi
        push    rbp
        xor     r8d, r8d
        lea     rcx, [rdi+rax*4]
        lea     eax, [rdx+1]
        push    rbx
        mov     ebp, DWORD PTR [rcx]
.L2:
        mov     ebx, DWORD PTR [rcx+4+r8]
        inc     esi
        cmp     ebx, ebp
        jg      .L3
        cmp     esi, edx
        jg      .L3
.L4:
        add     r8, 4
        jmp     .L2
.L3:
        movsx   r9, eax
        lea     r10, [rdi-4+r9*4]
.L6:
        mov     r9, r10
        sub     r10, 4
        mov     r11d, DWORD PTR [r10+4]
        dec     eax
        cmp     r11d, ebp
        jg      .L6
        cmp     esi, eax
        jge     .L7
        xor     r11d, ebx
        mov     DWORD PTR [rcx+4+r8], r11d
        xor     r11d, DWORD PTR [r9]
        mov     DWORD PTR [r9], r11d
        xor     DWORD PTR [rcx+4+r8], r11d
        jmp     .L4
.L7:
        xor     r11d, DWORD PTR [rcx]
        mov     DWORD PTR [rcx], r11d
        xor     r11d, DWORD PTR [r9]
        mov     DWORD PTR [r9], r11d
        xor     DWORD PTR [rcx], r11d
        pop     rbx
        pop     rbp
        ret

f1:
        push    r13
        push    r12
        mov     r12d, edx
        push    rbp
        mov     rbp, rdi
        push    rbx
        mov     ebx, esi
        push    rcx
.L12:
        cmp     ebx, r12d
        jge     .L10
        mov     esi, ebx
        mov     edx, r12d
        mov     rdi, rbp
        call    f2
        lea     edx, [rax-1]
        mov     r13d, eax
        mov     esi, ebx
        mov     rdi, rbp
        lea     ebx, [r13+1]
        call    f1
        jmp     .L12
.L10:
        pop     rax
        pop     rbx
        pop     rbp
        pop     r12
        pop     r13
        ret
_PRE_END

<p>Solution is to be posted soon...</p>
<!-- <p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise23/')</p> -->

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #21')

_HTML_LINK(`http://yurichev.com/blog/exercise21',`(Link to exercise)')

m4_include(`spoiler_show.inc')

<div id="example" class="hidden">

<p>
This code just checks whether specific string has specific suffix:
</p>

<!--
bool is_string_ends_with (const char *s, const char *ending)
{
	return strcmp (s+strlen(s)-strlen(ending), ending)==0 ? true : false;
};
-->

<pre style='color:#000000;background:#ffffff;'>bool is_string_ends_with <span style='color:#808030; '>(</span><span style='color:#800000; font-weight:bold; '>const</span> <span style='color:#800000; font-weight:bold; '>char</span> <span style='color:#808030; '>*</span>s<span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>const</span> <span style='color:#800000; font-weight:bold; '>char</span> <span style='color:#808030; '>*</span>ending<span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
	<span style='color:#800000; font-weight:bold; '>return</span> <span style='color:#603000; '>strcmp</span> <span style='color:#808030; '>(</span>s<span style='color:#808030; '>+</span><span style='color:#603000; '>strlen</span><span style='color:#808030; '>(</span>s<span style='color:#808030; '>)</span><span style='color:#808030; '>-</span><span style='color:#603000; '>strlen</span><span style='color:#808030; '>(</span>ending<span style='color:#808030; '>)</span><span style='color:#808030; '>,</span> ending<span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>0</span> <span style='color:#800080; '>?</span> true <span style='color:#800080; '>:</span> false<span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span><span style='color:#800080; '>;</span>
</pre>

m4_include(`spoiler_hide.inc')
</div>

_BLOG_FOOTER_GITHUB(`exercise22')

_BLOG_FOOTER()

