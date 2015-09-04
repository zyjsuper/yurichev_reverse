m4_include(`commons.m4')

_HEADER_HL1(`Yet another compiler anomaly; two solutions for exercises posted these days')

_HL2(`Yet another compiler anomaly to my collection')

<p>Just found in some old code:</p>

<!--
_PRE_BEGIN
                 fabs
                 fild    [esp+50h+var_34]
                 fabs
                 fxch    st(1) ; first instruction
                 fxch    st(1) ; second instruction
                 faddp   st(1), st
                 fcomp   [esp+50h+var_3C]
                 fnstsw  ax
                 test    ah, 41h
                 jz      short loc_100040B7
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#800000; font-weight:bold; '>fabs</span>
                 <span style='color:#800000; font-weight:bold; '>fild</span>    <span style='color:#808030; '>[</span><span style='color:#000080; '>esp</span><span style='color:#808030; '>+</span><span style='color:#008000; '>50h</span><span style='color:#808030; '>+</span>var_<span style='color:#008c00; '>34</span><span style='color:#808030; '>]</span>
                 <span style='color:#800000; font-weight:bold; '>fabs</span>
                 <span style='color:#800000; font-weight:bold; '>fxch</span>    <span style='color:#000080; '>st</span><span style='color:#808030; '>(</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span> <span style='color:#696969; '>; first instruction</span>
                 <span style='color:#800000; font-weight:bold; '>fxch</span>    <span style='color:#000080; '>st</span><span style='color:#808030; '>(</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span> <span style='color:#696969; '>; second instruction</span>
                 <span style='color:#800000; font-weight:bold; '>faddp</span>   <span style='color:#000080; '>st</span><span style='color:#808030; '>(</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>st</span>
                 <span style='color:#800000; font-weight:bold; '>fcomp</span>   <span style='color:#808030; '>[</span><span style='color:#000080; '>esp</span><span style='color:#808030; '>+</span><span style='color:#008000; '>50h</span><span style='color:#808030; '>+</span>var_3C<span style='color:#808030; '>]</span>
                 <span style='color:#800000; font-weight:bold; '>fnstsw</span>  <span style='color:#000080; '>ax</span>
                 <span style='color:#800000; font-weight:bold; '>test</span>    <span style='color:#000080; '>ah</span><span style='color:#808030; '>,</span> <span style='color:#008000; '>41h</span>
                 <span style='color:#800000; font-weight:bold; '>jz</span><span style='color:#800000; font-weight:bold; '>      short</span> <span style='color:#e34adc; '>loc_100040B7</span>
</pre>

<p>The firsst FXCH instruction swaps ST(0) and ST(1), the second do the same, so both do nothing.
This is a program uses MFC42.dll, so it could be MSVC 6.0, 5.0 or maybe even MSVC 4.2 from 1990s.</p>

<p>This pair do nothing, so it probably wasn't catched by MSVC compiler tests. Or maybe I wrong?</p>

<p>There are another compiler anomalies 
_HTML_LINK(`https://github.com/dennis714/RE-for-beginners/blob/3e16e8f3b56aefd69eb6fa931b04cc9a8a354b73/other/compiler_anomalies.tex',`in my book'),
or just open _HTML_LINK(`http://beginners.re/Reverse_Engineering_for_Beginners-en.pdf',`PDF') and then Ctrl-F "anomaly".</p>

<p>The reason I cite them is that sometimes practicing reverse engineers are stumbled by them while they should just ignore such quirks.</p>

_HL2(`Solution for the reverse engineering exercise posted at 22-Aug-2015')

_HTML_LINK(`http://yurichev.com/blog/2015-aug-22/',`Link to exercise')

<p>Spoiler warning! The text below has white color, select it using mouse to read the text (or press Ctrl-A):</p>

<p class="spoiler">The function counts bits set to 1. Also called as "population count" or 
<a href="https://en.wikipedia.org/wiki/Hamming_weight" class="spoiler">Hamming weight</a>.
It has no loops, which is better for CPUs starting at RISCs.</p>

<pre class="spoiler">
#include &lt;stdint.h>
#include &lt;stdio.h>

uint32_t f(uint32_t v)
{
	v = v - ((v >> 1) & 0x55555555);                    // reuse input as temporary
	v = (v & 0x33333333) + ((v >> 2) & 0x33333333);     // temp
	return ((v + (v >> 4) & 0xF0F0F0F) * 0x1010101) >> 24; // count
}

int main()
{
	printf ("%d\n", f(0x11111111));
	printf ("%d\n", f(0x22222222));
	printf ("%d\n", f(0xFFFFFFFF));
	printf ("%d\n", f(0));
};
</pre>

_HL2(`Solution for the reverse engineering exercise #5 posted at 23-Aug-2015')

_HTML_LINK(`http://yurichev.com/blog/exercise5/',`Link to exercise')

<p>Spoiler warning! The text below has white color, select it using mouse to read the text (or press Ctrl-A):</p>

<p class="spoiler">
The function is actually finds for a block inside another block and is called memmem().
It's non-standard, but Glibc has it.
<a href="http://linux.die.net/man/3/memmem" class="spoiler">http://linux.die.net/man/3/memmem</a>.
It is the same as strstr(), but ignores zero bytes.
My implementation is extremely ugly and slow, but smallest possible and has no external references, for the sake of exercise.
Real memmem() from Glibc is <a href="https://github.com/andikleen/glibc/blob/b0399147730d478ae45160051a8a0f00f91ef965/string/str-two-way.h" class="spoiler">much more complex</a>.
Nevertheless, practicing reverse engineers are no strangers to ugly and DIY-implemented algorithms.</p>

<pre class="spoiler">
#include &lt;stdint.h>

uint8_t *memmem (uint8_t *haystack, size_t haystack_size, uint8_t *needle, size_t needle_size)
{
	if (needle_size > haystack_size)
		return NULL;

	// may be optimized, probably...
	for (size_t i=0; i &lt; haystack_size - needle_size + 1; i++)
	{
		int fail=0;
		// compare
		for (size_t j=0; j &lt; needle_size; j++)
		{
			if (haystack[i+j]!=needle[i])
				fail=1;
		}
		if (fail==0)
			return haystack+i;
	};
	return NULL;
};
</pre>


_BLOG_FOOTER()

