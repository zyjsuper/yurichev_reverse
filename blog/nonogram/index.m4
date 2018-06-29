m4_include(`commons.m4')

_HEADER_HL1(`Nonogram puzzle solver using Z3 SMT-solver')

<p>This is a sample one, from Wikipedia:</p>

<p><img src="680px-Nonogram_wiki.svg.png"></p>

<p>( _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Nonogram') )</p>

<p>The source code of my solver: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/nonogram/nonogram_solver.py').</p>

The result:

_PRE_BEGIN
sat                                                                                                       
******** ******* ***** *******
  *****   ****    ***    ***
   ***     ***    **     ***
   ****     ***   **     **
    ***     ***  **      **
    ***     **** **     **
    ****     *****      **
     ***     *****      *
     ****     ***      **
      ***     ****     **
      ****    ****    **
       ***   ******   **
       ***   ** ***   *
       **** *** **** **
        *** **   *** **
        ******   *****
         ****    *****
         ***      ***
         ***      ***
          *        *
_PRE_END

<p>How it works (briefly).
Given a row of width 8 and input (or "clue") like [3,2], we create two "islands":</p>

_PRE_BEGIN
11100000
11000000
_PRE_END

<p>The length of each bitvector/bitstring is 8 (width of row).</p>

<p>We then define another variable: island_shift, for each "island", which defines a count, on which a bitstring is shifted right.
We also calculate limits for each "island": position of each one must not be lower/equal then the position of the previous
"island".</p>

<p>All islands are then merged into one (merged_islands[]) using OR operation:</p>

_PRE_BEGIN
11100000
00001100

->

11101100
_PRE_END

<p>merged_islands[] is a final representation of row - how it will be printed.</p>

<p>Now repeat this all for all rows and all columns.
Then make corresponding bits of each row and column to be equal to each other.
In other words, col_merged_islands[] must be equal to row_merged_islands[], but rotated by 90°.</p>

<p>The solver is surprisingly fast even on hard puzzles.</p>

_BLOG_FOOTER()

