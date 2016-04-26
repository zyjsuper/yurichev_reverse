m4_include(`commons.m4')

_HEADER_HL1(`19-Jan-2011: Oracle passwords (DES) solver updating to support AVX')

<p>New <a href="http://en.wikipedia.org/wiki/Advanced_Vector_Extensions">Advanced Vector Extensions (AVX)</a> x86 CPU extension is extending SIMD registers from 128 to 256 bits.</p>
<p>It is present now in Intel Sandy Bridge CPUs and will present is future AMD CPUs as well.</p>
<p>It is possible to make my <a href="http://conus.info/utils/ops_sse2/">Oracle passwords (DES) solver</a> working at double speed on these CPUs because of register extension.</p>
<p>But I need to test it before.</p>
<p>Does anybody have <a href="http://en.wikipedia.org/wiki/Sandy_Bridge_(microarchitecture)">Intel Sandy Bridge</a> hardware now? If yes, I would like to have Linux shell account to it and would update ops_sse2 to work with AVX.</p>
<p> -> <a href="mailto:dennis@conus.info">dennis@conus.info</a></p>

_BLOG_FOOTER_GITHUB(`60')

_BLOG_FOOTER()

