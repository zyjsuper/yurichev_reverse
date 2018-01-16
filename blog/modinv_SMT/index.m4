m4_include(`commons.m4')

_HEADER_HL1(`Yet another explanation of modulo inverse using SMT-solvers')

<p>By which constant we must multiply couple of random numbers, so that the result would be as if we divided them by 3?

_PRE_BEGIN
from z3 import *

m=BitVec('m', 32)

s=Solver()

# wouldn't work for 10, etc
divisor=3

# two random constants, must be divisible by divisor:
const1=(0x1234567*divisor)
const2=(0xabcdef0*divisor)

s.add(const1*m == const1/divisor)
s.add(const2*m == const2/divisor)

print s.check()
print "%x" % s.model()[m].as_long()
_PRE_END

<p>The magic number is:</p>

_PRE_BEGIN
sat
aaaaaaab
_PRE_END

<p>Indeed, this is modulo inverse of 3 modulo $2^{32}$: _HTML_LINK_AS_IS(`https://www.wolframalpha.com/input/?i=PowerMod%5B3,-1,2%5E32%5D').</p>

<p>Let's check using my calculator:</p>

_PRE_BEGIN
[3] 123456*0xaaaaaaab
[3] (unsigned) 353492988371136 0x141800000a0c0 0b1010000011000000000000000000000001010000011000000
[4] 123456/3
[4] (unsigned) 41152 0xa0c0 0b1010000011000000
_PRE_END

<p>The task is simple enough _HTML_LINK(`https://github.com/DennisYurichev/MK85/blob/master/tests/modinv.smt',`to be solved using my tow-level SMT-solver').</p>

<p>It wouldn't work for 10, because there are no modulo inverse of 10 modulo $2^{32}$, SMT solver would give "unsat".</p>

<p>Why random constants must be divisible by divisor? See: _HTML_LINK_AS_IS(`https://yurichev.com/blog/modinv/').</p>

_FOOTER()

