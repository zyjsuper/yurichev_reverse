m4_include(`commons.m4')

_HEADER_HL1(`Generating de Bruijn sequences using Z3 SMT-solver')

<p>The following piece of quite esoteric code calculates _HTML_LINK(`https://en.wikipedia.org/wiki/Find_first_set',`number of leading zeroes'):</p>

_PRE_BEGIN
int v[64]=
	{ -1,31, 8,30, -1, 7,-1,-1, 29,-1,26, 6, -1,-1, 2,-1,
	  -1,28,-1,-1, -1,19,25,-1, 5,-1,17,-1, 23,14, 1,-1,
	   9,-1,-1,-1, 27,-1, 3,-1, -1,-1,20,-1, 18,24,15,10,
	  -1,-1, 4,-1, 21,-1,16,11, -1,22,-1,12, 13,-1, 0,-1 };

int LZCNT(uint32_t x)
{
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    x *= 0x4badf0d;
    return v[x >> 26];
}
_PRE_END

<p>Read more about it: _HTML_LINK_AS_IS(`https://yurichev.com/blog/de_bruijn/').
The magic number used here is called "de Bruijn sequence", and I once used bruteforce to find it (the result was 0x4badf0d, which is used here).
But what if we need magic number for 64-bit values?
Bruteforce is not an option here.</p>

<p>If you alread read about this sequence in my blog or in other sources, you can see that the 32-bit magic number is a number consisting
of 5-bit overlapping chunks, and all chunks must be unique, i.e., must not be repeating.</p>

<p>For 64-bit magic number, these are 6-bit overlapping chunks.</p>

<p>To find the magic number, one can find a Hamiltonian path of a de Bruijn graph.
But I've found that Z3 is also can do this, though, overkill, but this is more illustrative.</p>

_PRE_BEGIN
#!/usr/bin/python
from z3 import *

out = BitVec('out', 64)

tmp=[]
for i in range(64):
    tmp.append((out>>i)&0x3F)

s=Solver()

# all overlapping 6-bit chunks must be distinct:
s.add(Distinct(*tmp))
# MSB must be zero:
s.add((out&0x8000000000000000)==0)

print s.check()

result=s.model()[out].as_long()
print "0x%x" % result

# print overlapping 6-bit chunks:
for i in range(64):
    t=(result>>i)&0x3F
    print " "*(63-i) + format(t, 'b').zfill(6)
_PRE_END

<p>We just enumerate all overlapping 6-bit chunks and tell Z3 that they must be unique (see "Distinct").
Output:</p>

_PRE_BEGIN
sat
0x79c52dd0991abf60
                                                               100000
                                                              110000
                                                             011000
                                                            101100
                                                           110110
                                                          111011
                                                         111101
                                                        111110
                                                       111111
                                                      011111
                                                     101111
                                                    010111
                                                   101011
                                                  010101
                                                 101010
                                                110101
                                               011010
                                              001101
                                             000110
                                            100011
                                           010001
                                          001000
                                         100100
                                        110010
                                       011001
                                      001100
                                     100110
                                    010011
                                   001001
                                  000100
                                 000010
                                100001
                               010000
                              101000
                             110100
                            111010
                           011101
                          101110
                         110111
                        011011
                       101101
                      010110
                     001011
                    100101
                   010010
                  101001
                 010100
                001010
               000101
              100010
             110001
            111000
           011100
          001110
         100111
        110011
       111001
      111100
     011110
    001111
   000111
  000011
 000001
000000
_PRE_END

<p>Overlapping chunks are clearly visible.
So the magic number is 0x79c52dd0991abf60.
Let's check:</p>

_PRE_BEGIN
#include &lt;stdint.h>
#include &lt;stdio.h>
#include &lt;assert.h>

#define MAGIC 0x79c52dd0991abf60

int magic_tbl[64];

// returns single bit position counting from LSB
// not working for i==0
int bitpos (uint64_t i)
{
        return magic_tbl[(MAGIC/i) & 0x3F];
};

// trailing zeroes count
// not working for i==0
int tzcnt (uint64_t i)
{
        uint64_t a=i & (-i);
        return magic_tbl[(MAGIC/a) & 0x3F];
};

int main()
{
        // construct magic table
        // may be omitted in production code
        for (int i=0; i<64; i++)
                magic_tbl[(MAGIC/(1ULL&lt;&lt;i)) & 0x3F]=i;

        // test
        for (int i=0; i<64; i++)
        {
                printf ("input=0x%llx, result=%d\n", 1ULL&lt;&lt;i, bitpos (1ULL&lt;&lt;i));
                assert(bitpos(1ULL&lt;&lt;i)==i);
        };
        assert(tzcnt (0xFFFF0000)==16);
        assert(tzcnt (0xFFFF0010)==4);
};
_PRE_END

<p>That works!</p>

<p>More about de Bruijn sequences:
_HTML_LINK_AS_IS(`https://yurichev.com/blog/de_bruijn/'),
_HTML_LINK_AS_IS(`https://chessprogramming.wikispaces.com/De+Bruijn+sequence'),
_HTML_LINK_AS_IS(`https://chessprogramming.wikispaces.com/De+Bruijn+Sequence+Generator').</p>

<p>My other notes about SAT/SMT: _HTML_LINK_AS_IS(`https://yurichev.com/writings/SAT_SMT_draft-EN.pdf').</p>

_BLOG_FOOTER()

