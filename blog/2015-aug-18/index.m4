m4_include(`commons.m4')

_HEADER_HL1(`18-Aug-2015: Solution for the exercise posted at 15 August; the next reverse engineering exercise (for x86, ARM, ARM64, MIPS)')

_HL2(`Solution for the exercise posted at 13 August')

<p>Link to exercise: _HTML_LINK_AS_IS(`http://yurichev.com/blog/2015-aug-15/').</p>

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">The code I used here is copypasted from the Linux kernel <a href=https://github.com/torvalds/linux/blob/de182468d1bb726198abaab315820542425270b7/include/linux/bitrev.h" class="spoiler">(from there)</a> and is used to reverse order of bits in 32-bit value.
While naïve method to solve this is to make a loop and toggle bits, this algorithm is better, because it hasn't conditional branches,
which is good for CPUs starting at RISC.
</p>

<p style="color: white;">
<pre class="spoiler">
#include &lt;stdint.h&gt;
#include &lt;stdio.h&gt;

uint32_t bitrev32(uint32_t x)
{
        uint32_t __x = x;
        __x = (__x &gt;&gt; 16) | (__x &lt;&lt; 16);
        __x = ((__x & (uint32_t)0xFF00FF00UL) &gt;&gt; 8) | ((__x & (uint32_t)0x00FF00FFUL) &lt;&lt; 8);
        __x = ((__x & (uint32_t)0xF0F0F0F0UL) &gt;&gt; 4) | ((__x & (uint32_t)0x0F0F0F0FUL) &lt;&lt; 4);
        __x = ((__x & (uint32_t)0xCCCCCCCCUL) &gt;&gt; 2) | ((__x & (uint32_t)0x33333333UL) &lt;&lt; 2);
        __x = ((__x & (uint32_t)0xAAAAAAAAUL) &gt;&gt; 1) | ((__x & (uint32_t)0x55555555UL) &lt;&lt; 1);
        return __x;
}

int main()
{
        for (int i=0; i<32; i++)
                printf ("%08X\n", bitrev32(1&lt;&lt;i));
};
</pre>
</p>

<p class="spoiler">
The function is used in Linux kernel mostly in drivers, here are examples:
<a href="https://github.com/torvalds/linux/search?utf8=%E2%9C%93&q=bitrev32" class="spoiler">bitrev32()</a>
<a href="https://github.com/torvalds/linux/search?utf8=%E2%9C%93&q=bitrev16" class="spoiler">bitrev16()</a>
<a href="https://github.com/torvalds/linux/search?utf8=%E2%9C%93&q=bitrev8" class="spoiler">bitrev8()</a>
</p>

_HL2(`The next reverse engineering exercise (for x86, ARM, ARM64, MIPS)')

<p>What this code does? The function has array of 64 32-bit integers, I removed it in each assembly code snippet to save space.
The array is:</p>

<!--
_PRE_BEGIN
int v[64]=
	{ -1,31, 8,30, -1, 7,-1,-1, 29,-1,26, 6, -1,-1, 2,-1,
	  -1,28,-1,-1, -1,19,25,-1, 5,-1,17,-1, 23,14, 1,-1,
	   9,-1,-1,-1, 27,-1, 3,-1, -1,-1,20,-1, 18,24,15,10,
	  -1,-1, 4,-1, 21,-1,16,11, -1,22,-1,12, 13,-1, 0,-1 };
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#800000; font-weight:bold; '>int</span> v<span style='color:#808030; '>[</span><span style='color:#008c00; '>64</span><span style='color:#808030; '>]</span><span style='color:#808030; '>=</span>
	<span style='color:#800080; '>{</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>31</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>8</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>30</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>7</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>29</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>26</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>6</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>2</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span>
	  <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>28</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>19</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>25</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>5</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>17</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>23</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>14</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span>
	   <span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>27</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>3</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>20</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>18</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>24</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>15</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>10</span><span style='color:#808030; '>,</span>
	  <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>4</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>21</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>16</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>11</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>22</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>12</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>13</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span> <span style='color:#800080; '>}</span><span style='color:#800080; '>;</span>
</pre>

<p>The algorithm is well-known, but I've changed constant so it wouldn't be googleable.</p>

<p>Optimizing GCC 4.8.2:</p>

<!--
_PRE_BEGIN
f:
	mov	edx, edi
	shr	edx
	or	edx, edi
	mov	eax, edx
	shr	eax, 2
	or	eax, edx
	mov	edx, eax
	shr	edx, 4
	or	edx, eax
	mov	eax, edx
	shr	eax, 8
	or	eax, edx
	mov	edx, eax
	shr	edx, 16
	or	edx, eax
	imul	eax, edx, 79355661 ; 0x4badf0d
	shr	eax, 26
	mov	eax, DWORD PTR v[0+rax*4]
	ret
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>f:</span>
	<span style='color:#800000; font-weight:bold; '>mov</span>	<span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>edi</span>
	<span style='color:#800000; font-weight:bold; '>shr</span>	<span style='color:#000080; '>edx</span>
	<span style='color:#800000; font-weight:bold; '>or</span>	<span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>edi</span>
	<span style='color:#800000; font-weight:bold; '>mov</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>edx</span>
	<span style='color:#800000; font-weight:bold; '>shr</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>2</span>
	<span style='color:#800000; font-weight:bold; '>or</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>edx</span>
	<span style='color:#800000; font-weight:bold; '>mov</span>	<span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>eax</span>
	<span style='color:#800000; font-weight:bold; '>shr</span>	<span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>4</span>
	<span style='color:#800000; font-weight:bold; '>or</span>	<span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>eax</span>
	<span style='color:#800000; font-weight:bold; '>mov</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>edx</span>
	<span style='color:#800000; font-weight:bold; '>shr</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>8</span>
	<span style='color:#800000; font-weight:bold; '>or</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>edx</span>
	<span style='color:#800000; font-weight:bold; '>mov</span>	<span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>eax</span>
	<span style='color:#800000; font-weight:bold; '>shr</span>	<span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>16</span>
	<span style='color:#800000; font-weight:bold; '>or</span>	<span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>eax</span>
	<span style='color:#800000; font-weight:bold; '>imul</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>79355661</span> <span style='color:#696969; '>; 0x4badf0d</span>
	<span style='color:#800000; font-weight:bold; '>shr</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>26</span>
	<span style='color:#800000; font-weight:bold; '>mov</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>DWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> v<span style='color:#808030; '>[</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>+</span>rax<span style='color:#808030; '>*</span><span style='color:#008c00; '>4</span><span style='color:#808030; '>]</span>
	<span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>Optimizing GCC 4.9.3 for ARM64:</p>

<!--
_PRE_BEGIN
<f>:
   0:           orr     w0, w0, w0, lsr #1
   4:           mov     w1, #0xdf0d                     // #57101
   8:           movk    w1, #0x4ba, lsl #16
   c:           orr     w0, w0, w0, lsr #2
  10:           orr     w0, w0, w0, lsr #4
  14:           orr     w0, w0, w0, lsr #8
  18:           orr     w0, w0, w0, lsr #16
  1c:           mul     w0, w0, w1
  20:           adrp    x1, 0 <f>
  24:           add     x1, x1, #0x0
  28:           lsr     w0, w0, #26
  2c:           ldr     w0, [x1,w0,uxtw #2]
  30:           ret
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>           orr     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> lsr #<span style='color:#008c00; '>1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     w1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0xdf0d</span>                     <span style='color:#808030; '>/</span><span style='color:#808030; '>/</span> #<span style='color:#008c00; '>57101</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;8:</span>           movk    w1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x4ba</span><span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>lsl</span> #<span style='color:#008c00; '>16</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;c:</span>           orr     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> lsr #<span style='color:#008c00; '>2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>           orr     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> lsr #<span style='color:#008c00; '>4</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;14:</span>           orr     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> lsr #<span style='color:#008c00; '>8</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;18:</span>           orr     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> lsr #<span style='color:#008c00; '>16</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1c:</span>           <span style='color:#800000; font-weight:bold; '>mul</span>     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> w1
<span style='color:#e34adc; '>&#xa0;&#xa0;20:</span>           adrp    x1<span style='color:#808030; '>,</span> <span style='color:#008c00; '>0</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;24:</span>           <span style='color:#800000; font-weight:bold; '>add</span>     x1<span style='color:#808030; '>,</span> x1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;28:</span>           lsr     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008c00; '>26</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2c:</span>           ldr     w0<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x1<span style='color:#808030; '>,</span>w0<span style='color:#808030; '>,</span>uxtw #<span style='color:#008c00; '>2</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;30:</span>           <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

<!--
_PRE_BEGIN
f PROC
        ORR      r0,r0,r0,LSR #1
        ORR      r0,r0,r0,LSR #2
        ORR      r0,r0,r0,LSR #4
        LDR      r1,|L0.44|
        ORR      r0,r0,r0,LSR #8
        ORR      r0,r0,r0,LSR #16
        MUL      r0,r1,r0
        LDR      r1,|L0.48|
        LSR      r0,r0,#26
        LDR      r0,[r1,r0,LSL #2]
        BX       lr
        ENDP

|L0.44|
        DCD      0x04badf0d
|L0.48|
        DCD      ||.data||
...
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        ORR      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>1</span>
        ORR      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>2</span>
        ORR      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>4</span>
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.44</span><span style='color:#808030; '>|</span>
        ORR      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>8</span>
        ORR      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>16</span>
        <span style='color:#800000; font-weight:bold; '>MUL</span>      r0<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.48</span><span style='color:#808030; '>|</span>
        LSR      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>26</span>
        LDR      r0<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>LSL</span> #<span style='color:#008c00; '>2</span><span style='color:#808030; '>]</span>
        <span style='color:#000080; '>BX</span>       lr
        <span style='color:#004a43; '>ENDP</span>

<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.44</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x04badf0d</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.48</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#808030; '>|</span><span style='color:#808030; '>|</span><span style='color:#004a43; '>.data</span><span style='color:#808030; '>|</span><span style='color:#808030; '>|</span>
...
</pre>

<p>(ARM) Optimizing Keil 5.05 (thumb mode):</p>

<!--
_PRE_BEGIN
f PROC
        LSRS     r1,r0,#1
        ORRS     r1,r1,r0
        LSRS     r0,r1,#2
        ORRS     r0,r0,r1
        LSRS     r1,r0,#4
        ORRS     r1,r1,r0
        LSRS     r2,r1,#8
        ORRS     r2,r2,r1
        LDR      r1,|L0.36|
        LSRS     r0,r2,#16
        ORRS     r0,r0,r2
        MULS     r0,r1,r0
        LDR      r1,|L0.40|
        LSRS     r0,r0,#26
        LSLS     r0,r0,#2
        LDR      r0,[r1,r0]
        BX       lr
        ENDP

|L0.36|
        DCD      0x04badf0d
|L0.40|
        DCD      ||.data||
...
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        LSRS     r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        ORRS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0
        LSRS     r0<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>2</span>
        ORRS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        LSRS     r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>4</span>
        ORRS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0
        LSRS     r2<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>8</span>
        ORRS     r2<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>r1
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.36</span><span style='color:#808030; '>|</span>
        LSRS     r0<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>16</span>
        ORRS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r2
        MULS     r0<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.40</span><span style='color:#808030; '>|</span>
        LSRS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>26</span>
        LSLS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>2</span>
        LDR      r0<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>]</span>
        <span style='color:#000080; '>BX</span>       lr
        <span style='color:#004a43; '>ENDP</span>

<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.36</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x04badf0d</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.40</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#808030; '>|</span><span style='color:#808030; '>|</span><span style='color:#004a43; '>.data</span><span style='color:#808030; '>|</span><span style='color:#808030; '>|</span>
...
</pre>

<p>Optimizing GCC 4.4.5 for MIPS:</p>

<!--
_PRE_BEGIN
f:
        srl     $2,$4,1
        or      $2,$2,$4
        srl     $3,$2,2
        or      $2,$3,$2
        srl     $3,$2,4
        or      $2,$3,$2
        srl     $3,$2,8
        or      $2,$3,$2
        srl     $3,$2,16
        or      $2,$3,$2
        li      $3,79298560                     # 0x4ba0000
        ori     $3,$3,0xdf0d
        mult    $2,$3
        lui     $3,%hi(v)
        addiu   $3,$3,%lo(v)
        mflo    $2
        srl     $2,$2,26
        sll     $2,$2,2
        addu    $2,$2,$3
        lw      $2,0($2)
        j       $31
        nop
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>f:</span>
        srl     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>
        srl     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>2</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        srl     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>4</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        srl     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>8</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        srl     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>16</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>79298560</span>                     # <span style='color:#008000; '>0x4ba0000</span>
        ori     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xdf0d</span>
        mult    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        lui     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#808030; '>%</span>hi<span style='color:#808030; '>(</span>v<span style='color:#808030; '>)</span>
        addiu   <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#808030; '>%</span>lo<span style='color:#808030; '>(</span>v<span style='color:#808030; '>)</span>
        mflo    <span style='color:#008000; '>$2</span>
        srl     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>26</span>
        sll     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>2</span>
        addu    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        lw      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>)</span>
        j       <span style='color:#008000; '>$31</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
</pre>

<p>_HTML_LINK(`http://yurichev.com/blog/de_bruijn/',`Solution').</p>

_EXERCISE_FOOTER()

_BLOG_FOOTER()


