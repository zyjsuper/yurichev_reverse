m4_include(`commons.m4')

_HEADER_HL1(`Coin flipping problem: Z3 and MaxSAT (Open-WBO)')

<p>Found this on reddit:</p>

_PRE_BEGIN
Coin flipping problem (KOI '06) (self.algorithms)

Hi. I'm struggling on this problem for weeks.

There is no official solution for this Korean Olympiad in Informatics problem.

The input is N × N coin boards, (0 < N < 33) 'H' means the coin's head is facing upward, and 'T' means the tail is facing upward.

The problem is minimizing T-coins with some operations:

    Flip all the coins in the same row.
    Flip all the coins in the same column.

Naïve O(N*2N) algorithm makes TLE. There are some heuristic approaches (Simulated Annealing) and branch-and-cut algorithm which reduces running time to about 200ms, but I have no idea to solve this problem in poly-time, or reduce this problem to any famous NP-complete problem.

Would you give some idea for me?
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://www.reddit.com/r/algorithms/comments/7aq9if/coin_flipping_problem_koi_06/') )</p>

<p>My solution for Z3: see _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/coin_flip/coin_z3.py',`source code') and comments, _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/coin_flip/z3.txt',`results').</p>

<p>And also MaxSAT solution (uses _HTML_LINK(`http://sat.inesc-id.pt/open-wbo/',`Open-WBO MaxSAT solver')): _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/coin_flip/coin_MaxSAT.py',`source code'), _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/coin_flip/SAT.txt',`results').
Xu.py and frolic.py are libraries which are used.</p>

<p>4-5 row/column flips can be achieved using this on 8*8 board (like chessboard) in reasonable time (couple of minutes).</p>

<p>All files: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/coin_flip').</p>

_BLOG_FOOTER()

