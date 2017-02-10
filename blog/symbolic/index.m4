m4_include(`commons.m4')

_HEADER_HL1(`9-Feb-2017: Symbolic execution')

<p>
The following blog post will be part of bigger article.
Meanwhile, readers are highly advised to read short introduction into symbolic mathematics:
_HTML_LINK_AS_IS(`https://github.com/dennis714/SAT_SMT_article/blob/89c46ca2d9040dd46b309043f4937b8e1d49c8ed/symbolic/main.tex').</p>

_HL2(`XOR swap')

<p>There is a well-known counterintuitive algorithm for swapping two variables using XOR operation without any additional
memory/register:</p>

_PRE_BEGIN
X=X^Y
Y=Y^X
X=X^Y
_PRE_END

<p>How it works?
It would be better to construct an expression at each step of execution.</p>

_PRE_BEGIN
m4_include(`blog/symbolic/1_XOR/xor_swap.py')
_PRE_END

<p>It would work, because Python dynamicaly typed language, so the function doesn't care what to operate on,
numerical values, or Expr() class.</p>

<p>Here is result:</p>

_PRE_BEGIN
new_X ((X^Y)^(Y^(X^Y)))
new_Y (Y^(X^Y))
_PRE_END

<p>
You can remove double variables in your mind (since XORing by a value twice will result in nothing).
At new_X we can drop two X-es and two Y-es, and single Y will left.
At new_Y we can drop two Y-es, and single X will left.
</p>

_HL2(`Change endianness')

<p>What does this code do?</p>

_PRE_BEGIN
mov     eax, ecx
mov     edx, ecx
shl     edx, 16
and     eax, 0000ff00H
or      eax, edx
mov     edx, ecx
and     edx, 00ff0000H
shr     ecx, 16
or      edx, ecx
shl     eax, 8
shr     edx, 8
or      eax, edx
_PRE_END

<p>In fact, many reverse engineers play shell game a lot, keeping track of is stored where, at each point of time.</p>

<img src="https://yurichev.com/blog/symbolic/2_assembly/718px-Conjurer_Bosch.jpg">

<p>( Hieronymus Bosch -- The Conjurer )</p>

<p>Again, we can build equivalent function which can take both numerical variables and Expr() objects.
We also extend Expr() class to support many arithmetical and boolean operations.
Also, Expr() methods would take both Expr() objects on input and integer values.</p>

_PRE_BEGIN
m4_include(`blog/symbolic/2_assembly/1.py')
_PRE_END

<p>I run it:</p>

_PRE_BEGIN
((((initial_ECX&65280)|(initial_ECX<<16))<<8)|(((initial_ECX&16711680)|(initial_ECX>>16))>>8))
_PRE_END

<p>Now this is something more readable, however, a bit LISPy at first sight.
In fact, this is a function which change endianness in 32-bit word.</p>

<p>By the way, my Toy Decompiler can do this job as well, but operates on AST (Abstract Syntax Trees) instead
of plain strings: _HTML_LINK_AS_IS(`https://yurichev.com/writings/toy_decompiler.pdf').</p>

_HL2(`Fast Fourier transform')

<p>I've found one of the smallest possible FFT implementations on _HTML_LINK(`https://www.reddit.com/r/Python/comments/1la4jp/understanding_the_fft_algorithm_with_python/',`reddit'):

_PRE_BEGIN
m4_include(`blog/symbolic/3_FFT/FFT.py')
_PRE_END

<p>Just interesting, what value has each element on output?</p>

_PRE_BEGIN
m4_include(`blog/symbolic/3_FFT/FFT_symb.py')
_PRE_END

<p>FFT() function left almost intact, the only thing I added: complex value is converted into string and then
Expr() object is constructed.</p>

_PRE_BEGIN
m4_include(`blog/symbolic/3_FFT/res1.txt')
_PRE_END

<p>We can see subexpressions in form like $x^0$ and $x^1$.
We can eliminate them, since $x^0=1$ and $x^1=x$.
Also, we can reduce subexpressions like $x \cdot 1$ to just $x$.
</p>

_PRE_BEGIN
    def __mul__(self, other):
        op1=self.s
        op2=self.convert_to_Expr_if_int(other).s

        if op1=="1":
            return Expr(op2)
        if op2=="1":
            return Expr(op1)

        return Expr("(" + op1 + "*" + op2 + ")")

    def __pow__(self, other):
        op2=self.convert_to_Expr_if_int(other).s
        if op2=="0":
            return Expr("1")
        if op2=="1":
            return Expr(self.s)

        return Expr("(" + self.s + "**" + op2 + ")")
_PRE_END

_PRE_BEGIN
m4_include(`blog/symbolic/3_FFT/res2.txt')
_PRE_END

_HL2(`Cyclic redundancy check')

<p>I've always been wondering, which input bit affects which bit in the final CRC32 value.</p>

<p>From CRC theory (good and concise introduction: _HTML_LINK_AS_IS(`http://web.archive.org/web/20161220015646/http://www.hackersdelight.org/crc.pdf')) we know that
CRC is shifting register with taps.</p>

<p>We will track each bit rather than byte or word, which is highly inefficient, but serves our purpose better:</p>

_PRE_BEGIN
m4_include(`blog/symbolic/4_CRC/1.py')
_PRE_END

<p>Here are expressions for each CRC32 bit for 1-byte buffer:</p>

_PRE_BEGIN
m4_include(`blog/symbolic/4_CRC/1byte.txt')
_PRE_END

<p>For larger buffer, expressions gets increasing exponentially.
This is 0th bit of the final state for 4-byte buffer:</p>

_PRE_BEGIN
state 0=((((((((((((((in_0_0^1)^(in_0_1^1))^(in_0_2^1))^(in_0_4^1))^(in_0_5^1))^(in_0_7^(1^(in_0_1^1))))^(in_1_0^(1^(in_0_2^1))))^
(in_1_2^(((1^(in_0_0^1))^(in_0_1^1))^(in_0_4^1))))^(in_1_3^(((1^(in_0_1^1))^(in_0_2^1))^(in_0_5^1))))^(in_1_4^(((1^(in_0_2^1))^
(in_0_3^1))^(in_0_6^(1^(in_0_0^1))))))^(in_2_0^((((1^(in_0_0^1))^(in_0_6^(1^(in_0_0^1))))^(in_0_7^(1^(in_0_1^1))))^(in_1_2^(((1^
(in_0_0^1))^(in_0_1^1))^(in_0_4^1))))))^(in_2_6^(((((((1^(in_0_0^1))^(in_0_1^1))^(in_0_2^1))^(in_0_6^(1^(in_0_0^1))))^(in_1_4^(((1^
(in_0_2^1))^(in_0_3^1))^(in_0_6^(1^(in_0_0^1))))))^(in_1_5^(((1^(in_0_3^1))^(in_0_4^1))^(in_0_7^(1^(in_0_1^1))))))^(in_2_0^((((1^
(in_0_0^1))^(in_0_6^(1^(in_0_0^1))))^(in_0_7^(1^(in_0_1^1))))^(in_1_2^(((1^(in_0_0^1))^(in_0_1^1))^(in_0_4^1))))))))^(in_2_7^(((((((1^
(in_0_1^1))^(in_0_2^1))^(in_0_3^1))^(in_0_7^(1^(in_0_1^1))))^(in_1_5^(((1^(in_0_3^1))^(in_0_4^1))^(in_0_7^(1^(in_0_1^1))))))^(in_1_6^
(((1^(in_0_4^1))^(in_0_5^1))^(in_1_0^(1^(in_0_2^1))))))^(in_2_1^((((1^(in_0_1^1))^(in_0_7^(1^(in_0_1^1))))^(in_1_0^(1^(in_0_2^1))))^
(in_1_3^(((1^(in_0_1^1))^(in_0_2^1))^(in_0_5^1))))))))^(in_3_2^(((((((((1^(in_0_1^1))^(in_0_2^1))^(in_0_4^1))^(in_0_5^1))^(in_0_6^(1^
(in_0_0^1))))^(in_1_2^(((1^(in_0_0^1))^(in_0_1^1))^(in_0_4^1))))^(in_2_0^((((1^(in_0_0^1))^(in_0_6^(1^(in_0_0^1))))^(in_0_7^(1^(in_0_1^
1))))^(in_1_2^(((1^(in_0_0^1))^(in_0_1^1))^(in_0_4^1))))))^(in_2_1^((((1^(in_0_1^1))^(in_0_7^(1^(in_0_1^1))))^(in_1_0^(1^(in_0_2^1))))^
(in_1_3^(((1^(in_0_1^1))^(in_0_2^1))^(in_0_5^1))))))^(in_2_4^(((((1^(in_0_0^1))^(in_0_4^1))^(in_1_2^(((1^(in_0_0^1))^(in_0_1^1))^(in_0_4^
1))))^(in_1_3^(((1^(in_0_1^1))^(in_0_2^1))^(in_0_5^1))))^(in_1_6^(((1^(in_0_4^1))^(in_0_5^1))^(in_1_0^(1^(in_0_2^1))))))))))
_PRE_END

<p>Expression for the 0th bit of the final state for 8-byte buffer has length of ~350KiB, which is, of course, can be reduced
significantly (because this expression is basically XOR tree), but you can feel the weight of it.</p>

<p>Now we can process this expressions somehow to get a smaller picture on what is affecting what.
Let's say, if we can find "in_2_3" substring in expression, this means that 3rd bit of 2nd byte of input
affects this expression.
But even more than that: since this is XOR tree (i.e., expression consisting only of XOR operations),
if some input variable is occurring twice, it's annihilated, since $x \oplus x=0$.
More than that: if some vairables occurred even number of times (2, 4, 8, etc), it's annihilated, but left if it's occurred
odd number of times (1, 3, 5, etc).
</p>

_PRE_BEGIN
    for i in range(32):
        #print "state %d=%s" % (i, state[31-i])
        sys.stdout.write ("state %02d: " % i)
        for byte in range(BYTES):
            for bit in range(8):
                s="in_%d_%d" % (byte, bit)
                if str(state[31-i]).count(s) & 1:
                    sys.stdout.write ("*")
                else:
                    sys.stdout.write (" ")
        sys.stdout.write ("\n")
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/symbolic/4_CRC/2.py') )</p>

<p>Now this how each input bit of 1-byte input buffer affects each bit of the final CRC state:<p>

_PRE_BEGIN
m4_include(`blog/symbolic/4_CRC/1byte_tbl.txt')
_PRE_END

<p>This is 8*8=64 bits of 8-byte input buffer:</p>

_PRE_BEGIN
m4_include(`blog/symbolic/4_CRC/8byte_tbl.txt')
_PRE_END

_HL2(`Linear congruential generator')

<p>This is popular PRNG from OpenWatcom CRT library: _HTML_LINK_AS_IS(`https://github.com/open-watcom/open-watcom-v2/blob/d468b609ba6ca61eeddad80dd2485e3256fc5261/bld/clib/math/c/rand.c').</p>

<p>What expression it generates on each step?</p>

_PRE_BEGIN
m4_include(`blog/symbolic/5_LCG/LCG.py')
_PRE_END

_PRE_BEGIN
m4_include(`blog/symbolic/5_LCG/1.txt')
_PRE_END

<p>Now if we once got several values from this PRNG, like 4583, 16304, 14440, 32315, 28670, 12568..., how would we
deduce initial seed?
The problem in fact is solving a system of equations:</p>

_PRE_BEGIN
((((initial_seed*1103515245)+12345)>>16)&32767)==4583
((((((initial_seed*1103515245)+12345)*1103515245)+12345)>>16)&32767)==16304
((((((((initial_seed*1103515245)+12345)*1103515245)+12345)*1103515245)+12345)>>16)&32767)==14440
((((((((((initial_seed*1103515245)+12345)*1103515245)+12345)*1103515245)+12345)*1103515245)+12345)>>16)&32767)==32315
_PRE_END

<p>As it turns out, Z3 can solve this system correctly using only two equations:</p>

_PRE_BEGIN
m4_include(`blog/symbolic/5_LCG/Z3_solve.py')
_PRE_END

_PRE_BEGIN
[x = 11223344]
_PRE_END

<p>(Though, it takes ~20s on my ancient Intel Atom netbook.)</p>

_HL2(`Path constraint')

<p>How to get weekday from UNIX timestamp?</p>

_PRE_BEGIN
#!/usr/bin/env python

input=...
SECS_DAY=24*60*60
dayno = input / SECS_DAY
wday = (dayno + 4) % 7
if wday==5:
    print "Thanks God, it's Friday!"
_PRE_END

<p>Let's say, we should find a way to run the block with print() call in it.
What input value should be?</p>

<p>First, let's build expression of $wday$ variable:</p>

_PRE_BEGIN
m4_include(`blog/symbolic/6_TGIF/TGIF.py')
_PRE_END

_PRE_BEGIN
(((input/86400)+4)%7)
_PRE_END

<p>In order to execute the block, we should solve this equation: (((input/86400)+4)%7)==5</p>

<p>So far, this is easy task for Z3:</p>

_PRE_BEGIN
m4_include(`blog/symbolic/6_TGIF/Z3_solve.py')
_PRE_END

_PRE_BEGIN
[x = 86438]
_PRE_END

<p>This is indeed correct UNIX timestamp for Friday:</p>

_PRE_BEGIN
% date --date='@86438'
Fri Jan  2 03:00:38 MSK 1970
_PRE_END

<p>Though the date back in year 1970, but it's still correct!</p>

<p>This is also called "path constraint", i.e., what constraint must be satisified to execute the path into
specific block?
Several tools has "path" in their names, like "pathgrind", etc.</p>

<p>Like the shell game, this task is also often encounters in practice.
You can see that something dangerous can be executed inside some basic block and you're trying to deduce,
what input values can cause execution of it.
It may be buffer overflow, etc.
Input values are sometimes also called "inputs of death".</p>

<p>Many crackmes are solved in this way, all you need is find a path into block which prints "key is correct"
or something like that.</p>

<p>KLEE (or similar tool) tries to find path to each basic block and produces "ideal" unit test.
Hence, KLEE can find a path into the block which crashes everything, or reporting about correctness of the input
key/license, etc.
Surprisingly, KLEE can find backdoors in the very same manner.</p>

<p>KLEE is also called "KLEE Symbolic Virtual Machine" -- by that its creators mean that the KLEE is VM which executes a code symbolically rather than numerically.<p>

_HL2(`Division by zero')

<p>If division by zero is unwrapped and exception isn't caught, it can crash process.</p>

<p>Let's calculate simple expression $\frac{x}{2y + 4z - 12}$.
We can add a warning into __div__ method:</p>

_PRE_BEGIN
m4_include(`blog/symbolic/7_div/1.py')
_PRE_END

<p>... so it will report about dangerous condition:</p>

_PRE_BEGIN
warning: division by zero if (((y*2)+(z*4))-12)==0
(x/(((y*2)+(z*4))-12))
_PRE_END

<p>This equation is easy to solve, let's try Wolfram Mathematica this time:</p>

_PRE_BEGIN
In[]:= FindInstance[{(y*2 + z*4) - 12 == 0}, {y, z}, Integers]
Out[]= {{y -> 0, z -> 3}}
_PRE_END

<p>These values for $y$ and $z$ can also be called "inputs of death".</p>

_HL2(`Merge sort')

<p>How merge sort works?
I have copypasted Python code from rosettacode.com intact:</p>

_PRE_BEGIN
m4_include(`blog/symbolic/8_sorting/1.py')
_PRE_END

<p>But here is a function which compares elements.
Obviously, it wouldn't work correctly without it.</p>

<p>So we can track both expression for each element and numerical value.
Both will be printed finally.
But whenever values are to be compared, only numerical parts will be used.</p>

<p>Result:</p>

_PRE_BEGIN
m4_include(`blog/symbolic/8_sorting/result.txt')
_PRE_END

_HL2(`Conclusion')

<p>For the sake of demonstration, I made things as simple as possible.
But reality is always much harsher, so all this shouldn't be taken as a silver bullet.</p>

<p>More Z3 and KLEE examples: _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf').</p>

<p>The files used in this blog post: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/symbolic').</p>

<p>As you noticed in my simple examples, expression is represented as a plain string, for the sake of simplicity.
Advanced symbolic execution engines uses AST (Abstract Syntax Trees), which are much better and efficient.
AST in its simplest form is used in my toy decompiler: _HTML_LINK_AS_IS(`https://yurichev.com/writings/toy_decompiler.pdf').
The toy decompiler can be used as simple symbolic engine as well, just feed all the instructions to it and it will track contents of each register.</p>

_BLOG_FOOTER()

