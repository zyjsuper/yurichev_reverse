m4_include(`commons.m4')

_HEADER_HL1(`Magic/Latin square of Knut Vik design: getting it using Z3')

<p>Magic/Latin square is a square filled with numbers/letters, which are all distinct in each row and column.
Sudoku is 9*9 magic square with additional constraints (for each 3*3 subsquare).</p>

<p>"Knut Vik design" is a square, where all (broken) diagonals has distinct numbers.</p>

<p>This is diagonal of 5*5 square:</p>

_PRE_BEGIN
. . . . *
. . . * .
. . * . .
. * . . .
* . . . .
_PRE_END

<p>These are broken diagonals:</p>

_PRE_BEGIN
. . * . .
. . . * .
. . . . *
* . . . .
. * . . .
_PRE_END

_PRE_BEGIN
* . . . .
. . . . *
. . . * .
. . * . .
. * . . .
_PRE_END

<p>I could only find 5*5 and 7*7 squares using Z3, couldn't find 11*11 square, however, it's possible to prove there are no 6*6 and 4*4 squares (such squares doesn't exist if size is divisible by 2 or 3).</p>

_PRE_BEGIN
m4_include(`blog/knut_vik/knut_vik1.py')
_PRE_END

<p>5*5 Knut Vik square:</p>

_PRE_BEGIN
3 4 5 1 2
5 1 2 3 4
2 3 4 5 1
4 5 1 2 3
1 2 3 4 5
_PRE_END

<p>7*7:</p>

_PRE_BEGIN
4 7 6 5 1 2 3
6 5 1 2 3 4 7
1 2 3 4 7 6 5
3 4 7 6 5 1 2
7 6 5 1 2 3 4
5 1 2 3 4 7 6
2 3 4 7 6 5 1
_PRE_END

<p>This is NP-problem: you can check this result visually, but it takes several seconds for computer to find it.</p>

<p>We can also use different encoding: each number can be represented by one bit. 0b0001 for 1, 0b0010 for 2, 0b1000 for 4, etc.
Then a "Distinct" operator can be replaced by OR operation and comparison against mask with all bits present.</p>

_PRE_BEGIN
m4_include(`blog/knut_vik/knut_vik2.py')
_PRE_END

<p>That works twice as faster (however, numbers are in 0..SIZE-1 range instead of 1..SIZE, but you've got the idea).</p>

<p>Besides recreational mathematics, squares like these are very important in design of experiments.</p>

<p>The files: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/knut_vik')</p>

<p>Further reading:</p>

<ul>
<li>A. Hedayat and W, T. Federer - On the Nonexistence of Knut Vik Designs for all Even Orders (1973)
<li>A. Hedayat - A Complete Solution to the Existence and Nonexistence of Knut Vik Designs and Orthogonal Knut Vik Designs (1975)
</ul>

_BLOG_FOOTER()

