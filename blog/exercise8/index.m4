m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #8 (for x86, ARM, ARM64, MIPS); solution for exercise #7')

_HL2(`Reverse engineering exercise #8 (for x86, ARM, ARM64, MIPS)')

<p>What this code does?
This is one of the busiest algorithms under the hood, though, usually hidden from programmers.
It implements one of the most popular algorithms in computer science.
It features recursion and callback function.</p>

<p>Optimizing GCC 4.8.2:</p>

_PRE_BEGIN
&lt;f>:
   0:       push   r12
   2:       test   rsi,rsi
   5:       mov    r12,rdi
   8:       push   rbp
   9:       mov    rbp,rdx
   c:       push   rbx
   d:       mov    rbx,rsi
  10:       je     32 <f+0x32>
  12:       nop    WORD PTR [rax+rax*1+0x0]
  18:       mov    rsi,QWORD PTR [rbx]
  1b:       mov    rdi,rbp
  1e:       call   r12
  21:       test   eax,eax
  23:       je     56 <f+0x56>
  25:       js     40 <f+0x40>
  27:       mov    rbx,QWORD PTR [rbx+0x18]
  2b:       test   rbx,rbx
  2e:       xchg   ax,ax
  30:       jne    18 <f+0x18>
  32:       pop    rbx
  33:       pop    rbp
  34:       xor    eax,eax
  36:       pop    r12
  38:       ret
  39:       nop    DWORD PTR [rax+0x0]
  40:       mov    rbx,QWORD PTR [rbx+0x10]
  44:       test   rbx,rbx
  47:       je     32 <f+0x32>
  49:       mov    rsi,QWORD PTR [rbx]
  4c:       mov    rdi,rbp
  4f:       call   r12
  52:       test   eax,eax
  54:       jne    25 <f+0x25>
  56:       mov    rax,rbx
  59:       pop    rbx
  5a:       pop    rbp
  5b:       pop    r12
  5d:       ret
_PRE_END

<p>Optimizing GCC 4.9.3 for ARM64:</p>

_PRE_BEGIN
&lt;f>:
   0:           stp     x29, x30, [sp,#-48]!
   4:           mov     x29, sp
   8:           stp     x19, x20, [sp,#16]
   c:           str     x21, [sp,#32]
  10:           mov     x19, x1
  14:           mov     x21, x0
  18:           mov     x20, x2
  1c:           cbz     x1, 40 <f+0x40>
  20:           ldr     x1, [x19]
  24:           mov     x0, x20
  28:           blr     x21
  2c:           cmp     w0, wzr
  30:           b.eq    70 <f+0x70>
  34:           b.lt    54 <f+0x54>
  38:           ldr     x19, [x19,#24]
  3c:           cbnz    x19, 20 <f+0x20>
  40:           mov     x0, #0x0                        // #0
  44:           ldr     x21, [sp,#32]
  48:           ldp     x19, x20, [sp,#16]
  4c:           ldp     x29, x30, [sp],#48
  50:           ret
  54:           ldr     x19, [x19,#16]
  58:           cbz     x19, 40 <f+0x40>
  5c:           ldr     x1, [x19]
  60:           mov     x0, x20
  64:           blr     x21
  68:           cmp     w0, wzr
  6c:           b.ne    34 <f+0x34>
  70:           mov     x0, x19
  74:           ldr     x21, [sp,#32]
  78:           ldp     x19, x20, [sp,#16]
  7c:           ldp     x29, x30, [sp],#48
  80:           ret
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

_PRE_BEGIN
f PROC
        PUSH     {r4-r6,lr}
|L0.4|
        MOVS     r4,r1
        MOV      r5,r0
        MOV      r6,r2
        BEQ      |L0.72|
        LDR      r1,[r4,#0]
        MOV      r0,r2
        MOV      lr,pc
        BX       r5
        CMP      r0,#0
        LDRGT    r1,[r4,#0xc]
        LDRLT    r1,[r4,#8]
        MOVEQ    r0,r4
        POPEQ    {r4-r6,pc}
        CMP      r1,#0
        MOVNE    r2,r6
        MOVNE    r0,r5
        BNE      |L0.4|
|L0.72|
        MOV      r0,#0
        POP      {r4-r6,pc}
        ENDP
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

_PRE_BEGIN
f PROC
        PUSH     {r4-r6,lr}
|L0.2|
        MOVS     r4,r1
        MOVS     r5,r0
        MOVS     r6,r2
        CMP      r1,#0
        BEQ      |L0.46|
        LDR      r1,[r4,#0]
        MOVS     r0,r2
        BL       __ARM_common_call_via_r5_thumb
        CMP      r0,#0
        BEQ      |L0.30|
        BGE      |L0.40|
        LDR      r1,[r4,#8]
        B        |L0.42|
|L0.30|
        MOVS     r0,r4
        POP      {r4-r6,pc}
|L0.34|
        MOVS     r2,r6
        MOVS     r0,r5
        B        |L0.2|
|L0.40|
        LDR      r1,[r4,#0xc]
|L0.42|
        CMP      r1,#0
        BNE      |L0.34|
|L0.46|
        MOVS     r0,#0
        POP      {r4-r6,pc}
        ENDP

__ARM_common_call_via_r5_thumb PROC
        BX       r5
        ENDP
_PRE_END

<p>Optimizing GCC 4.4.5 for MIPS:</p>

_PRE_BEGIN
f:
        addiu   $sp,$sp,-40
        sw      $18,32($sp)
        sw      $17,28($sp)
        sw      $16,24($sp)
        sw      $31,36($sp)
        move    $16,$5
        move    $17,$4
        beq     $5,$0,$L2
        move    $18,$6

$L8:
        lw      $5,0($16)
        move    $25,$17
        jalr    $25
        move    $4,$18
        beq     $2,$0,$L2
        nop
        bltz    $2,$L10
        nop
        lw      $16,12($16)
        nop
        bne     $16,$0,$L8
        nop
$L2:
        lw      $31,36($sp)
        move    $2,$16
        lw      $18,32($sp)
        lw      $17,28($sp)
        lw      $16,24($sp)
        j       $31
        addiu   $sp,$sp,40

$L10:
        lw      $16,8($16)
        nop
        bne     $16,$0,$L8
        nop
        b       $L2
        nop
_PRE_END

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise9/')</p>

_HL2(`Reverse engineering exercise #7')

_HTML_LINK(`http://yurichev.com/blog/exercise7/',`(Link to exercise)')

<p>Spoiler warning! The text below has white color, select it using mouse to read the text (or press Ctrl-A):</p>

<p class="spoiler">The function just makes all characters in input string lowercase:</p>

<pre class="spoiler">
#include &lt;string.h>
#include &lt;stdio.h>
#include &lt;stdlib.h>
#include &lt;memory.h>

char* f(char *s)
{
        char *tmp=s;
        for (;*tmp;tmp++)
        {
                if (*tmp>='A' && *tmp&lt;='Z')
                        *tmp=*tmp+0x20; // 0x20 is a distance between uppercase and lowercase characters in ASCII table
        };
        return s;
};
int main()
{
        printf ("%s\n", f(strdup("Hello WORLD")));
        printf ("%s\n", f(strdup("HOW IS THE WEATHER TODAY?")));
        printf ("%s\n", f(strdup("fine, thanks")));
};
</pre>

_BLOG_FOOTER()
