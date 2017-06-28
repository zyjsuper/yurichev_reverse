m4_include(`commons.m4')

_HEADER_HL1(`Simplifying long and messy expressions using Mathematica and Z3')

<p>... which can be results of Hex-Rays and/or manual rewriting.</p>

<p>I've added to my RE4B book about Wolfram Mathematica capabilities to minimize expressions:
_HTML_LINK_AS_IS(`https://github.com/dennis714/RE-for-beginners/blob/cd85356051937e87f90967cc272248084808223b/other/hexrays_EN.tex#L412').</p>

<p>Today I stumbled upon that Hex-Rays output:</p>

_PRE_BEGIN
if ( ( x != 7 || y!=0 ) && (x < 6 || x > 7) )
{
	...
};
_PRE_END

<p>Both Mathematica and Z3 (using "simplify" command) can't make it shorter, but I've got gut feeling, that it's somewhat redundant.</p>

<p>Let's take a look at the right part of the expression. If $x$ must be less than 6 OR greater than 7, that it can hold any value except 6 AND 7, right?
So I can rewrite this manually:</p>

_PRE_BEGIN
if ( ( x != 7 || y!=0 ) && x != 6 && x != 7) )
{
	...
};
_PRE_END

<p>This is what Mathematica can simplify:</p>

_PRE_BEGIN
In[]:= BooleanMinimize[(x != 7 || y != 0) && (x != 6 && x != 7)]
Out[]:= x != 6 && x != 7
_PRE_END

<p>But am I really right?
And why Mathematica and Z3 didn't simplify this at first place?</p>

<p>I can use Z3 to prove that these expressions are equal to each other:</p>

_PRE_BEGIN
#!/usr/bin/env python

from z3 import *

x=Int('x')
y=Int('y')

s=Solver()

exp1=And(Or(x!=7, y!=0), Or(x<6, x>7))
exp2=And(x!=6, x!=7)

s.add(exp1!=exp2)

print simplify(exp1) # no luck

print s.check()
print s.model()
_PRE_END

<p>Z3 can't find counterexample, so it says "unsat", meaning, these expressions are equal to each other.
So I've rewritten this expression in my code, tests has been passed, etc.</p>

<p>Yes, using both Mathematica and Z3 is overkill, and this is basic boolean algebra, but after ~10 hours of sitting at a computer you can make really dumb mistakes,
and additional proof your piece of code is correct never unwanted.</p>

<p>My other notes about SAT/SMT: _HTML_LINK_AS_IS(`https://yurichev.com/writings/SAT_SMT_draft-EN.pdf').</p>

_BLOG_FOOTER()

