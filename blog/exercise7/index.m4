m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #7 (for x86, ARM, ARM64, MIPS); solution for exercise #6')

_HL2(`Reverse engineering exercise #7 (for x86, ARM, ARM64, MIPS)')

<p>What this code does?
This is one of the simplest exercises I made, but still this code can be served as useful library function 
and is certainly used in many modern real-world applications.</p>

<p>Optimizing GCC 4.8.2:</p>

<!--
_PRE_BEGIN
<f>:
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
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>                <span style='color:#800000; font-weight:bold; '>movzx</span>  <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>BYTE</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rdi<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;3:</span>                <span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span>rdi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;6:</span>                <span style='color:#800000; font-weight:bold; '>mov</span>    rcx<span style='color:#808030; '>,</span>rdi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;9:</span>                <span style='color:#800000; font-weight:bold; '>test</span>   <span style='color:#000080; '>dl</span><span style='color:#808030; '>,</span><span style='color:#000080; '>dl</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;b:</span>                <span style='color:#800000; font-weight:bold; '>je</span>     <span style='color:#e34adc; '>29</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x29</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;d:</span>                <span style='color:#800000; font-weight:bold; '>nop</span>    <span style='color:#800000; font-weight:bold; '>DWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rax<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>                <span style='color:#800000; font-weight:bold; '>lea</span>    <span style='color:#000080; '>esi</span><span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>rdx<span style='color:#808030; '>-</span><span style='color:#008000; '>0x41</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;13:</span>                <span style='color:#800000; font-weight:bold; '>cmp</span>    sil<span style='color:#808030; '>,</span><span style='color:#008000; '>0x19</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;17:</span>                <span style='color:#800000; font-weight:bold; '>ja</span>     <span style='color:#e34adc; '>1e</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x1e</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;19:</span>                <span style='color:#800000; font-weight:bold; '>add</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x20</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1c:</span>                <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>BYTE</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rcx<span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#000080; '>dl</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1e:</span>                <span style='color:#800000; font-weight:bold; '>add</span>    rcx<span style='color:#808030; '>,</span><span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;22:</span>                <span style='color:#800000; font-weight:bold; '>movzx</span>  <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>BYTE</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rcx<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;25:</span>                <span style='color:#800000; font-weight:bold; '>test</span>   <span style='color:#000080; '>dl</span><span style='color:#808030; '>,</span><span style='color:#000080; '>dl</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;27:</span>                <span style='color:#800000; font-weight:bold; '>jne</span>    <span style='color:#e34adc; '>10</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;29:</span>                <span style='color:#800000; font-weight:bold; '>repz</span> <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>Optimizing GCC 4.9.3 for ARM64:</p>

<!--
_PRE_BEGIN
<f>:
0:           ldrb    w1, [x0]
4:           mov     x3, x0
8:           cbz     w1, 2c <f+0x2c>
c:           sub     w2, w1, #0x41
10:          add     w1, w1, #0x20
14:          uxtb    w2, w2
18:          cmp     w2, #0x19
1c:          b.hi    24 <f+0x24>
20:          strb    w1, [x3]
24:          ldrb    w1, [x3,#1]!
28:          cbnz    w1, c <f+0xc>
2c:          ret
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#008c00; '>0</span><span style='color:#808030; '>:</span>           ldrb    w1<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x0<span style='color:#808030; '>]</span>
<span style='color:#008c00; '>4</span><span style='color:#808030; '>:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x3<span style='color:#808030; '>,</span> x0
<span style='color:#008c00; '>8</span><span style='color:#808030; '>:</span>           cbz     w1<span style='color:#808030; '>,</span> 2c <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x2c</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>c:</span>           <span style='color:#800000; font-weight:bold; '>sub</span>     w2<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x41</span>
<span style='color:#008c00; '>10</span><span style='color:#808030; '>:</span>          <span style='color:#800000; font-weight:bold; '>add</span>     w1<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x20</span>
<span style='color:#008c00; '>14</span><span style='color:#808030; '>:</span>          uxtb    w2<span style='color:#808030; '>,</span> w2
<span style='color:#008c00; '>18</span><span style='color:#808030; '>:</span>          <span style='color:#800000; font-weight:bold; '>cmp</span>     w2<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x19</span>
<span style='color:#e34adc; '>1c:</span>          b.hi    <span style='color:#008c00; '>24</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x24</span><span style='color:#808030; '>></span>
<span style='color:#008c00; '>20</span><span style='color:#808030; '>:</span>          strb    w1<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x3<span style='color:#808030; '>]</span>
<span style='color:#008c00; '>24</span><span style='color:#808030; '>:</span>          ldrb    w1<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x3<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#808030; '>!</span>
<span style='color:#008c00; '>28</span><span style='color:#808030; '>:</span>          cbnz    w1<span style='color:#808030; '>,</span> <span style='color:#004a43; '>c</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0xc</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>2c:</span>          <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        <span style='color:#800000; font-weight:bold; '>MOV</span>      r1<span style='color:#808030; '>,</span>r0
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.4</span><span style='color:#808030; '>|</span>
        LDRB     r2<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r2<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        BXEQ     lr
        <span style='color:#800000; font-weight:bold; '>SUB</span>      r3<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x41</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r3<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x19</span>
        ADDLS    r2<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x20</span>
        STRBLS   r2<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>ADD</span>      r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        B        <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.4</span><span style='color:#808030; '>|</span>
        <span style='color:#004a43; '>ENDP</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r1<span style='color:#808030; '>,</span>r0
        B        <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.18</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.4</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r3<span style='color:#808030; '>,</span>r2
        SUBS     r3<span style='color:#808030; '>,</span>r3<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x41</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r3<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x19</span>
        BHI      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.16</span><span style='color:#808030; '>|</span>
        ADDS     r2<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x20</span>
        STRB     r2<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.16</span><span style='color:#808030; '>|</span>
        ADDS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.18</span><span style='color:#808030; '>|</span>
        LDRB     r2<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r2<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        BNE      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.4</span><span style='color:#808030; '>|</span>
        <span style='color:#000080; '>BX</span>       lr
        <span style='color:#004a43; '>ENDP</span>
</pre>

<p>Optimizing GCC 4.4.5 for MIPS:</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>f:</span>
        lb      <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>)</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
        beq     <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L9
        move    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>

        move    <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>
        andi    <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x00ff</span>
<span style='color:#e34adc; '>$L8:</span>
        addiu   <span style='color:#008000; '>$6</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>-65</span>
        andi    <span style='color:#008000; '>$6</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$6</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x00ff</span>
        sltu    <span style='color:#008000; '>$6</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$6</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>26</span>
        beq     <span style='color:#008000; '>$6</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L3
        addiu   <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>32</span>
        sb      <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>)</span>
<span style='color:#e34adc; '>$L3:</span>
        addiu   <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
        lb      <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>)</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
        bne     <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L8
        andi    <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x00ff</span>
<span style='color:#e34adc; '>$L9:</span>
        j       <span style='color:#008000; '>$31</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
</pre>

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise8/').</p>

_EXERCISE_FOOTER()

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
