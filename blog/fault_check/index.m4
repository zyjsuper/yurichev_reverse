m4_include(`commons.m4')

_HEADER_HL1(`[Z3][SMT][Python][EE] Fault check of digital circuit: minimizing test set')

<p>Donald Knuth's TAOCP section 7.2.2.2 has the following exercise.</p>

<p>Given the circuit:</p>

<p><img src="circuit.png">

<p>Find a way to check, if it was soldered correclty, with no wires stuck at ground (always 0) or current (always 1).
You can just enumerate all possible inputs (5) and this will be a table of correct inputs/outputs, 32 pairs.
But you want to make fault check as fast as possible and minimize test set.</p>

<p>This is almost a problem I've been writing about: "Making smallest possible test suite using Z3":
_HTML_LINK_AS_IS(`https://yurichev.com/writings/SAT_SMT_by_example.pdf#page=250&zoom=auto,-266,710') (page 250).</p>

<p>We want such a test set, so that all gates' outputs will output 0 and 1, at least once.
And the test set should be as small, as possible.</p>

<p>The source code is very close to my previous example...</p>

_PRE_BEGIN
m4_include(`blog/fault_check/1.py')
_PRE_END

The output:

_PRE_BEGIN
m4_include(`blog/fault_check/out.txt')
_PRE_END

<p>This is it, you can test this circuit using just 3 test vectors: 01111, 10001 and 11011.</p>

<p>However, Donald Knuth's test set is bigger: 5 test vectors, but his algorithm also checks "fanout" gates (one input, multiple outputs), which also may be faulty.
I've omitted this for simplification.</p>

_BLOG_FOOTER()

