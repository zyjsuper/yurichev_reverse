m4_include(`commons.m4')

_HEADER_HL1(`Hilbert’s 10th problem, Fermat’s last theorem and SMT solvers')

<p>Hilbert's 10th problem _HTML_LINK(`https://en.wikipedia.org/wiki/Hilbert%27s_tenth_problem',`states') that you cannot devise an algorithm which can solve any diophantine equation over integers.
However, it's important to understand, that this is possible over fixed-size bitvectors.</p>

<p>Fermat's last theorem states that there are no integer solution(s) for $a^n + b^n = c^n$, for $n>=3$.</p>

<p>Let's prove it for n=3 and for a in 0..255 range:</p>

_PRE_BEGIN
m4_include(`blog/Hilbert_10/fermat.py')
_PRE_END

<p>Z3 gives "unsat", meaning, it couldn't find any a/b/c.
However, this is possible to check even using brute-force search.</p>

<p>If to replace "BitVecs" by "Ints", Z3 would give "unknown":</p>

_PRE_BEGIN
m4_include(`blog/Hilbert_10/fermat2.py')
_PRE_END

<p>In short: anything is decidable (you can build an algorithm which can solve equation or not) under fixed-size bitvectors.
Given enough computational power, you can solve such equations for big bit-vectors.
But this is not possible for integers or bit-vectors of any size.</p>

<p>Another interesting reading about this by Leonardo de Moura:
_HTML_LINK_AS_IS(`https://stackoverflow.com/questions/13898175/how-does-z3-handle-non-linear-integer-arithmetic').</p>

_BLOG_FOOTER()

