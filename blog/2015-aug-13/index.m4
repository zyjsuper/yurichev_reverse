m4_include(`commons.m4')

_HEADER_HL1(`13-Aug-2015: Introduction to logarithms; yet another x86 reverse engineering exercise')

<p>Just wrote small _HTML_LINK(`http://yurichev.com/writings/log_intro.pdf',`introduction to logarithms'), it's early draft, to be continued!</p>

<hr>

<p>Since my book (_HTML_LINK_AS_IS(`http://beginners.re')) is now in frozen state (so translators can finish their work), 
I'll post some reverse engineering exercises here in blog.</p>

<p>What this code does? The function has 4 arguments, it is compiled by GCC for Linux x64 ABI (i.e., arguments are passed in registers).
I'll publish answer some days later...</p>

_PRE_BEGIN
0000000000000000 &lt;f&gt;:
   0:   49 89 f8                mov    r8,rdi
   3:   53                      push   rbx
   4:   48 89 f7                mov    rdi,rsi
   7:   48 89 d3                mov    rbx,rdx
   a:   4c 89 c6                mov    rsi,r8
   d:   48 31 d2                xor    rdx,rdx

0000000000000010 &lt;begin&gt;:
  10:   48 ad                   lods   rax,QWORD PTR ds:[rsi]
  12:   48 f7 f3                div    rbx
  15:   48 ab                   stos   QWORD PTR es:[rdi],rax
  17:   e2 f7                   loop   begin
  19:   5b                      pop    rbx
  1a:   48 89 d0                mov    rax,rdx
  1d:   c3                      ret
_PRE_END

<p>I'll post more exercises soon...</p>

<p>Update: Reddit discussion: _HTML_LINK_AS_IS(`https://www.reddit.com/r/ReverseEngineering/comments/3gtyk7/introduction_to_logarithms_yet_another_x86/').</p>
<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/src/blog/2015-aug-15/').</p>

_BLOG_FOOTER()

