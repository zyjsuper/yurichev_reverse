m4_include(`commons.m4')

_HEADER_HL1(`22-Aug-2015: De Bruijn sequences (solution for the exercise posted at 18-Aug-2015); leading/trailing zero bits counting.')

_HL2(`Introduction')

<p>Let's imagine there is a very simplified code lock accepting 2 digits, but it has no "enter" key, it just checks 2 last entered digits.
Our task is to brute force each 2-digit combination.
Naïve method is to try 00, 01, 02 ... 99.
That require 2*100=200 key pressings.
Will it be possible to reduce number of key pressings during brute-force?
It is indeed so, with the help of De Bruijn sequences.
We can generate them for the code lock, using Wolfram Mathematica:</p>

_PRE_BEGIN
In[]:= DeBruijnSequence[{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, 2]
Out[]= {6, 8, 6, 5, 4, 3, 2, 1, 7, 8, 7, 1, 1, 0, 9, 0, 8, 0, 6, 6, \
0, 5, 5, 0, 4, 4, 0, 3, 3, 0, 2, 7, 2, 2, 0, 7, 7, 9, 8, 8, 9, 9, 7, \
0, 0, 1, 9, 1, 8, 1, 6, 1, 5, 1, 4, 1, 3, 7, 3, 1, 2, 9, 2, 8, 2, 6, \
2, 5, 2, 4, 7, 4, 2, 3, 9, 3, 8, 3, 6, 3, 5, 7, 5, 3, 4, 9, 4, 8, 4, \
6, 7, 6, 4, 5, 9, 5, 8, 5, 6, 9}
_PRE_END

<p>The result has exactly 100 digits, which is 2 times less than our initial idea can offer.
By scanning visually this 100-digits array, you'll find any number in 00..99 range.
All numbers are overlapped with each other: second half of each number is also first half of the next number, etc.</p>

<p>Here is another. We need a sequence of binary bits with all 3-bit numbers in it:</p>

_PRE_BEGIN
In[]:= DeBruijnSequence[{0, 1}, 3]
Out[]= {1, 0, 1, 0, 0, 0, 1, 1}
_PRE_END

<p>Sequence length is just 8 bits, but it has all binary numbers in 000..111 range.
You may visually spot 000 in the middle of sequence.
111 is also present: two first bits of it at the end of sequence and the last bit is in the beginning.
This is so because De Bruijn sequences are cyclic.</p>

<p>There is also visual demonstration: _HTML_LINK_AS_IS(`http://demonstrations.wolfram.com/DeBruijnSequences/').</p>

_HL2(`Trailing zero bits counting')

<p>In _HTML_LINK(`https://en.wikipedia.org/wiki/De_Bruijn_sequence',`Wikipedia article about De Bruijn sequences') we can find:</p>

<blockquote>The symbols of a De Bruijn sequence written around a circular object (such as a wheel of a robot) can be used to identify its angle by examining the n consecutive symbols facing a fixed point.</blockquote>

<p>Indeed: if we know De Bruijn sequence and we observe only part of it (any part), we can deduce exact position of this part within sequence.</p>

<p>Let's see, how this feature can be used.</p>

<p>Let's say, there is a need to detect position of input bit within 32-bit word.
For 0x1, the algorithm should report 1.
2 for 0x2.
3 for 0x4.
And 31 for 0x80000000.</p>

<p>The result is in 0..31 range, so the result can be stored in 5 bits.</p>

<p>We can construct binary De Bruijn sequence for all 5-bit numbers:</p>

_PRE_BEGIN
In[]:= tmp = DeBruijnSequence[{0, 1}, 5]
Out[]= {1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0}

In[]:= BaseForm[FromDigits[tmp, 2], 16]
Out[]:= e6bec520
_PRE_END

<p>Let's also recall that division some number by $2^n$ number is the same thing as shifting it by $n$ bits.
So if you divide 0xe6bec520 by 1, the result is not shifted, it is still the same.
If if divide 0xe6bec520 by 4 ($2^2$), the result is shifted by 2 bits.
We then take result and isolate lowest 5 bits.
This result is unique number for each input.
Let's shift 0xe6bec520 by all possible count number, and we'll get all possible last 5-bit values:</p>

_PRE_BEGIN
In[]:= Table[BitAnd[BitShiftRight[FromDigits[tmp, 2], i], 31], {i, 0, 31}]
Out[]= {0, 16, 8, 4, 18, 9, 20, 10, 5, 2, 17, 24, 12, 22, 27, 29, \
30, 31, 15, 23, 11, 21, 26, 13, 6, 19, 25, 28, 14, 7, 3, 1}
_PRE_END

The table has no duplicates:

_PRE_BEGIN
In[]:= DuplicateFreeQ[%]
Out[]= True
_PRE_END

<p>Using this table, it's easy to build "magic" table.
OK, now working C example:</p>

_PRE_BEGIN
#include &lt;stdint.h>
#include &lt;stdio.h>

int magic_tbl[32];

// returns single bit position counting from LSB
// not working for i==0
int bitpos (uint32_t i)
{
	return magic_tbl[(0xe6bec520/i) & 0x1F];
};

int main()
{
	// construct magic table
	// may be omitted in production code
	for (int i=0; i&lt;32; i++)
		magic_tbl[(0xe6bec520/(1&lt;&lt;i)) & 0x1F]=i;

	// test
	for (int i=0; i&lt;32; i++)
	{
		printf ("input=0x%x, result=%d\n", 1&lt;&lt;i, bitpos (1&lt;&lti));
	};
};
_PRE_END

<p>Here we feed our bitpos() function with numbers in 0..0x80000000 range and we got:</p>

_PRE_BEGIN
input=0x1, result=0
input=0x2, result=1
input=0x4, result=2
input=0x8, result=3
input=0x10, result=4
input=0x20, result=5
input=0x40, result=6
input=0x80, result=7
input=0x100, result=8
input=0x200, result=9
input=0x400, result=10
input=0x800, result=11
input=0x1000, result=12
input=0x2000, result=13
input=0x4000, result=14
input=0x8000, result=15
input=0x10000, result=16
input=0x20000, result=17
input=0x40000, result=18
input=0x80000, result=19
input=0x100000, result=20
input=0x200000, result=21
input=0x400000, result=22
input=0x800000, result=23
input=0x1000000, result=24
input=0x2000000, result=25
input=0x4000000, result=26
input=0x8000000, result=27
input=0x10000000, result=28
input=0x20000000, result=29
input=0x40000000, result=30
input=0x80000000, result=31
_PRE_END

<p>The bitpos() function actually counts trailing zero bits, but it works only for input values where only one bit is set.
To make it more practical, we need to devise a method to drop all leading bits except of the last one.
This method is very simple and well-known:</p>

_PRE_BEGIN
input & (-input)
_PRE_END

<p>This bit twiddling hack can solve the job. Feeding 0x11 to it, it will return 0x1. Feeding 0xFFFF0000, it will return 0x10000.
In other words, it leaves lowest significant bit of the value, dropping all others.</p>

<p>It works because negated value in two's complement environment is the value with all bits flipped but also 1 added (because there is a zero in the middle of ring).
For example, let's take 0xF0. -0xF0 is 0x10 or 0xFFFFFF10. ANDing 0xF0 and 0xFFFFFF10 will produce 0x10.</p>

<p>Let's modify our algorithm to support true trailing zero bits count:</p>

_PRE_BEGIN
#include &lt;stdint.h>
#include &lt;stdio.h>

int magic_tbl[32];

// not working for i==0
int tzcnt (uint32_t i)
{
	uint32_t a=i & (-i);
	return magic_tbl[(0xe6bec520/a) & 0x1F];
};

int main()
{
	// construct magic table
	// may be omitted in production code
	for (int i=0; i&lt;<32; i++)
		magic_tbl[(0xe6bec520/(1&lt;&lt;i)) & 0x1F]=i;

	// test:
	printf ("%d\n", tzcnt (0xFFFF0000));
	printf ("%d\n", tzcnt (0xFFFF0010));
};
_PRE_END

<p>It works!</p>

_PRE_BEGIN
16
4
_PRE_END

<p>But it has one drawback: it uses division, which is slow.
Can we just multiplicate De Bruijn sequence by the value with the bit isolated instead of dividing sequence?
Yes, indeed.
Let's check in Mathematica:</p>

_PRE_BEGIN
In[]:= BaseForm[16^^e6bec520*16^^80000000, 16]
Out[]:= 0x735f629000000000
_PRE_END

<p>The result is just too big to fit in 32-bit register, but can be used.
MUL/IMUL instruction 32-bit x86 CPUs stores 64-bit result into two 32-bit registers pair, yes.
But let's suppose we would like to make portable code which will work on any 32-bit architecture.
First, let's again take a look on De Bruijn sequence Mathematica first produced:</p>

_PRE_BEGIN
In[]:= tmp = DeBruijnSequence[{0, 1}, 5]
Out[]= {1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, \
0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0}
_PRE_END

<p>There is exactly 5 bits at the end which can be dropped.
The "magic" constant will be much smaller:</p>

_PRE_BEGIN
In[]:= BaseForm[BitShiftRight[FromDigits[tmp, 2], 5], 16]
Out[]:=0x735f629
_PRE_END

<p>The "magic" constant is now "divided by 32 (or 1>>5)".
This mean that the result of multiplication of some value with one isolated bit by new magic number will also be smaller, so the bits we need will
be stored at the high 5 bits of the result.</p>

<p>De Bruijn sequence is not broken after 5 lowest bits dropped, because these zero bits are "relocated" to the start of the sequence.
Sequence is cyclic after all.</p>

_PRE_BEGIN
#include &lt;stdint.h>
#include &lt;stdio.h>

int magic_tbl[32];

// not working for i==0
int tzcnt (uint32_t i)
{
	uint32_t a=i & (-i);
	// 5 bits we need are stored in 31..27 bits of product, shift and isolate them after multiplication:
	return magic_tbl[((0x735f629*a)>>27) & 0x1F];
};

int main()
{
	// construct magic table
	// may be omitted in production code
	for (int i=0; i<32; i++)
		magic_tbl[(0x735f629&lt;&lt;i >>27) & 0x1F]=i;
	
	// test:
	printf ("%d\n", tzcnt (0xFFFF0000));
	printf ("%d\n", tzcnt (0xFFFF0010));
};
_PRE_END

_HL2(`Leading zero bits counting')

<p>This is almost the same task, but most significant bit must be isolated instead of lowest.
This is typical algorithm for 32-bit integer values:</p>

_PRE_BEGIN
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
_PRE_END

<p>For example, 0x100 becomes 0x1ff, 0x1000 becomes 0x1fff, 0x20000 becomes 0x3ffff, 0x12340000 becomes 0x1fffffff.
It works because all 1 bits are gradually propagated towards the lowest bit in 32-bit number,
while zero bits at the left of most significant 1 bit are not touched.</p>

<p>It's possible to add 1 to resulting number, so it will becomes 0x2000 or 0x20000000, but in fact, since multiplication by magic number is used,
these numbers are very close to each other, so there are no error.</p>

<p>This example I used in my reverse engineering exercise from 15-Aug-2015: _HTML_LINK_AS_IS(`http://yurichev.com/blog/2015-aug-18/').</p>

_PRE_BEGIN
int v[64]=
	{ -1,31, 8,30, -1, 7,-1,-1, 29,-1,26, 6, -1,-1, 2,-1,
	  -1,28,-1,-1, -1,19,25,-1, 5,-1,17,-1, 23,14, 1,-1,
	   9,-1,-1,-1, 27,-1, 3,-1, -1,-1,20,-1, 18,24,15,10,
	  -1,-1, 4,-1, 21,-1,16,11, -1,22,-1,12, 13,-1, 0,-1 };

int LZCNT(uint32_t x)
{
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    x *= 0x4badf0d;
    return v[x >> 26];
}
_PRE_END

<p>This piece of code I took _HTML_LINK(`http://stackoverflow.com/questions/7365562/de-bruijn-like-sequence-for-2n-1-how-is-it-constructed/7369288#7369288',`here').
It is slightly different: the table is twice bigger, and the function returns -1 if input value is zero.
The magic number I found using just brute-force, so the readers will not be able to google it, for the sake of exercise.</p>

<p>The code is tricky after all, and the moral of the exercise is that practicing reverse engineer sometimes may just observe input/outputs to understand
code's behaviour instead of diving into it.</p>

_HL2(`Performance')

<p>The algorithms considered are probably fastest known, they has no conditional jumps, which is very good for CPUs starting at RISCs.
Newer CPUs has LZCNT and TZCNT instructions, even 80386 had BSF/BSR instructions which can be used for this: 
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Find_first_set').
Nevertheless, these algorithms can be still used on cheaper RISC CPUs without specialized instructions.</p>

_HL2(`Applications')

<p>Number of leading zero bits is binary logarithm of value. My article about logarithms including binary:
_HTML_LINK_AS_IS(`http://yurichev.com/writings/log_intro.pdf').</p>

<p>These algorithms are also extensively used in chess engines programming, where each piece is represented as 64-bit bitmask (chess board has 64 squares):
_HTML_LINK_AS_IS(`http://chessprogramming.wikispaces.com/BitScan').</p>

<p>There are more: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Find_first_set#Applications').</p>

_HL2(`Generation of De Bruijn sequences')

<p>_HTML_LINK(`https://en.wikipedia.org/wiki/De_Bruijn_graph',`De Bruijn graph') is a graph where all values are represented as vertices (or nodes) and each edge (or link) connects two nodes which can be "overlapped".
Then we need to visit each edge only once, this is called _HTML_LINK(`https://en.wikipedia.org/wiki/Eulerian_path',`eulerian path').
It is like the famous _HTML_LINK(`https://en.wikipedia.org/wiki/Seven_Bridges_of_K%C3%B6nigsberg',`task of seven bridges of Königsberg'):
traveller must visit each bridge only once.</p>

<p>There are also simpler algorithms exist: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/De_Bruijn_sequence#Algorithm').</p>

_HL2(`Other articles')

<p>At least these are worth reading:
_HTML_LINK_AS_IS(`http://supertech.csail.mit.edu/papers/debruijn.pdf'),
_HTML_LINK_AS_IS(`http://alexandria.tue.nl/repository/books/252901.pdf'),
_HTML_LINK(`https://en.wikipedia.org/wiki/De_Bruijn_sequence',`Wikipedia Article about De Bruijn sequences').</p>

_BLOG_FOOTER()

