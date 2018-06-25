m4_include(`commons.m4')

_HEADER_HL1(`Kirchhoff’s circuit laws and Z3 SMT-solver')

<p>The circuit I've created on _HTML_LINK(`http://falstad.com/circuit/',`falstad.com'):</p>

<img src="kirk.png">

<p>Click here to open it on their website and run: _HTML_LINK_AS_IS(`http://tinyurl.com/y8raoud3').</p>

<p>The problem: find all 3 current values in 2 loops.
This is usually solved by solving a system of linear equations.</p>

<p>Overkill, but Z3 SMT-solver can be used here as well, since it can solve linear equations as well, over real numbers:</p>

_PRE_BEGIN
m4_include(`blog/kirchhoff/kirk.py')
_PRE_END

<p>And the result:</p>

_PRE_BEGIN
sat
[i3 = 11/3400, i1 = 3/3400, i2 = 1/425]
0.000882?
0.002352?
0.003235?
_PRE_END

<p>Same as on falstad.com online simulator.</p>

<p>Z3 represents real numbers as fractions, then we convert them to numerical form...</p>

<p>Further work: take a circuit as a graph and build a system of equations.</p>

_BLOG_FOOTER()

