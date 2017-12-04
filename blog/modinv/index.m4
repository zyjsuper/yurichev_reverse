m4_include(`commons.m4')

_HEADER_HL1(`Yet another explanation of modulo inverse')

<p>Let's imagine, we work on 4-bit CPU, it has 4-bit registers, each can hold a value in 0..15 range.</p>

<p>Now we want to divide by 3 using multiplication.
Let's find modulo inverse of 3 using Wolfram Mathematica:</p>

_PRE_BEGIN
In[]:= PowerMod[3, -1, 16]
Out[]= 11
_PRE_END

<p>This is in fact solution of a $3m=16k+1$ equation ($16 = 2^4$):</p>

_PRE_BEGIN
In[]:= FindInstance[3 m == 16 k + 1, {m, k}, Integers]
Out[]= {{m -> 11, k -> 2}}
_PRE_END

<p>The "magic number" for division by 3 is 11. Multiply by 11 instead of dividing by 3 and you'll get a result (quotient).</p>

<p>This works, let's divide 6 by 3. We can now do this by multiplying 6 by 11, this is 66=0x42, but on 4-bit register, only 0x2 will be left in register ($0x42 \equiv 2 \mod 2^4$).
Yes, 2 is correct answer, 6/3=2.</p>

<p>Let's divide 3, 6 and 9 by 3, by multiplying by 11 (m).</p>

_PRE_BEGIN
           |123456789abcdef0|123456789abcdef0|123456789abcdef0|123456789abcdef0|123456789abcdef0|123456789abcdef0|123456789abcdef0|
    m=11   |***********     |                |                |                |                |                |                |
3/3 3m=33  |****************|****************|*               |                |                |                |                |
6/3 6m=66  |****************|****************|****************|****************|**              |                |                |
9/3 9m=99  |****************|****************|****************|****************|****************|****************|***             |
_PRE_END

<p>A "protruding" asterisk(s) (*) in the last non-empty chunk is what will be left in 4-bit register.
This is 1 in case of 33, 2 if 66, 3 if 99.</p>

<p>In fact, this "protrusion" is defined by 1 in the equation we've solved.
Let's replace 1 with 2:</p>

_PRE_BEGIN
In[]:= FindInstance[3 m == 16 k + 2, {m, k}, Integers]
Out[]= {{m -> 6, k -> 1}}
_PRE_END

<p>Now the new "magic number" is 6.
Let's divide 3 by 3. 3*6=18=0x12, 2 will be left in 4-bit register. This is incorrect, we have 2 instead of 1. 2 asterisks are "protruding".
Let's divide 6 by 3. 6*6=36=0x24, 4 will be left in the register. This is also incorrect, we now have 4 "protruding" asterisks instead of correct 2.</p>

<p>Replace 1 in the equation by 0, and nothing will "protrude".</p>

<p>Now the problem: this only works for dividends in 3x form, i.e., which can be divided by 3 with no remainder.
Try to divide 4 by 3, 4*11=44=0x2c, 12 will be left in register, this is incorrect.
The correct quotient is 1.</p>

<p>We can also notice that the 4-bit register is "overflown" during multiplication twice as much as in "incorrect" result in low 4 bits.</p>

<p>Here is what we can do: use only high 4 bits and drop low 4 bits.
4*11=0x2c and 2 is high 4 bits.
Divide 2 by 2, this is 1.</p>

<p>Let's "divide" 8 by 3. 8*11=88=0x58. 5/2=2, this is correct answer again.</p>

<p>Now this is the formula we can use on our 4-bit CPU to divide numbers by 3: "x*3 >> 4 / 2" or "x*3 >> 5".
This is the same as almost all modern compilers do instead of integer division, but they do this for 32-bit and 64-bit registers.</p>

_BLOG_FOOTER()

