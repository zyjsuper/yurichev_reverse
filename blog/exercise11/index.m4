m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #11 (for x86, ARM, ARM64, MIPS); solution for exercise #10')

_HL2(`Reverse engineering exercise #11 (for x86, ARM, ARM64, MIPS)')

<p>This is somewhat large function (in contrast to other exercises in this blog), but heavily used nowadays in various software.
As it can be clearly seen, it uses standard C/C++ functions including strlen() and sscanf().
Some other helper function is also used.
I intentionally gave it this name to conceal its real function.
So what the whole code snippet does?</p>

<p>GCC 4.8.2 with -Os option (generate smallest possible code):</p>

_PRE_BEGIN
helper:
        lea     edx, [rdi-48]
        mov     eax, 1
        cmp     edx, 9
        jbe     .L2
        and     edi, -33
        xor     eax, eax
        sub     edi, 65
        cmp     edi, 5
        setbe   al
.L2:
        ret
.LC0:
        .string "%2x"
f:
        push    r15
        xor     eax, eax
        or      rcx, -1
        push    r14
        push    r13
        push    r12
        mov     r12, rsi
        push    rbp
        mov     rbp, rsi
        push    rbx
        mov     rbx, rdi
        sub     rsp, 24
        repnz scasb
        not     rcx
        lea     r14, [rbx-1+rcx]
.L6:
        cmp     rbx, r14
        ja      .L24
        movsx   eax, BYTE PTR [rbx]
        lea     r13, [rbx+1]
        mov     r15, r13
        cmp     eax, 43
        mov     DWORD PTR [rsp+12], eax
        jne     .L7
        mov     DWORD PTR [rsp+12], 32
        jmp     .L8
.L7:
        cmp     eax, 37
        jne     .L8
        movsx   edi, BYTE PTR [rbx+1]
        call    helper
        test    eax, eax
        jne     .L9
.L11:
        or      eax, -1
        jmp     .L10
.L9:
        movsx   edi, BYTE PTR [rbx+2]
        lea     r13, [rbx+3]
        call    helper
        test    eax, eax
        je      .L11
        lea     rdx, [rsp+12]
        xor     eax, eax
        mov     esi, OFFSET FLAT:.LC0
        mov     rdi, r15
        call    __isoc99_sscanf
        test    eax, eax
        je      .L11
.L8:
        test    r12, r12
        je      .L12
        mov     eax, DWORD PTR [rsp+12]
        mov     BYTE PTR [rbp+0], al
.L12:
        inc     rbp
        mov     rbx, r13
        jmp     .L6
.L24:
        mov     eax, ebp
        sub     eax, r12d
.L10:
        add     rsp, 24
        pop     rbx
        pop     rbp
        pop     r12
        pop     r13
        pop     r14
        pop     r15
        ret
_PRE_END

<p>GCC 4.9.3 for ARM64 with -Os option (generate smallest possible code):</p>

_PRE_BEGIN
helper:
        sub     w2, w0, #48
        mov     w1, 1
        cmp     w2, 9
        bls     .L2
        and     w0, w0, -33
        sub     w0, w0, #65
        cmp     w0, 5
        cset    w1, ls
.L2:
        mov     w0, w1
        ret
f:
        stp     x29, x30, [sp, -96]!
        add     x29, sp, 0
        stp     x19, x20, [sp, 16]
        stp     x21, x22, [sp, 32]
        mov     x19, x0
        mov     x21, x1
        adrp    x22, .LC0
        mov     x20, x21
        stp     x23, x24, [sp, 48]
        stp     x25, x26, [sp, 64]
        add     x22, x22, :lo12:.LC0
        bl      strlen
        mov     w25, 32
        add     x24, x19, x0
.L6:
        cmp     x19, x24
        bhi     .L23
        ldrb    w1, [x19]
        add     x23, x19, 1
        str     w1, [x29, 92]
        mov     x26, x23
        cmp     w1, 43
        bne     .L7
        str     w25, [x29, 92]
        b       .L8
.L7:
        cmp     w1, 37
        bne     .L8
        ldrb    w0, [x19, 1]
        bl      helper
        cbnz    w0, .L9
.L11:
        mov     w0, -1
        b       .L10
.L9:
        ldrb    w0, [x19, 2]
        add     x23, x19, 3
        bl      helper
        cbz     w0, .L11
        add     x2, x29, 92
        mov     x1, x22
        mov     x0, x26
        bl      __isoc99_sscanf
        cbz     w0, .L11
.L8:
        cbz     x21, .L12
        ldr     w0, [x29, 92]
        strb    w0, [x20]
.L12:
        add     x20, x20, 1
        mov     x19, x23
        b       .L6
.L23:
        sub     w0, w20, w21
.L10:
        ldp     x19, x20, [sp, 16]
        ldp     x21, x22, [sp, 32]
        ldp     x23, x24, [sp, 48]
        ldp     x25, x26, [sp, 64]
        ldp     x29, x30, [sp], 96
        ret
.LC0:
        .string "%2x"
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

_PRE_BEGIN
helper PROC
        MOVS     r1,r0
        SUBS     r1,r1,#0x30
        CMP      r1,#9
        BLS      |L0.20|
        SUBS     r1,r1,#0x31
        CMP      r1,#5
        BLS      |L0.20|
        SUBS     r0,r0,#0x41
        CMP      r0,#5
        BHI      |L0.24|
|L0.20|
        MOVS     r0,#1
        BX       lr
|L0.24|
        MOVS     r0,#0
        BX       lr
        ENDP

f PROC
        PUSH     {r3-r7,lr}
        MOVS     r6,r1
        MOVS     r4,r0
        BL       strlen
        ADDS     r7,r0,r4
        MOVS     r5,r6
        B        |L0.114|
|L0.44|
        LDRB     r0,[r4,#0]
        ADDS     r4,r4,#1
        CMP      r0,#0x2b
        STR      r0,[sp,#0]
        BEQ      |L0.60|
        CMP      r0,#0x25
        BEQ      |L0.66|
        B        |L0.104|
|L0.60|
        MOVS     r0,#0x20
        STR      r0,[sp,#0]
        B        |L0.104|
|L0.66|
        LDRB     r0,[r4,#0]
        ADDS     r4,r4,#1
        BL       helper
        CMP      r0,#0
        BEQ      |L0.122|
        LDRB     r0,[r4,#0]
        ADDS     r4,r4,#1
        BL       helper
        CMP      r0,#0
        BEQ      |L0.122|
        SUBS     r0,r4,#2
        MOV      r2,sp
        ADR      r1,|L0.128|
        BL       __0sscanf
        CMP      r0,#0
        BEQ      |L0.122|
|L0.104|
        CMP      r6,#0
        BEQ      |L0.112|
        LDR      r0,[sp,#0]
        STRB     r0,[r5,#0]
|L0.112|
        ADDS     r5,r5,#1
|L0.114|
        CMP      r4,r7
        BLS      |L0.44|
        SUBS     r0,r5,r6
        POP      {r3-r7,pc}
|L0.122|
        MOVS     r0,#0
        MVNS     r0,r0
        POP      {r3-r7,pc}
        ENDP

|L0.128|
        DCB      "%2x",0
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

_PRE_BEGIN
helper PROC
        SUB      r1,r0,#0x30
        CMP      r1,#9
        SUBHI    r1,r0,#0x61
        CMPHI    r1,#5
        BLS      |L0.36|
        SUB      r0,r0,#0x41
        CMP      r0,#5
        MOVHI    r0,#0
        BXHI     lr
|L0.36|
        MOV      r0,#1
        BX       lr
        ENDP

f PROC
        PUSH     {r3-r7,lr}
        MOV      r6,r1
        MOV      r4,r0
        BL       strlen
        ADD      r7,r0,r4
        MOV      r5,r6
|L0.68|
        CMP      r4,r7
        SUBHI    r0,r5,r6
        BHI      |L0.192|
        LDRB     r0,[r4],#1
        CMP      r0,#0x2b
        STR      r0,[sp,#0]
        MOVEQ    r0,#0x20
        STREQ    r0,[sp,#0]
        BEQ      |L0.168|
        CMP      r0,#0x25
        BNE      |L0.168|
        LDRB     r0,[r4],#1
        BL       helper
        CMP      r0,#0
        BEQ      |L0.188|
        LDRB     r0,[r4],#1
        BL       helper
        CMP      r0,#0
        BEQ      |L0.188|
        MOV      r2,sp
        ADR      r1,|L0.196|
        SUB      r0,r4,#2
        BL       __0sscanf
        CMP      r0,#0
        BEQ      |L0.188|
|L0.168|
        CMP      r6,#0
        LDRNE    r0,[sp,#0]
        STRBNE   r0,[r5,#0]
        ADD      r5,r5,#1
        B        |L0.68|
|L0.188|
        MVN      r0,#0
|L0.192|
        POP      {r3-r7,pc}
        ENDP

|L0.196|
        DCB      "%2x",0

_PRE_END

<p>GCC 4.4.5 for MIPS with -Os option (generate smallest possible code):</p>

_PRE_BEGIN
helper:
        addiu   $2,$4,-48
        sltu    $2,$2,10
        bne     $2,$0,$L7
        li      $2,1                    # 0x1

        addiu   $2,$4,-97
        sltu    $2,$2,6
        bne     $2,$0,$L2
        addiu   $4,$4,-65

        j       $31
        sltu    $2,$4,6
$L2:
        li      $2,1                    # 0x1
$L7:
        j       $31
        nop

$LC0:
        .ascii  "%2x\000"
f:
        lui     $28,%hi(__gnu_local_gp)
        addiu   $sp,$sp,-72
        addiu   $28,$28,%lo(__gnu_local_gp)
        sw      $31,68($sp)
        sw      $fp,64($sp)
        sw      $23,60($sp)
        sw      $22,56($sp)
        sw      $21,52($sp)
        sw      $20,48($sp)
        sw      $19,44($sp)
        sw      $18,40($sp)
        sw      $17,36($sp)
        sw      $16,32($sp)
        lw      $25,%call16(strlen)($28)
        move    $18,$5
        move    $16,$4
        jalr    $25
        lui     $23,%hi($LC0)

        addu    $fp,$16,$2
        addiu   $23,$23,%lo($LC0)
        move    $17,$18
        li      $22,43                  # 0x2b
        li      $21,37                  # 0x25
        addiu   $20,$sp,24
        b       $L9
        li      $19,32                  # 0x20

$L14:
        lb      $2,0($16)
        addiu   $16,$16,1
        bne     $2,$22,$L10
        sw      $2,24($sp)

        b       $L11
        sw      $19,24($sp)

$L10:
        bne     $2,$21,$L11
        nop

        lb      $4,0($16)
        jal     helper
        nop
        beq     $2,$0,$L15
        li      $2,-1                   # 0xffffffffffffffff
        lb      $4,1($16)
        jal     helper
        addiu   $16,$16,2

        lw      $28,16($sp)
        addiu   $4,$16,-2
        lw      $25,%call16(__isoc99_sscanf)($28)
        move    $5,$23
        beq     $2,$0,$L12
        move    $6,$20

        jalr    $25
        nop

        beq     $2,$0,$L15
        li      $2,-1                   # 0xffffffffffffffff

$L11:
        beq     $18,$0,$L13
        nop

        lw      $2,24($sp)
        nop
        sb      $2,0($17)
$L13:
        addiu   $17,$17,1
$L9:
        sltu    $2,$fp,$16
        beq     $2,$0,$L14
        subu    $2,$17,$18

        b       $L15
        nop

$L12:
        li      $2,-1                   # 0xffffffffffffffff
$L15:
        lw      $31,68($sp)
        lw      $fp,64($sp)
        lw      $23,60($sp)
        lw      $22,56($sp)
        lw      $21,52($sp)
        lw      $20,48($sp)
        lw      $19,44($sp)
        lw      $18,40($sp)
        lw      $17,36($sp)
        lw      $16,32($sp)
        j       $31
        addiu   $sp,$sp,72

_PRE_END

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise12/')</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #10')

_HTML_LINK(`http://yurichev.com/blog/exercise10/',`(Link to exercise)')

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">
The function calculates size of something aligned to some boundary.
For example, you need to allocate memory 123 bytes, but you can allocate only 4k-pages. How many pages would you need?
One page (or 4096 bytes).
What if 0x4567 bytes? 5 pages or 0x5000 bytes.
</p>

<pre class="spoiler">
#include &lt;stdio.h>

// copypasted from http://docs.oracle.com/javase/specs/jvms/se7/html/jvms-3.html (3.3)
int align2grain(int i, int grain)
{
    return ((i + grain-1) & ~(grain-1));
}

int main()
{
        printf ("0x%x\n", align2grain(0x123, 0x1000));
        printf ("0x%x\n", align2grain(0x1234, 0x1000));
        printf ("0x%x\n", align2grain(0x4567, 0x1000));
}
</pre>

_BLOG_FOOTER()
