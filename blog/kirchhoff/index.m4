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

_HL2(`Gaussian elimination')

<p>SMT-solver is overkill, these linear equations can be solved using simple and well-known Gaussian elimination.</p>

<p>First, we rewrite the system of equation:</p>

_PRE_BEGIN
   i1 +    i2 -    i3 == 0
R1*i1 +         R3*i3 == V1
        R2*i2 + R3*i3 == V2
_PRE_END

<p>Or in matrix form:</p>

_PRE_BEGIN
[ 1,    1,    -1    | 0  ]
[ 2000, 0,    1000  | 5  ]
[ 0,    5000, 1000  | 15 ]
_PRE_END

<p>I can solve it using Wolfram Mathematica, using _HTML_LINK(`http://reference.wolfram.com/language/ref/RowReduce.html',`RowReduce'):</p>

_PRE_BEGIN
In[1]:= RowReduce[{{1, 1, -1, 0}, {2000, 0, 1000, 5}, {0, 5000, 1000, 15}}]
Out[1]= {{1,0,0,3/3400},{0,1,0,1/425},{0,0,1,11/3400}}

In[2]:= 3/3400//N
Out[2]= 0.000882353

In[3]:= 1/425//N
Out[3]= 0.00235294

In[4]:= 11/3400//N
Out[4]= 0.00323529
_PRE_END

<p>This is the same result: i1, i2 and i3 in numerical form.</p>

<p>ReduceRow output is:</p>

_PRE_BEGIN
[ 1,0,0 | 3/3400  ]
[ 0,1,0 | 1/425   ]
[ 0,0,1 | 11/3400 ]
_PRE_END

<p>... back to expressions, this is:</p>

_PRE_BEGIN
1*i1 + 0*i2 + 0*i3 = 3/3400
0*i1 + 1*i2 + 0*i3 = 1/425
0*i1 + 0*i2 + 1*i3 = 11/3400
_PRE_END

<p>In other words, this is just what i1/i2/i3 are.</p>

<p>Now something down-to-earth, C example I've copypasted from 
_HTML_LINK(`https://rosettacode.org/wiki/Gaussian_elimination#C',`Rosetta Code'),
working with no additional libraries, etc:</p>

_PRE_BEGIN
// copypasted from https://rosettacode.org/wiki/Gaussian_elimination#C

#include &lt;stdio.h>
#include &lt;stdlib.h>
#include &lt;math.h>
 
#define mat_elem(a, y, x, n) (a + ((y) * (n) + (x)))
 
void swap_row(double *a, double *b, int r1, int r2, int n)
{
	double tmp, *p1, *p2;
	int i;
 
	if (r1 == r2) return;
	for (i = 0; i < n; i++) {
		p1 = mat_elem(a, r1, i, n);
		p2 = mat_elem(a, r2, i, n);
		tmp = *p1, *p1 = *p2, *p2 = tmp;
	}
	tmp = b[r1], b[r1] = b[r2], b[r2] = tmp;
}
 
void gauss_eliminate(double *a, double *b, double *x, int n)
{
#define A(y, x) (*mat_elem(a, y, x, n))
	int i, j, col, row, max_row,dia;
	double max, tmp;
 
	for (dia = 0; dia < n; dia++) {
		max_row = dia, max = A(dia, dia);
 
		for (row = dia + 1; row < n; row++)
			if ((tmp = fabs(A(row, dia))) > max)
				max_row = row, max = tmp;
 
		swap_row(a, b, dia, max_row, n);
 
		for (row = dia + 1; row < n; row++) {
			tmp = A(row, dia) / A(dia, dia);
			for (col = dia+1; col < n; col++)
				A(row, col) -= tmp * A(dia, col);
			A(row, dia) = 0;
			b[row] -= tmp * b[dia];
		}
	}
	for (row = n - 1; row >= 0; row--) {
		tmp = b[row];
		for (j = n - 1; j > row; j--)
			tmp -= x[j] * A(row, j);
		x[row] = tmp / A(row, row);
	}
#undef A
}

int main(void)
{
	double a[] = {
		1, 1, -1, 
		2000, 0, 1000,
		0, 5000, 1000
	};
	double b[] = { 0, 5, 15 };
	double x[3];
	int i;
 
	gauss_eliminate(a, b, x, 3);
 
	for (i = 0; i < 3; i++)
		printf("%g\n", x[i]);
 
	return 0;
}
_PRE_END

<p>I run it:</p>

_PRE_BEGIN
0.000882353
0.00235294
0.00323529
_PRE_END

<p>See also: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Gaussian_elimination'),
_HTML_LINK_AS_IS(`http://mathworld.wolfram.com/GaussianElimination.html').</p>

<p>But a fun with SMT solver is that we can solve these equations without any knowledge of linear algebra, matrices,
Gaussian elimination and whatnot.</p>

<p>According to the source code of Z3, it can perform Gaussian Elimination, perhaps, whenever it can do so.</p>

_BLOG_FOOTER()

