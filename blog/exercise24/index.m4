m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #24 (for x64, ARM, MIPS); solution for exercise #23')

_HL2(`Reverse engineering exercise #23 (for x64, ARM, ARM64, MIPS)')

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

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #23')

_HTML_LINK(`http://yurichev.com/blog/exercise23',`(Link to exercise)')

m4_include(`spoiler_show.inc')

<div id="example" class="hidden">

<p>
This code is vectorized (using general purpose registers instead of SSEx) strlen() function:
</p>

<!--
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <assert.h>

// copypasted from http://www.strchr.com/optimized_strlen_function and reworked for x64
size_t my_strlen(const char *s)
{
	size_t len = 0;
	for(;;)
	{
		uint64_t x = *(uint64_t*)s;
		if((x & 0xFF) == 0)
				return len;
		if((x & 0xFF00) == 0)
				return len + 1;
		if((x & 0xFF0000) == 0)
				return len + 2;
		if((x & 0xFF000000) == 0)
				return len + 3;
		if((x & 0xFF00000000) == 0)
				return len + 4;
		if((x & 0xFF0000000000) == 0)
				return len + 5;
		if((x & 0xFF000000000000) == 0)
				return len + 6;
		if((x & 0xFF00000000000000) == 0)
				return len + 7;
		s += 8, len += 8;
	}
}

int main()
{
	assert(my_strlen("a")==1);
	assert(my_strlen("aa")==2);
	assert(my_strlen("aaa")==3);
	assert(my_strlen("aaaa")==4);
	assert(my_strlen("aaaaa")==5);
	assert(my_strlen("aaaaaa")==6);
	assert(my_strlen("aaaaaaa")==7);
	assert(my_strlen("aaaaaaaa")==8);
	assert(my_strlen("aaaaaaaaa")==9);
	assert(my_strlen("aaaaaaaaaa")==10);
	assert(my_strlen("aaaaaaaaaaa")==11);
	assert(my_strlen("aaaaaaaaaaaa")==12);
	assert(my_strlen("aaaaaaaaaaaaa")==13);
	assert(my_strlen("aaaaaaaaaaaaaa")==14);
	assert(my_strlen("aaaaaaaaaaaaaaa")==15);
	assert(my_strlen("aaaaaaaaaaaaaaaa")==16);
	assert(my_strlen("aaaaaaaaaaaaaaaaa")==17);
	assert(my_strlen("aaaaaaaaaaaaaaaaaa")==18);
	assert(my_strlen("aaaaaaaaaaaaaaaaaaa")==19);
	assert(my_strlen("aaaaaaaaaaaaaaaaaaaa")==20);
	assert(my_strlen("aaaaaaaaaaaaaaaaaaaaa")==21);
	assert(my_strlen("aaaaaaaaaaaaaaaaaaaaaa")==22);
	assert(my_strlen("aaaaaaaaaaaaaaaaaaaaaaa")==23);
	assert(my_strlen("aaaaaaaaaaaaaaaaaaaaaaaa")==24);
	assert(my_strlen("aaaaaaaaaaaaaaaaaaaaaaaaa")==25);
	assert(my_strlen("aaaaaaaaaaaaaaaaaaaaaaaaaa")==26);
};
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdio.h</span><span style='color:#800000; '>></span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdint.h</span><span style='color:#800000; '>></span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdbool.h</span><span style='color:#800000; '>></span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdlib.h</span><span style='color:#800000; '>></span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>assert.h</span><span style='color:#800000; '>></span>

<span style='color:#696969; '>// copypasted from </span><span style='color:#5555dd; '>http://www.strchr.com/optimized_strlen_function</span><span style='color:#696969; '> and reworked for x64</span>
<span style='color:#603000; '>size_t</span> my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; font-weight:bold; '>const</span> <span style='color:#800000; font-weight:bold; '>char</span> <span style='color:#808030; '>*</span>s<span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
	<span style='color:#603000; '>size_t</span> len <span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#800080; '>;</span>
	<span style='color:#800000; font-weight:bold; '>for</span><span style='color:#808030; '>(</span><span style='color:#800080; '>;</span><span style='color:#800080; '>;</span><span style='color:#808030; '>)</span>
	<span style='color:#800080; '>{</span>
		uint64_t x <span style='color:#808030; '>=</span> <span style='color:#808030; '>*</span><span style='color:#808030; '>(</span>uint64_t<span style='color:#808030; '>*</span><span style='color:#808030; '>)</span>s<span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>x <span style='color:#808030; '>&amp;</span> <span style='color:#008000; '>0xFF</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
				<span style='color:#800000; font-weight:bold; '>return</span> len<span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>x <span style='color:#808030; '>&amp;</span> <span style='color:#008000; '>0xFF00</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
				<span style='color:#800000; font-weight:bold; '>return</span> len <span style='color:#808030; '>+</span> <span style='color:#008c00; '>1</span><span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>x <span style='color:#808030; '>&amp;</span> <span style='color:#008000; '>0xFF0000</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
				<span style='color:#800000; font-weight:bold; '>return</span> len <span style='color:#808030; '>+</span> <span style='color:#008c00; '>2</span><span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>x <span style='color:#808030; '>&amp;</span> <span style='color:#008000; '>0xFF000000</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
				<span style='color:#800000; font-weight:bold; '>return</span> len <span style='color:#808030; '>+</span> <span style='color:#008c00; '>3</span><span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>x <span style='color:#808030; '>&amp;</span> <span style='color:#008000; '>0xFF00000000</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
				<span style='color:#800000; font-weight:bold; '>return</span> len <span style='color:#808030; '>+</span> <span style='color:#008c00; '>4</span><span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>x <span style='color:#808030; '>&amp;</span> <span style='color:#008000; '>0xFF0000000000</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
				<span style='color:#800000; font-weight:bold; '>return</span> len <span style='color:#808030; '>+</span> <span style='color:#008c00; '>5</span><span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>x <span style='color:#808030; '>&amp;</span> <span style='color:#008000; '>0xFF000000000000</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
				<span style='color:#800000; font-weight:bold; '>return</span> len <span style='color:#808030; '>+</span> <span style='color:#008c00; '>6</span><span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>x <span style='color:#808030; '>&amp;</span> <span style='color:#008000; '>0xFF00000000000000</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
				<span style='color:#800000; font-weight:bold; '>return</span> len <span style='color:#808030; '>+</span> <span style='color:#008c00; '>7</span><span style='color:#800080; '>;</span>
		s <span style='color:#808030; '>+</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>8</span><span style='color:#808030; '>,</span> len <span style='color:#808030; '>+</span><span style='color:#808030; '>=</span> <span style='color:#008c00; '>8</span><span style='color:#800080; '>;</span>
	<span style='color:#800080; '>}</span>
<span style='color:#800080; '>}</span>

<span style='color:#800000; font-weight:bold; '>int</span> <span style='color:#400000; '>main</span><span style='color:#808030; '>(</span><span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>a</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>2</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>3</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>4</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>5</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>6</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>7</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>8</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>9</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>10</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>11</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>12</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>13</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>14</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>15</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>16</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>17</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>18</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>19</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>20</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>21</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>22</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>23</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>24</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>25</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	assert<span style='color:#808030; '>(</span>my_strlen<span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>aaaaaaaaaaaaaaaaaaaaaaaaaa</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>26</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span><span style='color:#800080; '>;</span>
</pre>

m4_include(`spoiler_hide.inc')
</div>

_BLOG_FOOTER_GITHUB(`exercise24')

_BLOG_FOOTER()

