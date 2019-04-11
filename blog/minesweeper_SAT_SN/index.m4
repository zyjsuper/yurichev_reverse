m4_include(`commons.m4')

_HEADER_HL1(`[Python][SAT] Cracking Minesweeper with SAT solver and sorting network')

<p>This is what I did before with Z3, see _HTML_LINK(`https://yurichev.com/writings/SAT_SMT_by_example.pdf',`here')
(Ctrl-F "Minesweeper").</p>

<p>_HTML_LINK(`https://github.com/DennisYurichev/SAT_SMT_by_example/blob/master/equations/minesweeper_SAT/minesweeper_SAT.py',`The SAT version of this program') used Mathematica-generated POPCNT functions.</p>

<p>Now what if I locked on a desert island again, with no Internet and Wolfram Mathematica?</p>

<p>Here is another way of solving it using SAT solver.
The main problem is to count bits around a cell.</p>

<p>_HTML_LINK(`https://yurichev.com/writings/SAT_SMT_by_example.pdf',`Here') I described sorting networks shortly.
They are popular in GPU, because they can be parallelized easily to work on multiple CPU cores.</p>

<p>They can be used for sorting boolean values.
01101 will become 00111, 10001 -> 00011, etc.
We will count bits using sorting network.</p>

<p>My implementation is a simplest "bubble sort" and not the one the most optimized I described earlier.
It's created recursively, as shown in _HTML_LINK(`https://en.wikipedia.org/wiki/Sorting_network',`Wikipedia'):</p>

<img src="288px-Recursive-bubble-sorting-network.png">

<p>The resulting 6-wire network is:</p>

<img src="257px-Six-wire-bubble-sorting-network.png">

<p>Now the comparator/swapper. How do we compare/swap two boolean variables, A and B?</p>

_PRE_BEGIN
A B out1 out2
0 0    0    0
0 1    0    1
1 0    0    1
1 1    1    1
_PRE_END

<p>As you can deduce effortlessly, out1 is just an AND, out2 is OR.</p>

<p>And here is all functions creating sorting network in my SAT_lib Python library:</p>

_PRE_BEGIN
    def sort_unit(self, a, b):
        return self.OR_list([a,b]), self.AND(a,b)

    def sorting_network_make_ladder(self, lst):
        if len(lst)==2:
            return list(self.sort_unit(lst[0], lst[1]))
    
        tmp=self.sorting_network_make_ladder(lst[1:]) # lst without head
        first, second=self.sort_unit(lst[0], tmp[0])
        return [first, second] + tmp[1:]

    def sorting_network(self, lst):
        # simplest possible, bubble sort
    
        if len(lst)==2:
            return self.sorting_network_make_ladder(lst)

        tmp=self.sorting_network_make_ladder(lst)
        return self.sorting_network(tmp[:-1]) + [tmp[-1]]
_PRE_END
<p>( _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/SAT_SMT_by_example/blob/master/libs/SAT_lib.py') )</p>

<p>Now if you will look closely on the output of sorting network, it looks like a thermometer, isn't it?
This is indeed "_HTML_LINK(`https://en.wikipedia.org/wiki/Unary_coding',`unary coding')", or "thermometer code",
where 1 is encoded as 1, 2 as 11... 4 as 1111, etc.
Who need such a wasteful code?
For 9 inputs/outputs, we can afford it so far.</p>

<p>In other words, sorting network is a device counting input bits and giving output in unary coding.</p>

<p>Also, we don't need to add 9 constraints for each variable.
Only two will suffice, one False and one True, because we are only interesting in the "level" of a thermometer.</p>

_PRE_BEGIN
def POPCNT(s, n, vars):
    sorted=s.sorting_network(vars)
    s.fix_always_false(sorted[n])
    if n!=0:
        s.fix_always_true(sorted[n-1])
_PRE_END

<p>And the whole source code:</p>

_PRE_BEGIN
m4_include(`blog/minesweeper_SAT_SN/minesweeper_SAT_lib_SN.py')
_PRE_END

<p>As before, this is a list of Minesweeper cells you can safely click on:</p>

_PRE_BEGIN
row=1, col=3, unsat!
row=6, col=2, unsat!
row=6, col=3, unsat!
row=7, col=4, unsat!
row=7, col=9, unsat!
row=8, col=9, unsat!
_PRE_END

<p>However, it works several times slower than the version with Mathematica-generated POPCNT functions, which is the fastest version so far...</p>

<p>Nevertheless, sorting networks has important place in SAT/SMT world.
By fixing a "level" of a thermometer using a single constraint, it's possible to add PB (pseudo-boolean) constraints, like, "x>=10"
(you need just to force a "level" to be always higher or equal than 10).</p>

_BLOG_FOOTER()

