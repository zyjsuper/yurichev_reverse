m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #6 (for x86, ARM, ARM64, MIPS)')

<p>What this code does?
This is one of the simplest exercises I made, but still this code can be served as useful library function 
and is certainly used in many modern real-world applications.</p>

<p>Non-optimizing GCC 4.8.2:</p>

<!--
_PRE_BEGIN
<f>:
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
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>             <span style='color:#800000; font-weight:bold; '>push</span>   rbp
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;1:</span>             <span style='color:#800000; font-weight:bold; '>mov</span>    rbp<span style='color:#808030; '>,</span>rsp
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>             <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x8</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span>rdi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;8:</span>             <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span>rsi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;c:</span>             <span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x8</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>             <span style='color:#800000; font-weight:bold; '>movzx</span>  <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>BYTE</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rax<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;13:</span>             <span style='color:#800000; font-weight:bold; '>movsx</span>  <span style='color:#000080; '>dx</span><span style='color:#808030; '>,</span><span style='color:#000080; '>al</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;17:</span>             <span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1b:</span>             <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>WORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rax<span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#000080; '>dx</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1e:</span>             <span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;22:</span>             <span style='color:#800000; font-weight:bold; '>movzx</span>  <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>WORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rax<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;25:</span>             <span style='color:#800000; font-weight:bold; '>test</span>   <span style='color:#000080; '>ax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>ax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;28:</span>             <span style='color:#800000; font-weight:bold; '>jne</span>    <span style='color:#e34adc; '>2c</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x2c</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2a:</span>             <span style='color:#800000; font-weight:bold; '>jmp</span>    <span style='color:#e34adc; '>38</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x38</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2c:</span>             <span style='color:#800000; font-weight:bold; '>add</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x8</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;31:</span>             <span style='color:#800000; font-weight:bold; '>add</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;36:</span>             <span style='color:#800000; font-weight:bold; '>jmp</span>    <span style='color:#e34adc; '>c</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0xc</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;38:</span>             <span style='color:#800000; font-weight:bold; '>pop</span>    rbp
<span style='color:#e34adc; '>&#xa0;&#xa0;39:</span>             <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>Optimizing GCC 4.8.2:</p>

<!--
_PRE_BEGIN
<f>:
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
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#008c00; '>0</span><span style='color:#808030; '>:</span>          <span style='color:#800000; font-weight:bold; '>jmp</span>    <span style='color:#e34adc; '>10</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>></span>
<span style='color:#008c00; '>2</span><span style='color:#808030; '>:</span>          <span style='color:#800000; font-weight:bold; '>nop</span>    <span style='color:#800000; font-weight:bold; '>WORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rax<span style='color:#808030; '>+</span>rax<span style='color:#808030; '>*</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>+</span><span style='color:#008000; '>0x0</span><span style='color:#808030; '>]</span>
<span style='color:#008c00; '>8</span><span style='color:#808030; '>:</span>          <span style='color:#800000; font-weight:bold; '>add</span>    rdi<span style='color:#808030; '>,</span><span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>c:</span>          <span style='color:#800000; font-weight:bold; '>add</span>    rsi<span style='color:#808030; '>,</span><span style='color:#008000; '>0x2</span>
<span style='color:#008c00; '>10</span><span style='color:#808030; '>:</span>         <span style='color:#800000; font-weight:bold; '>movsx</span>  <span style='color:#000080; '>ax</span><span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>BYTE</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rdi<span style='color:#808030; '>]</span>
<span style='color:#008c00; '>14</span><span style='color:#808030; '>:</span>         <span style='color:#800000; font-weight:bold; '>test</span>   <span style='color:#000080; '>ax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>ax</span>
<span style='color:#008c00; '>17</span><span style='color:#808030; '>:</span>         <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>WORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rsi<span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#000080; '>ax</span>
<span style='color:#e34adc; '>1a:</span>         <span style='color:#800000; font-weight:bold; '>jne</span>    <span style='color:#e34adc; '>8</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x8</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>1c:</span>         <span style='color:#800000; font-weight:bold; '>repz</span> <span style='color:#800000; font-weight:bold; '>ret</span>
<span style='color:#e34adc; '>1e:</span>         <span style='color:#800000; font-weight:bold; '>xchg</span>   <span style='color:#000080; '>ax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>ax</span>
</pre>

<p>Optimizing GCC 4.9.3 for ARM64:</p>

<!--
_PRE_BEGIN
<f>:
0:           ldrb    w2, [x0]
4:           strh    w2, [x1]
8:           cbz     w2, 18 <f+0x18>
c:           ldrb    w2, [x0,#1]!
10:          strh    w2, [x1,#2]!
14:          cbnz    w2, c <f+0xc>
18:          ret
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#008c00; '>0</span><span style='color:#808030; '>:</span>           ldrb    w2<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x0<span style='color:#808030; '>]</span>
<span style='color:#008c00; '>4</span><span style='color:#808030; '>:</span>           strh    w2<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x1<span style='color:#808030; '>]</span>
<span style='color:#008c00; '>8</span><span style='color:#808030; '>:</span>           cbz     w2<span style='color:#808030; '>,</span> <span style='color:#008c00; '>18</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x18</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>c:</span>           ldrb    w2<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#808030; '>!</span>
<span style='color:#008c00; '>10</span><span style='color:#808030; '>:</span>          strh    w2<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>2</span><span style='color:#808030; '>]</span><span style='color:#808030; '>!</span>
<span style='color:#008c00; '>14</span><span style='color:#808030; '>:</span>          cbnz    w2<span style='color:#808030; '>,</span> <span style='color:#004a43; '>c</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0xc</span><span style='color:#808030; '>></span>
<span style='color:#008c00; '>18</span><span style='color:#808030; '>:</span>          <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.0</span><span style='color:#808030; '>|</span>
        LDRB     r2<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r2<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        STRH     r2<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.14</span><span style='color:#808030; '>|</span>
        ADDS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        ADDS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>2</span>
        B        <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.0</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.14</span><span style='color:#808030; '>|</span>
        <span style='color:#000080; '>BX</span>       lr
        <span style='color:#004a43; '>ENDP</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.0</span><span style='color:#808030; '>|</span>
        LDRB     r2<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r2<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        STRH     r2<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        ADDNE    r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        ADDNE    r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>2</span>
        BNE      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.0</span><span style='color:#808030; '>|</span>
        <span style='color:#000080; '>BX</span>       lr
        <span style='color:#004a43; '>ENDP</span>
</pre>

<p>Optimizing GCC 4.4.5 for MIPS:</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>f:</span>
        lb      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>)</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
        andi    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xffff</span>
        beq     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L8
        sh      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>)</span>

<span style='color:#e34adc; '>$L5:</span>
        addiu   <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
        lb      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>)</span>
        addiu   <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>2</span>
        andi    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xffff</span>
        bne     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L5
        sh      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>)</span>
<span style='color:#e34adc; '>$L8:</span>
        j       <span style='color:#008000; '>$31</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
</pre>

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise7/')</p>

<!-- надо будет потом дописать про "редкие" инструкции вроде SH (MIPS), STRH (ARM), etc -->

_EXERCISE_FOOTER()

_BLOG_FOOTER()
