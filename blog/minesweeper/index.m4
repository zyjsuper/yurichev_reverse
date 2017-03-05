m4_include(`commons.m4')

_HEADER_HL1(`5-Mar-2017: Cracking Minesweeper with Z3 SMT solver')

<p>For those who are not very good at playing Minesweeper (like me), it's possible to predict bombs' placement without touching debugger.</p>

<p>Here is a clicked somewhere and I see revealed empty cells and cells with known number of "neighbours":</p>

<p><img src="https://yurichev.com/blog/minesweeper/1.png"></p>

<p>What we have here, actually? Hidden cells, empty cells (where bombs are not present), and empty cells with numbers, which shows how many bombs are placed nearby.
Here is what we can do: we will try to place a bomb to all possible hidden cells and ask Z3 SMT solver, if it can disprove the very fact that the bomb can be placed there.</p>

_PRE_BEGIN
m4_include(`blog/minesweeper/minesweeper_solver.py')
_PRE_END

<p>The code is almost self-explanatory.
We need border for the same reason, why Conway's "Game of Life" implementations also has border.
Whenever we know that the cell is free of bomb, we put zero there.
Whenever we know number of neighbours, we can add a constraint, again, just like in "Game of Life".
Then we place bomb somewhere and check.</p>

<p>Let's run:</p>

_PRE_BEGIN
row=1 col=3, unsat!
row=6 col=2, unsat!
row=6 col=3, unsat!
row=7 col=4, unsat!
row=7 col=9, unsat!
row=8 col=9, unsat!
_PRE_END

<p>These are cells where I can click, so I did:</p>

<p><img src="https://yurichev.com/blog/minesweeper/2.png"></p>

<p>We have more information, so we update input:</p>

_PRE_BEGIN
known=[
"01110001?",
"01?100011",
"011100000",
"000000000",
"111110011",
"?11?1001?",
"???331011",
"?????2110",
"???????10"]
_PRE_END

<p>I run it again:</p>

_PRE_BEGIN
row=7 col=1, unsat!
row=7 col=2, unsat!
row=7 col=3, unsat!
row=8 col=3, unsat!
row=9 col=5, unsat!
row=9 col=6, unsat!
_PRE_END

<p>I click again:</p>

<p><img src="https://yurichev.com/blog/minesweeper/3.png"></p>

<p>I update it again:</p>

_PRE_BEGIN
known=[
"01110001?",
"01?100011",
"011100000",
"000000000",
"111110011",
"?11?1001?",
"222331011",
"??2??2110",
"????22?10"]
_PRE_END

_PRE_BEGIN
row=8 col=2, unsat!
row=9 col=4, unsat!
_PRE_END

<p><img src="https://yurichev.com/blog/minesweeper/4.png"></p>

<p>This is last update:</p>

_PRE_BEGIN
known=[
"01110001?",
"01?100011",
"011100000",
"000000000",
"111110011",
"?11?1001?",
"222331011",
"?22??2110",
"???322?10"]
_PRE_END

<p>... last result:</p>

_PRE_BEGIN
row=9 col=1, unsat!
row=9 col=2, unsat!
_PRE_END

<p>Voila!</p>

<p><img src="https://yurichev.com/blog/minesweeper/5.png"></p>

<p>The source code: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/minesweeper/minesweeper_solver.py').</p>

_BLOG_FOOTER()

