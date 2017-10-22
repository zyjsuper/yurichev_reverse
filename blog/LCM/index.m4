m4_include(`commons.m4')

_HEADER_HL1(`Explanation of the Least Common Multiple using Z3 SMT solver, etc')

<p>(Previously: _HTML_LINK(`https://yurichev.com/blog/GCD/',`Explanation of the Greatest Common Divisor using Z3 SMT solver, etc').)</p>

<p>Many people use LCM in school. Sum up $\frac{1}{4}$ and $\frac{1}{6}$. To find an answer mentally, you ought to find Lowest Common Denominator, which can be 4*6=24.
Now you can sum up $\frac{6}{24} + \frac{4}{24} = \frac{10}{24}$.</p>

<p>But the lowest denominator is also a LCM.
LCM of 4 and 6 is 12: $\frac{3}{12} + \frac{2}{12} = \frac{5}{12}$.</p>

<p>To find LCM of 4 and 6, we are going to solve the following diophantine (i.e., allowing only integer solutions) system of equations:</p>

<p>$4x = 6y = LCM$</p>

<p>... where LCM>0 and as small, as possible.</p>

_PRE_BEGIN
#!/usr/bin/env python

from z3 import *

opt = Optimize()

x,y,LCM=Ints('x y LCM')

opt.add(x*4==LCM)
opt.add(y*6==LCM)
opt.add(LCM>0)

h=opt.minimize(LCM)

print (opt.check())
print (opt.model())
_PRE_END

<p>The (correct) answer:</p>

_PRE_BEGIN
sat
[y = 2, x = 3, LCM = 12]
_PRE_END

_HL2(`File copying routine')

<p>In GNU coreutils, we can find that LCM is used to find optimal buffer size, if buffer sizes in input and ouput files are differ.
For example, input file has buffer of 4096 bytes, and output is 6144.
Well, these sizes are somewhat suspicious. I made up this example.
Nevertheless, LCM of 4096 and 6144 is 12288. This is a buffer size you can allocate, so that you will minimize number of read/write operations during copying.</p>

<p>_HTML_LINK_AS_IS(`https://github.com/coreutils/coreutils/blob/4cb3f4faa435820dc99c36b30ce93c7d01501f65/src/copy.c#L1246').</p>
<p>_HTML_LINK_AS_IS(`https://github.com/coreutils/coreutils/blob/master/gl/lib/buffer-lcm.c').</p>

_BLOG_FOOTER()

