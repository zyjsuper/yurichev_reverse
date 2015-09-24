m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #16 (for x64 SSE2); solution for exercise #15')

_HL2(`Reverse engineering exercise #16 (for x64 SSE2)')

<p>Now this is getting harder. Clang did a lot of optimization tricks and this code is heavily optimized for SSE2.
Nonetheless, the original function is tiny and simple.
What it does?</p>

<p>Optimizing clang 3.4, LLVM 3.4, Intel syntax:</p>

_PRE_BEGIN
f:                                      # @f
# BB#0:
        xor     eax, eax
        test    rsi, rsi
        je      .LBB0_8
# BB#1:                                 # %.lr.ph.preheader
        xor     ecx, ecx
        mov     rax, rsi
        and     rax, -4
        pxor    xmm0, xmm0
        pxor    xmm2, xmm2
        je      .LBB0_5
# BB#2:                                 # %vector.body.preheader
        pxor    xmm0, xmm0
        xor     ecx, ecx
        movdqa  xmm1, xmmword ptr [rip + .LCPI0_0]
        pxor    xmm2, xmm2
.LBB0_3:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
        movdqa  xmm3, xmm2
        movdqa  xmm4, xmm0
        movzx   edx, word ptr [rdi + rcx]
        movd    xmm0, edx
        pinsrw  xmm0, edx, 0
        movzx   edx, dh
        pinsrw  xmm0, edx, 4
        movzx   edx, word ptr [rdi + rcx + 2]
        movd    xmm2, edx
        pinsrw  xmm2, edx, 0
        movzx   edx, dh
        pinsrw  xmm2, edx, 4
        pand    xmm0, xmm1
        pand    xmm2, xmm1
        paddq   xmm0, xmm4
        paddq   xmm2, xmm3
        add     rcx, 4
        cmp     rax, rcx
        jne     .LBB0_3
# BB#4:
        mov     rcx, rax
.LBB0_5:                                # %middle.block
        paddq   xmm0, xmm2
        movdqa  xmm1, xmm0
        punpckhqdq      xmm1, xmm1      # xmm1 = xmm1[1,1]
        paddq   xmm1, xmm0
        movq    rax, xmm1
        cmp     rcx, rsi
        je      .LBB0_8
# BB#6:                                 # %.lr.ph.preheader11
        add     rdi, rcx
        sub     rsi, rcx
.LBB0_7:                                # %.lr.ph
                                        # =>This Inner Loop Header: Depth=1
        movzx   ecx, byte ptr [rdi]
        add     rax, rcx
        inc     rdi
        dec     rsi
        jne     .LBB0_7
.LBB0_8:                                # %._crit_edge
        ret

_PRE_END

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise17/')</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #15')

_HTML_LINK(`http://yurichev.com/blog/exercise15',`(Link to exercise)')

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">The code is simple memset(..., 0, 256).
It clears 256 bytes of the input block.
For small blocks, clang (and many other compilers as well), just generates series of clearing MOV instructions,
because this can be faster than calling another function (memset()).
If you'll increase 256 to 512, clang 4.3 will generate call to memset() instead.</p>

<pre class="spoiler">
#include &lt;stdint.h>

void f(uint8_t *a)
{
	for (int i=0; i&lt;256; i++)
		a[i]=0;
};
</pre>

_BLOG_FOOTER()
