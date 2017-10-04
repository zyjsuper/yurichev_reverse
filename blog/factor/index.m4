m4_include(`commons.m4')

_HEADER_HL1(`Integer factorization using Z3 SMT solver')

<p>(The following text has been moved to the article at _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf').)</p>

<p>Integer factorization is method of breaking a composite (non-prime number) into prime factors.
Like 12345 = 3*4*823.
</p>

<p>Though for small numbers, this task can be accomplished by Z3:</p>

_PRE_BEGIN
#!/usr/bin/env python

# note: there is no primality test at all, no lookup tables, etc

import random
from z3 import *
from operator import mul

def factor(n):
    print "factoring",n

    in1,in2,out=Ints('in1 in2 out')

    s=Solver()
    s.add(out==n)
    s.add(in1*in2==out)
    # inputs cannot be negative and must be non-1:
    s.add(in1>1)
    s.add(in2>1)

    if s.check()==unsat:
        print n,"is prime (unsat)"
        return [n]
    if s.check()==unknown:
        print n,"is probably prime (unknown)"
        return [n]

    m=s.model()
    # get inputs of multiplier:
    in1_n=m[in1].as_long()
    in2_n=m[in2].as_long()

    print "factors of", n, "are", in1_n, "and", in2_n
    # factor factors recursively:
    rt=sorted(factor (in1_n) + factor (in2_n))
    # self-test:
    assert reduce(mul, rt, 1)==n
    return rt

# infinite test:
def test():
    while True:
        print factor (random.randrange(1000000000))

#test()

# tested by Mathematica:
#print factor(123456) # {{2, 6}, {3, 1}, {643, 1}} 
#print factor(256)
#print factor(999999) # {{3, 3}, {7, 1}, {11, 1}, {13, 1}, {37, 1}}
print factor(1234567890) # {{2, 1}, {3, 2}, {5, 1}, {3607, 1}, {3803, 1}}
#print factor(10000) # {{2, 4}, {5, 4}}
#print factor(123456789012345)
#print factor(3*7*11*17*23*29*31*37*41)
#print factor(1234567890123)
#print factor(2147713027)
#print factor(137446031423)
_PRE_END

<p>( The source code: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/factor/factor_z3.py') )</p>

<p>When factoring 1234567890 recursively:</p>

_PRE_BEGIN
% time python z.py
factoring 1234567890
factors of 1234567890 are 342270 and 3607
factoring 342270
factors of 342270 are 2 and 171135
factoring 2
2 is prime (unsat)
factoring 171135
factors of 171135 are 3803 and 45
factoring 3803
3803 is prime (unsat)
factoring 45
factors of 45 are 3 and 15
factoring 3
3 is prime (unsat)
factoring 15
factors of 15 are 5 and 3
factoring 5
5 is prime (unsat)
factoring 3
3 is prime (unsat)
factoring 3607
3607 is prime (unsat)
[2, 3, 3, 5, 3607, 3803]
python z.py  19.30s user 0.02s system 99% cpu 19.443 total
_PRE_END

<p>So, 1234567890 = 2*3*3*5*3607*3803.</p>

<p>One important note: there is no primality test, no lookup tables, etc.
Prime number is a number for which "x*y=prime" (where x>1 and y>1) diophantine equation (which allows only integers in solution) has no solutions.
It can be solved for real numbers, though.</p>

<p>Z3 is _HTML_LINK(`https://github.com/Z3Prover/z3/issues/1264',`not yet good enough for non-linear integer arithmetic') and sometimes returns "unknown" instead of "unsat", but,
as Leonardo de Moura (one of Z3's author) commented about this:</p>

_PRE_BEGIN
...Z3 will solve the problem as a real problem. If no real solution is found, we know there is no integer solution.
If a solution is found, Z3 will check if the solution is really assigning integer values to integer variables.
If that is not the case, it will return unknown to indicate it failed to solve the problem.
_PRE_END
( _HTML_LINK_AS_IS(`https://stackoverflow.com/questions/13898175/how-does-z3-handle-non-linear-integer-arithmetic') )

<p>Probably, this is the case: we getting "unknown" in the case when a number cannot be factored, i.e., it's prime.</p>

<p>It's also very slow. Wolfram Mathematica can factor number around 2^80 in a matter of seconds.
Still, I've written this for demonstration.</p>

<p>The problem of breaking RSA is a problem of factorization of very large numbers, up to 2^4096.
It's currently not possible to do this in practice.</p>

<p>Next part: _HTML_LINK(`https://yurichev.com/blog/factor_SAT/',`Integer factorization using SAT solver').</p>

_BLOG_FOOTER()

