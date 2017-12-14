m4_include(`commons.m4')

_HEADER_HL1(`Proving sorting network correctness using Z3 SMT solver')

<p><h5>Thanks to @linuxenia for the idea</h5></p>

<p>Sorting networks are highly popular in electronics, GPGPU and even in SAT encodings:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Sorting_network').</p>

<p>Especially bitonic sorters, which are also sorting networks:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Bitonic_sorter').</p>

<p>They are relatively easy to construct, but, finding smallest is a challenge.</p>

<p>There is a smallest network (only 25 comparators) for 9-channel sorting network:</p>

<img src="network9.png">

<p>This is combinational circuit, each connection is a comparator+swapper, it swaps if one of input values is bigger and passes output to the next level.</p>

<p>I copypasted it from _HTML_LINK(`https://arxiv.org/pdf/1405.5754.pdf',`the article'): Michael Codish, Lu ́ıs Cruz-Filipe, Michael Frank, and Peter Schneider-Kamp - 
"Twenty-Five Comparators is Optimal when Sorting Nine Inputs (and Twenty-Nine for Ten)".</p>

<p>Another article about it: _HTML_LINK(`http://larc.unt.edu/ian/pubs/9-input.pdf',`Ian Parberry - A Computer Assisted Optimal Depth Lower Bound for Nine-Input Sorting Networks').</p>

<p>I don't know (yet) how they proved it, but it's interesting, that it's extremely easy to prove its correctness using Z3 SMT solver.
We just construct network out of comparators/swappers and asking Z3 to find counterexample, for which the output of the network will not be sorted.
And it can't, meaning, output's state is always sorted, no matter what values are plugged into inputs.</p>

_PRE_BEGIN
m4_include(`blog/sorting_network/test9.py')
_PRE_END

<p>( The full source code: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/sorting_network/test9.py') )</p>

<p>There is also smaller 4-channel network I copypasted from Wikipedia:</p>

_PRE_BEGIN
...

l=line(l, " + +")
l=line(l, "+ + ")
l=line(l, "++++")
l=line(l, " ++ ")

...
_PRE_END

<p>( The full source code: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/sorting_network/test4.py') )</p>

<p>It also proved to be correct, but it's interesting, what Z3Py expression we've got at each of 4 outputs:</p>

_PRE_BEGIN
If(If(a < c, a, c) < If(b < d, b, d),
   If(a < c, a, c),
   If(b < d, b, d))

If(If(If(a < c, a, c) > If(b < d, b, d),
      If(a < c, a, c),
      If(b < d, b, d)) <
   If(If(a > c, a, c) < If(b > d, b, d),
      If(a > c, a, c),
      If(b > d, b, d)),
   If(If(a < c, a, c) > If(b < d, b, d),
      If(a < c, a, c),
      If(b < d, b, d)),
   If(If(a > c, a, c) < If(b > d, b, d),
      If(a > c, a, c),
      If(b > d, b, d)))

If(If(If(a < c, a, c) > If(b < d, b, d),
      If(a < c, a, c),
      If(b < d, b, d)) >
   If(If(a > c, a, c) < If(b > d, b, d),
      If(a > c, a, c),
      If(b > d, b, d)),
   If(If(a < c, a, c) > If(b < d, b, d),
      If(a < c, a, c),
      If(b < d, b, d)),
   If(If(a > c, a, c) < If(b > d, b, d),
      If(a > c, a, c),
      If(b > d, b, d)))

If(If(a > c, a, c) > If(b > d, b, d),
   If(a > c, a, c),
   If(b > d, b, d))
_PRE_END

<p>The first and the last are shorter than the 2nd and the 3rd, they are just min(min(min(a,b),c),d) and max(max(max(a,b),c),d).</p>

_BLOG_FOOTER()

