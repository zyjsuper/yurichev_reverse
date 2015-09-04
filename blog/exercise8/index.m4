m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #8 (for x86, ARM, ARM64, MIPS); solution for exercise #7')

_HL2(`Reverse engineering exercise #8 (for x86, ARM, ARM64, MIPS)')

<p>What this code does?
This is one of the busiest algorithms under the hood, though, usually hidden from programmers.
It implements one of the most popular algorithms in computer science.
It features recursion and callback function.</p>

<p>Optimizing GCC 4.8.2:</p>

<!--
_PRE_BEGIN
<f>:
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
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>       <span style='color:#800000; font-weight:bold; '>push</span>   r1<span style='color:#008c00; '>2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;2:</span>       <span style='color:#800000; font-weight:bold; '>test</span>   rsi<span style='color:#808030; '>,</span>rsi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;5:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    r1<span style='color:#008c00; '>2</span><span style='color:#808030; '>,</span>rdi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;8:</span>       <span style='color:#800000; font-weight:bold; '>push</span>   rbp
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;9:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    rbp<span style='color:#808030; '>,</span>rdx
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;c:</span>       <span style='color:#800000; font-weight:bold; '>push</span>   rbx
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;d:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    rbx<span style='color:#808030; '>,</span>rsi
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>       <span style='color:#800000; font-weight:bold; '>je</span>     <span style='color:#e34adc; '>32</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x32</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;12:</span>       <span style='color:#800000; font-weight:bold; '>nop</span>    <span style='color:#800000; font-weight:bold; '>WORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rax<span style='color:#808030; '>+</span>rax<span style='color:#808030; '>*</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>+</span><span style='color:#008000; '>0x0</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;18:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    rsi<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbx<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1b:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    rdi<span style='color:#808030; '>,</span>rbp
<span style='color:#e34adc; '>&#xa0;&#xa0;1e:</span>       <span style='color:#800000; font-weight:bold; '>call</span>   <span style='color:#e34adc; '>r12</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;21:</span>       <span style='color:#800000; font-weight:bold; '>test</span>   <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>eax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;23:</span>       <span style='color:#800000; font-weight:bold; '>je</span>     <span style='color:#e34adc; '>56</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x56</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;25:</span>       <span style='color:#800000; font-weight:bold; '>js</span>     <span style='color:#e34adc; '>40</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x40</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;27:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    rbx<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbx<span style='color:#808030; '>+</span><span style='color:#008000; '>0x18</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2b:</span>       <span style='color:#800000; font-weight:bold; '>test</span>   rbx<span style='color:#808030; '>,</span>rbx
<span style='color:#e34adc; '>&#xa0;&#xa0;2e:</span>       <span style='color:#800000; font-weight:bold; '>xchg</span>   <span style='color:#000080; '>ax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>ax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;30:</span>       <span style='color:#800000; font-weight:bold; '>jne</span>    <span style='color:#e34adc; '>18</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x18</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;32:</span>       <span style='color:#800000; font-weight:bold; '>pop</span>    rbx
<span style='color:#e34adc; '>&#xa0;&#xa0;33:</span>       <span style='color:#800000; font-weight:bold; '>pop</span>    rbp
<span style='color:#e34adc; '>&#xa0;&#xa0;34:</span>       <span style='color:#800000; font-weight:bold; '>xor</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>eax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;36:</span>       <span style='color:#800000; font-weight:bold; '>pop</span>    r1<span style='color:#008c00; '>2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;38:</span>       <span style='color:#800000; font-weight:bold; '>ret</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;39:</span>       <span style='color:#800000; font-weight:bold; '>nop</span>    <span style='color:#800000; font-weight:bold; '>DWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rax<span style='color:#808030; '>+</span><span style='color:#008000; '>0x0</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;40:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    rbx<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbx<span style='color:#808030; '>+</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;44:</span>       <span style='color:#800000; font-weight:bold; '>test</span>   rbx<span style='color:#808030; '>,</span>rbx
<span style='color:#e34adc; '>&#xa0;&#xa0;47:</span>       <span style='color:#800000; font-weight:bold; '>je</span>     <span style='color:#e34adc; '>32</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x32</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;49:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    rsi<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbx<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;4c:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    rdi<span style='color:#808030; '>,</span>rbp
<span style='color:#e34adc; '>&#xa0;&#xa0;4f:</span>       <span style='color:#800000; font-weight:bold; '>call</span>   <span style='color:#e34adc; '>r12</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;52:</span>       <span style='color:#800000; font-weight:bold; '>test</span>   <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>eax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;54:</span>       <span style='color:#800000; font-weight:bold; '>jne</span>    <span style='color:#e34adc; '>25</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x25</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;56:</span>       <span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span>rbx
<span style='color:#e34adc; '>&#xa0;&#xa0;59:</span>       <span style='color:#800000; font-weight:bold; '>pop</span>    rbx
<span style='color:#e34adc; '>&#xa0;&#xa0;5a:</span>       <span style='color:#800000; font-weight:bold; '>pop</span>    rbp
<span style='color:#e34adc; '>&#xa0;&#xa0;5b:</span>       <span style='color:#800000; font-weight:bold; '>pop</span>    r1<span style='color:#008c00; '>2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;5d:</span>       <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>Optimizing GCC 4.9.3 for ARM64:</p>

<!--
_PRE_BEGIN
<f>:
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
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>           stp     x2<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x3<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>-48</span><span style='color:#808030; '>]</span><span style='color:#808030; '>!</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x2<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>sp</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;8:</span>           stp     x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x2<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>16</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;c:</span>           <span style='color:#800000; font-weight:bold; '>str</span>     x2<span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>32</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x1
<span style='color:#e34adc; '>&#xa0;&#xa0;14:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x2<span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> x0
<span style='color:#e34adc; '>&#xa0;&#xa0;18:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x2<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> x2
<span style='color:#e34adc; '>&#xa0;&#xa0;1c:</span>           cbz     x1<span style='color:#808030; '>,</span> <span style='color:#008c00; '>40</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x40</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;20:</span>           ldr     x1<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;24:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x0<span style='color:#808030; '>,</span> x2<span style='color:#008c00; '>0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;28:</span>           blr     x2<span style='color:#008c00; '>1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2c:</span>           <span style='color:#800000; font-weight:bold; '>cmp</span>     w0<span style='color:#808030; '>,</span> wzr
<span style='color:#e34adc; '>&#xa0;&#xa0;30:</span>           b.<span style='color:#004a43; '>eq</span>    <span style='color:#008c00; '>70</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x70</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;34:</span>           b.<span style='color:#004a43; '>lt</span>    <span style='color:#008c00; '>54</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x54</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;38:</span>           ldr     x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>24</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;3c:</span>           cbnz    x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>20</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x20</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;40:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x0<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x0</span>                        <span style='color:#808030; '>/</span><span style='color:#808030; '>/</span> #<span style='color:#008c00; '>0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;44:</span>           ldr     x2<span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>32</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;48:</span>           ldp     x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x2<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>16</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;4c:</span>           ldp     x2<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x3<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>48</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;50:</span>           <span style='color:#800000; font-weight:bold; '>ret</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;54:</span>           ldr     x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>16</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;58:</span>           cbz     x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>40</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x40</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;5c:</span>           ldr     x1<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;60:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x0<span style='color:#808030; '>,</span> x2<span style='color:#008c00; '>0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;64:</span>           blr     x2<span style='color:#008c00; '>1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;68:</span>           <span style='color:#800000; font-weight:bold; '>cmp</span>     w0<span style='color:#808030; '>,</span> wzr
<span style='color:#e34adc; '>&#xa0;&#xa0;6c:</span>           b.<span style='color:#004a43; '>ne</span>    <span style='color:#008c00; '>34</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x34</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;70:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x0<span style='color:#808030; '>,</span> x1<span style='color:#008c00; '>9</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;74:</span>           ldr     x2<span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>32</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;78:</span>           ldp     x1<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x2<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>16</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;7c:</span>           ldp     x2<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x3<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>48</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;80:</span>           <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        <span style='color:#800000; font-weight:bold; '>PUSH</span>     <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r6<span style='color:#808030; '>,</span>lr<span style='color:#808030; '>}</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.4</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r4<span style='color:#808030; '>,</span>r1
        <span style='color:#800000; font-weight:bold; '>MOV</span>      r5<span style='color:#808030; '>,</span>r0
        <span style='color:#800000; font-weight:bold; '>MOV</span>      r6<span style='color:#808030; '>,</span>r2
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.72</span><span style='color:#808030; '>|</span>
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r4<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>MOV</span>      r0<span style='color:#808030; '>,</span>r2
        <span style='color:#800000; font-weight:bold; '>MOV</span>      lr<span style='color:#808030; '>,</span>pc
        <span style='color:#000080; '>BX</span>       r5
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        LDRGT    r1<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r4<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0xc</span><span style='color:#808030; '>]</span>
        LDRLT    r1<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r4<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>8</span><span style='color:#808030; '>]</span>
        MOVEQ    r0<span style='color:#808030; '>,</span>r4
        POPEQ    <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r6<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        MOVNE    r2<span style='color:#808030; '>,</span>r6
        MOVNE    r0<span style='color:#808030; '>,</span>r5
        BNE      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.4</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.72</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOV</span>      r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        <span style='color:#800000; font-weight:bold; '>POP</span>      <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r6<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
        <span style='color:#004a43; '>ENDP</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        <span style='color:#800000; font-weight:bold; '>PUSH</span>     <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r6<span style='color:#808030; '>,</span>lr<span style='color:#808030; '>}</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.2</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r4<span style='color:#808030; '>,</span>r1
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r5<span style='color:#808030; '>,</span>r0
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r6<span style='color:#808030; '>,</span>r2
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.46</span><span style='color:#808030; '>|</span>
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r4<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r0<span style='color:#808030; '>,</span>r2
        <span style='color:#000080; '>BL</span>       __ARM_common_call_via_r5_thumb
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.30</span><span style='color:#808030; '>|</span>
        BGE      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.40</span><span style='color:#808030; '>|</span>
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r4<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>8</span><span style='color:#808030; '>]</span>
        B        <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.42</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.30</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r0<span style='color:#808030; '>,</span>r4
        <span style='color:#800000; font-weight:bold; '>POP</span>      <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r6<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.34</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r2<span style='color:#808030; '>,</span>r6
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r0<span style='color:#808030; '>,</span>r5
        B        <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.2</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.40</span><span style='color:#808030; '>|</span>
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r4<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0xc</span><span style='color:#808030; '>]</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.42</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        BNE      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.34</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.46</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        <span style='color:#800000; font-weight:bold; '>POP</span>      <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r6<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
        <span style='color:#004a43; '>ENDP</span>

__ARM_common_call_via_r5_thumb <span style='color:#004a43; '>PROC</span>
        <span style='color:#000080; '>BX</span>       r5
        <span style='color:#004a43; '>ENDP</span>
</pre>

<p>Optimizing GCC 4.4.5 for MIPS:</p>

<!--
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
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>f:</span>
        addiu   $<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>-40</span>
        sw      <span style='color:#008000; '>$18</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>32</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        sw      <span style='color:#008000; '>$17</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>28</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        sw      <span style='color:#008000; '>$16</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>24</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        sw      <span style='color:#008000; '>$31</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>36</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        move    <span style='color:#008000; '>$16</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span>
        move    <span style='color:#008000; '>$17</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>
        beq     <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L2
        move    <span style='color:#008000; '>$18</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$6</span>

<span style='color:#e34adc; '>$L8:</span>
        lw      <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$16</span><span style='color:#808030; '>)</span>
        move    <span style='color:#008000; '>$25</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$17</span>
        jalr    <span style='color:#008000; '>$25</span>
        move    <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$18</span>
        beq     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L2
        <span style='color:#800000; font-weight:bold; '>nop</span>
        bltz    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span>$L1<span style='color:#008c00; '>0</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
        lw      <span style='color:#008000; '>$16</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>12</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$16</span><span style='color:#808030; '>)</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
        bne     <span style='color:#008000; '>$16</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L8
        <span style='color:#800000; font-weight:bold; '>nop</span>
<span style='color:#e34adc; '>$L2:</span>
        lw      <span style='color:#008000; '>$31</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>36</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        move    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$16</span>
        lw      <span style='color:#008000; '>$18</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>32</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        lw      <span style='color:#008000; '>$17</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>28</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        lw      <span style='color:#008000; '>$16</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>24</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        j       <span style='color:#008000; '>$31</span>
        addiu   $<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>40</span>

<span style='color:#e34adc; '>$L10:</span>
        lw      <span style='color:#008000; '>$16</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>8</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$16</span><span style='color:#808030; '>)</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
        bne     <span style='color:#008000; '>$16</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L8
        <span style='color:#800000; font-weight:bold; '>nop</span>
        b       $L2
        <span style='color:#800000; font-weight:bold; '>nop</span>
</pre>

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise9/')</p>

_EXERCISE_FOOTER()

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
