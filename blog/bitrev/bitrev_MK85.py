#!/usr/bin/python

from MK85 import *

# MK85 uses logical shift right for Python operator >>, so here is it as is...

def bitrev32(x):
    x = (x >> 16) | (x << 16)
    x = ((x & 0xFF00FF00) >> 8) | ((x & 0x00FF00FF) << 8)
    x = ((x & 0xF0F0F0F0) >> 4) | ((x & 0x0F0F0F0F) << 4)
    x = ((x & 0xCCCCCCCC) >> 2) | ((x & 0x33333333) << 2)
    x = ((x & 0xAAAAAAAA) >> 1) | ((x & 0x55555555) << 1)
    return x

def bitrev64_unoptimized(x):
    return (bitrev32(x & 0xffffffff) << 32) | bitrev32(x >> 32)

s=MK85(verbose=0)

def bitrev64 (a):
    a = (a >> 32) ^ (a << 32)
    m = 0x0000ffff0000ffff
    a = ((a >> 16) & m) ^ ((a << 16) & ~m)
    m = 0x00ff00ff00ff00ff
    a = ((a >> 8) & m) ^ ((a << 8) & ~m)
    m = 0x0f0f0f0f0f0f0f0f
    a = ((a >> 4) & m) ^ ((a << 4) & ~m)
    m = 0x3333333333333333
    a = ((a >> 2) & m) ^ ((a << 2) & ~m)
    m = 0x5555555555555555
    a = ((a >> 1) & m) ^ ((a << 1) & ~m)
    return a

x=s.BitVec('x', 64)
y=s.BitVec('y', 64)

# tests.

# check this:
#s.add(bitrev64_unoptimized(x)!=bitrev64(x))

# or this:
s.add(bitrev64(x)==y)
s.add(bitrev64(y)!=x)

# must be False:
print s.check()

