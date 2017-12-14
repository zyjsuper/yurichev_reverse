m4_include(`commons.m4')

_HEADER_HL1(`Finding (good) CRC polynomial using Z3')

<p>Finding good CRC polynomial is tricky, and my results can't compete with other tested popular CRC polynomial.
Nevertheless, it was fun to use Z3 to find them.</p>

<p>I just generate 32 random samples, all has size between 1 and 32 bytes.
Then I flip 1..3 random bits and I add a constraint: CRC hash of sample and hash of modified sample (with 1..3 bits flipped) must be different.</p>

_PRE_BEGIN
#!/usr/bin/env python

from z3 import *
import copy, random

width=32

poly=BitVec('poly', width)

s=Solver()

no_call=0

def CRC(_input, poly):
    # make each variable name unique
    # no_call (number of call) increments at each call to CRC() function
    global no_call
    states=[[BitVec('state_%d_%d_%d' % (no_call, i, bit), width) for bit in range(8+1)] for i in range(len(_input)+1)]
    no_call=no_call+1
    # initial state is always 0:
    s.add(Or(states[0][8]==0))

    for i in range(len(_input)):
        s.add(states[i+1][0] == states[i][8] ^ _input[i])

        for bit in range(8):
            s.add(states[i+1][bit+1] == LShR(states[i+1][bit],1) ^ If(states[i+1][bit]&1==1, poly, 0))

    return states[len(_input)][8]

# generate 32 random samples:
for i in range(32):
    print "pair",i
    # each sample has random size 1..32
    buf1=bytearray(os.urandom(random.randrange(32)+1))
    buf2=copy.deepcopy(buf1)
    # flip 1, 2 or 3 random bits in second sample:
    for bits in range(1,random.randrange(3)+2):
        # get random position and bit to flip:
        pos=random.randrange(0, len(buf2))
        to_flip=1&lt;&lt;random.randrange(8)
        print "  pos=", pos, "bit=",to_flip
        # flip random bit at random position:
        buf2[pos]=buf2[pos]^to_flip

    # original sample and sample with 1..3 random bits flipped.
    # their hashes must be different:
    s.add(CRC(buf1, poly)!=CRC(buf2, poly))
# get all possible results:
results=[]
while True:
    if s.check() == sat:
        m = s.model()
        print "poly=0x%x" % (m[poly].as_long())
        results.append(m)
        block = []
        for d in m:
            c=d()
            block.append(c != m[d])
        s.add(Or(block))
    else:
        print "total results", len(results)
        break
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/CRC_find_poly/CRC_find_poly.py') )</p>

<p>Several polynomials for CRC8:</p>

_PRE_BEGIN
poly=0xf9
poly=0x50
poly=0x90
...
_PRE_END

<p>... for CRC16:</p>

_PRE_BEGIN
poly=0xf7af
poly=0x368
poly=0x268
poly=0x228
...
_PRE_END

<p>... for CRC32:</p>

_PRE_BEGIN
poly=0x1683a5ab
poly=0x78553eda
poly=0x7a153eda
poly=0x7b353eda
...
_PRE_END

<p>... for CRC64:</p>

_PRE_BEGIN
poly=0x8000000000000006
poly=0x926b19b536a62f10
poly=0x4a7bb0a7da78a370
poly=0xbbc781e7e83dabf0
...
_PRE_END

<p>Problem: at least this one. CRC must be able to detect errors in very long buffers, up to $2^{32}$ for CRC32. We can't feed that huge buffers to SMT solver. I had success only with samples up to ~32 bytes.</p>

_BLOG_FOOTER()

