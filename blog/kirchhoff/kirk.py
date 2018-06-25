from z3 import *

i1, i2, i3 = Reals ("i1 i2 i3")

R1=2000
R2=5000
R3=1000

V1=5 # left
V2=15 # right

s=Solver()

s.add(i3 == i1+i2)

s.add(V1 == R1*i1 + R3*i3)
s.add(V2 == R2*i2 + R3*i3)

print s.check()
m=s.model()
print m
print m[i1].as_decimal(6)
print m[i2].as_decimal(6)
print m[i3].as_decimal(6)

