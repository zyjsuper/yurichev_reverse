m4_include(`commons.m4')

_HEADER_HL1(`2-Jun-2017: Minimizing test set using Z3')

<p>
I once worked on rewriting large piece of code into pure C, and there were a tests, several thousands.
Testing process was painfully slow, so I thought if the test set can be minimized somehow.
</p>

<p>
What we can do is to run each test and get code coverage.
Then the task is to build such test set, where coverage is maximum, and number of tests is minimal.
</p>

<p>
In fact, this is _HTML_LINK(`https://en.wikipedia.org/wiki/Set_cover_problem',`set cover problem') (also known as "hitting set problem").
While simpler algorithms exist (see Wikipedia), it is also possible to solve with SMT-solver.
</p>

<p>
First, I took _HTML_LINK(`https://github.com/opensource-apple/kext_tools/blob/master/compression.c',`LZSS compression/decompression code') for the example, from Apple sources.
Such routines are not easy to test.
Here is _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/set_cover/compression.c',`my version') of it: I've added random generation of input data to be compressed.
Random generation is dependent of some kind of input seed.
Standard srand()/rand() are not recommended to be used, but for such simple task as ours, it's OK.
I'll _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/set_cover/gen_gcov_tests.sh',`generate') 1000 tests with 0..999 seeds, that would produce random data to be compressed/decompressed/checked.
</p>

<p>
After the compression/decompression routine has finished its work, GNU gcov utility is executed, which produces result like this:
</p>

_PRE_BEGIN()
     1401:  161:static void insert_node(struct encode_state *sp, int r)
        -:  162:{
        -:  163:    int  i, p, cmp;
        -:  164:    u_int8_t  *key;
        -:  165:
     1401:  166:    cmp = 1;
     1401:  167:    key = &sp->text_buf[r];
     1401:  168:    p = N + 1 + key[0];
     1401:  169:    sp->rchild[r] = sp->lchild[r] = NIL;
     1401:  170:    sp->match_length = 0;
        -:  171:    for ( ; ; ) {
     3966:  172:        if (cmp >= 0) {
     2611:  173:            if (sp->rchild[p] != NIL)
     1783:  174:                p = sp->rchild[p];
        -:  175:            else {
      828:  176:                sp->rchild[p] = r;
      828:  177:                sp->parent[r] = p;
      828:  178:                return;
        -:  179:            }
        -:  180:        } else {
     1355:  181:            if (sp->lchild[p] != NIL)
      782:  182:                p = sp->lchild[p];
        -:  183:            else {
      573:  184:                sp->lchild[p] = r;
      573:  185:                sp->parent[r] = p;
      573:  186:                return;
        -:  187:            }
        -:  188:        }
     3395:  189:        for (i = 1; i < F; i++) {
     3395:  190:            if ((cmp = key[i] - sp->text_buf[p + i]) != 0)
     2565:  191:                break;
        -:  192:        }
     2565:  193:        if (i > sp->match_length) {
     1291:  194:            sp->match_position = p;
     1291:  195:            if ((sp->match_length = i) >= F)
    #####:  196:                break;
        -:  197:        }
     2565:  198:    }
    #####:  199:    sp->parent[r] = sp->parent[p];
    #####:  200:    sp->lchild[r] = sp->lchild[p];
    #####:  201:    sp->rchild[r] = sp->rchild[p];
    #####:  202:    sp->parent[sp->lchild[p]] = r;
    #####:  203:    sp->parent[sp->rchild[p]] = r;
    #####:  204:    if (sp->rchild[sp->parent[p]] == p)
    #####:  205:        sp->rchild[sp->parent[p]] = r;
        -:  206:    else
    #####:  207:        sp->lchild[sp->parent[p]] = r;
    #####:  208:    sp->parent[p] = NIL;  /* remove p */
        -:  209:}
_PRE_END()

<p>
Leftmost number is an execution count for each line.
##### means the line of code hasn't been executed at all.
The second column is a line number.
</p>

<p>
Now the Z3Py script, which will parse all these 1000 gcov results and produce minimal <i>hitting set</i>:
</p>

_PRE_BEGIN()
m4_include(`blog/set_cover/set_cover.py')
_PRE_END()

<p>
And what it produces (on my old Intel Quad-Core Xeon E3-1220 3.10GHz):
</p>

_PRE_BEGIN()
% time python set_cover.py
sat
test_7
test_48
test_134
python set_cover.py  18.95s user 0.03s system 99% cpu 18.988 total
_PRE_END()

<p>
We need just these 3 tests to execute (almost) all lines in the code: looks impressive, given the fact, that it would be notoriously hard to pick these tests by hand!
The result can be checked easily, again, using gcov utility.
</p>

<p>
This is sometimes also called MaxSAT/MaxSMT - the problem is just to find solution, but the solution where some variable is as maximal as possible, or as minimal as possible.
</p>

<p>
Also, the code gives incorrect results on Z3 4.4.1, but working correctly on Z3 4.5.0 (so please upgrade).
This is relatively fresh feature in Z3, so probably it was not stable in previous versions?
</p>

<p>
The files:
_HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/set_cover').
</p>

<p>
Further reading:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Set_cover_problem'),
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Maximum_satisfiability_problem').
</p>

_BLOG_FOOTER()

