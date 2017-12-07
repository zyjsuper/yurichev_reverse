m4_include(`commons.m4')

_HEADER_HL1(`Ménage problem')

_PRE_BEGIN
In combinatorial mathematics, the ménage problem or problème des ménages[1] asks for the number of different ways in which
it is possible to seat a set of male-female couples at a dining table so that men and women alternate and nobody sits next 
to his or her partner. This problem was formulated in 1891 by Édouard Lucas and independently, a few years earlier, 
by Peter Guthrie Tait in connection with knot theory.[2] For a number of couples equal to 3, 4, 5, ... 
the number of seating arrangements is

    12, 96, 3120, 115200, 5836320, 382072320, 31488549120, ... (sequence A059375 in the OEIS). 
_PRE_END

<p>( _HTML_LINK(`https://en.wikipedia.org/wiki/M%C3%A9nage_problem',`Wikipedia'). )</p>

<p>We can count it using Z3, but also get actual men/women allocations:</p>

_PRE_BEGIN
from z3 import *

COUPLES=3

# a pair each men and women related to:
men=[Int('men_%d' % i) for i in range(COUPLES)]
women=[Int('women_%d' % i) for i in range(COUPLES)]

# men and women are placed around table like this:

# m m m
#  w w w

# i.e., women[0] is placed between men[0] and men[1]
# the last women[COUPLES-1] is between men[COUPLES-1] and men[0] (wrapping)

s=Solver()
s.add(Distinct(men))
s.add(Distinct(women))

[s.add(And(men[i]>=0, men[i] < COUPLES)) for i in range (COUPLES)]
[s.add(And(women[i]>=0, women[i] < COUPLES)) for i in range (COUPLES)]

# a pair, each woman belong to, cannot be the same as men's located at left and right.
# "% COUPLES" is wrapping, so that the last woman is between the last man and the first man.
for i in range(COUPLES):
    s.add(And(women[i]!=men[i], women[i]!=men[(i+1) % COUPLES]))

def print_model(m):
    print "  men",
    for i in range(COUPLES):
        print m[men[i]],
    print ""

    print "women ",

    for i in range(COUPLES):
        print m[women[i]],
    print ""
    print ""

results=[]

# enumerate all possible solutions:
while True:
    if s.check() == sat:
        m = s.model()
        print_model(m)
        results.append(m)
        block = []
        for d in m:
            c=d()
            block.append(c != m[d])
        s.add(Or(block))
    else:
        print "results total=", len(results)
        print "however, according to https://oeis.org/A059375 :", len(results)*2
        break

_PRE_END

( _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/menage'). )

<p>For 3 couples:</p>

_PRE_BEGIN
  men 0 2 1
women  1 0 2

  men 1 2 0
women  0 1 2

  men 0 1 2
women  2 0 1

  men 2 1 0
women  0 2 1

  men 2 0 1
women  1 2 0

  men 1 0 2
women  2 1 0

results total= 6
however, according to https://oeis.org/A059375 : 12
_PRE_END

<p>We are getting "half" of results because men and women can be then swapped (their sex swapped (or reassigned)) and you've got another 6 results.
6+6=12 in total.</p>

<p>For 4 couples:</p>

_PRE_BEGIN

...

  men 3 0 2 1
women  1 3 0 2

  men 3 0 1 2
women  2 3 0 1

  men 1 0 2 3
women  3 1 0 2

  men 2 0 1 3
women  3 2 0 1

results total= 48
however, according to https://oeis.org/A059375 : 96
_PRE_END

<p>For 5 couples:</p>

_PRE_BEGIN

...

  men 0 4 1 2 3
women  1 3 0 4 2

  men 0 3 1 2 4
women  1 4 0 3 2

  men 0 3 1 2 4
women  1 0 4 3 2

  men 4 3 1 0 2
women  0 2 4 1 3

results total= 1560
however, according to https://oeis.org/A059375 : 3120
_PRE_END

<p>The source code: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/menage').</p>

_FOOTER()

