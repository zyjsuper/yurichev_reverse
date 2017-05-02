m4_include(`commons.m4')

_HEADER_HL1(`29-Apr-2017: Recalculating micro-spreadsheet using Z3Py')

<p>There is a nice exercise (_HTML_LINK(`http://thesz.livejournal.com/280784.html',`blog post in Russian')): write a program to recalculate micro-spreadsheet, like this one:</p>

_PRE_BEGIN
m4_include(`blog/spreadsheet/test1')
_PRE_END

<p>As it turns out, though overkill, this can be solved using Z3 with little effort:</p>

_PRE_BEGIN
m4_include(`blog/spreadsheet/1.py')
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/spreadsheet/1.py') )</p>

<p>All we do is just creating pack of variables for each cell, named A0, B1, etc, of integer type.
All of them are stored in <i>cells[]</i> dictionary.
Key is a string.
Then we parse all the strings from cells, and add to list of constraints "A0=123" (in case of number in cell) or "A0=B1+C2" (in case of expression in cell).
There is a slight preparation: string like "A0+B2" becomes "cells["A0"]+cells["B2"]".</p>

<p>Then the string is evaluated using Python <i>eval()</i> method, which is _HTML_LINK(`http://stackoverflow.com/questions/1832940/is-using-eval-in-python-a-bad-practice',`highly dangerous'):
imagine if end-user could add a string to cell other than expression?
Nevertheless, it serves our purposes well, because this is a simplest way to pass a string with expression into Z3.</p>

<p>Z3 do the job with little effort:</p>

_PRE_BEGIN
 % python 1.py test1
sat
1       0       135     82041
123     10      12      11
667     11      1342    83383
_PRE_END

<p>Now the problem: what if there is circular dependency? Like:</p>

_PRE_BEGIN
m4_include(`blog/spreadsheet/test_circular')
_PRE_END

<p>Two first cells of the last row (C0 and C1) are linked to each other.
Our program will just tell "unsat", meaning, it couldn't solve all constraints together.
We can't use this as error message reported to end-user, because it's highly unfriendly.</p>

<p>However, we can fetch "unsat core", i.e., list of variables which Z3 finds conflicting.</p>

_PRE_BEGIN
...
s=Solver()
s.set(unsat_core=True)
...
        # add constraint:
        s.assert_and_track(e, coord_to_name(cur_R, cur_C))
...
if result=="sat":
...
else:
    print s.unsat_core()
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/spreadsheet/2.py') )</p>

<p>We should explicitly turn on unsat core support and use <i>assert_and_track()</i> instead of <i>add()</i> method, because this feature slows down the whole process.
That works:</p>

_PRE_BEGIN
 % python 2.py test_circular
unsat
[C0, C1]
_PRE_END

<p>Perhaps, these variables could be removed from the 2D array, marked as "unresolved" and the whole spreadsheet could be recalculated again.</p>

<p>The files: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/spreadsheet').</p>

<p>Other Z3-related examples: _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf').</p>

_BLOG_FOOTER()

