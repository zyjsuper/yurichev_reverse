m4_include(`commons.m4')

_HEADER_HL1(`22-Aug-2015: The next reverse engineering exercise (for x86, ARM, ARM64, MIPS)')

<p>What this code does?</p>

<p>Some versions has 0x1010101 constant, some are not. Why?</p>
 
<p>Optimizing GCC 4.8.2:</p>

<!--
_PRE_BEGIN
<f>:
   0:          mov    edx,edi
   2:          shr    edx,1
   4:          and    edx,0x55555555
   a:          sub    edi,edx
   c:          mov    eax,edi
   e:          shr    edi,0x2
  11:          and    eax,0x33333333
  16:          and    edi,0x33333333
  1c:          add    edi,eax
  1e:          mov    eax,edi
  20:          shr    eax,0x4
  23:          add    eax,edi
  25:          and    eax,0xf0f0f0f
  2a:          imul   eax,eax,0x1010101
  30:          shr    eax,0x18
  33:          ret
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>          <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#000080; '>edi</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;2:</span>          <span style='color:#800000; font-weight:bold; '>shr</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x55555555</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;a:</span>          <span style='color:#800000; font-weight:bold; '>sub</span>    <span style='color:#000080; '>edi</span><span style='color:#808030; '>,</span><span style='color:#000080; '>edx</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;c:</span>          <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>edi</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;e:</span>          <span style='color:#800000; font-weight:bold; '>shr</span>    <span style='color:#000080; '>edi</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;11:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x33333333</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;16:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>edi</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x33333333</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1c:</span>          <span style='color:#800000; font-weight:bold; '>add</span>    <span style='color:#000080; '>edi</span><span style='color:#808030; '>,</span><span style='color:#000080; '>eax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1e:</span>          <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>edi</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;20:</span>          <span style='color:#800000; font-weight:bold; '>shr</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x4</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;23:</span>          <span style='color:#800000; font-weight:bold; '>add</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>edi</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;25:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xf0f0f0f</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2a:</span>          <span style='color:#800000; font-weight:bold; '>imul</span>   <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x1010101</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;30:</span>          <span style='color:#800000; font-weight:bold; '>shr</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x18</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;33:</span>          <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>Optimizing GCC 4.9.3 for ARM64:</p>

<!--
_PRE_BEGIN
<f>:
   0:           lsr     w1, w0, #1
   4:           and     w1, w1, #0x55555555
   8:           sub     w0, w0, w1
   c:           and     w1, w0, #0x33333333
  10:           lsr     w0, w0, #2
  14:           and     w0, w0, #0x33333333
  18:           add     w0, w0, w1
  1c:           mov     w1, #0x1010101                  // #16843009
  20:           add     w0, w0, w0, lsr #4
  24:           and     w0, w0, #0xf0f0f0f
  28:           mul     w0, w0, w1
  2c:           lsr     w0, w0, #24
  30:           ret
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>           lsr     w1<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008c00; '>1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w1<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x55555555</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;8:</span>           <span style='color:#800000; font-weight:bold; '>sub</span>     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w1
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;c:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w1<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x33333333</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>           lsr     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008c00; '>2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;14:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x33333333</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;18:</span>           <span style='color:#800000; font-weight:bold; '>add</span>     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w1
<span style='color:#e34adc; '>&#xa0;&#xa0;1c:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     w1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x1010101</span>                  <span style='color:#808030; '>/</span><span style='color:#808030; '>/</span> #<span style='color:#008c00; '>16843009</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;20:</span>           <span style='color:#800000; font-weight:bold; '>add</span>     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> lsr #<span style='color:#008c00; '>4</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;24:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0xf0f0f0f</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;28:</span>           <span style='color:#800000; font-weight:bold; '>mul</span>     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w1
<span style='color:#e34adc; '>&#xa0;&#xa0;2c:</span>           lsr     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008c00; '>24</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;30:</span>           <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.148</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>1</span>
        <span style='color:#800000; font-weight:bold; '>SUB</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.152</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r2<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        <span style='color:#800000; font-weight:bold; '>AND</span>      r0<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>2</span>
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.156</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>ADD</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r2
        <span style='color:#800000; font-weight:bold; '>ADD</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>4</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        <span style='color:#800000; font-weight:bold; '>ADD</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>LSL</span> #<span style='color:#008c00; '>16</span>
        <span style='color:#800000; font-weight:bold; '>ADD</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>LSL</span> #<span style='color:#008c00; '>8</span>
        LSR      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>24</span>
        <span style='color:#000080; '>BX</span>       lr
        <span style='color:#004a43; '>ENDP</span>

<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.148</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x55555555</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.152</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x33333333</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.156</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x0f0f0f0f</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

<!--
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
-->

<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        LSRS     r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        LDR      r2<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.100</span><span style='color:#808030; '>|</span>
        ANDS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r2
        SUBS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.104</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r2<span style='color:#808030; '>,</span>r0
        LSRS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>2</span>
        ANDS     r2<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>r1
        ANDS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        ADDS     r0<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>r0
        LSRS     r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>4</span>
        ADDS     r0<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.108</span><span style='color:#808030; '>|</span>
        ANDS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.112</span><span style='color:#808030; '>|</span>
        MULS     r0<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0
        LSRS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>24</span>
        <span style='color:#000080; '>BX</span>       lr
        <span style='color:#004a43; '>ENDP</span>

<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.100</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x55555555</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.104</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x33333333</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.108</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x0f0f0f0f</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.112</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x01010101</span>
</pre>

<p>Optimizing GCC 4.4.5 for MIPS:</p>

<!--
_PRE_BEGIN
f:
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
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>f:</span>
        li      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1431633920</span>                   # <span style='color:#008000; '>0x55550000</span>
        srl     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
        ori     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x5555</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        subu    <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>858980352</span>                    # <span style='color:#008000; '>0x33330000</span>
        ori     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x3333</span>
        srl     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>2</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        addu    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        srl     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>4</span>
        addu    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>252641280</span>                    # <span style='color:#008000; '>0xf0f0000</span>
        ori     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xf0f</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        sll     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>8</span>
        addu    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        sll     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>16</span>
        addu    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        j       <span style='color:#008000; '>$31</span>
        srl     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>24</span>
</pre>

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/2015-aug-26/').</p>

_EXERCISE_FOOTER()

_BLOG_FOOTER()


