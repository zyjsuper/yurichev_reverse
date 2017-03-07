m4_include(`commons.m4')

_HEADER_HL1(`7-Mar-2017: Cracking Minesweeper with SAT solver')

<p>(Previously: _HTML_LINK_AS_IS(`https://yurichev.com/blog/minesweeper/').)</p>

<p>SAT solvers are very different in that sense that they are at low-level, and can take only CNF expressions on input.
I wrote a very short intro into SAT, right at the beginning of the following article: _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf'), which you can skim quickly before proceeding to the rest of this blog post.</p>

_HL2(`Simple population count function')

<p>First of all, somehow we need to count neighbour bombs.
The counting function is very similar to <i>population count</i> function.</p>

<p>We can try to make CNF expression in Wolfram Mathematica.
This will be a function, returning True if any of 2 bits of 8 inputs bits are True and others are False.
First, we make truth table of such function:</p>

_PRE_BEGIN
In[]:= tbl2 = 
 Table[PadLeft[IntegerDigits[i, 2], 8] -> 
   If[Equal[DigitCount[i, 2][[1]], 2], 1, 0], {i, 0, 255}]

Out[]= {{0, 0, 0, 0, 0, 0, 0, 0} -> 0, {0, 0, 0, 0, 0, 0, 0, 1} -> 0, 
{0, 0, 0, 0, 0, 0, 1, 0} -> 0, {0, 0, 0, 0, 0, 0, 1, 1} -> 1, 
{0, 0, 0, 0, 0, 1, 0, 0} -> 0, {0, 0, 0, 0, 0, 1, 0, 1} -> 1, 
{0, 0, 0, 0, 0, 1, 1, 0} -> 1, {0, 0, 0, 0, 0, 1, 1, 1} -> 0, 
{0, 0, 0, 0, 1, 0, 0, 0} -> 0, {0, 0, 0, 0, 1, 0, 0, 1} -> 1, 
{0, 0, 0, 0, 1, 0, 1, 0} -> 1, {0, 0, 0, 0, 1, 0, 1, 1} -> 0, 
...
{1, 1, 1, 1, 1, 0, 1, 0} -> 0, {1, 1, 1, 1, 1, 0, 1, 1} -> 0, 
{1, 1, 1, 1, 1, 1, 0, 0} -> 0, {1, 1, 1, 1, 1, 1, 0, 1} -> 0, 
{1, 1, 1, 1, 1, 1, 1, 0} -> 0, {1, 1, 1, 1, 1, 1, 1, 1} -> 0}
_PRE_END

<p>Now we can make CNF expression using this truth table:</p>

_PRE_BEGIN
In[]:= BooleanConvert[
 BooleanFunction[tbl2, {a, b, c, d, e, f, g, h}], "CNF"]

Out[]= (! a || ! b || ! c) && (! a || ! b || ! d) && (! a || ! 
    b || ! e) && (! a || ! b || ! f) && (! a || ! b || ! g) && (! 
    a || ! b || ! h) && (! a || ! c || ! d) && (! a || ! c || ! 
    e) && (! a || ! c || ! f) && (! a || ! c || ! g) && (! a || ! 
    c || ! h) && (! a || ! d || ! e) && (! a || ! d || ! f) && (! 
    a || ! d || ! g) && (! a || ! d || ! h) && (! a || ! e || ! 
    f) && (! a || ! e || ! g) && (! a || ! e || ! h) && (! a || ! 
    f || ! g) && (! a || ! f || ! h) && (! a || ! g || ! h) && (a || 
   b || c || d || e || f || g) && (a || b || c || d || e || f || 
   h) && (a || b || c || d || e || g || h) && (a || b || c || d || f ||
    g || h) && (a || b || c || e || f || g || h) && (a || b || d || 
   e || f || g || h) && (a || c || d || e || f || g || 
   h) && (! b || ! c || ! d) && (! b || ! c || ! e) && (! b || ! 
    c || ! f) && (! b || ! c || ! g) && (! b || ! c || ! h) && (! 
    b || ! d || ! e) && (! b || ! d || ! f) && (! b || ! d || ! 
    g) && (! b || ! d || ! h) && (! b || ! e || ! f) && (! b || ! 
    e || ! g) && (! b || ! e || ! h) && (! b || ! f || ! g) && (! 
    b || ! f || ! h) && (! b || ! g || ! h) && (b || c || d || e || 
   f || g || 
   h) && (! c || ! d || ! e) && (! c || ! d || ! f) && (! c || ! 
    d || ! g) && (! c || ! d || ! h) && (! c || ! e || ! f) && (! 
    c || ! e || ! g) && (! c || ! e || ! h) && (! c || ! f || ! 
    g) && (! c || ! f || ! h) && (! c || ! g || ! h) && (! d || ! 
    e || ! f) && (! d || ! e || ! g) && (! d || ! e || ! h) && (! 
    d || ! f || ! g) && (! d || ! f || ! h) && (! d || ! g || ! 
    h) && (! e || ! f || ! g) && (! e || ! f || ! h) && (! e || ! 
    g || ! h) && (! f || ! g || ! h)
_PRE_END

<p>The syntax is similar to C/C++.
Let's check it.</p>

<p>I wrote a Python function to convert Mathematica's output into CNF file which can be feeded to SAT solver:</p>

_PRE_BEGIN
m4_include(`blog/minesweeper_SAT/tst.py')
_PRE_END

<p>It replaces a/b/c/... variables to the variable names passed (1/2/3...), reworks syntax, etc.
Here is a result:</p>

_PRE_BEGIN
m4_include(`blog/minesweeper_SAT/tst1.cnf')
_PRE_END

<p>I can run it:</p>

_PRE_BEGIN
% minisat -verb=0 tst1.cnf results.txt
WARNING: for repeatability, setting FPU to use double precision
SATISFIABLE

% cat results.txt
SAT
1 -2 -3 -4 -5 -6 -7 8 0
_PRE_END

<p>The variable name in results lacking minus sign is "True".
Variable name with minus sign is "False".
We see there are just two variables are "True": 1 and 8.
This is indeed correct: MiniSat solver found a condition, for which our function returns "True".
Zero at the end is just a terminal symbol which means nothing.</p>

<p>We can ask MiniSat for another solution, by adding current solution to the input CNF file, but with all variables negated:</p>

_PRE_BEGIN
...
-5 -6 -8 0
-5 -7 -8 0
-6 -7 -8 0
-1 2 3 4 5 6 7 -8 0
_PRE_END

<p>In plain English language, this means "give me ANY solution which can satisfy all clauses, but also not equal to the last clause we've just added".</p>

<p>MiniSat, indeed, found another solution, again, with only 2 variables equal to "True":</p>

_PRE_BEGIN
% minisat -verb=0 tst2.cnf results.txt
WARNING: for repeatability, setting FPU to use double precision
SATISFIABLE

% cat results.txt
SAT
1 2 -3 -4 -5 -6 -7 -8 0
_PRE_END

<p>By the way, <i>population count</i> function for 8 neighbours in CNF form is simplest:</p>

_PRE_BEGIN
a&&b&&c&&d&&e&&f&&g&&h
_PRE_END

<p>Indeed: it's true if all 8 input bits are "True".</p>

<p>The function for 0 neighbours is also simple:</p>

_PRE_BEGIN
!a&&!b&&!c&&!d&&!e&&!f&&!g&&!h
_PRE_END

<p>It means, it will return "True", if all input variables are "False".</p>

<p>And yes, you can ask Mathematica for finding CNF expressions for any other truth table.</p>

_HL2(`Minesweeper')

<p>Now we can use Mathematica to get all <i>population count</i> functions for 0..8 neighbours.</p>

<p>For 9*9 Minesweeper grid including invisible border, there will be 11*11=121 variables, mapped to Minesweeper grid like this:</p>

_PRE_BEGIN
 1    2   3   4   5   6   7   8   9  10  11
12   13  14  15  16  17  18  19  20  21  22
23   24  25  26  27  28  29  30  31  32  33
34   35  36  37  38  39  40  41  42  43  44

...

100 101 102 103 104 105 106 107 108 109 110
111 112 113 114 115 116 117 118 119 120 121
_PRE_END

<p>Then we write a Python script which stacks all <i>population count</i> functions: each function for each known number of neighbours (digit on Minesweeper field).
Each POPCNTx() function takes list of variable numbers and outputs list of clauses to be added to the final CNF file.</p>

<p>As of empty cells, we also add them as clauses, but with minus sign, which means, the variable must be False.
Whenever we try to place bomb, we add its variable as clause without minus sign, this means the variable must be True.</p>

<p>Then we execute external minisat process.
The only thing we need from it is exit code.
If an input CNF is UNSAT, it returns 20:</p>

_PRE_BEGIN
m4_include(`blog/minesweeper_SAT/minesweeper_SAT.py')
_PRE_END

<p>The output CNF file can be large, up to ~2000 clauses, or more, here is an example: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/minesweeper_SAT/sample.cnf').</p>

<p>Anyway, it works just like my previous Z3Py script:</p>

_PRE_BEGIN
row=1, col=3, unsat!
row=6, col=2, unsat!
row=6, col=3, unsat!
row=7, col=4, unsat!
row=7, col=9, unsat!
row=8, col=9, unsat!
_PRE_END

<p>... but it runs way faster, even considering overhead of executing external program.
Perhaps, Z3Py version could be optimized much better?</p>

<p>The files, including Wolfram Mathematica notebook: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/minesweeper_SAT').</p>

_BLOG_FOOTER()

