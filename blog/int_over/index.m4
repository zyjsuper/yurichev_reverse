m4_include(`commons.m4')

_HEADER_HL1(`[SMT][Z3][Python] Integer overflow and SMT-solvers')

<p>This is a classic bug:</p>

_PRE_BEGIN
void allocate_data_for_some_chunks(int num)
{
#define MAX_CHUNKS 10

	if (num>MAX_CHUNKS)
		// throw error

	void* chunks=malloc(num*sizeof(CHUNK));

	...
};
_PRE_END

<p>Seems innocent? However, if a (remote) attacker can put negative value into num, no exception is to be throwed, and malloc() will crash
on too big input value, because malloc() takes unsigned size_t on input.
Unsigned int should be used instead of int for "num", but many programmers use int as a generic type for everything.</p>

_HL2(`Signed addition')

<p>First, let's start with addition.
a+b also seems innocent, but it is producing incorrect result if a+b doesn't fit into 32/64-bit register.</p>

<p>This is what we will do: evaluate an expression on two ALUs: 32-bit one and 64-bit one:</p>

_PRE_BEGIN
                                            +--------------+
a ---+----------------------------------->  |              |
     |                                      |  32-bit ALU  |  --- [sign extend to 64-bit] --->   |\
b -- | -+-------------------------------->  |              |                                     | \
     |  |                                   +--------------+                                     |  \
     |  |                                                                                        |   | (64-bit comparator)
     |  |                                   +--------------+                                     |  /
     +- | -- [sign extend to 64 bits] --->  |              |                                     | /
        |                                   |  64-bit ALU  |  ------------------------------->   |/
        +--- [sign extend to 64 bits] --->  |              |
                                            +--------------+
_PRE_END

<p>In other words, you want your expression to be evaluated on both ALUs correctly, for all possible inputs, right?
Like if the result of 32-bit ALU is always fit into 32-bit register.</p>

<p>And now we can ask Z3 SMT solver to find such an a/b inputs, for which the final comparison will fail.</p>

<p>Needless to say, the default operations (+, -, comparisons, etc) in Z3's Python API are signed, you can see this here:
_HTML_LINK_AS_IS(`https://github.com/Z3Prover/z3/blob/master/src/api/python/z3/z3.py').</p>

<p>Also, we can find lower bound, or minimal possible inputs, using minimize():</p>

_PRE_BEGIN
m4_include(`blog/int_over/1.py')
_PRE_END

_PRE_BEGIN
a32=0x1 or 1
b32=0x7fffffff or 2147483647
out32=0x80000000 or -2147483648
out32_extended=0xffffffff80000000 or -2147483648
a64=0x1 or 1
b64=0x7fffffff or 2147483647
out64=0x80000000 or 2147483648
_PRE_END

<p>Right, 1+0x7fffffff = 0x80000000.
But 0x80000000 is negative already, because MSB is 1.
However, add this on 64-bit ALU and the result will fit in 64-bit register.</p>

<p>How would we fix this problem?
We can devise a special function with "wrapped" addition:</p>

_PRE_BEGIN
/* Returns: a + b */

/* Effects: aborts if a + b overflows */

COMPILER_RT_ABI si_int
__addvsi3(si_int a, si_int b)
{
    si_int s = (su_int) a + (su_int) b;
    if (b >= 0)
    {
        if (s < a)
            compilerrt_abort();
    }
    else
    {
        if (s >= a)
            compilerrt_abort();
    }
    return s;
}
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/llvm-mirror/compiler-rt/blob/master/lib/builtins/addvsi3.c') )</p>

<p>Now I can simulate this function in Z3Py.
I'm telling it: "find a solution, where this expression will be false":</p>

_PRE_BEGIN
s.add(Not(If(b32>=0, a32+b32&lt;a32, a32+b32>a32)))
_PRE_END

<p>And it gives unsat, meaning, there is no counterexample, so the expression can be evaluated safely on both ALUs.</p>

<p>But is there a bug in my statement?
Let's check.
Find inputs for which this piece of LLVM code will call compilerrt_abort():</p>

_PRE_BEGIN
s.add(If(b32>=0, a32+b32&lt;a32, a32+b32>a32))
_PRE_END

_PRE_BEGIN
a32=0x1 or 1
b32=0x7fffffff or 2147483647
out32=0x80000000 or -2147483648
out32_extended=0xffffffff80000000 or -2147483648
a64=0x1 or 1
b64=0x7fffffff or 2147483647
out64=0x80000000 or 2147483648
_PRE_END

<p>Safe implementations of other operations:
_HTML_LINK_AS_IS(`https://wiki.sei.cmu.edu/confluence/display/java/NUM00-J.+Detect+or+prevent+integer+overflow').
A popular library:
_HTML_LINK_AS_IS(`https://github.com/dcleblanc/SafeInt').</p>

_HL2(`Arithmetic mean')

<p>Another classic bug. This is a famous bug in binary search algorithms:
_HTML_LINK(`https://ai.googleblog.com/2006/06/extra-extra-read-all-about-it-nearly.html',`1'),
_HTML_LINK(`https://thebittheories.com/the-curious-case-of-binary-search-the-famous-bug-that-remained-undetected-for-20-years-973e89fc212',`2').
The bug itself not in binary search algorithm, but in calculating arithmetic mean:</p>

_PRE_BEGIN
def func(a,b):
    return (a+b)/2
_PRE_END

_PRE_BEGIN
a32=0x1 or 1
b32=0x7fffffff or 2147483647
out32=0xc0000000 or -1073741824
out32_extended=0xffffffffc0000000 or -1073741824
a64=0x1 or 1
b64=0x7fffffff or 2147483647
out64=0x40000000 or 1073741824
_PRE_END

<p>We can fix this function using a seemingly esoteric Dietz formula, used to do the same, but without integer overflow:</p>

_PRE_BEGIN
def func(a,b):
    return ((a^b)>>1) + (a&b)
_PRE_END

<p>( Its internal workings is described in my _HTML_LINK_AS_IS(`https://yurichev.com/writings/SAT_SMT_by_example.pdf') )</p>

<p>Z3 gives unsat for this function, it can't find counterexample.</p>

_HL2(`Allocate memory for some chunks')

<p>Let's return to the allocate_data_for_some_chunks() function at the beginning of this post.</p>

_PRE_BEGIN
m4_include(`blog/int_over/2.py')
_PRE_END

<p>For which "a" values the expression a*1024 will fail?
This is a smallest "a" input:</p>

_PRE_BEGIN
a32=0x200000 or 2097152
out32=0x80000000 or -2147483648
out32_extended=0xffffffff80000000 or -2147483648
a64=0x200000 or 2097152
out64=0x80000000 or 2147483648
_PRE_END

<p>OK, let's pretend we inserted a "assert (a<100)" before malloc:</p>

_PRE_BEGIN
s.add(a32<100)
_PRE_END

_PRE_BEGIN
a32=0x80000000 or -2147483648
out32=0x0 or 0
out32_extended=0x0 or 0
a64=0xffffffff80000000 or -2147483648
out64=0xfffffe0000000000 or -2199023255552
_PRE_END

<p>Still, an attacker can pass negative a=-2147483648, and malloc() will fail.</p>

<p>Let's pretend, we added a "assert (a>0)" before calling malloc():</p>

_PRE_BEGIN
s.add(a32>0)
_PRE_END

<p>Now Z3 can't find any counterexample.</p>

<p>Some people say, you should use functions like reallocarray() to be protected from integer overflows:
_HTML_LINK_AS_IS(`http://lteo.net/blog/2014/10/28/reallocarray-in-openbsd-integer-overflow-detection-for-free/').</p>

_HL2(`abs()')

<p>Also seemingly innocent function:</p>

_PRE_BEGIN
def func(a):
    return If(a<0, -a, a)
_PRE_END

_PRE_BEGIN
a32=0x80000000 or -2147483648
out32=0x80000000 or -2147483648
out32_extended=0xffffffff80000000 or -2147483648
a64=0xffffffff80000000 or -2147483648
out64=0x80000000 or 2147483648
_PRE_END

<p>This is an artifact of two's complement system.
This is INT_MIN, and -INT_MIN == INT_MIN.
It can lead to nasty bugs, and classic one is in naive implementations of itoa() or printf().</p>

<p>Suppose, you print a signed value.
And you write something like:</p>

_PRE_BEGIN
if (input<0)
{
	input=-input;
	printf ("-"); // print leading minus
};

// print digits in (positive) input:
...
_PRE_END

<p>If INT_MIN (0x80000000) is passed, minus sign is printed, but the "input" variable still contain negative value.
An additional check for INT_MIN is to be added to fix this.</p>

<p>This is also called "undefined behaviour" in C.
The problem is that C language itself is old enough to be a witness of "old iron" -- computers which could
represent signed numbers in other ways than two's complement representation:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Signed_number_representations').</p>

<p>For this reason, C standard doesn't guarantee that -1 will be 0xffffffff (all bits set) on 32-bit registers.
However, almost all hardware you can currently use and buy uses two's complement.</p>

<p>More about the abs() problem:</p>

_PRE_BEGIN
This can become a security issue. I have seen one instance in the vasprintf implementation of libiberty,
which is part of gcc, binutils and some other GNU software. vasprintf walks over the format string and 
tries to estimate how much space it will need to hold the formatted result string. In format strings, 
there is a construct %.*s or %*s, which means that the actual value should be taken from the stack. 
The libiberty code did it like this:

          if (*p == '*')
            {
              ++p;
              total_width += abs (va_arg (ap, int));
            }

This is actually two issues in one. The first issue is that total_width can overflow. The second issue 
is the one that is interesting in this context: abs can return a negative number, causing the code 
to allocate not enough space and thus cause a buffer overflow. 
_PRE_END

<p>( _HTML_LINK_AS_IS(`http://www.fefe.de/intof.html') )</p>

_HL2(`Games')

<p>A lot of video games are prone to integer overflow.
Which are exploited actively by gamers.
As of NetHack:
_HTML_LINK_AS_IS(`https://nethackwiki.com/wiki/Integer_overflow'),
_HTML_LINK_AS_IS(`https://nethackwiki.com/wiki/Negative_gold').</p>

_HL2(`Summary')

<p>What we did here, is we checked, if a result of an expression can fit in 32-bit register.
Probably, you can use a narrower second "ALU", than a 64-bit one.</p>

_HL2(`Further work')

<p>If you want to catch overflows on unsigned variables, use unsigned Z3 operations instead of signed, and do zero extend instead of sign extend.</p>

_HL2(`Further reading')

<p>_HTML_LINK(`https://www.cs.utah.edu/~regehr/papers/tosem15.pdf',`Understanding Integer Overflow in C/C++').</p>

<p>_HTML_LINK(`https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/z3prefix.pdf',`Modular Bug-finding for Integer Overflows in the Large: Sound, Efficient, Bit-precise Static Analysis').</p>

<p>_HTML_LINK(`http://fmv.jku.at/c32sat/',`C32SAT').</p>

<p>My other examples: _HTML_LINK(`https://yurichev.com/writings/SAT_SMT_by_example.pdf',`SAT/SMT by Example').</p>

_BLOG_FOOTER()

