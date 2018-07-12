m4_include(`commons.m4')

_HEADER_HL1(`Register allocation using graph coloring')

<p>This is an implementation of _HTML_LINK(`https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm',`Knuth-Morris-Pratt algorithm'), it searches for a substring in a string.
(Copypasted from _HTML_LINK_AS_IS(`http://cprogramming.com/snippets/source-code/knuthmorrispratt-kmp-string-search-algorithm').</p>

_PRE_BEGIN
#include &lt;stdlib.h>                                                                                                               
#include &lt;stdio.h>
#include &lt;string.h>

int64_t T[1024];

char *kmp_search(char *haystack, size_t haystack_size, char *needle, size_t needle_size)
{
        //int *T;
        int64_t i, j;
        char *result = NULL;

        if (needle_size==0)
                return haystack;

        /* Construct the lookup table */
        //T = (int*) malloc((needle_size+1) * sizeof(int));
        T[0] = -1;
        for (i=0; i&lt;needle_size; i++)
        {
                T[i+1] = T[i] + 1;
                while (T[i+1] > 0 && needle[i] != needle[T[i+1]-1])
                        T[i+1] = T[T[i+1]-1] + 1;
        }

        /* Perform the search */
        for (i=j=0; i&lt;haystack_size; )
        {
                if (j < 0 || haystack[i] == needle[j])
                {
                        ++i, ++j;
                        if (j == needle_size)
                        {
                                result = haystack+i-j;
                                break;
                        }
                }
                else j = T[j];
        }

        //free(T);
        return result;
}

char* helper(char* haystack, char* needle)
{
        return kmp_search(haystack, strlen(haystack), needle, strlen(needle));
};

int main()
{
        printf ("%s\n", helper("hello world", "world"));
        printf ("%s\n", helper("hello world", "ell"));
};
_PRE_END

<p>... as you can see, I simplified it a bit, there are no more calls to malloc/free and T[] array is now global.</p>

<p>Then I compiled it using GCC 7.3 x64 and reworked assembly listing a little, now there are no registers, but rather vXX variables, each one is assigned only once,
in a SSA (_HTML_LINK(`https://en.wikipedia.org/wiki/Static_single_assignment_form',`Static single assignment form')) manner. No variable assigned more than once. This is AT&T syntax.</p>

_PRE_BEGIN
m4_include(`blog/reg_alloc/KMP_template')
_PRE_END

<p>Dangling "noodles" you see at right is a "live ranges" of each vXX variable. "D" means "defined", "U" - "used" or "used and then defined again".
Whenever live range is started, we need to allocate variable (in a register or a local stack).
When it's ending, we may do not need to keep it somewhere in storage (in a register or a local stack).</p>

<p>As you can see, the function has two parts: preparation and processing.
You can clearly see how live ranges are divided by two parts, except of first 4, which are function arguments.</p>

<p>You see, there are 16 variables. But we want to use as small number of registers, as possible.
If several live ranges are present at some address or point of time, these variables cannot be allocated in the same register.</p>

<p>This is how we can assign a register to each live range using Z3 SMT-solver:</p>

_PRE_BEGIN
from z3 import *                                                                                                                  

def attempt(colors):

    v=[Int('v%d' % i) for i in range(18)]

    s=Solver()

    for i in range(18):
        s.add(And(v[i]>=0, v[i]&lt;colors))

    # a bit redundant, but that is not an issue:
    s.add(Distinct(v[1], v[2], v[3], v[4]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[7]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7], v[9]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7], v[8], v[9]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7], v[8], v[9], v[14]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7], v[8], v[9], v[11], v[14]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7], v[8], v[9], v[12], v[14]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7], v[8], v[9], v[14], v[15]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7], v[9], v[14], v[15]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7], v[9], v[14]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[5], v[7], v[14]))
    s.add(Distinct(v[1], v[2], v[3], v[4]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[6]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[6], v[16]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[6], v[10], v[16]))
    s.add(Distinct(v[1], v[2], v[3], v[4], v[6], v[10], v[13], v[16]))
    s.add(Distinct(v[1], v[2], v[4], v[6], v[10], v[13], v[16]))
    s.add(Distinct(v[1], v[2], v[4], v[6], v[10], v[16]))
    s.add(Distinct(v[1], v[4], v[6], v[10], v[16]))
    s.add(Distinct(v[1], v[4], v[10], v[16]))
    s.add(Distinct(v[1], v[4], v[10]))
    s.add(Distinct(v[1], v[10]))

    registers=["RDI", "RSI", "RDX", "RCX", "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15"]
    # first 4 variables are function arguments and they are always linked to rdi/rsi/rdx/rcx:
    s.add(v[1]==0)
    s.add(v[2]==1)
    s.add(v[3]==2)
    s.add(v[4]==3)

    if s.check()==sat:
        print "* colors=", colors
        m=s.model()
        for i in range(1, 17):
            print "v%d=%s" % (i, registers[m[v[i]].as_long()])

for colors in range(12, 0, -1):
    attempt(colors)
_PRE_END

<p>What we've got for 12, 11 and 10 registers:</p>

_PRE_BEGIN
m4_include(`blog/reg_alloc/solver.txt')
_PRE_END

<p>It's not possible to assign 9 or less registers. 10 is a minimum.</p>

<p>Now all I do is replacing vXX variables to registers the SMT-solver offered:</p>

_PRE_BEGIN
m4_include(`blog/reg_alloc/KMP.s')
_PRE_END

<p>That works and it's almost the same as GCC does.</p>

<p>The problem of register allocation as a _HTML_LINK(`https://en.wikipedia.org/wiki/Graph_coloring',`graph coloring problem'): each live range is a vertex.
It a live range must coexist with another live range, put an edge between vertices, that means, vertices cannot share same color.
Color reflecting register number.</p>

<p>Almost all compilers (except simplest) do this in code generator. They use simpler algorithms, though, instead of such a heavy machinery as SAT/SMT solvers.</p>

<p>See also: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Register_allocation').</p>

_BLOG_FOOTER()

