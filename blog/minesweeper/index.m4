m4_include(`commons.m4')

_HEADER_HL1(`5-Mar-2017: Cracking Minesweeper with Z3 SMT solver')

_COPYPASTED2()

<p>For those who are not very good at playing Minesweeper (like me), it's possible to predict bombs' placement without touching debugger.</p>

<p>Here is a clicked somewhere and I see revealed empty cells and cells with known number of "neighbours":</p>

<p><img src="https://yurichev.com/blog/minesweeper/1.png"></p>

<p>What we have here, actually? Hidden cells, empty cells (where bombs are not present), and empty cells with numbers, which shows how many bombs are placed nearby.
Here is what we can do: we will try to place a bomb to all possible hidden cells and ask Z3 SMT solver, if it can disprove the very fact that the bomb can be placed there.</p>

_HL2(`The method')

<p>Take a look at this fragment. "?" mark is for unknown cell, "." is for empty cell, digit is a number of neighbours.</p>

_PRE_BEGIN
? ? ?
? 3 .
? 1 .
_PRE_END

<p>
So there are 5 unknown cells.
We will try each unknown cell by placing a bomb there.
Let's first pick top/left cell:
</p>

_PRE_BEGIN
1 ? ?
? 3 .
? 1 .
_PRE_END

<p>Then we will try to solve the following system of equations (RrCc is cell of row r and column c):</p>

_PRE_BEGIN
R1C2+R2C1+R2C2=1                               (because we placed bomb at R1C1)
R2C1+R2C2+R3C1=1                               (because we have "1" at R3C2)
R1C1+R1C2+R1C3+R2C1+R2C2+R2C3+R3C1+R3C2+R3C3=3 (because we have "3" at R2C2)
R1C2+R1C3+R2C2+R2C3+R3C2+R3C3=0                (because we have "." at R2C3)
R2C2+R2C3+R3C2+R3C3=0                          (because we have "." at R3C3)
_PRE_END

<p>
As it turns out, this system of equations is satisfiable, so there could be a bomb at this cell.
But this information is not interesting to us, since we want to find cells we can freely click on.
And we will try another one...
</p>

_HL2(`The code')

_PRE_BEGIN
m4_include(`blog/minesweeper/minesweeper_solver.py')
_PRE_END

<p>The code is almost self-explanatory.
We need border for the same reason, why Conway's "Game of Life" implementations also has border (to make calculation
function simpler).
Whenever we know that the cell is free of bomb, we put zero there.
Whenever we know number of neighbours, we add a constraint, again, just like in "Game of Life": number of neighbours must be equal to the number we got from the Minesweeper.
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

<p>These are cells where I can click safely, so I did:</p>

<p><img src="https://yurichev.com/blog/minesweeper/2.png"></p>

<p>Now we have more information, so we update input:</p>

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

<p>I click on these cells again:</p>

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

<p>The source code: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/minesweeper/minesweeper_solver.py').</p>

<p>More Z3 examples are in _HTML_LINK(`https://yurichev.com/blog/',`my blog') and here: _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf').</p>

<p>Some discussion on HN: _HTML_LINK_AS_IS(`https://news.ycombinator.com/item?id=13797375').</p>

<p>Update: next part: _HTML_LINK_AS_IS(`https://yurichev.com/blog/minesweeper_SAT/').</p>

_BLOG_FOOTER()

