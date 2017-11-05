m4_include(`commons.m4')

_HEADER_HL1(`Yet another explanation of CRC (Cyclic redundancy check)')

_HL2(`What is wrong with checksum?')

<p>If you just sum up values of several bytes, two bit flips (increment one bit and decrement another bit) can
give the same checksum.
No good.</p>

_HL2(`Division by prime')

<p>You can represent a file of buffer as a (big) number, then to divide it by prime.
The remainder is then very sensitive to bit flips.
For example, a prime 0x10015 (65557).</p>

<p>Wolfram Mathematica:</p>

_PRE_BEGIN
In[]:= divisor=16^^10015
Out[]= 65557

In[]:= BaseForm[Mod[16^^abcdef1234567890, divisor],16]
Out[]= d8c1

In[]:= BaseForm[Mod[16^^abcdef0234567890, divisor],16]
Out[]= bd31

In[]:= BaseForm[Mod[16^^bbcdef1234567890, divisor],16]
Out[]= 382b

In[]:= BaseForm[Mod[16^^abcdee1234567890, divisor],16]
Out[]= 1fd6

In[]:= BaseForm[Mod[16^^abcdef0234567891, divisor],16]
Out[]= bd32
_PRE_END

<p>This is what is called 'avalanche effect' in cryptography: one bit flip of input can affect many bits of output.
Go figure out which bits must be also flipped to preserve specific remainder.</p>

<p>You can build such a divisor in hardware, but it would require at least one adder or subtractor, you will have
a carry-ripple problem in simple case, or you would have to create more complicated circuit.</p>

_HL2(`(Binary) long divison')

<p>Binary long division is in fact simpler then the paper-n-pencil algorithm taught in schools.</p>

<p>The algorithm is:</p>

<ul>
<li>1) Allocate some 'tmp' variable and copy dividend to it.

<li>2) Pad divisor by zero bits at left so that MSB of divisor is at the place of MSB of the value in tmp.

<li>3) If the divisor is larger than tmp or equal, subtract divider from tmp and add 1 bit to the quotient.
If the divisor is smaller than tmp, add 0 bit to the quotient.

<li>4) Shift divisor right.
If the divisor is 0, stop. Remainder is in tmp.

<li>5) Goto 3
</ul>

<p>The following piece of code I've copypasted from somewhere:</p>

_PRE_BEGIN
unsigned int divide(unsigned int dividend, unsigned int divisor)
{
        unsigned int tmp = dividend;
        unsigned int denom = divisor;
        unsigned int current = 1;
        unsigned int answer = 0;

        if (denom > tmp)
                return 0;

        if (denom == tmp)
                return 1;

        // align divisor:
        while (denom <= tmp)
        {
                denom = denom << 1;
                current = current << 1;
        }

        denom = denom >> 1;
        current = current >> 1;

        while (current!=0)
        {
                printf ("current=%d, denom=%d\n", current, denom);
                if (tmp >= denom)
                {
                        tmp -= denom;
                        answer |= current;
                }
                current = current >> 1;
                denom = denom >> 1;
        }
        printf ("tmp/remainder=%d\n", tmp); // remainder!
        return answer;
}
_PRE_END

( _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/CRC/div.c') )

<p>Let's divide 1234567 by 813 and find remainder:</p>

_PRE_BEGIN
current=1024, denom=832512
current=512, denom=416256
current=256, denom=208128
current=128, denom=104064
current=64, denom=52032
current=32, denom=26016
current=16, denom=13008
current=8, denom=6504
current=4, denom=3252
current=2, denom=1626
current=1, denom=813
tmp/remainder=433
1518
_PRE_END

_HL2(`(Binary) long division, version 2')

<p>Now let's say, you only need to compute a remainder, and throw away a quotient.
Also, maybe you work on some kind BigInt values and you've got a function like get_next_bit() and that's it.</p>

<p>What we can do: tmp value will be shifted at each iteration, while divisor is not:</p>

_PRE_BEGIN
uint8_t *buf;
int buf_pos;
int buf_bit_pos;

int get_bit()
{
	if (buf_pos==-1)
		return -1; // end

	int rt=(buf[buf_pos] >> buf_bit_pos) & 1;
	if (buf_bit_pos==0)
	{
		buf_pos--;
		buf_bit_pos=7;
	}
	else
		buf_bit_pos--;
	return rt;
};

uint32_t remainder_arith(uint32_t dividend, uint32_t divisor)
{
	buf=(uint8_t*)&dividend;
	buf_pos=3;
	buf_bit_pos=7;

	uint32_t tmp=0;

	for(;;)
	{
		int bit=get_bit();
		if (bit==-1)
		{
			printf ("exit. remainder=%d\n", tmp);
			return tmp;
		};

		tmp=tmp<<1;
		tmp=tmp|bit;

		if (tmp>=divisor)
		{
			printf ("%d greater or equal to %d\n", tmp, divisor);
			tmp=tmp-divisor;
			printf ("new tmp=%d\n", tmp);
		}
		else
			printf ("tmp=%d, can't subtract\n", tmp);
	};
}
_PRE_END

( _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/CRC/div_both.c') )
	
<p>Let's divide 1234567 by 813 and find remainder:</p>

_PRE_BEGIN
m4_include(`blog/CRC/log.txt')
_PRE_END

_HL2(`Shortest possible introduction into GF(2)')

<p>There is a huge difference between digit and number.
Digit is a symbol, number is a group of digits.
0 can be both digit and number.</p>

<p>Binary digits are 0 and 1, but a binary number can be any.</p>

<p>There are just two numbers in Galois Field (2): 0 and 1.
No other numbers.</p>

<p>What practical would you do with just two numbers?
Not much, but you can pack GF(2) numbers into some kind of structure or tuple or even array.
Such structures are represented using polynomials.
For example, CRC32 polynomial you can find in source code is 0x04C11DB7.
Each bit represent a number in GF(2), not a digit.
The 0x04C11DB7 polynomial is written as: </p>

<p>$x^{32} + x^{26} + x^{23} + x^{22} + x^{16} + x^{12} + x^{11} + x^{10} + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1$</p>

<p>Wherever $x^n$ is present, that means, you have a bit at position $n$.
Just $x$ means, bit present at LSB.
There is, however, bit at $x^{32}$, so the CRC32 polynomial has the size of 33 bits, bit the MSB is always 1 and is
omitted in all algorithms.</p>

<p>It's important to say that unlike in algebra, GF(2) polynomials are never evaluated here.
$x$ is symbol is present mereley as a convention.
People represent GF(2) "structures" as polynomials to emphasize the fact that "numbers" are isolated from each other.</p>

<p>Now, subtraction and addition are the same operations in GF(2) and actually works as XOR.
This is present in many tutorials, so I'll omit this here.</p>

<p>Also, by convention, whenever you compare two numbers in GF(2), you only compare two most significant bits,
and ignore the rest.</p>

_HL2(`CRC32')

<p>Now we can take the binary division algorithm and change it a little:</p>

_PRE_BEGIN
uint32_t remainder_GF2(uint32_t dividend, uint32_t divisor)
{
	// necessary bit shuffling/negation to to make it compatible with other CRC32 implementations.
	// N.B.: input data is not an array, but a 32-bit integer, hence we need to swap endiannes.
	uint32_t dividend_negated_swapped = ~swap_endianness32(bitrev32(dividend));
	buf=(uint8_t*)&dividend_negated_swapped;
	buf_pos=3;
	buf_bit_pos=7;

	uint32_t tmp=0;

	// process 32 bits from the input + 32 zero bits:
	for(int i=0; i<32+32; i++)
	{
		int bit=get_bit();
		int shifted_bit=tmp>>31;

		// fetch next bit:
		tmp=tmp<<1;
		if (bit==-1)
		{
			// no more bits, but continue, we fetch 32 more zero bits.
			// shift left operation set leftmost bit to zero.
		}
		else
		{
			// append next bit at right:
			tmp=tmp|bit;
		};

		// at this point, tmp variable/value has 33 bits: shifted_bit + tmp
		// now take the most significant bit (33th) and test it:
		// 33th bit of polynomial (not present in "divisor" variable is always 1
		// so we have to only check shifted_bit value
		if (shifted_bit)
		{
			// use only 32 bits of polynomial, ingore 33th bit, which is always 1:
			tmp=tmp^divisor;
		};
	};
	// bit shuffling/negation for compatibility once again:
	return ~bitrev32(tmp);
}
_PRE_END

( _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/CRC/div_both.c') )

<p>And voila, this is the function which computes CRC32 for the input 32-bit value.</p>

<p>There are only 3 significant changes:</p>

<ul>
<li>1) XOR instead of minus.

<li>2) Only MSB is checked during comparison. But the MSB of all CRC polynomials is always 1,
so we only need to check MSB (33th bit) of the tmp variable.

<li>3) There are 32+32=64 iterations instead of 32.
As you can see, only MSB of tmp affects the whole behaviour of the algorithm.
So when tmp variable is filled by 32 bits which never affected anything so far,
we need to "blow out" all these bits through 33th bit of tmp variable to get correct remainder (or CRC32 sum).
</ul>

<p>All the rest algorithms you can find on the Internet are optimized version, which may be harder to understand.
No algorithms used in practice "blows" anything "out" due to optimization.
Many practical algorithms are either bytewise (process input stream by bytes, not by bits) or table-based.</p>

<p>My goal was to write two functions, as similar to each other as possible, to demonstrate the difference.</p>

<p>So the CRC value is in fact remainder of division of input date by CRC polynomial in GF(2) environment.
As simple as that.</p>

_HL2(`Rationale')

<p>Why would anyone use such an unusual mathematics?
The answer is: many GF(2) operations can be done using bit shifts and XOR, which are very cheap operations.</p>

<p>Electronic circuit for CRC generator is extremely simple, it consists of only shift register and XOR gates.
This one is for CRC16:</p>

<img src="CRC16.gif">

<p>( src of image: _HTML_LINK_AS_IS(`https://olimex.wordpress.com/2014/01/10/weekend-programming-challenge-week-39-crc-16/') )</p>

<p>The following page has animation: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Computation_of_cyclic_redundancy_checks').</p>

<p>It can be implemented maybe even using vacuum tubes.</p>

<p>And the task is not to compute remainder according to rules of arithmetics, but rather to detect errors.</p>

<p>Compare this to a division circuit with at least one binary adder/subtractor.</p>

_HL2(`Further reading')

<p>These documents I've found interesting/helpful:</p>

<ul>
<li>_HTML_LINK_AS_IS(`http://www.ross.net/crc/download/crc_v3.txt')
<li>_HTML_LINK_AS_IS(`https://www.kernel.org/doc/Documentation/crc32.txt')
<li>_HTML_LINK_AS_IS(`http://web.archive.org/web/20161220015646/http://www.hackersdelight.org/crc.pdf')
</ul>

_BLOG_FOOTER()

