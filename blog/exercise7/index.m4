m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #7 (for x86, ARM, ARM64, MIPS); solution for exercise #6')

_HL2(`Reverse engineering exercise #7 (for x86, ARM, ARM64, MIPS)')

<p>What this code does?
This is one of the simplest exercises I made, but still this code can be served as useful library function 
and is certainly used in many modern real-world applications.</p>

<p>Optimizing GCC 4.8.2:</p>

_PRE_BEGIN
&lt;f>:
   0:                movzx  edx,BYTE PTR [rdi]
   3:                mov    rax,rdi
   6:                mov    rcx,rdi
   9:                test   dl,dl
   b:                je     29 <f+0x29>
   d:                nop    DWORD PTR [rax]
  10:                lea    esi,[rdx-0x41]
  13:                cmp    sil,0x19
  17:                ja     1e <f+0x1e>
  19:                add    edx,0x20
  1c:                mov    BYTE PTR [rcx],dl
  1e:                add    rcx,0x1
  22:                movzx  edx,BYTE PTR [rcx]
  25:                test   dl,dl
  27:                jne    10 <f+0x10>
  29:                repz ret
_PRE_END

<p>Optimizing GCC 4.9.3 for ARM64:</p>

_PRE_BEGIN
&lt;f>:
   0:           ldrb    w1, [x0]
   4:           mov     x3, x0
   8:           cbz     w1, 2c <f+0x2c>
   c:           sub     w2, w1, #0x41
  10:           add     w1, w1, #0x20
  14:           uxtb    w2, w2
  18:           cmp     w2, #0x19
  1c:           b.hi    24 <f+0x24>
  20:           strb    w1, [x3]
  24:           ldrb    w1, [x3,#1]!
  28:           cbnz    w1, c <f+0xc>
  2c:           ret
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

_PRE_BEGIN
f PROC
        MOV      r1,r0
|L0.4|
        LDRB     r2,[r1,#0]
        CMP      r2,#0
        BXEQ     lr
        SUB      r3,r2,#0x41
        CMP      r3,#0x19
        ADDLS    r2,r2,#0x20
        STRBLS   r2,[r1,#0]
        ADD      r1,r1,#1
        B        |L0.4|
        ENDP
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

_PRE_BEGIN
f PROC
        MOVS     r1,r0
        B        |L0.18|
|L0.4|
        MOVS     r3,r2
        SUBS     r3,r3,#0x41
        CMP      r3,#0x19
        BHI      |L0.16|
        ADDS     r2,r2,#0x20
        STRB     r2,[r1,#0]
|L0.16|
        ADDS     r1,r1,#1
|L0.18|
        LDRB     r2,[r1,#0]
        CMP      r2,#0
        BNE      |L0.4|
        BX       lr
        ENDP
_PRE_END

<p>Optimizing GCC 4.4.5 for MIPS:</p>

_PRE_BEGIN
f:
        lb      $5,0($4)
        nop
        beq     $5,$0,$L9
        move    $2,$4

        move    $3,$4
        andi    $5,$5,0x00ff
$L8:
        addiu   $6,$5,-65
        andi    $6,$6,0x00ff
        sltu    $6,$6,26
        beq     $6,$0,$L3
        addiu   $5,$5,32
        sb      $5,0($3)
$L3:
        addiu   $3,$3,1
        lb      $5,0($3)
        nop
        bne     $5,$0,$L8
        andi    $5,$5,0x00ff
$L9:
        j       $31
        nop
_PRE_END

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise8/').</p>

_HL2(`Reverse engineering exercise #6')

_HTML_LINK(`http://yurichev.com/blog/exercise6/',`(Link to exercise)')

<p>Spoiler warning! The text below has white color, select it using mouse to read the text (or press Ctrl-A):</p>

<p class="spoiler">The function converts Latin-1 (AKA ISO/IEC 8859-1) string to UTF-16.
In other words, it just interleaves all input bytes by zero byte.</p>

<pre class="spoiler">
void convert_Latin_to_UTF16 (char *in, uint16_t *out)
{
        for(;;)
        {
                *out=*in;
                if (*out==0)
                        break;
                in++;
                out++;
        };
};
</pre>

_BLOG_FOOTER()
