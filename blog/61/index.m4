m4_include(`commons.m4')

_HEADER_HL1(`6-Apr-2011: ops_SIMD 0.3')

<p>Here is my third version of (so far) known fastest Oracle RDBMS hash cracker (DES based hashes):
_HTML_LINK_AS_IS(`http://conus.info/utils/ops_SIMD/')</p>

<p>Significant addition is <a href="http://en.wikipedia.org/wiki/Advanced_Vector_Extensions">AVX</a> support. This instruction set is available on new <a href="http://en.wikipedia.org/wiki/Sandy_Bridge">Intel Sandy Bridge CPUs</a>.
On entry-level Sandy Bridge CPUs (Intel Core i3 2100) I got 17-20 millions hashes per second (for SYS user) in AVX mode.
In old SSE2 mode, on the same CPU, I got 13-15 millions.</p>

<p>On quad core Intel Core i7 2600K it is possible to achive up to 40 millions hashes per second.</p>

<p>I decided to make it commercial. So, here is demo version, working only with SYS usernames. Price of PRO version allowing any username is fixed at USD 100.</p>

_BLOG_FOOTER_GITHUB(`61')

_BLOG_FOOTER()

