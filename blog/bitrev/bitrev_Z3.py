#!/usr/bin/python

from z3 import *

# from Henry Warren's "Hacker's Delight", Chapter 7
# Or: https://github.com/torvalds/linux/blob/master/include/linux/bitrev.h

# default right shift in Z3 is arithmetical, so I'm using Z3's LShR() function here, which is logical shift right

def bitrev8(x):
    x = LShR(x, 4) | (x << 4)
    x = LShR(x & 0xCC, 2) | ((x & 0x33) << 2)
    x = LShR(x & 0xAA, 1) | ((x & 0x55) << 1)
    return x

# these "unoptimized" versions are constructed like a Russian doll...

def bitrev16_unoptimized(x):
    return (bitrev8(x & 0xff) << 8) | (bitrev8(LShR(x, 8)))

def bitrev32_unoptimized(x):
    return (bitrev16_unoptimized(x & 0xffff) << 16) | (bitrev16_unoptimized(LShR(x, 16)))

def bitrev32(x):
    x = LShR(x, 16) | (x << 16)
    x = LShR(x & 0xFF00FF00, 8) | ((x & 0x00FF00FF) << 8)
    x = LShR(x & 0xF0F0F0F0, 4) | ((x & 0x0F0F0F0F) << 4)
    x = LShR(x & 0xCCCCCCCC, 2) | ((x & 0x33333333) << 2)
    x = LShR(x & 0xAAAAAAAA, 1) | ((x & 0x55555555) << 1)
    return x

def bitrev64_unoptimized(x):
    # both versions must work:
    return (bitrev32_unoptimized(x & 0xffffffff) << 32) | bitrev32_unoptimized(LShR(x, 32))
    #return (bitrev32(x & 0xffffffff) << 32) | bitrev32(LShR(x, 32))

# copypasted from CADO-NFS 2.3.0, http://cado-nfs.gforge.inria.fr/download.html
def bitrev64 (a):
    a = LShR(a, 32) ^ (a << 32)
    m = 0x0000ffff0000ffff
    a = (LShR(a, 16) & m) ^ ((a << 16) & ~m)
    m = 0x00ff00ff00ff00ff
    a = (LShR(a, 8) & m) ^ ((a << 8) & ~m)
    m = 0x0f0f0f0f0f0f0f0f
    a = (LShR(a, 4) & m) ^ ((a << 4) & ~m)
    m = 0x3333333333333333
    a = (LShR(a, 2) & m) ^ ((a << 2) & ~m)
    m = 0x5555555555555555
    a = (LShR(a, 1) & m) ^ ((a << 1) & ~m)
    return a

s=Solver()

x=BitVec('x', 64)

# tests.
# uncomment any.
# must be "unsat" in each case.

s.add(bitrev64(bitrev64_unoptimized(x))!=x)

# these are involutory functions, i.e., f(f(x))=x
#s.add(bitrev64_unoptimized(bitrev64_unoptimized(x))!=x)
#s.add(bitrev64(bitrev64(x))!=x)

# must be "unsat", no counterexample found
print s.check()

