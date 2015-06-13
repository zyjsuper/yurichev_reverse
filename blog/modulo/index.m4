m4_include(`commons.m4')

_HEADER_HL1(`13-Jun-2015: Modular arithmetic + division by multiplication + reversible LCG (PRNG) + cracking LCG with Z3.')

<p>Many practicing reverse engineerings are fully aware that division operation is sometimes replaced by multiplication.</p>

<p>Here is an example:</p>

<pre>
#include &lt;stdint.h&gt;

uint32_t divide_by_9 (uint32_t a)
{
        return a/9;
};

Optimizing GCC 4.8.2 does this:

divide_by_9:
        mov     edx, 954437177
        mov     eax, edx
        mul     DWORD PTR [esp+4]
        shr     edx
        mov     eax, edx
        ret
</pre>

<p>The following code can be rewritten into C/C++:</p>

<pre>
#include &lt;stdint.h&gt;

uint32_t divide_by_9_v2 (uint32_t a)
{
        return ((uint64_t)a * (uint64_t)954437177)) >> 33; // 954437177 = 0x38e38e39
};
</pre>

<p>And it works: you can compile it and check it.
Let's see, how.</p>

_HL2(`Quick introduction into modular arithmetic')

<p>Modular arithmetic is an environment where all values are limited by some number (modulo).
Many textbooks has clock as example. Let's imagine old mechanical analog clock.
There hour hand points to one of number in bounds of 0..11 (zero is usually shown as 12).
What hour will be if to sum up 10 hours (no matter, AM or PM) and 4 hours?
10+4 is 14 or 2 by modulo 12.
Naively you can just sum up numbers and subtract modulo base (12) as long as it's possible.</p>

<p>Modern digital watch shows time in 24 hours format, so hour there is a variable in modulo base 24.
But minutes and seconds are in modulo 60 (let's forget about leap seconds for now).</p>

<p>Another example is US imperial system of measurement: human height is measured in feets and inches.
There are 12 inches in feet, so when you sum up some lengths, you increase feet variable each time you've got more than 12 inches.</p>

<p>Another example I would recall is password cracking utilities. Often, characters set is defined in such utilities.
And when you set all Latin characters plus numbers, you've got 26+10=36 characters in total.
If you brute-forcing a 6-characters password, you've got 6 variables, each is limited by 36.
And when you increase last variable, it happens in modular arithmetic rules: if you got 36, set last variable to 0 and increase penultimate
one. If it's also 36, do the same. If the very first variable is 36, then stop.
Modular arithmetic may be very helpful when you write multi-threading (or distributed) password cracking utility and you need to slice all passwords space by even
parts.</p>

<p>Now let's recall old mechanical counters which were widespread in pre-digital era:</p>

<center><img src="http://yurichev.com/blog/modulo/counter.jpg" alt="The picture was stolen from http://www.featurepics.com/ - sorry for it!"></center>

<p>This counter has 6 wheels, so it can count from 0 to 10^6-1 or 999999.
When you have 999999 and you increase the counter, it will resetting to 000000 - this situation is usually understood by engineers and computer programmers as overflow.
And if you have 000000 and you decrease it, the counter will show you 999999. This situation is often called "wrap around".
See also: _HTML_LINK_AS_IS(`http://en.wikipedia.org/wiki/Integer_overflow').</p>

_HL2(`Modular arithmetic on CPUs')

<p>The reason I talk about mechanical counter is that CPU registers acting in the very same way, because this is, perhaps, simplest possible and efficient way
to compute using integer numbers.</p>

<p>This implies that almost all operations on integer values on your CPU is happens by modulo 2^32 or 2^64 depending on your CPU.
For example, you can sum up 0x87654321 and 0xDEADBABA, which resulting in 0x16612FDDB. 
This value is too big for 32-bit register, so only 0x6612FDDB is stored, and leading 1 is dropped.
If you will multiply these two numbers, the actual result it 0x75C5B266EDA5BFFA, which is also too big, so only low 32-bit part is stored into destination
register: 0xEDA5BFFA. This is what happens when you multiply numbers in plain C/C++ language, but some readers may argue:
when sum is too big for register, CF (carry flag) is set, and it can be used after.
And there is x86 MUL instruction which in fact produces 64-bit result in 32-bit environment (in EDX:EAX registers pair).
That's true, but observing just 32-bit registers, this is exactly environment of modulo with base 2^32.</p>

<p>Now that leads to surprising consequence: almost every result of arithmetic operation stored in general purpose register of 32-bit CPU is in fact
remainder of division operation: result is always divided by 2^32 and remainder is left in register.
For example, 0x16612FDDB is too large for storage, and it's divided by 2^32 (or 0x100000000).
The result of division (quotient) is 1 (which is dropped) and remainder is 0x6612FDDB (which is stored as a result).
0x75C5B266EDA5BFFA divided by 2^32 (0x100000000) produces 0x75C5B266 as a result of division (quotient) and 0xEDA5BFFA as a remainder, the latter is stored.</p>

<p>And if your code is 32-bit one in 64-bit environment, CPU registers are bigger, so the whole result can be stored there, 
but high half is hidden behind the scenes -- because no 32-bit code can access it.</p>

<p>By the way, this is the reason why remainder calculation is often called "division by modulo".
C/C++ has percent sign (%) for this operation, but some other PLs like Pascal and Haskell has "mod" operator.</p>

<p>Usually, almost all sane computer programmers works with variables as they never wrapping around and value here is always in some limits which 
are defined preliminarily.
However, this implicit division operation or "wrapping around" can be exploited usefully.</p>

_HL2(`Getting random numbers')

<p>When you write some kind of videogame, you need random numbers, and the standard C/C++ rand() function gives you them in 0..0x7FFF range (MSVC)
or in 0..0x7FFFFFFF range (GCC).
And when you need a random number in 0..10 range, the common way to do it is:</p>

<pre>
X_coord_of_something_spawned_somewhere=rand() % 10;
Y_coord_of_something_spawned_somewhere=rand() % 10;
</pre>

<p>No matter what compiler do you use, you can think about it as 10 is subtraced from rand() result, as long as there is still a number bigger than 10.
Hence, result is remainder of division of rand() result by 10.</p>

<p>One nasty consequence is that neither 0x8000 nor 0x80000000 cannot be divided by 10 evenly, so you'll get some numbers slightly more often than others.</p>

_HL2(`Multiplicative inverse')

_HL3(`Finding multiplicative inverse')

<p>From school-level mathematics we may recall there is an easy way to replace multiplication by division.
For example, if you need to divide some number by 3, multiply it by 1/3 (or 0.33333...).
So if you've got a lot of numbers you need to divide by 3, and if multiplication on your FPU works faster than division, you can precompute 1/3 and then 
multiply all numbers by this one.
1/3 is called <i>multiplicative inverse</i> or <i>reciprocal</i>.
Russian textbook also uses more terse <i>inverse number</i> or <i>inverse value</i> term.</p>

<p>But that works for real numbers only. What about integer ones?</p>

_HL3(`Finding modular multiplicative inverse')

<p>First, let's state our task: we need to divide <i>a</i> (unknown at compile time) number by 9.</p>

<p>Our environment has at least these properties:</p>

<ul>
<li> multiplication is fast;
<li> division by 2^32 consumes nothing;
<li> finding remainder of division by 2^32 is also consumes nothing;
<li> division by 2^n is very fast (binary shift right).
</ul>

<p>We can't divide by 9 using bit shifts, but we can divide by 2^32 or by 2^n in general.
What if we would multiply input number to make it much bigger so to compensate difference between 9 and 2^32?
Yes!</p>

<p>Our initial task is:</p>

<pre>
result = input / 9
</pre>

<p>What we can do:</p>

<pre>
result = input * coefficient / 2^32
</pre>

<p><i>coefficient</i> is the solution of this equation:</p>

<pre>
9x = 1+k(2^32).
</pre>

<p>We can solve it in Wolfram Mathematica:</p>

<pre>
In[]= FindInstance[9 x == 1 + k (2^32), {x, k}, Integers]
Out[]= {{x -> 954437177, k -> 2}}
</pre>

<p><i>x</i> (which is modular multiplicative inverse) will be coefficient, <i>k</i> will be another special value, used at the very end.</p>

<p>Let's check it in Mathematica:</p>

<pre>
In[]:= BaseForm[954437177*90, 16]
Out[]//BaseForm= 140000000a
</pre>

<p>(BaseForm is the instruction to print result in hexadecimal form).</p>

<p>There was multiplication, but division by 2^32 or 2^n is not happened yet.
So after division by 2^32, 0x14 will be a result and 0xA is remainder.
0x14 is 20, which twice as large as the result we expect (90/9=10).
It's because k=2, so final result should also be divided by 2.</p>

<p>That is exactly what the code produced by GCC does:</p>

<ul>
<li> input value is multiplicated by 954437177 (x);
<li> then it is divided by 2^32 using quick bit shift right;
<li> final value is divided by 2 (k).
</ul>

<p>Two last steps are coalesced into one SHR instruction, which does shifting by 33 bits.</p>

<p>Let's also check relation between modular multiplicative inverse coefficient we've got and 2^32 (modulo base):</p>

<pre>
In[]:= 954437177 / 2^32 // N
Out[]= 0.222222
</pre>

<p>0.222... is twice as large than 1/9.
So this number acting like a real 1/9 number, but on integer <acronym title="Arithmetic logic unit">ALU</acronym>!</p>

_HL3(`A little more theory')

<p>But why _HTML_LINK(`http://en.wikipedia.org/wiki/Modular_multiplicative_inverse',`Wikipedia article about it') is somewhat harder to grasp?
And why we need additional <i>k</i> coefficient?
The reason of this is because equation we should solve to get coefficients is in fact diophantine equation, that is equation
which allows only integers as it's variables.
Hence you see "Integers" in FindInstance Mathematica command: no real numbers are allowed.
Mathematica wouldn't be able to find <i>x</i> for k=1 (additional bit shift would not need then), but was able to find it for k=2.
Diophantine equation is so important here because we work on integer ALU, after all.</p>

<p>So the coefficient used is in fact modular multiplicative inverse.
And when you see such piece of code in some software, Mathematica can find division number easily, just find modular multiplicative inverse of modular
multiplicative inverse!
It works because x=1/(1/x).</p>

<pre>
In[]:= PowerMod[954437177, -1, 2^32]
Out[]= 9
</pre>

<p>PowerMod command is so called because it computes x^(-1) by given modulo (2^32), which is the same thing.
Other representations of this algorithm are there: _HTML_LINK_AS_IS(`http://rosettacode.org/wiki/Modular_inverse').</p>

_HL3(`Remainder?')

<p>It can be easily observed that no bit shifting need, just multiply number by modular inverse:</p>

<pre>
In[]:= Mod[954437177*18, 2^32]
Out[]= 2
</pre>

<p>The number we've got is in fact remainder of division by 2^32.
It is the same as result we are looking for, because diophantine equation we solved has 1 in "1+k...", this 1 is multiplied by result and it is left
as remainder.</p>

<p>This is somewhat useless, because this calculation is going crazy when we need to divide some number (like 19) by 9 (19/9=2.111...), which should leave remainder (19 % 9 = 1):</p>

<pre>
In[]:= Mod[954437177*19, 2^32]
Out[]= 954437179
</pre>

<p>Perhaps, this can be used to detect situations when remainder is also present?</p>

_HL3(`Always coprimes?')

<p>As it's stated in many textbooks, to find modular multiplicative inverse, modulo base (2^32) and initial value (e.g., 9) 
should be _HTML_LINK(`http://en.wikipedia.org/wiki/Coprime_integers',`coprime') to each other.
9 is coprime to 2^32, so is 7, but not 10.
But if you try to compile x/10 code, GCC can do it as well:</p>

<pre>
push   %ebp
mov    %esp,%ebp
mov    0x8(%ebp),%eax
mov    $0xcccccccd,%edx
mul    %edx
mov    %edx,%eax
shr    $0x3,%eax
pop    %ebp
ret    
</pre>

<p>The reason it works is because division by 5 is actually happens here (and 5 is coprime to 2^32), and then the final result is divided by 2
(so there is 3 instead of 2 in the SHR instruction).</p>

_HL2(`Reversible LCG')

<p><acronym title="Linear congruential generator">LCG</acronym> is very simple: just multiply seed by some value, add another one and here is a new random number.
Here is how it is implemented in MSVC (the source code is not original one and is reconstructed by me):</p>

<pre>
uint32_t state;

uint32_t rand()
{
	state=state*214013+2531011;
	return (state>>16)&0x7FFF;
};
</pre>

<p>The last bit shift is attempt to compensate LCG weakness and we may ignore it so far.
Will it be possible to make an inverse function to rand(), which can reverse state back?
First, let's try to think, what would make this possible? Well, if state internal variable would be some kind of BigInt or BigNum container which can
store infinitely big numbers, then, although state is increasing rapidly, it would be possible to reverse the process.
<i>state</i> isn't BigInt/BigNum, it's 32-bit variable, and summing operation is easily reversible on it (just subtract 2531011 at each step).
As we may know now, multiplication is also reversible: just multiply the state by modular multiplicative inverse of 214013!</p>

<pre>
#include &lt;stdio.h&gt;
#include &lt;stdint.h&gt;

uint32_t state;

void next_state()
{
	state=state*214013+2531011;
};

void prev_state()
{
	state=state-2531011; // reverse summing operation
	state=state*3115528533; // reverse multiply operation. 3115528533 is modular inverse of 214013 in 2^32.
};

int main()
{
	state=12345;
	
	printf ("state=%d\n", state);
	next_state();
	printf ("state=%d\n", state);
	next_state();
	printf ("state=%d\n", state);
	next_state();
	printf ("state=%d\n", state);

	prev_state();
	printf ("state=%d\n", state);
	prev_state();
	printf ("state=%d\n", state);
	prev_state();
	printf ("state=%d\n", state);
};
</pre>

<p>Wow, that works!</p>

<pre>
state=12345
state=-1650445800
state=1255958651
state=-456978094
state=1255958651
state=-1650445800
state=12345
</pre>

<p>It's very hard to find a real-world application of reversible LCG, but it was a spectacular demonstration of modular multiplicative inverse, so I added it.</p>

_HL2(`Cracking LCG with Z3 SMT solver')

<p>There are well-known weaknesses of LCG (
_HTML_LINK(`http://en.wikipedia.org/wiki/Linear_congruential_generator#Advantages_and_disadvantages_of_LCGs',`1'),
_HTML_LINK(`http://www.reteam.org/papers/e59.pdf',`2'),
_HTML_LINK(`http://stackoverflow.com/questions/8569113/why-1103515245-is-used-in-rand/8574774#8574774',`3')
), but let's see, if it would be possible to crack it straightforwardly, without any special knowledge.
We would define all relations between LCG states in term of Z3 SMT solver.
(I first made attempt to do it using _HTML_LINK(`https://reference.wolfram.com/language/ref/FindInstance.html',`FindInstance') in Mathematica, but failed, perhaps, made a mistake somewhere).
Here is a test progam:</p>

<pre>
#include &lt;stdlib.h&gt;
#include &lt;stdio.h&gt;
#include &lt;time.h&gt;

int main()
{
	int i;

	srand(time(NULL));

	for (i=0; i<10; i++)
		printf ("%d\n", rand()%100);
};
</pre>

<p>It is intended to print 10 pseudorandom numbers in 0..99 range.
So it does:</p>

<pre>
37
29
74
95
98
40
23
58
61
17
</pre>

<p>Let's say we are observing only 8 of these numbers (from 29 to 61) and we need to predict next one (17) and/or previous one (37).</p>

<p>The program is compiled using MSVC 2013 (I choose it because its LCG is simpler than that in Glib):</p>

<pre>
.text:0040112E rand            proc near
.text:0040112E                 call    __getptd
.text:00401133                 imul    ecx, [eax+0x14], 214013
.text:0040113A                 add     ecx, 2531011
.text:00401140                 mov     [eax+14h], ecx
.text:00401143                 shr     ecx, 16
.text:00401146                 and     ecx, 7FFFh
.text:0040114C                 mov     eax, ecx
.text:0040114E                 retn
.text:0040114E rand            endp
</pre>

<p>This is very simple LCG, but the result is not clipped state, but it's rather shifted by 16 bits.
Let's define LCG in Z3:</p>

<pre>
#!/usr/bin/python
from z3 import *

output_prev = BitVec('output_prev', 32)
state1 = BitVec('state1', 32)
state2 = BitVec('state2', 32)
state3 = BitVec('state3', 32)
state4 = BitVec('state4', 32)
state5 = BitVec('state5', 32)
state6 = BitVec('state6', 32)
state7 = BitVec('state7', 32)
state8 = BitVec('state8', 32)
state9 = BitVec('state9', 32)
state10 = BitVec('state10', 32)
output_next = BitVec('output_next', 32)

s = Solver()

s.add(state2 == state1*214013+2531011)
s.add(state3 == state2*214013+2531011)
s.add(state4 == state3*214013+2531011)
s.add(state5 == state4*214013+2531011)
s.add(state6 == state5*214013+2531011)
s.add(state7 == state6*214013+2531011)
s.add(state8 == state7*214013+2531011)
s.add(state9 == state8*214013+2531011)
s.add(state10 == state9*214013+2531011)

s.add(output_prev==URem((state1>>16)&0x7FFF,100))
s.add(URem((state2>>16)&0x7FFF,100)==29)
s.add(URem((state3>>16)&0x7FFF,100)==74)
s.add(URem((state4>>16)&0x7FFF,100)==95)
s.add(URem((state5>>16)&0x7FFF,100)==98)
s.add(URem((state6>>16)&0x7FFF,100)==40)
s.add(URem((state7>>16)&0x7FFF,100)==23)
s.add(URem((state8>>16)&0x7FFF,100)==58)
s.add(URem((state9>>16)&0x7FFF,100)==61)
s.add(output_next==URem((state10>>16)&0x7FFF,100))

print(s.check())
print(s.model())
</pre>

<p>URem states for <i>unsigned remainder</i>.
It works for some time and gave us correct result!</p>

<pre>
sat
[state3 = 2276903645,
 state4 = 1467740716,
 state5 = 3163191359,
 state7 = 4108542129,
 state8 = 2839445680,
 state2 = 998088354,
 state6 = 4214551046,
 state1 = 1791599627,
 state9 = 548002995,
 output_next = 17,
 output_prev = 37,
 state10 = 1390515370]
</pre>

<p>That is the reason why LCG is not suitable for any security-related task.
This is why _HTML_LINK(`https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator',`cryptographically secure pseudorandom number generators') are exist: they are designed to be protected against such simple attack.
Well, at least if _HTML_LINK(`https://en.wikipedia.org/wiki/Dual_EC_DRBG',`NSA is not involved').</p>

<p>As far, as I can understand, _HTML_LINK(`http://en.wikipedia.org/wiki/Security_token',`security tokens') like _HTML_LINK(`http://en.wikipedia.org/wiki/RSA_SecurID',`RSA SecurID') can be viewed as just <acronym title="cryptographically secure pseudorandom number generator">CPRNG</acronym> with a secret seed.
It shows new pseudorandom number each minute, and the server can predict it, because it knows the seed.
Imagine if such token would implement LCG -- it would be much easier to break!</p>

_BLOG_FOOTER()
