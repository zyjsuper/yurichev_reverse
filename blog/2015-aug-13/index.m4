m4_include(`commons.m4')

_HEADER_HL1(`13-Aug-2015: Introduction to logarithms; yet another x86 reverse engineering exercise')

<p>Just wrote small _HTML_LINK(`http://yurichev.com/writings/log_intro.pdf',`introduction to logarithms'), it's early draft, to be continued!</p>

<hr>

<p>Since my book (_HTML_LINK_AS_IS(`http://beginners.re')) is now in frozen state (so translators can finish their work), 
I'll post some reverse engineering exercises here in blog.</p>

<p>What this code does? The function has 4 arguments, it is compiled by GCC for Linux x64 ABI (i.e., arguments are passed in registers).
I'll publish answer some days later...</p>

<!--
_PRE_BEGIN
<f>:
   0:                   mov    r8,rdi
   3:                   push   rbx
   4:                   mov    rdi,rsi
   7:                   mov    rbx,rdx
   a:                   mov    rsi,r8
   d:                   xor    rdx,rdx

begin:
  10:                   lods   rax,QWORD PTR ds:[rsi]
  12:                   div    rbx
  15:                   stos   QWORD PTR es:[rdi],rax
  17:                   loop   begin
  19:                   pop    rbx
  1a:                   mov    rax,rdx
  1d:                   ret
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>                   <span style='color:#800000; font-weight:bold; '>mov</span>    r8<span style='color:#808030; '>,</span>rdi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;3:</span>                   <span style='color:#800000; font-weight:bold; '>push</span>   rbx
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>                   <span style='color:#800000; font-weight:bold; '>mov</span>    rdi<span style='color:#808030; '>,</span>rsi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;7:</span>                   <span style='color:#800000; font-weight:bold; '>mov</span>    rbx<span style='color:#808030; '>,</span>rdx
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;a:</span>                   <span style='color:#800000; font-weight:bold; '>mov</span>    rsi<span style='color:#808030; '>,</span>r8
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;d:</span>                   <span style='color:#800000; font-weight:bold; '>xor</span>    rdx<span style='color:#808030; '>,</span>rdx

<span style='color:#e34adc; '>begin:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>                   lods   rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#000080; '>ds</span><span style='color:#808030; '>:</span><span style='color:#808030; '>[</span>rsi<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;12:</span>                   <span style='color:#800000; font-weight:bold; '>div</span>    rbx
<span style='color:#e34adc; '>&#xa0;&#xa0;15:</span>                   <span style='color:#800000; font-weight:bold; '>stos</span>   <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#000080; '>es</span><span style='color:#808030; '>:</span><span style='color:#808030; '>[</span>rdi<span style='color:#808030; '>]</span><span style='color:#808030; '>,</span>rax
<span style='color:#e34adc; '>&#xa0;&#xa0;17:</span>                   <span style='color:#800000; font-weight:bold; '>loop</span>   <span style='color:#e34adc; '>begin</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;19:</span>                   <span style='color:#800000; font-weight:bold; '>pop</span>    rbx
<span style='color:#e34adc; '>&#xa0;&#xa0;1a:</span>                   <span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span>rdx
<span style='color:#e34adc; '>&#xa0;&#xa0;1d:</span>                   <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>I'll post more exercises soon...</p>

<p>Update: Reddit discussion: _HTML_LINK_AS_IS(`https://www.reddit.com/r/ReverseEngineering/comments/3gtyk7/introduction_to_logarithms_yet_another_x86/').</p>

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/2015-aug-15/').</p>

_EXERCISE_FOOTER()

_BLOG_FOOTER()

