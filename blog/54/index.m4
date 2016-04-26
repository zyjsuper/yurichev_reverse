m4_include(`commons.m4')

_HEADER_HL1(`10-Oct-2010: Oracle passwords (DES) solver 0.2 (SSE2)')

<p>A second version of Oracle (DES) passwords cracker is published.</p>

<p><a href="http://blog.yurichev.com/node/45">Here is old blog post about first version</a>.</p>

<p>Changes are:</p>

<p>* Enlist all usernames and passwords in a text file:</p>

_PRE_BEGIN
uname:password:SID_or_comment
_PRE_END

<p>Now ops_sse2 is able to check several hashes for specific username simultaneously. For example, if you have a list consisting of X hashes for username SYS and Y hashes for username SYSTEM, there will be only two passes. It is possible because significant amount of work is to generate all hashes for all possible passwords, but checking generated hash value against to what is defined in list, is not very costly.</p>

<p>* Set minimum and maximum password length.</p>

<p>* Define charset and define first symbol charset. </p>

<p>Usually, first password character is in A..Z limits, but Alexander Kornbrust <a href="http://blog.red-database-security.com/2009/12/06/dennis-yurichev-wrote-an-article-about-his-fpga-oracle-password-cracker/">noted</a> that it is possible to set a password with a digit as first character. So, if you would like to check such passwords, now it is possible to define charsets explicitly.</p>

<p>* Itanium support is absent in this version so far.</p>

<p>Win32 / Linux executables, source code:</p>

<p>_HTML_LINK_AS_IS(`http://conus.info/utils/ops_SIMD/')</p>

_BLOG_FOOTER_GITHUB(`54')

_BLOG_FOOTER()

