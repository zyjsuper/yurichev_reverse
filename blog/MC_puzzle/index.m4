m4_include(`commons.m4')

_HEADER_HL1(`Multiple choice logic puzzle, and solving it using SAT/SMT solvers')

<p>I've found this logic puzzle.
Source is probably Ross Honsberger's "More Mathematical Morsels (Dolciani Mathematical Expositions)" book:</p>

_PRE_BEGIN
A certain question has the following possible answers.

    a. All of the below
    b. None of the below
    c. All of the above
    d. One of the above
    e. None of the above
    f. None of the above

Which answer is correct?
_PRE_END

<p>Cited from: _HTML_LINK_AS_IS(`https://www.johndcook.com/blog/2015/07/06/multiple-choice/').</p>

<p>This problem can be easily represented as a system of equations.
Let's try to solve it using Z3:</p>

_PRE_BEGIN
m4_include(`blog/MC_puzzle/mc.py')
_PRE_END

<p>The answer:</p>

_PRE_BEGIN
sat
[f = False,
 b = False,
 a = False,
 c = False,
 d = False,
 e = True]
_PRE_END

<p>I can also rewrite this in SMT-LIB v2 form:</p>

_PRE_BEGIN
m4_include(`blog/MC_puzzle/mc.smt2')
_PRE_END

<p>The problem is easy enough to be solved using my _HTML_LINK(`https://github.com/DennisYurichev/MK85',`toy-level MK85 SMT-solver'):</p>

_PRE_BEGIN
sat
(model
        (define-fun a () Bool false)
        (define-fun b () Bool false)
        (define-fun c () Bool false)
        (define-fun d () Bool false)
        (define-fun e () Bool true)
        (define-fun f () Bool false)
)
_PRE_END

<p>Now let's have fun and see how my solver tackles this example.
What internal variables it creates?</p>

_PRE_BEGIN
$ ./MK85 --dump-internal-variables mc.smt2
m4_include(`blog/MC_puzzle/dbg1.txt')
_PRE_END

<p>What is in resulting CNF file to be fed into the external minisat SAT-solver?</p>

_PRE_BEGIN
m4_include(`blog/MC_puzzle/tmp.cnf')
_PRE_END

<p>Here are comments (starting with "c " prefix), and my SMT-solver indicate, how each low-level logical gate is added,
its inputs (variable IDs and numbers) and outputs.</p>

<p>Let's filter comments:</p>

_PRE_BEGIN
$ cat tmp.cnf | grep "^c "

m4_include(`blog/MC_puzzle/tmp.cnf.comments')
_PRE_END

<p>Now you can juxtapose list of internal variables and comments in CNF file.
For example, equality gate is generated as NOT(XOR(a,b)).</p>

<p>create_assert() function fixes a bool variable to always be True.</p>

<p>Other (internal) variables are added by SMT solver as "joints" to connect logic gates with each other.</p>

<p>Hence, my SMT solver constructing a digital circuit based on the input SMT file.
Logic gates are then converted into CNF form using _HTML_LINK(`https://en.wikipedia.org/wiki/Tseytin_transformation',`Tseitin transformations').
The task of SAT solver is then to find such an assignment, for which CNF expression would be true.
In other words, its task is to find such inputs/outputs for which this "virtual" digital circuit would work
without contradictions.</p>

<p>The SAT instance is also small enough to be solved using _HTML_LINK(`https://github.com/DennisYurichev/SAT_SMT_article/blob/master/SAT/backtrack/SAT_backtrack.py',`my simplest SAT solver written in ~120 lines of Python'):</p>

_PRE_BEGIN
$ ./SAT_backtrack.py tmp.cnf

SAT
-1 2 -3 -4 -5 -6 7 -8 -9 -10 -11 -12 -13 14 15 16 17 -18 -19 20 -21 -22 23 -24 -25 26 27 -28 29 -30 31 -32 33 -34 -35 36 37 38 -39 -40 -41 42 43 44 45 46 47 48 49 -50 51 52 53 54 55 56 57 58 -59 -60 -61 62 0
UNSAT
solutions= 1
_PRE_END

<p>You can juxtapose variables from solver's result and variable numbers from MK85 listing.
Therefore, MK85 + my small SAT solver is standalone program under ~2000 SLOC, which still can solve such (simple enough) system of boolean equations, without external aid like minisat.</p>

<hr>

<p>Among _HTML_LINK(`https://www.johndcook.com/blog/2015/07/06/multiple-choice/',`comments') in the John D. Cook's blog, there is also a solution by Aaron Meurer, using SymPy,
which also has SAT-solver inside:</p>

_PRE_BEGIN
7 July 2015 at 01:34

Decided to run this through SymPy’s SAT solver.

In [1]: var(‘a b c d e f’)
Out[1]: (a, b, c, d, e, f)

In [2]: facts = [
Equivalent(a, (b & c & d & e & f)),
Equivalent(b, (~c & ~d & ~e & ~f)),
Equivalent(c, a & b),
Equivalent(d, ((a & ~b & ~c) | (~a & b & ~c) | (~a & ~b & c))),
Equivalent(e, (~a & ~b & ~c & ~d)),
Equivalent(f, (~a & ~b & ~c & ~d & ~e)),
]

In [3]: list(satisfiable(And(*facts), all_models=True))
Out[3]: [{e: True, c: False, b: False, a: False, f: False, d: False}]

So it seems e is the only answer, assuming I got the facts correct. And it is important to use Equivalent (a bidirectional implication) rather than just Implies. If you only use -> (which I guess would mean that an answer not being chosen doesn’t necessarily mean that it isn’t true), then ‘none’, b, and f are also “solutions”.

Also, if I replace the d fact with Equivalent(d, a | b | c), the result is the same. So it seems that the interpretation of “one” both in terms of choice d and in terms of how many choices there are is irrelevant.

Thanks for the fun problem. I hope others took the time to solve this in their head before reading the comments.
_PRE_END

_FOOTER()

