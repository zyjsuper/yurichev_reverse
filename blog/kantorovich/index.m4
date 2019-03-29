m4_include(`commons.m4')

_HEADER_HL1(`[Math][Python][Z3] Wood workshop, linear programming and Leonid Kantorovich')

<p>Let's say, you work at wood workshop.
You have a supply of rectangular wood workpieces, 6*13 inches, or meters, or whatever unit you use:</p>

<p>Workpiece (6*13 inches):</p>

_PRE_BEGIN
.............
.............
.............
.............
.............
.............
_PRE_END

<p>You need to produce 800 rectangles of 4*5 size:</p>

<p>Output A (4*5, we need 800 of these): </p>

_PRE_BEGIN
.....
.....
.....
.....
_PRE_END

<p>... and 400 rectangles of 2*3 size:</p>

<p>Output B (2*3, we need 400 of these):</p>

_PRE_BEGIN
...
...
_PRE_END

<p>To cut a piece as A/B rectangles, you can cut a 6*13 workpiece in 4 ways.
Or, to put it in another way, you can place A/B rectangles on 6*13 rectanlge in 4 ways:</p>

<p>Cut A (Output A: 3, Output B: 1):</p>

_PRE_BEGIN
--------444--
11112222444--
1111222233333
1111222233333
1111222233333
1111222233333
_PRE_END

<p>Cut B (Output A: 2, Output B: 6):</p>

_PRE_BEGIN
333444555666-
333444555666-
1111122222777
1111122222777
1111122222888
1111122222888
_PRE_END

<p>Cut C (Output A: 1, Output B: 9):</p>

_PRE_BEGIN
----222555888
1111222555888
1111333666999
1111333666999
1111444777000
1111444777000
_PRE_END

<p>Cut D (Output A: 0, Output B: 13):</p>

_PRE_BEGIN
1133557799bbb
1133557799bbb
1133557799ccc
22446688aaccc
22446688aaddd
22446688aaddd
_PRE_END

<p>Now the problem.
Which cuts are most efficient?
You want to consume as little workpieces as possible.</p>

<p>This is optimization problem and I can solve it this with Z3:</p>

_PRE_BEGIN
m4_include(`blog/kantorovich/1.py')
_PRE_END

_PRE_BEGIN
m4_include(`blog/kantorovich/1.txt')
_PRE_END

<p>So you need to cut 250 workpieces in A's way and 25 pieces in B's way, this is the most optimal way.</p>

<p>Also, the problem is small enough to be solved by my toy bit-blaster _HTML_LINK(`https://github.com/DennisYurichev/MK85',`MK85'),
thanks to _HTML_LINK(`http://sat.inesc-id.pt/open-wbo/',`Open-WBO MaxSAT solver'):</p>

_PRE_BEGIN
m4_include(`blog/kantorovich/1.smt')
_PRE_END

<p>The result:</p>

_PRE_BEGIN
m4_include(`blog/kantorovich/res.txt')
_PRE_END

<p>The task I solved I've found in _HTML_LINK(`https://en.wikipedia.org/wiki/Leonid_Kantorovich',`Leonid Kantorovich')'s book 
"The Best Uses of Economic Resources" (1959).
And these are _HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/tree/master/blog/kantorovich/from_book',`5 pages with the task and solution')
(in Russian).</p>

<p>Leonid Kantorovich was indeed consulting plywood factory in 1939 about optimal use of materials.
And this is how _HTML_LINK(`https://en.wikipedia.org/wiki/Linear_programming',`linear programming') (LP)
and integer linear programming (ILP) has emerged.</p>

_BLOG_FOOTER()
