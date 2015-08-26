m4_include(`commons.m4')

_HEADER_HL1(`22-Aug-2015: The next reverse engineering exercise (for x86, ARM, ARM64, MIPS)')

<p>What this code does?</p>

<p>Some versions has 0x1010101 constant, some are not. Why?</p>
 
<p>Optimizing GCC 4.8.2:</p>

_PRE_BEGIN
0000000000000000 <f>:
   0:   89 fa                   mov    edx,edi
   2:   d1 ea                   shr    edx,1
   4:   81 e2 55 55 55 55       and    edx,0x55555555
   a:   29 d7                   sub    edi,edx
   c:   89 f8                   mov    eax,edi
   e:   c1 ef 02                shr    edi,0x2
  11:   25 33 33 33 33          and    eax,0x33333333
  16:   81 e7 33 33 33 33       and    edi,0x33333333
  1c:   01 c7                   add    edi,eax
  1e:   89 f8                   mov    eax,edi
  20:   c1 e8 04                shr    eax,0x4
  23:   01 f8                   add    eax,edi
  25:   25 0f 0f 0f 0f          and    eax,0xf0f0f0f
  2a:   69 c0 01 01 01 01       imul   eax,eax,0x1010101
  30:   c1 e8 18                shr    eax,0x18
  33:   c3                      ret
_PRE_END

<p>Optimizing GCC 4.9.3 for ARM64:</p>

_PRE_BEGIN
0000000000000000 <f>:
   0:   53017c01        lsr     w1, w0, #1
   4:   1200f021        and     w1, w1, #0x55555555
   8:   4b010000        sub     w0, w0, w1
   c:   1200e401        and     w1, w0, #0x33333333
  10:   53027c00        lsr     w0, w0, #2
  14:   1200e400        and     w0, w0, #0x33333333
  18:   0b010000        add     w0, w0, w1
  1c:   3200c3e1        mov     w1, #0x1010101                  // #16843009
  20:   0b401000        add     w0, w0, w0, lsr #4
  24:   1200cc00        and     w0, w0, #0xf0f0f0f
  28:   1b017c00        mul     w0, w0, w1
  2c:   53187c00        lsr     w0, w0, #24
  30:   d65f03c0        ret
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

_PRE_BEGIN
f PROC
        LDR      r1,|L0.148|
        AND      r1,r1,r0,LSR #1
        SUB      r0,r0,r1
        LDR      r1,|L0.152|
        AND      r2,r0,r1
        AND      r0,r1,r0,LSR #2
        LDR      r1,|L0.156|
        ADD      r0,r0,r2
        ADD      r0,r0,r0,LSR #4
        AND      r0,r0,r1
        ADD      r0,r0,r0,LSL #16
        ADD      r0,r0,r0,LSL #8
        LSR      r0,r0,#24
        BX       lr
        ENDP

|L0.148|
        DCD      0x55555555
|L0.152|
        DCD      0x33333333
|L0.156|
        DCD      0x0f0f0f0f
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

_PRE_BEGIN
f PROC
        LSRS     r1,r0,#1
        LDR      r2,|L0.100|
        ANDS     r1,r1,r2
        SUBS     r0,r0,r1
        LDR      r1,|L0.104|
        MOVS     r2,r0
        LSRS     r0,r0,#2
        ANDS     r2,r2,r1
        ANDS     r0,r0,r1
        ADDS     r0,r2,r0
        LSRS     r1,r0,#4
        ADDS     r0,r1,r0
        LDR      r1,|L0.108|
        ANDS     r0,r0,r1
        LDR      r1,|L0.112|
        MULS     r0,r1,r0
        LSRS     r0,r0,#24
        BX       lr
        ENDP

|L0.100|
        DCD      0x55555555
|L0.104|
        DCD      0x33333333
|L0.108|
        DCD      0x0f0f0f0f
|L0.112|
        DCD      0x01010101
_PRE_END

<p>Optimizing GCC 4.4.5 for MIPS:</p>

_PRE_BEGIN
f:
        .frame  $sp,0,$31               # vars= 0, regs= 0/0, args= 0, gp= 0
        .mask   0x00000000,0
        .fmask  0x00000000,0
        .set    noreorder
        .set    nomacro
        li      $2,1431633920                   # 0x55550000
        srl     $3,$4,1
        ori     $2,$2,0x5555
        and     $2,$3,$2
        subu    $4,$4,$2
        li      $3,858980352                    # 0x33330000
        ori     $3,$3,0x3333
        srl     $2,$4,2
        and     $2,$2,$3
        and     $3,$4,$3
        addu    $2,$2,$3
        srl     $3,$2,4
        addu    $2,$3,$2
        li      $3,252641280                    # 0xf0f0000
        ori     $3,$3,0xf0f
        and     $2,$2,$3
        sll     $3,$2,8
        addu    $2,$3,$2
        sll     $3,$2,16
        addu    $2,$2,$3
        j       $31
        srl     $2,$2,24 
_PRE_END

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/2015-aug-26/').</p>

_BLOG_FOOTER()


