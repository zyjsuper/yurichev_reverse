m4_include(`commons.m4')

_HEADER_HL1(`Simplest SAT solver in ~120 lines')

<p>
This is simplest possible backtracking SAT solver written in Python (not a DPLL one).
It uses the same backtracking algorithm you can find in many simple Sudoku solvers.
It works significantly slower, but due to its extreme simplicity, it can also count solutions.
For example, it count all solutions of _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/SAT_backtrack/queens8.cnf',`8 queens problem').
For example, there are 70 solutions for POPCNT4 function (the function is true if any 4 of its input 8 variables are true):</p>

_PRE_BEGIN
SAT
-1 -2 -3 -4 5 6 7 8 0
SAT
-1 -2 -3 4 -5 6 7 8 0
SAT
-1 -2 -3 4 5 -6 7 8 0
SAT
-1 -2 -3 4 5 6 -7 8 0
...

SAT
1 2 3 -4 -5 6 -7 -8 0
SAT
1 2 3 -4 5 -6 -7 -8 0
SAT
1 2 3 4 -5 -6 -7 -8 0
UNSAT
solutions= 70
_PRE_END

<p>It was also tested on _HTML_LINK(`https://yurichev.com/blog/minesweeper_SAT/',`my Minesweeper cracker'), and works reasonable time (though, slower than MiniSat by a factor of ~10).</p>

<p>On bigger CNF instances, it gets stuck.</p>

<p>Source code:</p>

_PRE_BEGIN
m4_include(`blog/SAT_backtrack/SAT_backtrack.py')
_PRE_END

<p>The files: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/SAT_backtrack').</p>

<p>My other notes about SAT/SMT: _HTML_LINK_AS_IS(`https://yurichev.com/writings/SAT_SMT_draft-EN.pdf').</p>

_BLOG_FOOTER()

