m4_include(`commons.m4')

_HEADER(`Cabling in rack cabinet and Z3')

_HL1(`Cabling in rack cabinet and Z3')

<p>Take a rack cabinet, like this one:</p>

<p><img src="Assembled_Network_Cabinets_Server_Rack_Telecom_Standard_Supreme_Quality_Product_3152_7.jpg"></p>

<p>Let's say, there are 8 1U devices, maybe servers, routers and whatnot, named as A, B, C, D, E, F, G, H.
Devices must be connected by cables: probably twisted pair or whatever network engineers using today.
Some devices must be connected by several cables (2 cables, 3 or 4):</p>

_PRE_BEGIN
A <--- 1 cable  ---> H
A <--- 2 cables ---> E
B <--- 4 cables ---> F
C <--- 1 cable  ---> G
C <--- 1 cable  ---> D
C <--- 1 cable  ---> E
D <--- 3 cables ---> H
G <--- 1 cable  ---> H
_PRE_END

<p>The problem: how we can place these 8 devices in such an order, so that sum of all cable lengths would be as short as possible?</p>

_PRE_BEGIN
#!/usr/bin/env python

from z3 import *

# it's like abs(x-y)
# but since we don't have abs() here, we're going to use If():
def diff(x, y):
    return If(x&lt;y, y-x, x-y)

A, B, C, D, E, F, G, H = Ints("A B C D E F G H")

s=Optimize()

# only 8 1U slots in rack:
s.add(And(A>=0, A<=7))
s.add(And(B>=0, B<=7))
s.add(And(C>=0, C<=7))
s.add(And(D>=0, D<=7))
s.add(And(E>=0, E<=7))
s.add(And(F>=0, F<=7))
s.add(And(G>=0, G<=7))
s.add(And(H>=0, H<=7))

# all "devices" has distinct positions in rack:
s.add(Distinct(A, B, C, D, E, F, G, H))

# A <--- 1 cable  ---> H
diff_A_H=Int("diff_A_H")
s.add(diff_A_H==diff(A,H))
final_sum=Int("final_sum")
final_sum=diff_A_H

# A <--- 2 cables ---> E
diff_A_E=Int("diff_A_E")
s.add(diff_A_E==diff(A,E))
final_sum=final_sum+diff_A_E*2

# B <--- 4 cables ---> F
diff_B_F=Int("diff_B_F")
s.add(diff_B_F==diff(B,F))
final_sum=final_sum+diff_B_F*4

# C <--- 1 cable  ---> G
diff_C_G=Int("diff_C_G")
s.add(diff_C_G==diff(C,G))
final_sum=final_sum+diff_C_G

# C <--- 1 cable  ---> D
diff_C_D=Int("diff_C_D")
s.add(diff_C_D==diff(C,D))
final_sum=final_sum+diff_C_D

# C <--- 1 cable  ---> E
diff_C_E=Int("diff_C_E")
s.add(diff_C_E==diff(C,E))
final_sum=final_sum+diff_C_E

# D <--- 3 cables ---> H
diff_D_H=Int("diff_D_H")
s.add(diff_D_H==diff(D,H))
final_sum=final_sum+diff_D_H*3

# G <--- 1 cable  ---> H
diff_G_H=Int("diff_G_H")
s.add(diff_G_H==diff(G,H))
final_sum=final_sum+diff_G_H

print "minimizing", final_sum

# somehow, final_sum variable is not in the model, so add new variable
# we'll need it for printing
final_sum2=Int("final_sum2")
s.add(final_sum==final_sum2)

s.minimize(final_sum)
#s.maximize(final_sum)

print s.check()
m=s.model()
print m

a={}

print "order:"
a[m[A].as_long()]="A"
a[m[B].as_long()]="B"
a[m[C].as_long()]="C"
a[m[D].as_long()]="D"
a[m[E].as_long()]="E"
a[m[F].as_long()]="F"
a[m[G].as_long()]="G"
a[m[H].as_long()]="H"
for i in range(8):
    print a[i]
print "final_sum2", m[final_sum2]
_PRE_END

<p>Each 1 in diff_X_X variables and in final_sum means a cable of length enough to connect two 1U devices placed adjacently.
So we measure cable lengths in "units".</p>

<p>Minimizing:</p>

_PRE_BEGIN
m4_include(`blog/cabling_Z3/min.txt')
_PRE_END

<p>So we need a cable of 19 units to cut it and connect everything.</p>

<p>Essentially, we're asking Z3 to find such values for A, B, C, D, E, F, G, H, so that the value of the following expression would be as small as possible:</p>

_PRE_BEGIN
diff_A_H +                                                                                                             
diff_A_E*2 +
diff_B_F*4 +
diff_C_G +
diff_C_D +
diff_C_E +
diff_D_H*3 +
diff_G_H
_PRE_END

<p>Just for fun, we can maximize solution (comment "s.minimize()" and uncomment "s.maximize()"):</p>

_PRE_BEGIN
m4_include(`blog/cabling_Z3/max.txt')
_PRE_END

<p>Further work: it's not a problem to extend this script for several types of cables: network, power, etc, and minimize them as well.
Even more, we can assign priorities: maybe, we can live with longer network cables, but want to minimize lengths of power cables at first.
</p>

_BLOG_FOOTER()

