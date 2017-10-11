m4_include(`commons.m4')

_HEADER_HL1(`Explanation of the Greatest Common Divisor using Z3 SMT solver, etc')

<p>What is Greatest common divisor (GCD)?</p>

<p>Let's suppose, you want to cut a rectangle by squares. What is maximal square could be?</p>

<p>For a 14*8 rectangle, this is 2*2 square:</p>

_PRE_BEGIN
**************
**************
**************
**************
**************
**************
**************
**************
_PRE_END

<p>-></p>

_PRE_BEGIN
** ** ** ** ** ** **
** ** ** ** ** ** **
                  
** ** ** ** ** ** **
** ** ** ** ** ** **
                  
** ** ** ** ** ** **
** ** ** ** ** ** **
                  
** ** ** ** ** ** **
** ** ** ** ** ** **
_PRE_END

<p>What for 14*7 rectangle? It's 7*7 square:</p>

_PRE_BEGIN
**************
**************
**************
**************
**************
**************
**************
_PRE_END

<p>-></p>

_PRE_BEGIN
******* *******
******* *******
******* *******
******* *******
******* *******
******* *******
******* *******
_PRE_END

<p>14*9 rectangle? 1, i.e., smallest possible.</p>

_PRE_BEGIN
**************
**************
**************
**************
**************
**************
**************
**************
**************
**************
_PRE_END

<p>To compute GCD, one of the oldest algorithms is used: _HTML_LINK(`https://en.wikipedia.org/wiki/Euclidean_algorithm',`Euclidean algorithm').
But, I can demonstrate how to make things much less efficient, but more spectacular.</p>

<p>To find GCD of 14 and 8, we are going to solve this system of equations:</p>

_PRE_BEGIN
x*GCD=14
y*GCD=8
_PRE_END

<p>Then we drop x and y, we don't need them.
This system can be solved using paper and pencil, but GCD must be as big as possible.
Here we can use Z3 in MaxSMT mode:</p>

_PRE_BEGIN
#!/usr/bin/env python

from z3 import *

opt = Optimize()

x,y,GCD=Ints('x y GCD')

opt.add(x*GCD==14)
opt.add(y*GCD==8)

h=opt.maximize(GCD)

print (opt.check())
print (opt.model())
_PRE_END

<p>That works:</p>

_PRE_BEGIN
sat
[y = 4, x = 7, GCD = 2]
_PRE_END

<p>What if we need to find GCD for 3 numbers?
Maybe we are going to fill a space with biggest possible cubes?</p>

_PRE_BEGIN
#!/usr/bin/env python

from z3 import *

opt = Optimize()

x,y,z,GCD=Ints('x y z GCD')

opt.add(x*GCD==300)
opt.add(y*GCD==333)
opt.add(z*GCD==900)

h=opt.maximize(GCD)

print (opt.check())
print (opt.model())
_PRE_END

<p>This is 3:</p>

_PRE_BEGIN
sat
[z = 300, y = 111, x = 100, GCD = 3]
_PRE_END

_HL2(`Couple of words about GCD')

<p>GCD of _HTML_LINK(`https://yurichev.com/blog/RSA/',`coprimes') is 1.</p>

<hr>

<p>GCD is a smallest of factors of several numbers.
This we can see in Mathematica:</p>

_PRE_BEGIN
In[]:= FactorInteger[300]
Out[]= {{2, 2}, {3, 1}, {5, 2}}

In[]:= FactorInteger[333]
Out[]= {{3, 2}, {37, 1}}

In[]:= GCD[300, 333]
Out[]= 3
_PRE_END

<p>I.e., 300=2^2 * 3 * 5^2 and 333=3^2 * 37 and GCD=3, which is smallest factor.</p>

_BLOG_FOOTER()

