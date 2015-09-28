m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #19 (for x64, ARM, ARM64, MIPS); solution for exercise #18')

_HL2(`Reverse engineering exercise #19 (for x64, ARM, ARM64, MIPS)')

<p>
This is tricky.
The algorithm is well-known in computer science, but probably not to wide public.
The task it does is high demand and very mundane.
</p>

_HL3(`Optimizing GCC 4.8.2 for x64')

_PRE_BEGIN
f2:
	push	rbx
	mov	rax, rdi
	mov	rbx, rdi
	sub	rsp, 32
	test	rcx, rcx
	jne	.L21
	add	rsp, 32
	pop	rbx
	ret
.L21:
	lea	rdi, [4+rcx*4]
	mov	QWORD PTR [rsp+24], rdx
	mov	QWORD PTR [rsp+16], rsi
	mov	QWORD PTR [rsp+8], rcx
	call	malloc
	mov	rcx, QWORD PTR [rsp+8]
	mov	r9d, 1
	mov	DWORD PTR [rax], -1
	mov	DWORD PTR [rax+4], 0
	mov	rsi, QWORD PTR [rsp+16]
	mov	rdx, QWORD PTR [rsp+24]
	cmp	r9, rcx
	je	.L22
.L8:
	mov	edi, DWORD PTR [rax+r9*4]
	lea	r8d, [rdi+1]
	test	r8d, r8d
	mov	DWORD PTR [rax+4+r9*4], r8d
	jle	.L5
	movzx	r10d, BYTE PTR [rdx+r9]
	movsx	r8, r8d
	cmp	r10b, BYTE PTR [rdx-1+r8]
	jne	.L7
	jmp	.L5
.L23:
	movsx	r8, r8d
	cmp	BYTE PTR [rdx-1+r8], r10b
	je	.L5
.L7:
	mov	r8d, DWORD PTR [rax-4+r8*4]
	add	r8d, 1
	test	r8d, r8d
	mov	DWORD PTR [rax+4+r9*4], r8d
	jg	.L23
.L5:
	add	r9, 1
	cmp	r9, rcx
	jne	.L8
.L22:
	xor	r8d, r8d
	xor	r10d, r10d
	xor	edi, edi
.L9:
	cmp	rdi, rsi
	jae	.L24
.L14:
	test	r8d, r8d
	js	.L10
	movsx	r9, r8d
	movzx	r11d, BYTE PTR [rdx+r9]
	cmp	BYTE PTR [rbx+rdi], r11b
	je	.L10
	cmp	rdi, rsi
	mov	r8d, DWORD PTR [rax+r9*4]
	jb	.L14
.L24:
	xor	ebx, ebx
.L13:
	mov	rdi, rax
	call	free
	add	rsp, 32
	mov	rax, rbx
	pop	rbx
	ret
.L10:
	add	r8d, 1
	add	r10d, 1
	movsx	rdi, r8d
	cmp	rdi, rcx
	je	.L18
	movsx	rdi, r10d
	jmp	.L9
.L18:
	movsx	r10, r10d
	sub	r10, rcx
	add	rbx, r10
	jmp	.L13
_PRE_END

_HL3(`Optimizing Keil 5.05 (ARM mode)')

_PRE_BEGIN
||f2|| PROC
        PUSH     {r4-r10,lr}
        MOVS     r5,r3
        MOV      r6,r2
        MOV      r9,r1
        MOV      r7,r0
        MOV      r8,#0
        POPEQ    {r4-r10,pc}
        LSL      r0,r5,#2
        ADD      r0,r0,#4
        BL       malloc
        MVN      r1,#0
        STR      r1,[r0,#0]
        MOV      r1,#0
        B        |L0.104|
|L0.56|
        ADD      r2,r2,#1
        CMP      r2,#0
        STR      r2,[r3,#4]
        BLE      |L0.100|
        ADD      r4,r2,r6
        LDRB     r12,[r6,r1]
        LDRB     r4,[r4,#-1]
        CMP      r12,r4
        ADDNE    r2,r0,r2,LSL #2
        LDRNE    r2,[r2,#-4]
        BNE      |L0.56|
|L0.100|
        ADD      r1,r1,#1
|L0.104|
        CMP      r5,r1
        LDRHI    r2,[r0,r1,LSL #2]
        ADDHI    r3,r0,r1,LSL #2
        BHI      |L0.56|
        MOV      r4,#0
        CMP      r9,#0
        MOV      r12,r4
        BHI      |L0.148|
        B        |L0.200|
|L0.140|
        CMP      r12,#0
        BLT      |L0.168|
|L0.148|
        LDRB     r1,[r7,r4]
        LDRB     r2,[r6,r12]
        CMP      r1,r2
        LDRNE    r12,[r0,r12,LSL #2]
        BNE      |L0.192|
|L0.168|
        ADD      r12,r12,#1
        CMP      r12,r5
        ADD      r4,r4,#1
        ADDEQ    r1,r7,r4
        SUBEQ    r8,r1,r12
        BEQ      |L0.200|
|L0.192|
        CMP      r4,r9
        BCC      |L0.140|
|L0.200|
        BL       free
        MOV      r0,r8
        POP      {r4-r10,pc}
        ENDP
_PRE_END

_HL3(`Optimizing Keil 5.05 (Thumb mode)')

_PRE_BEGIN
||f2|| PROC
        PUSH     {r0-r7,lr}
        MOVS     r0,#0
        MOVS     r5,r3
        MOVS     r4,r2
        SUB      sp,sp,#4
        CMP      r3,#0
        STR      r0,[sp,#0]
        BEQ      |L0.38|
        LSLS     r0,r5,#2
        ADDS     r0,r0,#4
        BL       malloc
        MOVS     r1,#0
        MVNS     r1,r1
        STR      r1,[r0,#0]
        MOVS     r1,#0
        SUBS     r2,r4,#1
        MOV      r12,r2
        B        |L0.86|
|L0.38|
        LDR      r0,[sp,#4]
|L0.40|
        ADD      sp,sp,#0x14
        POP      {r4-r7,pc}
|L0.44|
        LSLS     r2,r1,#2
        LDR      r3,[r0,r2]
        ADDS     r6,r2,r0
        ADDS     r3,r3,#1
        STR      r3,[r6,#4]
        B        |L0.70|
|L0.56|
        LSLS     r2,r3,#2
        ADDS     r2,r2,r0
        SUBS     r2,r2,#0x80
        LDR      r2,[r2,#0x7c]
        ADDS     r2,r2,#1
        MOVS     r3,r2
        STR      r2,[r6,#4]
|L0.70|
        CMP      r3,#0
        BLE      |L0.84|
        MOV      r2,r12
        LDRB     r7,[r4,r1]
        LDRB     r2,[r3,r2]
        CMP      r7,r2
        BNE      |L0.56|
|L0.84|
        ADDS     r1,r1,#1
|L0.86|
        CMP      r1,r5
        BCC      |L0.44|
        LDR      r3,[sp,#8]
        MOVS     r1,#0
        MOVS     r2,r1
        CMP      r3,#0
        BHI      |L0.106|
        B        |L0.144|
|L0.102|
        CMP      r1,#0
        BLT      |L0.116|
|L0.106|
        LDR      r3,[sp,#4]
        LDRB     r6,[r4,r1]
        LDRB     r3,[r3,r2]
        CMP      r3,r6
        BNE      |L0.134|
|L0.116|
        ADDS     r1,r1,#1
        ADDS     r2,r2,#1
        CMP      r1,r5
        BNE      |L0.138|
        LDR      r3,[sp,#4]
        ADDS     r2,r3,r2
        SUBS     r1,r2,r1
        STR      r1,[sp,#0]
        B        |L0.144|
|L0.134|
        LSLS     r1,r1,#2
        LDR      r1,[r0,r1]
|L0.138|
        LDR      r3,[sp,#8]
        CMP      r2,r3
        BCC      |L0.102|
|L0.144|
        BL       free
        LDR      r0,[sp,#0]
        B        |L0.40|
_PRE_END

_HL3(`Optimizing GCC 4.9.3 for ARM64')

_PRE_BEGIN
f2:
        stp     x29, x30, [sp, -48]!
        add     x29, sp, 0
        stp     x21, x22, [sp, 32]
        stp     x19, x20, [sp, 16]
        mov     x22, x0
        cbnz    x3, .L20
        ldp     x19, x20, [sp, 16]
        ldp     x21, x22, [sp, 32]
        ldp     x29, x30, [sp], 48
        ret
.L20:
        add     x0, x3, 1
        mov     x21, x1
        lsl     x0, x0, 2
        mov     x19, x2
        mov     x20, x3
        bl      malloc
        mov     x6, x0
        mov     w1, -1
        mov     x7, 0
        str     w1, [x6], 4
.L4:
        ldr     w4, [x6, -4]
        add     w4, w4, 1
        str     w4, [x6]
        cmp     w4, wzr
        ble     .L6
        sxtw    x4, w4
        ldrb    w2, [x19, x7]
        add     x1, x19, x4
        ldrb    w1, [x1, -1]
        cmp     w1, w2
        bne     .L7
        b       .L6
.L21:
        ldrb    w5, [x5, -1]
        cmp     w5, w2
        beq     .L6
.L7:
        add     x4, x0, x4, lsl 2
        ldr     w4, [x4, -4]
        add     w4, w4, 1
        str     w4, [x6]
        cmp     w4, wzr
        sxtw    x4, w4
        add     x5, x19, x4
        bgt     .L21
.L6:
        add     x7, x7, 1
        add     x6, x6, 4
        cmp     x7, x20
        bne     .L4
        mov     w2, 0
        mov     w5, 0
        mov     x4, 0
.L5:
        cmp     x4, x21
        bcs     .L22
.L12:
        tbnz    w2, #31, .L8
        ldrb    w3, [x19, w2, sxtw]
        ldrb    w6, [x22, x4]
        cmp     w6, w3
        beq     .L8
        cmp     x4, x21
        ldr     w2, [x0, w2, sxtw 2]
        bcc     .L12
.L22:
        mov     x19, 0
.L11:
        bl      free
        mov     x0, x19
        ldp     x19, x20, [sp, 16]
        ldp     x21, x22, [sp, 32]
        ldp     x29, x30, [sp], 48
        ret
.L8:
        add     w2, w2, 1
        add     w5, w5, 1
        cmp     x20, x2, sxtw
        sxtw    x4, w5
        bne     .L5
        sub     x5, x4, x20
        add     x19, x22, x5
        b       .L11
_PRE_END

_HL3(`Optimizing GCC 4.4.5 for MIPS')

_PRE_BEGIN
f2:
        lui     $28,%hi(__gnu_local_gp)
        addiu   $sp,$sp,-48
        addiu   $28,$28,%lo(__gnu_local_gp)
        sw      $31,44($sp)
        sw      $16,40($sp)
        bne     $7,$0,$L21
        move    $16,$4
        lw      $31,44($sp)
        move    $2,$16
        lw      $16,40($sp)
        j       $31
        addiu   $sp,$sp,48
$L21:
        lw      $25,%call16(malloc)($28)
        addiu   $4,$7,1
        sw      $5,24($sp)
        sw      $6,28($sp)
        sw      $7,32($sp)
        jalr    $25
        sll     $4,$4,2
        li      $3,-1                   # 0xffffffffffffffff
        lw      $28,16($sp)
        lw      $7,32($sp)
        lw      $6,28($sp)
        lw      $5,24($sp)
        sw      $3,0($2)
        move    $8,$0
        move    $11,$0
$L5:
        sll     $3,$8,2
        addu    $3,$2,$3
        lw      $3,0($3)
        addiu   $4,$8,1
        sll     $4,$4,2
        addu    $4,$2,$4
        addiu   $9,$3,1
        blez    $9,$L3
        sw      $9,0($4)
        addu    $8,$6,$8
        lbu     $10,0($8)
        b       $L19
        addu    $9,$6,$3
$L22:
        addu    $3,$2,$3
        lw      $8,0($3)
        nop
        move    $3,$8
        addu    $9,$6,$8
        addiu   $8,$8,1
        blez    $8,$L3
        sw      $8,0($4)
$L19:
        lbu     $8,0($9)
        nop
        bne     $10,$8,$L22
        sll     $3,$3,2
$L3:
        addiu   $11,$11,1
        bne     $11,$7,$L5
        move    $8,$11
        move    $3,$0
        move    $4,$0
        sltu    $11,$0,$5
$L17:
        sll     $8,$3,2
        addu    $10,$6,$3
        addu    $9,$16,$4
        beq     $11,$0,$L23
        addu    $8,$2,$8

$L10:
        bltz    $3,$L7
        nop

        lbu     $12,0($9)
        lbu     $9,0($10)
        nop
        beq     $12,$9,$L7
        addu    $9,$16,$4
        lw      $3,0($8)
        nop
        sll     $8,$3,2
        addu    $10,$6,$3
        bne     $11,$0,$L10
        addu    $8,$2,$8

$L23:
        move    $16,$0
$L9:
        lw      $25,%call16(free)($28)
        nop
        jalr    $25
        move    $4,$2
        lw      $31,44($sp)
        move    $2,$16
        lw      $16,40($sp)
        j       $31
        addiu   $sp,$sp,48
$L7:
        addiu   $3,$3,1
        beq     $3,$7,$L18
        addiu   $4,$4,1
        b       $L17
        sltu    $11,$4,$5
$L18:
        subu    $3,$4,$3
        b       $L9
        addu    $16,$16,$3
_PRE_END

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise20/')</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #17')

_HTML_LINK(`http://yurichev.com/blog/exercise17',`(Link to exercise)')

m4_include(`spoiler_show.inc')

<div id="example" class="hidden">

<p>
This code just parses UUID (or GUID in Microsoft terms):
</p>

<!--
// reworked from http://www.opensource.apple.com/source/Libc/Libc-391.5.21/uuid/uuidsrc/parse.c
int f3(const char *in, uint32_t *uuid1, uint16_t *uuid2, uint16_t *uuid3, uint16_t *uuid4, uint64_t *uuid5)
{
        int             i;
        const char      *cp;

        if (strlen(in) != 36)
                return -1;
        for (i=0, cp = in; i <= 36; i++,cp++) {
                if ((i == 8) || (i == 13) || (i == 18) ||
                    (i == 23)) {
                        if (*cp == '-')
                                continue;
                        else
                                return -1;
                }
                if (i== 36)
                        if (*cp == 0)
                                continue;
                if (!isxdigit(*cp))
                        return -1;
        }

        *uuid1=strtoul(in, NULL, 16);
        *uuid2=strtoul(in+9, NULL, 16);
        *uuid3=strtoul(in+14, NULL, 16);
        *uuid4=strtoul(in+19, NULL, 16);
        *uuid5=strtoull(in+24, NULL, 16);

        return 0;
}

int main()
{
        //printf ("%s\n", f2 (HAYSTACK, strlen(HAYSTACK), NEEDLE, strlen(NEEDLE)));
        uint32_t uuid1;
        uint16_t uuid2, uuid3, uuid4;
        uint64_t uuid5;

        f3("de305d54-75b4-431b-adb2-eb6b9e546014", &uuid1, &uuid2, &uuid3, &uuid4, &uuid5);

        printf ("0x%x\n", uuid1);
        printf ("0x%x\n", uuid2);
        printf ("0x%x\n", uuid3);
        printf ("0x%x\n", uuid4);
        printf ("0x%llx\n", uuid5);
};
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#696969; '>// reworked from </span><span style='color:#5555dd; '>http://www.opensource.apple.com/source/Libc/Libc-391.5.21/uuid/uuidsrc/parse.c</span>
<span style='color:#800000; font-weight:bold; '>int</span> f3<span style='color:#808030; '>(</span><span style='color:#800000; font-weight:bold; '>const</span> <span style='color:#800000; font-weight:bold; '>char</span> <span style='color:#808030; '>*</span>in<span style='color:#808030; '>,</span> uint32_t <span style='color:#808030; '>*</span>uuid1<span style='color:#808030; '>,</span> uint16_t <span style='color:#808030; '>*</span>uuid2<span style='color:#808030; '>,</span> uint16_t <span style='color:#808030; '>*</span>uuid3<span style='color:#808030; '>,</span> uint16_t <span style='color:#808030; '>*</span>uuid4<span style='color:#808030; '>,</span> uint64_t <span style='color:#808030; '>*</span>uuid5<span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
        <span style='color:#800000; font-weight:bold; '>int</span>             i<span style='color:#800080; '>;</span>
        <span style='color:#800000; font-weight:bold; '>const</span> <span style='color:#800000; font-weight:bold; '>char</span>      <span style='color:#808030; '>*</span>cp<span style='color:#800080; '>;</span>

        <span style='color:#800000; font-weight:bold; '>if</span> <span style='color:#808030; '>(</span><span style='color:#603000; '>strlen</span><span style='color:#808030; '>(</span>in<span style='color:#808030; '>)</span> <span style='color:#808030; '>!</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>36</span><span style='color:#808030; '>)</span>
                <span style='color:#800000; font-weight:bold; '>return</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#800080; '>;</span>
        <span style='color:#800000; font-weight:bold; '>for</span> <span style='color:#808030; '>(</span>i<span style='color:#808030; '>=</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> cp <span style='color:#808030; '>=</span> in<span style='color:#800080; '>;</span> i <span style='color:#808030; '>&lt;</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>36</span><span style='color:#800080; '>;</span> i<span style='color:#808030; '>+</span><span style='color:#808030; '>+</span><span style='color:#808030; '>,</span>cp<span style='color:#808030; '>+</span><span style='color:#808030; '>+</span><span style='color:#808030; '>)</span> <span style='color:#800080; '>{</span>
                <span style='color:#800000; font-weight:bold; '>if</span> <span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>i <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>8</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>|</span><span style='color:#808030; '>|</span> <span style='color:#808030; '>(</span>i <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>13</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>|</span><span style='color:#808030; '>|</span> <span style='color:#808030; '>(</span>i <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>18</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>|</span><span style='color:#808030; '>|</span>
                    <span style='color:#808030; '>(</span>i <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>23</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span> <span style='color:#800080; '>{</span>
                        <span style='color:#800000; font-weight:bold; '>if</span> <span style='color:#808030; '>(</span><span style='color:#808030; '>*</span>cp <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#0000e6; '>'-'</span><span style='color:#808030; '>)</span>
                                <span style='color:#800000; font-weight:bold; '>continue</span><span style='color:#800080; '>;</span>
                        <span style='color:#800000; font-weight:bold; '>else</span>
                                <span style='color:#800000; font-weight:bold; '>return</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#800080; '>;</span>
                <span style='color:#800080; '>}</span>
                <span style='color:#800000; font-weight:bold; '>if</span> <span style='color:#808030; '>(</span>i<span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>36</span><span style='color:#808030; '>)</span>
                        <span style='color:#800000; font-weight:bold; '>if</span> <span style='color:#808030; '>(</span><span style='color:#808030; '>*</span>cp <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
                                <span style='color:#800000; font-weight:bold; '>continue</span><span style='color:#800080; '>;</span>
                <span style='color:#800000; font-weight:bold; '>if</span> <span style='color:#808030; '>(</span><span style='color:#808030; '>!</span><span style='color:#603000; '>isxdigit</span><span style='color:#808030; '>(</span><span style='color:#808030; '>*</span>cp<span style='color:#808030; '>)</span><span style='color:#808030; '>)</span>
                        <span style='color:#800000; font-weight:bold; '>return</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#800080; '>;</span>
        <span style='color:#800080; '>}</span>

        <span style='color:#808030; '>*</span>uuid1<span style='color:#808030; '>=</span><span style='color:#603000; '>strtoul</span><span style='color:#808030; '>(</span>in<span style='color:#808030; '>,</span> <span style='color:#7d0045; '>NULL</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>16</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#808030; '>*</span>uuid2<span style='color:#808030; '>=</span><span style='color:#603000; '>strtoul</span><span style='color:#808030; '>(</span>in<span style='color:#808030; '>+</span><span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> <span style='color:#7d0045; '>NULL</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>16</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#808030; '>*</span>uuid3<span style='color:#808030; '>=</span><span style='color:#603000; '>strtoul</span><span style='color:#808030; '>(</span>in<span style='color:#808030; '>+</span><span style='color:#008c00; '>14</span><span style='color:#808030; '>,</span> <span style='color:#7d0045; '>NULL</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>16</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#808030; '>*</span>uuid4<span style='color:#808030; '>=</span><span style='color:#603000; '>strtoul</span><span style='color:#808030; '>(</span>in<span style='color:#808030; '>+</span><span style='color:#008c00; '>19</span><span style='color:#808030; '>,</span> <span style='color:#7d0045; '>NULL</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>16</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#808030; '>*</span>uuid5<span style='color:#808030; '>=</span><span style='color:#603000; '>strtoull</span><span style='color:#808030; '>(</span>in<span style='color:#808030; '>+</span><span style='color:#008c00; '>24</span><span style='color:#808030; '>,</span> <span style='color:#7d0045; '>NULL</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>16</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>

        <span style='color:#800000; font-weight:bold; '>return</span> <span style='color:#008c00; '>0</span><span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span>

<span style='color:#800000; font-weight:bold; '>int</span> <span style='color:#400000; '>main</span><span style='color:#808030; '>(</span><span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
        <span style='color:#696969; '>//printf ("%s\n", f2 (HAYSTACK, strlen(HAYSTACK), NEEDLE, strlen(NEEDLE)));</span>
        uint32_t uuid1<span style='color:#800080; '>;</span>
        uint16_t uuid2<span style='color:#808030; '>,</span> uuid3<span style='color:#808030; '>,</span> uuid4<span style='color:#800080; '>;</span>
        uint64_t uuid5<span style='color:#800080; '>;</span>

        f3<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>de305d54-75b4-431b-adb2-eb6b9e546014</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>&amp;</span>uuid1<span style='color:#808030; '>,</span> <span style='color:#808030; '>&amp;</span>uuid2<span style='color:#808030; '>,</span> <span style='color:#808030; '>&amp;</span>uuid3<span style='color:#808030; '>,</span> <span style='color:#808030; '>&amp;</span>uuid4<span style='color:#808030; '>,</span> <span style='color:#808030; '>&amp;</span>uuid5<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>

        <span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>0x</span><span style='color:#007997; '>%x</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> uuid1<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>0x</span><span style='color:#007997; '>%x</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> uuid2<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>0x</span><span style='color:#007997; '>%x</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> uuid3<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>0x</span><span style='color:#007997; '>%x</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> uuid4<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>0x</span><span style='color:#007997; '>%llx</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> uuid5<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span><span style='color:#800080; '>;</span>
</pre>

m4_include(`spoiler_hide.inc')
</div>

_BLOG_FOOTER_GITHUB(`exercise19')

_BLOG_FOOTER()

