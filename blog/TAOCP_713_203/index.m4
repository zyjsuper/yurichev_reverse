m4_include(`commons.m4')

_HEADER_HL1(`TAOCP 7.1.3 Exercise 203, MMIX MOR instruction and program synthesis by sketching')

<p>Found this exercise in TAOCP 7.1.3 (Bitwise Tricks and Techniques):</p>

<p><img src="203q.png" class="ImageBorder" /></p>

<p>What is MOR instruction in MMIX?</p>

<p><img src="MOR.png" class="ImageBorder" /></p>

<p>( _HTML_LINK_AS_IS(`http://mmix.cs.hm.edu/doc/mmix-doc.pdf') )</p>

<p>Let's try to solve. We create two functions. First has MOR instructions simulation + the program from TAOCP.
The second is a naive implementation.
Then we add "forall" qunator: for all inputs, both functions must produce the same result.
<b>But</b>, we don't know a/b/c/d/e/f and ask Z3 SMT-solver to find them.</p>

_PRE_BEGIN
m4_include(`blog/TAOCP_713_203/v1.py')
_PRE_END

<p>Very slow, it takes several hours on my venerable Intel Quad-Core Xeon E3-1220 3.10GHz but found at least one solution:</p>

_PRE_BEGIN
a,b,c,d,e = 8000400020001 f0f0f0f0f0f0f0f 56d656d616969616 411a00000000 bf3fbf3fff7f8000
_PRE_END

<p>... which is correct (I've wrote bruteforce checker, _HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/TAOCP_713_203/check.c',`here')).</p>

<p>D.Knuth's TAOCP also has answers:</p>

<p><img src="203a.png" class="ImageBorder" /></p>

<p>... which are different, but also correct.</p>

<p>What if a==0x0008000400020001 always?
I'm adding a new constraint:</p>

_PRE_BEGIN
s.add(a==0x0008000400020001)
_PRE_END

<p>We've getting many results (much faster, and also correct):</p>

_PRE_BEGIN
...

a,b,c,d,e = 8000400020001 7f0fcf0fcf0f7f0f 1616d6d656561656 8680522903020000 eeeda9aa2e2eee2f
a,b,c,d,e = 8000400020001 7f0fcf0fcf0f6f0f 1616d6d656561656 8680522903020000 eeeda9aa2e2eee2f
a,b,c,d,e = 8000400020001 7f0fcf0fdf0f6f0f 1616d6d656561656 8680522903020000 eeeda9aa2e2eee2f
a,b,c,d,e = 8000400020001 5f0fcf0fdf0f6f0f 1616d6d656561656 8680522903020000 eeeda9aa2e2eee2f

...
_PRE_END

<p>The files: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/tree/master/blog/TAOCP_713_203').</p>

_FOOTER()

