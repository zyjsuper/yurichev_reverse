m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #17 (for x64); solution for exercise #16')

_HL2(`Reverse engineering exercise #17 (for x64)')

<p>
This is quite esoteric piece of code, but nonetheless, the task it does is very mundane and well-known to anyone.
The function has 4 64-bit arguments and returns also 64-bit one.
What it does?
</p>

<p>Optimizing GCC 4.8.2:</p>

_PRE_BEGIN
f:
        sub     edx, edi
        mov     r8d, ecx
        mov     ecx, 63
        mov     eax, edx
        sub     r8d, esi
        sar     eax, cl
        and     eax, edx
        mov     edx, r8d
        sar     edx, cl
        add     edi, eax
        and     edx, r8d
        add     esi, edx
        sub     esi, edi
        mov     eax, esi
        sar     eax, cl
        and     eax, esi
        add     eax, edi
        ret
_PRE_END

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise18/')</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #16')

_HTML_LINK(`http://yurichev.com/blog/exercise16',`(Link to exercise)')

m4_include(`spoiler_show.inc')

<div id="example" class="hidden">

<p>The code just summing up all bytes in input buffer, but LLVM have done a great job in optimizing it into SSE2 code.</p>

<!-- <pre class="spoiler">
#include <stdint.h>
#include <stdio.h>

// just sum up all bytes
uint64_t f (uint8_t *src, size_t s)
{
	uint64_t rt=0;

	for (int i=0; i<s; i++)
		rt+=src[i];

	return rt;
};
</pre>
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdint.h</span><span style='color:#800000; '>></span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdio.h</span><span style='color:#800000; '>></span>

<span style='color:#696969; '>// just sum up all bytes</span>
uint64_t f <span style='color:#808030; '>(</span>uint8_t <span style='color:#808030; '>*</span>src<span style='color:#808030; '>,</span> <span style='color:#603000; '>size_t</span> s<span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
	uint64_t rt<span style='color:#808030; '>=</span><span style='color:#008c00; '>0</span><span style='color:#800080; '>;</span>

	<span style='color:#800000; font-weight:bold; '>for</span> <span style='color:#808030; '>(</span><span style='color:#800000; font-weight:bold; '>int</span> i<span style='color:#808030; '>=</span><span style='color:#008c00; '>0</span><span style='color:#800080; '>;</span> i<span style='color:#808030; '>&lt;</span>s<span style='color:#800080; '>;</span> i<span style='color:#808030; '>+</span><span style='color:#808030; '>+</span><span style='color:#808030; '>)</span>
		rt<span style='color:#808030; '>+</span><span style='color:#808030; '>=</span>src<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span><span style='color:#800080; '>;</span>

	<span style='color:#800000; font-weight:bold; '>return</span> rt<span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span><span style='color:#800080; '>;</span>
</pre>

m4_include(`spoiler_hide.inc')
</div>

_BLOG_FOOTER()
