m4_include(`commons.m4')

_HEADER_HL1(`Kirkman’s Schoolgirl Problem')

_PRE_BEGIN
Fifteen young ladies in a school walk out three abreast for seven days in succession: it is required to arrange them daily so that no two shall walk twice abreast.
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Kirkman%27s_schoolgirl_problem') )</p>

<p>The problem is also famously known as "social golfer problem": <i>Twenty golfers wish to play in foursomes for 5 days. Is it possible for each golfer to play no more than once with any other golfer?</i>
( _HTML_LINK_AS_IS(`http://mathworld.wolfram.com/SocialGolferProblem.html') ).</p>

<p>This is naive and straightforward solution:</p>

_PRE_BEGIN
from z3 import *
import itertools

PERSONS, DAYS, GROUPS = 15, 7, 5
#PERSONS, DAYS, GROUPS = 20, 5, 5

# each element - group for each person and each day:
tbl=[[Int('%d_%d' % (person, day)) for day in range(DAYS)] for person in range(PERSONS)]

s=Solver()

for person in range(PERSONS):
    for day in range(DAYS):
        s.add(And(tbl[person][day]>=0, tbl[person][day]&lt;GROUPS))

# one in pair must be equal, all others must differ:
def only_one_in_pair_can_be_equal(l1, l2):
    assert len(l1)==len(l2)
    expr=[]
    for pair_eq in range(len(l1)):
        tmp=[]
        for i in range(len(l1)):
            if pair_eq==i:
                tmp.append(l1[i]==l2[i])
            else:
                tmp.append(l1[i]!=l2[i])
        expr.append(And(*tmp))

# at this point, expression like this constructed:
# Or(
#	And(l1[0]==l2[0], l1[1]!=l2[1], l1[2]!=l2[2])
#	And(l1[0]!=l2[0], l1[1]==l2[1], l1[2]!=l2[2])
#	And(l1[0]!=l2[0], l1[1]!=l2[1], l1[2]==l2[2])
#   )

    s.add(Or(*expr))

# enumerate all possible pairs.
for pair in itertools.combinations(range(PERSONS), r=2):
    only_one_in_pair_can_be_equal (tbl[pair[0]], tbl[pair[1]])

print s.check()
m=s.model()

print "group for each person:"
print "person:"+"".join([chr(ord('A')+i)+" " for i in range(PERSONS)])
for day in range(DAYS):
    print "day=%d:" % day,
    for person in range(PERSONS):
        print m[tbl[person][day]].as_long(),
    print ""

def persons_in_group(day, group):
    rt=""
    for person in range(PERSONS):
        if m[tbl[person][day]].as_long()==group:
            rt=rt+chr(ord('A')+person)
    return rt

print ""
print "persons grouped:"
for day in range(DAYS):
    print "day=%d:" % day,
    for group in range(GROUPS):
        print persons_in_group(day, group)+" ",
    print ""
_PRE_END

_PRE_BEGIN
sat
group for each person:
person:A B C D E F G H I J K L M N O
day=0: 2 2 3 1 0 0 3 4 0 1 1 3 4 4 2
day=1: 2 1 2 4 3 1 4 4 2 1 0 3 0 3 0
day=2: 4 3 1 0 4 0 4 2 2 1 2 3 3 0 1
day=3: 4 3 1 4 2 1 3 1 0 2 3 4 2 0 0
day=4: 3 0 0 1 1 2 4 3 4 3 2 2 4 0 1
day=5: 2 4 1 1 4 3 3 4 0 0 2 0 1 2 3
day=6: 0 2 4 2 4 0 1 3 2 1 4 3 0 1 3

persons grouped:
day=0: EFI  DJK  ABO  CGL  HMN
day=1: KMO  BFJ  ACI  ELN  DGH
day=2: DFN  CJO  HIK  BLM  AEG
day=3: INO  CFH  EJM  BGK  ADL
day=4: BCN  DEO  FKL  AHJ  GIM
day=5: IJL  CDM  AKN  FGO  BEH
day=6: AFM  GJN  BDI  HLO  CEK
_PRE_END

<p>It took ~48s on my old Intel Xeon E3-1220 3.10GHz.</p>

<p>As in my _HTML_LINK(`https://yurichev.com/blog/knut_vik/',`previous example'), I've tried to represent each number (group in which schoolgirl/golfer is) as a single bit:</p>

_PRE_BEGIN
m4_include(`blog/kirkman/kirkman2.py')
_PRE_END

<p>This is way faster, ~1.5 seconds on the same CPU.</p>

<p>Unfortunately, sample SGP (social golfer problems) are out of reach. Yet?
_HTML_LINK_AS_IS(`http://www.mathpuzzle.com/MAA/54-Golf%20Tournaments/mathgames_08_14_07.html').</p>

<p>The files: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/kirkman').</p>

_BLOG_FOOTER()

