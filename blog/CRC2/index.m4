m4_include(`commons.m4')

_HEADER_HL1(`Factorize GF(2)/CRC polynomials using Z3')

<p>GF(2)/CRC polynomials, like usual numbers, can also be factored, because a polynomial can be a product of two other polynomial (or not).</p>

<p>Some people say that good CRC polynomial should be irreducible (i.e., cannot be factored), some other say that this is not a requirement.
I've checked several CRC-16 and CRC-32 polynomials from _HTML_LINK(`https://en.wikipedia.org/wiki/Cyclic_redundancy_check',`the Wikipedia article').</p>

<p>The multiplier is constructed in the same manner, as I did it earlier for _HTML_LINK(`https://yurichev.com/blog/factor_SAT/',`integer factorization using SAT').
Factors are not prime integers, but prime polynomials.</p>

<p>Another important thing to notice is that replacing XOR with addition will make this script factor integers, because addition in GF(2) is XOR.</p>

<p>Also, can be used for tests, online GF(2) polynomials factorization: _HTML_LINK_AS_IS(`http://www.ee.unb.ca/cgi-bin/tervo/factor.pl?binary=101').</p>

_PRE_BEGIN
m4_include(`blog/CRC2/factor_GF2.py')
_PRE_END

( _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/CRC2/factor_GF2.py') )

_BLOG_FOOTER()

