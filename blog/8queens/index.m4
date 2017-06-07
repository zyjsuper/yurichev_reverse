m4_include(`commons.m4')

_HEADER_HL1(`7-Jun-2017: Eight queens problem in 93 bytes')

<p>There is a well known _HTML_LINK(`https://en.wikipedia.org/wiki/Eight_queens_puzzle',`eight queens') problem: place 8 queens on chess board so they will not attack each other; also, count all possible positions.
There are 92 possible positions for 8*8 chess board (let's leave aside all symmetries).</p>

<p>Here is my piece of code to count them:</p>

_PRE_BEGIN()
#include &lt;stdio.h>
#include &lt;assert.h>

// https://en.wikipedia.org/wiki/Eight_queens_puzzle
// https://oeis.org/A000170/b000170.txt

int try_row(int row, int attack_vertical, int attack_RL, int attack_LR, int queens, int start_bit)
{
        if (row==queens)
        {
                // all rows are filled, so we have a correct position
                return 1;
        };

        int total=0;
        // squares attacked in current row:
        int attack=attack_vertical | attack_RL | attack_LR;

        // enumerate all squares in current row:
        for (int new_queen=start_bit; new_queen; new_queen=new_queen>>1)
        {
                // square is not attacked by previous/upper row(s),
                // so place the queen here:
                if ((new_queen & attack)==0)
                {
                        // add new queen to "attack" variables:
                        // "vertical" is squares attacked vertically
                        // "RL" is squares attacked diagonally R-to-L
                        // "LR" is squares attacked diagonally L-to-R

                        total+=try_row(row+1,
                                attack_vertical | new_queen,
                                (attack_RL | new_queen)&lt;&lt;1,
                                (attack_LR | new_queen)>>1,
                                queens, start_bit);
                };
        };

        // no more space for queen(s) in current row, stop:
        return total;
};

int main()
{
        for (int i=1; i<=14; i++)
                printf ("%d*%d total=%d\n", i, i, try_row(0, 0, 0, 0, i, 1<<(i-1)));
/*
        assert (try_row(0, 0, 0, 0, 1, 1<<(1-1))==1);
        assert (try_row(0, 0, 0, 0, 2, 1<<(2-1))==0);
        assert (try_row(0, 0, 0, 0, 3, 1<<(3-1))==0);
        assert (try_row(0, 0, 0, 0, 4, 1<<(4-1))==2);
        assert (try_row(0, 0, 0, 0, 5, 1<<(5-1))==10);
        assert (try_row(0, 0, 0, 0, 6, 1<<(6-1))==4);
        assert (try_row(0, 0, 0, 0, 7, 1<<(7-1))==40);
        assert (try_row(0, 0, 0, 0, 8, 1<<(8-1))==92);
        assert (try_row(0, 0, 0, 0, 9, 1<<(9-1))==352);
        assert (try_row(0, 0, 0, 0, 10, 1<<(10-1))==724);
        assert (try_row(0, 0, 0, 0, 11, 1<<(11-1))==2680);
        assert (try_row(0, 0, 0, 0, 12, 1<<(12-1))==14200);
        assert (try_row(0, 0, 0, 0, 13, 1<<(13-1))==73712);
        assert (try_row(0, 0, 0, 0, 14, 1<<(14-1))==365596);
*/
};
_PRE_END()

<p>We can try to rewrite it to assembly.
It's very hard to compete with modern compilers in efficient code generation, but we can still compete with small code generation.</p>

<p>This is what GCC generated, but I optimized it manually:</p>

_PRE_BEGIN()
m4_include(`blog/8queens/8queens_asm.s')
_PRE_END()

<p>It works slightly slower, but, judging by objdump (<i>objdump -d 8queens_asm</i>), occupies 93 bytes.
It still can be optimized further.</p>

<p>There is no point to write assembly code these days, but it can be good exercise, to understand it better.
Surprisingly, it also helps during SIMD coding, since you work with CPU instructions rather than functions.</p>

<p>The files: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/8queens').</p>

_BLOG_FOOTER()

