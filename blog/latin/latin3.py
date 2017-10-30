#!/usr/bin/env python

# Python 2.x

from z3 import *

SIZE=10

a=[[BitVec('a_%d_%d' % (x,y), 8) for x in range(SIZE)] for y in range(SIZE)]
b=[[BitVec('b_%d_%d' % (x,y), 8) for x in range(SIZE)] for y in range(SIZE)]
c=[[BitVec('c_%d_%d' % (x,y), 8) for x in range(SIZE)] for y in range(SIZE)]
ab=[[BitVec('ab_%d_%d' % (x,y), 8) for x in range(SIZE)] for y in range(SIZE)]
bc=[[BitVec('bc_%d_%d' % (x,y), 8) for x in range(SIZE)] for y in range(SIZE)]
ac=[[BitVec('ac_%d_%d' % (x,y), 8) for x in range(SIZE)] for y in range(SIZE)]

s=Solver()

# all square elements are in 1..SIZE range:
for x in range(SIZE):
    for y in range(SIZE):
        s.add(And(a[x][y]>=1, a[x][y]<=SIZE))
        s.add(And(b[x][y]>=1, b[x][y]<=SIZE))
        s.add(And(c[x][y]>=1, c[x][y]<=SIZE))

# all rows are distinct in all squares:
for x in range(SIZE):
    s.add(Distinct(*[a[x][y] for y in range(SIZE)]))
    s.add(Distinct(*[b[x][y] for y in range(SIZE)]))
    s.add(Distinct(*[c[x][y] for y in range(SIZE)]))
    s.add(Distinct(*[ab[x][y] for y in range(SIZE)]))
    s.add(Distinct(*[bc[x][y] for y in range(SIZE)]))
    s.add(Distinct(*[ac[x][y] for y in range(SIZE)]))

# all columns are distinct in all squares:
for y in range(SIZE):
    s.add(Distinct(*[a[x][y] for x in range(SIZE)]))
    s.add(Distinct(*[b[x][y] for x in range(SIZE)]))
    s.add(Distinct(*[c[x][y] for x in range(SIZE)]))
    s.add(Distinct(*[ab[x][y] for x in range(SIZE)]))
    s.add(Distinct(*[bc[x][y] for x in range(SIZE)]))
    s.add(Distinct(*[ac[x][y] for x in range(SIZE)]))

# form ab/bc/ac squares:
for x in range(SIZE):
    for y in range(SIZE):
        s.add(ab[x][y]==a[x][y]<<4 | b[x][y])
        s.add(bc[x][y]==b[x][y]<<4 | c[x][y])
        s.add(ac[x][y]==a[x][y]<<4 | c[x][y])

print s.check()
m=s.model()

print "a:"
for x in range(SIZE):
    for y in range(SIZE):
        print "%X" % m[a[x][y]].as_long(),
    print ""

print "b:"
for x in range(SIZE):
    for y in range(SIZE):
        print "%X" % m[b[x][y]].as_long(),
    print ""

print "c:"
for x in range(SIZE):
    for y in range(SIZE):
        print "%X" % m[c[x][y]].as_long(),
    print ""

print "ab:"
for x in range(SIZE):
    for y in range(SIZE):
        print "%02X" % m[ab[x][y]].as_long(),
    print ""

print "bc:"
for x in range(SIZE):
    for y in range(SIZE):
        print "%02X" % m[bc[x][y]].as_long(),
    print ""

print "ac:"
for x in range(SIZE):
    for y in range(SIZE):
        print "%02X" % m[ac[x][y]].as_long(),
    print ""

