m4_include(`commons.m4')

_HEADER_HL1(`Finding three 10*10 mutually orthogonal latin squares using Z3: criticism wanted')

<p>About latin squares:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Latin_square'),
_HTML_LINK_AS_IS(`http://mathworld.wolfram.com/LatinSquare.html').</p>

<p>About mutually orthogonal latin squares:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Graeco-Latin_square').</p>

<p>Mention that three 10*10 MOLS (mutually orthogonal latin squares) is an open problem:
_HTML_LINK_AS_IS(`https://math.stackexchange.com/questions/649548/find-three-10-times10-orthogonal-latin-squares').</p>

<p>In Knuth's TAOCP Vol.4 (fasc0a.ps) we can find this problem with maximal score (50):</p>

_PRE_BEGIN
15. [50] Find three 10*10 latin squares that are mutually orthogonal to each other.
_PRE_END

<p>( _HTML_LINK_AS_IS(`http://www.cs.utsa.edu/~wagner/knuth/fasc0a.pdf'), _HTML_LINK_AS_IS(`http://www-cs-faculty.stanford.edu/~uno/fasc0a.ps.gz') )</p>

<p>I've tried to find 3 squares using relatively simple program, and found this.
10 is replaced by hexadecimal A for visual compactness:</p>

_PRE_BEGIN
m4_include(`blog/latin/solution.txt')
_PRE_END

_PRE_BEGIN
m4_include(`blog/latin/latin3.py')
_PRE_END

<p>Works relatively fast, 1.5 minutes on my ancient Intel Atom 1.5 GHz netbook.</p>

<p>The files: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/latin').</p>

<p><b>So am I wrong somewhere or not? Is there a mistake somewhere?</b></p>

_BLOG_FOOTER()

