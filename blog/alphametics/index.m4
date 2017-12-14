m4_include(`commons.m4')

_HEADER_HL1(`Alphametics and Z3 SMT solver')

<p>According to Donald Knuth, the term "Alphametics" was coined by J. A. H. Hunter.
This is a puzzle: what decimal digits in 0..9 range must be assigned to each letter,
so the following equation will be true?</p>

_PRE_BEGIN
  SEND
+ MORE
 -----
 MONEY
_PRE_END

<p>This is easy for Z3:</p>

_PRE_BEGIN
m4_include(`blog/alphametics/alpha.py')
_PRE_END

<p>Output:</p>

_PRE_BEGIN
sat
[E, = 5,
 S, = 9,
 M, = 1,
 N, = 6,
 D, = 7,
 R, = 8,
 O, = 0,
 Y = 2]
_PRE_END

<p>Another one, also from TAOCP volume IV (_HTML_LINK_AS_IS(`http://www-cs-faculty.stanford.edu/~uno/fasc2b.ps.gz')):</p>

_PRE_BEGIN
m4_include(`blog/alphametics/alpha2.py')
_PRE_END

_PRE_BEGIN
sat
[L, = 6,
 S, = 7,
 N, = 2,
 T, = 1,
 I, = 5,
 V = 3,
 A, = 8,
 R, = 9,
 O, = 4,
 TRIO = 1954,
 SONATA, = 742818,
 VIOLA, = 35468,
 VIOLIN, = 354652]
_PRE_END

<p>This puzzle I've found in _HTML_LINK(`https://github.com/pysmt/pysmt',`pySMT') examples:</p>

_PRE_BEGIN
m4_include(`blog/alphametics/alpha3.py')
_PRE_END

_PRE_BEGIN
sat
[E, = 4, D = 6, O, = 2, W, = 3, R, = 5, L, = 1, H, = 9]
_PRE_END

<p>This is exercise Q209 from the "_HTML_LINK(`http://www-cs-faculty.stanford.edu/~knuth/cp.html',`Companion to the Papers of Donald Knuth')":</p>

_PRE_BEGIN
 KNIFE
  FORK
 SPOON
  SOUP
------
SUPPER
_PRE_END

<p>I've added a helper function (list_to_expr()) to make things simpler:</p>

_PRE_BEGIN
m4_include(`blog/alphametics/alpha4.py')
_PRE_END

_PRE_BEGIN
sat
[K = 7,
 N = 4,
 R = 9,
 I = 1,
 E = 6,
 S = 0,
 O = 3,
 F = 5,
 U = 8,
 P = 2,
 SUPPER = 82269,
 SOUP = 382,
 SPOON = 2334,
 FORK = 5397,
 KNIFE = 74156]
_PRE_END

<p>S is zero, so SUPPER value is starting with leading (removed) zero. Let's say, we don't like it. Add this to resolve it:</p>

_PRE_BEGIN
s.add(S!=0)
_PRE_END

_PRE_BEGIN
sat
[K = 8,
 N = 4,
 R = 3,
 I = 7,
 E = 6,
 S = 1,
 O = 9,
 F = 2,
 U = 0,
 P = 5,
 SUPPER = 105563,
 SOUP = 1905,
 SPOON = 15994,
 FORK = 2938,
 KNIFE = 84726]
_PRE_END

_HL2(`Devising your own puzzle')

<p>Here is a problem: you can only use 10 letters, but how to select them among words?
We can try to offload this task to Z3:</p>

_PRE_BEGIN
m4_include(`blog/alphametics/gen.py')
_PRE_END

<p>This is the first generated puzzle:</p>

_PRE_BEGIN
sat
EGGS
JELLY
LUNCH
C 5
E 6
G 3
H 7
J 0
L 1
N 4
S 8
U 2
Y 9
_PRE_END

<p>What if we want to "CAKE" be present among "addends"?</p>

<p>Add this:</p>

_PRE_BEGIN
s.add(word_used[words.index('CAKE')])
_PRE_END

_PRE_BEGIN
sat
CAKE
TEA
LUNCH
A 8
C 3
E 1
H 9
J 6
K 2
L 0
N 5
T 7
U 4
_PRE_END

<p>Add this:</p>

_PRE_BEGIN
s.add(word_used[words.index('EGGS')])
_PRE_END

<p>Now it can find pair to EGGS:</p>

_PRE_BEGIN
sat
EGGS
HONEY
LUNCH
C 6
E 7
G 9
H 4
L 5
N 8
O 2
S 3
U 0
Y 1
_PRE_END

_HL2(`The files')

_HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/tree/master/blog/alphametics')

_BLOG_FOOTER()

