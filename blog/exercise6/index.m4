m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #6 (for x86, ARM, ARM64, MIPS)')

<p>What this code does?
This is one of the simplest exercises I made, but still this code can be served as useful library function 
and is certainly used in many modern real-world applications.</p>

<p>Non-optimizing GCC 4.8.2:</p>

_PRE_BEGIN
&lt;f>:
   0:             push   rbp
   1:             mov    rbp,rsp
   4:             mov    QWORD PTR [rbp-0x8],rdi
   8:             mov    QWORD PTR [rbp-0x10],rsi
   c:             mov    rax,QWORD PTR [rbp-0x8]
  10:             movzx  eax,BYTE PTR [rax]
  13:             movsx  dx,al
  17:             mov    rax,QWORD PTR [rbp-0x10]
  1b:             mov    WORD PTR [rax],dx
  1e:             mov    rax,QWORD PTR [rbp-0x10]
  22:             movzx  eax,WORD PTR [rax]
  25:             test   ax,ax
  28:             jne    2c <f+0x2c>
  2a:             jmp    38 <f+0x38>
  2c:             add    QWORD PTR [rbp-0x8],0x1
  31:             add    QWORD PTR [rbp-0x10],0x2
  36:             jmp    c <f+0xc>
  38:             pop    rbp
  39:             ret
_PRE_END

<p>Optimizing GCC 4.8.2:</p>

_PRE_BEGIN
&lt;f>:
   0:          jmp    10 <f+0x10>
   2:          nop    WORD PTR [rax+rax*1+0x0]
   8:          add    rdi,0x1
   c:          add    rsi,0x2
  10:          movsx  ax,BYTE PTR [rdi]
  14:          test   ax,ax
  17:          mov    WORD PTR [rsi],ax
  1a:          jne    8 <f+0x8>
  1c:          repz ret
  1e:          xchg   ax,ax
_PRE_END

<p>Optimizing GCC 4.9.3 for ARM64:</p>

_PRE_BEGIN
&lt;f>:
   0:           ldrb    w2, [x0]
   4:           strh    w2, [x1]
   8:           cbz     w2, 18 <f+0x18>
   c:           ldrb    w2, [x0,#1]!
  10:           strh    w2, [x1,#2]!
  14:           cbnz    w2, c <f+0xc>
  18:           ret
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

_PRE_BEGIN
f PROC
|L0.0|
        LDRB     r2,[r0,#0]
        CMP      r2,#0
        STRH     r2,[r1,#0]
        BEQ      |L0.14|
        ADDS     r0,r0,#1
        ADDS     r1,r1,#2
        B        |L0.0|
|L0.14|
        BX       lr
        ENDP
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

_PRE_BEGIN
f PROC
|L0.0|
        LDRB     r2,[r0,#0]
        CMP      r2,#0
        STRH     r2,[r1,#0]
        ADDNE    r0,r0,#1
        ADDNE    r1,r1,#2
        BNE      |L0.0|
        BX       lr
        ENDP
_PRE_END

<p>Optimizing GCC 4.4.5 for MIPS:</p>

_PRE_BEGIN
f:
        lb      $2,0($4)
        nop
        andi    $2,$2,0xffff
        beq     $2,$0,$L8
        sh      $2,0($5)

$L5:
        addiu   $4,$4,1
        lb      $2,0($4)
        addiu   $5,$5,2
        andi    $2,$2,0xffff
        bne     $2,$0,$L5
        sh      $2,0($5)
$L8:
        j       $31
        nop
_PRE_END

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise7/')</p>

<!-- надо будет потом дописать про "редкие" инструкции вроде SH (MIPS), STRH (ARM), etc -->

_BLOG_FOOTER()
