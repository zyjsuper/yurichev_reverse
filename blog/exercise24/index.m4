m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #24 (for x64, ARM, MIPS)')

<p>
Here is a simplest possible calculator program, simplified version of _HTML_LINK(`https://en.wikipedia.org/wiki/Bc_%28programming_language%29',`bc UNIX utility'):
</p>

_PRE_BEGIN
123+456
(unsigned) dec: 579 hex: 0x243  bin: 1001000011
120/10
(unsigned) dec: 12 hex: 0xC  bin: 1100
-10
(unsigned) dec: 4294967286 hex: 0xFFFFFFF6  bin: 11111111111111111111111111110110
(signed) dec: -10 hex: -0xA  bin: -1010
-10+20
(unsigned) dec: 10 hex: 0xA  bin: 1010
_PRE_END

<p>It is known that it supports 4 arithmetic operations and negative numbers can be denoted with minus before the number.
But it's also known that there are at least 7 undocumented features.
Try to find them all.</p>

<ul>
<li> _HTML_LINK(`http://yurichev.com/blog/exercise24/files/calc_linux_x64.tar',`GCC 4.8.2 for Linux x64')
<li> _HTML_LINK(`http://yurichev.com/blog/exercise24/files/calc_MIPS.tar',`GCC 4.4.5 for MIPS')
<li> _HTML_LINK(`http://yurichev.com/blog/exercise24/files/calc_ARM_Raspberry.tar',`GCC 4.6.3 for ARM (Raspberry Pi)')
<li> _HTML_LINK(`http://yurichev.com/blog/exercise24/files/calc_MSVC2013.exe',`MSVC 2013, Windows x64')
</ul>

<p>Solution is to be posted soon...</p>
<!-- <p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise25/')</p> -->

_BLOG_FOOTER_GITHUB(`exercise24')

_BLOG_FOOTER()

