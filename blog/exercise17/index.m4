m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #17 (for x64); solution for exercise #16')

_HL2(`Reverse engineering exercise #17 (for x64)')

<p>
This is quite esoteric piece of code, but nonetheless, the thing it does is very mundane.
The function has 4 arguments and returns one.
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

<p>Solution is to be posted soon...</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #16')

_HTML_LINK(`http://yurichev.com/blog/exercise16',`(Link to exercise)')

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">The code just summing up all bytes in input buffer, but LLVM have done a great job in optimizing it into SSE2 code.</p>

<pre class="spoiler">
#include &lt;stdint.h>
#include &lt;stdio.h>

// just sum up all bytes
uint64_t f (uint8_t *src, size_t s)
{
	uint64_t rt=0;

	for (int i=0; i&lt;s; i++)
		rt+=src[i];

	return rt;
};
</pre>

_BLOG_FOOTER()
