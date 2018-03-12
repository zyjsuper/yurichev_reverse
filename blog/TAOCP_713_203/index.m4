m4_include(`commons.m4')

_HEADER_HL1(`TAOCP 7.1.3 Exercise 203, MMIX MOR instruction and program synthesis by sketching')

<p>Found this exercise in TAOCP 7.1.3 (Bitwise Tricks and Techniques):</p>

<p><img src="203q.png" class="ImageBorder" /></p>

<p>What is MOR instruction in MMIX?</p>

<p><img src="MOR.png" class="ImageBorder" /></p>

<p>( _HTML_LINK_AS_IS(`http://mmix.cs.hm.edu/doc/mmix-doc.pdf') )</p>

<p>Let's try to solve. We create two functions. First has MOR instructions simulation + the program from TAOCP.
The second is a naive implementation.
Then we add "forall" qunator: for all inputs, both functions must produce the same result.
<b>But</b>, we don't know a/b/c/d/e/f and ask Z3 SMT-solver to find them.</p>

_PRE_BEGIN
from z3 import *

s=Solver()

a, b, c, d, e=BitVecs('a b c d e', 64)

def simulate_MOR(y,z):
    """
    set each bit of 64-bit result, as:

    $x_i_j = y_0_j z_i_0 \vee y_1_j z_i_1 \vee \cdots \vee y_7_j z_i_7$
    https://latexbase.com/d/bf2243f8-5d0b-4231-8891-66fb47d846f0

    IOW:

    x<byte><bit> = (y<0><bit> AND z<byte><0>) OR (y<1><bit> AND z<byte><1>) OR ... OR (y<7><bit> AND z<byte><7>)
    """

    def get_ij(x, i, j):
        return (x>>(i*8+j))&1

    rt=0
    for byte in range(8):
        for bit in range(8):
            t=0
            for i in range(8):
                t|=get_ij(y, i, bit) & get_ij(z, byte, i)

            pos=byte*8+bit
            rt|=t &lt;&lt; pos

    return rt

def simulate_pgm(x):
    t=simulate_MOR(x,a)
    s=t<<4
    t=s^t
    t=t&b
    t=t+c
    s=simulate_MOR(d,t)
    t=t+e
    y=t+s
    return y

def nibble_to_ASCII(x):
    return If(And(x>=0, x<=9), 0x30+x, 0x61+x-10)

def method2(x):
    rt=0
    for i in range(8):
        rt|=nibble_to_ASCII((x >> i*4)&0xf) << i*8
    return rt

#"""
# new version.
# for all possible 32-bit x's, find such a/b/c/d/e, so that these two parts would be equal to each other
# zero extend x to 64-bit value in both cases
x=BitVec('x', 32)
s.add(ForAll([x], simulate_pgm(ZeroExt(32, x))==method2(ZeroExt(32, x))))
#"""

"""
# previous version:
for i in range(5):
    x=random.getrandbits(32)
    t="%08x" % x
    y=int(''.join("%02X" % ord(c) for c in t), 16)
    print "%x %x" % (x, y)

    s.add(simulate_pgm(x)==y)
"""

# enumerate all solutions:
results=[]
while s.check() == sat:
    m = s.model()

    print "a,b,c,d,e = %x %x %x %x %x" % (m[a].as_long(), m[b].as_long(), m[c].as_long(), m[d].as_long(), m[e].as_long())

    results.append(m)
    block = []
    for d1 in m:
        t=d1()
        block.append(t != m[d1])
    s.add(Or(block))

print "results total=", len(results)
_PRE_END

<p>Very slow, it takes several hours on my venerable Intel Quad-Core Xeon E3-1220 3.10GHz but found at least one solution:</p>

_PRE_BEGIN
a,b,c,d,e = 8000400020001 f0f0f0f0f0f0f0f 56d656d616969616 411a00000000 bf3fbf3fff7f8000
_PRE_END

<p>... which is correct (I've wrote bruteforce checker, _HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/TAOCP_713_203/check.c',`here')).</p>

<p>D.Knuth's TAOCP also has answers:</p>

<p><img src="203a.png" class="ImageBorder" /></p>

<p>... which are different, but also correct.</p>

<p>What if a==0x0008000400020001 always?
I'm adding a new constraint:</p>

_PRE_BEGIN
s.add(a==0x0008000400020001)
_PRE_END

<p>We've getting many results (much faster, and also correct):</p>

_PRE_BEGIN
...

a,b,c,d,e = 8000400020001 7f0fcf0fcf0f7f0f 1616d6d656561656 8680522903020000 eeeda9aa2e2eee2f
a,b,c,d,e = 8000400020001 7f0fcf0fcf0f6f0f 1616d6d656561656 8680522903020000 eeeda9aa2e2eee2f
a,b,c,d,e = 8000400020001 7f0fcf0fdf0f6f0f 1616d6d656561656 8680522903020000 eeeda9aa2e2eee2f
a,b,c,d,e = 8000400020001 5f0fcf0fdf0f6f0f 1616d6d656561656 8680522903020000 eeeda9aa2e2eee2f

...
_PRE_END

<p>The files: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/tree/master/blog/TAOCP_713_203').</p>

_BLOG_FOOTER()

