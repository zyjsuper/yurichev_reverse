m4_include(`commons.m4')

_HEADER_HL1(`15-Aug-2015: Solution for the exercise posted at 13 August; the next reverse engineering exercise (for x86, ARM, ARM64, MIPS)')

_HL2(`Solution for the exercise posted at 13 August')

<p>Link to exercise: _HTML_LINK_AS_IS(`http://yurichev.com/blog/2015-aug-13/').</p>
<p>Reddit discussion: _HTML_LINK_AS_IS(`https://www.reddit.com/r/ReverseEngineering/comments/3gtyk7/introduction_to_logarithms_yet_another_x86/').</p>

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">The code I used is partly copypasted from the 
<a href="http://www.jagregory.com/abrash-black-book/#full-32-bit-division" class="spoiler">Michael Abrash's book</a>
(who is also known for his involvement in id Quake videogame as assembly programmer)
and it's the function to divide long (which has $n \cdot 64 $ bits) value by 64-bit divisor.
It returns long result and 64-bit remainder.
In my code below, it is used for dividing 256-bit value by 64-bit one.
</p>

<p style="color: white;">
<pre class="spoiler">
#include &lt;stdio.h&gt;
#include &lt;stdint.h&gt;
#include &lt;inttypes.h&gt;

uint64_t __attribute__ ((noinline)) long_div (uint64_t *input, uint64_t *result, uint64_t divisor, int size)
{
	/*
	
	equivalent C version:

	uint32_t remainder=0;
	for (int i=0; i&gt;size; i++)
	{
		result[i]=(((uint64_t)remainder << 32) | (uint64_t)input[i]) / divisor;
		remainder=input[i] % divisor;
	};
	return remainder;
	*/
	
	uint64_t remainder;
	__asm__ ("xorq %%rdx, %%rdx;"
	     "begin: lodsq;"
	     "divq %%rbx;"
	     "stosq;"
	     "loop begin;" : "=c" (size), "=d" (remainder) : "S" (input), "D" (result), "b" (divisor));
	return remainder;
};

int main()
{
	uint64_t arr[4]={ 0x12345678ABCDEF00, 0x12345678ABCDEF00, 0x12345678ABCDEF00, 0x12345678ABCDEF00 };
	uint64_t res[4];
	uint64_t divisor=1234;

	printf ("remainder=0x%016llx\n", long_div(arr, res, divisor, 4));
	printf ("result=0x%016llx%016llx%016llx%016llx\n", res[0], res[1], res[2], res[3]);
};
</pre>
</p>

<p class="spoiler">Why it works: DIV/IDIV instruction takes input 64+64-bit value in RDX:EAX registers pair, divides it by RBX (where divisor is),
then places remainder in RDX and result in RAX. RAX is stored into the array containing result, but RDX is used at the next iteration as high part of the next
chunk.
Needless to say, LODS, STOS and LOOP instructions are almost never appeared in compiler-generated code.
Indeed, I copypasted it from Abrash's book, and, apparently he wrote this piece manually (or took it from some other manually written code).</p>

_HL2(`The next reverse engineering exercise (for x86, ARM, ARM64, MIPS)')

<p>What this code does?</p>

<p>Optimizing GCC 4.8.2 -m32:</p>

<!--
_PRE_BEGIN
<f>:
   0:          mov    eax,DWORD PTR [esp+0x4]
   4:          bswap  eax
   6:          mov    edx,eax
   8:          and    eax,0xf0f0f0f
   d:          and    edx,0xf0f0f0f0
  13:          shr    edx,0x4
  16:          shl    eax,0x4
  19:          or     eax,edx
  1b:          mov    edx,eax
  1d:          and    eax,0x33333333
  22:          and    edx,0xcccccccc
  28:          shr    edx,0x2
  2b:          shl    eax,0x2
  2e:          or     eax,edx
  30:          mov    edx,eax
  32:          and    eax,0x55555555
  37:          and    edx,0xaaaaaaaa
  3d:          add    eax,eax
  3f:          shr    edx,1
  41:          or     eax,edx
  43:          ret
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#008c00; '>0</span><span style='color:#808030; '>:</span>          <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>DWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>esp</span><span style='color:#808030; '>+</span><span style='color:#008000; '>0x4</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>          <span style='color:#800000; font-weight:bold; '>bswap</span>  <span style='color:#000080; '>eax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;6:</span>          <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#000080; '>eax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;8:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xf0f0f0f</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;d:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xf0f0f0f0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;13:</span>          <span style='color:#800000; font-weight:bold; '>shr</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x4</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;16:</span>          <span style='color:#800000; font-weight:bold; '>shl</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x4</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;19:</span>          <span style='color:#800000; font-weight:bold; '>or</span>     <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>edx</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1b:</span>          <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#000080; '>eax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1d:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x33333333</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;22:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xcccccccc</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;28:</span>          <span style='color:#800000; font-weight:bold; '>shr</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2b:</span>          <span style='color:#800000; font-weight:bold; '>shl</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2e:</span>          <span style='color:#800000; font-weight:bold; '>or</span>     <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>edx</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;30:</span>          <span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#000080; '>eax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;32:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x55555555</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;37:</span>          <span style='color:#800000; font-weight:bold; '>and</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xaaaaaaaa</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;3d:</span>          <span style='color:#800000; font-weight:bold; '>add</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>eax</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;3f:</span>          <span style='color:#800000; font-weight:bold; '>shr</span>    <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;41:</span>          <span style='color:#800000; font-weight:bold; '>or</span>     <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#000080; '>edx</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;43:</span>          <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>Optimizing GCC 4.9.3 (Linaro) for ARM64:</p>

<!--
_PRE_BEGIN
<f>:
   0:           rev     w0, w0
   4:           and     w1, w0, #0xf0f0f0f
   8:           and     w0, w0, #0xf0f0f0f0
   c:           lsl     w1, w1, #4
  10:           orr     w0, w1, w0, lsr #4
  14:           and     w1, w0, #0x33333333
  18:           and     w0, w0, #0xcccccccc
  1c:           lsl     w1, w1, #2
  20:           orr     w1, w1, w0, lsr #2
  24:           and     w0, w1, #0xaaaaaaaa
  28:           and     w1, w1, #0x55555555
  2c:           add     w1, w1, w1
  30:           orr     w0, w1, w0, lsr #1
  34:           ret
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>           rev     w0<span style='color:#808030; '>,</span> w0
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w1<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0xf0f0f0f</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;8:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0xf0f0f0f0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;c:</span>           <span style='color:#800000; font-weight:bold; '>lsl</span>     w1<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> #<span style='color:#008c00; '>4</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>           orr     w0<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> lsr #<span style='color:#008c00; '>4</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;14:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w1<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x33333333</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;18:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w0<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0xcccccccc</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1c:</span>           <span style='color:#800000; font-weight:bold; '>lsl</span>     w1<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> #<span style='color:#008c00; '>2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;20:</span>           orr     w1<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> lsr #<span style='color:#008c00; '>2</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;24:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w0<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0xaaaaaaaa</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;28:</span>           <span style='color:#800000; font-weight:bold; '>and</span>     w1<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x55555555</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2c:</span>           <span style='color:#800000; font-weight:bold; '>add</span>     w1<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> w1
<span style='color:#e34adc; '>&#xa0;&#xa0;30:</span>           orr     w0<span style='color:#808030; '>,</span> w1<span style='color:#808030; '>,</span> w0<span style='color:#808030; '>,</span> lsr #<span style='color:#008c00; '>1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;34:</span>           <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

<!--
_PRE_BEGIN
f       PROC
        ROR      r0,r0,#16
        MVN      r1,#0xff00
        AND      r1,r1,r0,LSR #8
        BIC      r0,r0,#0xff00
        ORR      r0,r1,r0,LSL #8
        LDR      r1,|L0.124|
        AND      r2,r1,r0,LSR #4
        AND      r0,r0,r1
        LDR      r1,|L0.128|
        ORR      r0,r2,r0,LSL #4
        AND      r2,r1,r0,LSR #2
        AND      r0,r0,r1
        ORR      r0,r2,r0,LSL #2
        EOR      r1,r1,r1,LSL #1
        AND      r2,r1,r0,LSR #1
        AND      r0,r0,r1
        ORR      r0,r2,r0,LSL #1
        BX       lr
        ENDP
|L0.124|
        DCD      0xff0f0f0f
|L0.128|
        DCD      0x33333333
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'>f       <span style='color:#004a43; '>PROC</span>
        <span style='color:#800000; font-weight:bold; '>ROR</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>16</span>
        MVN      r1<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0xff00</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>8</span>
        BIC      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0xff00</span>
        ORR      r0<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>LSL</span> #<span style='color:#008c00; '>8</span>
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.124</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r2<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>4</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        LDR      r1<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.128</span><span style='color:#808030; '>|</span>
        ORR      r0<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>LSL</span> #<span style='color:#008c00; '>4</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r2<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>2</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        ORR      r0<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>LSL</span> #<span style='color:#008c00; '>2</span>
        EOR      r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>LSL</span> #<span style='color:#008c00; '>1</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r2<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>LSR #<span style='color:#008c00; '>1</span>
        <span style='color:#800000; font-weight:bold; '>AND</span>      r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        ORR      r0<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>LSL</span> #<span style='color:#008c00; '>1</span>
        <span style='color:#000080; '>BX</span>       lr
        <span style='color:#004a43; '>ENDP</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.124</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0xff0f0f0f</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.128</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x33333333</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

<!--
_PRE_BEGIN
f       PROC
        MOVS     r1,#0x10
        RORS     r0,r0,r1
        LDR      r2,|L0.88|
        LSRS     r1,r0,#8
        ANDS     r0,r0,r2
        ANDS     r1,r1,r2
        LSLS     r0,r0,#8
        LDR      r2,|L0.92|
        ORRS     r1,r1,r0
        LSRS     r0,r1,#4
        ANDS     r1,r1,r2
        ANDS     r0,r0,r2
        LSLS     r1,r1,#4
        LDR      r2,|L0.96|
        ORRS     r0,r0,r1
        LSRS     r1,r0,#2
        ANDS     r0,r0,r2
        ANDS     r1,r1,r2
        LSLS     r0,r0,#2
        LDR      r2,|L0.100|
        ORRS     r1,r1,r0
        LSRS     r0,r1,#1
        ANDS     r1,r1,r2
        ANDS     r0,r0,r2
        LSLS     r1,r1,#1
        ORRS     r0,r0,r1
        BX       lr
        ENDP
|L0.88|
        DCD      0x00ff00ff
|L0.92|
        DCD      0x0f0f0f0f
|L0.96|
        DCD      0x33333333
|L0.100|
        DCD      0x55555555
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'>f       <span style='color:#004a43; '>PROC</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r1<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x10</span>
        RORS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        LDR      r2<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.88</span><span style='color:#808030; '>|</span>
        LSRS     r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>8</span>
        ANDS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r2
        ANDS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r2
        LSLS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>8</span>
        LDR      r2<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.92</span><span style='color:#808030; '>|</span>
        ORRS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0
        LSRS     r0<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>4</span>
        ANDS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r2
        ANDS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r2
        LSLS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>4</span>
        LDR      r2<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.96</span><span style='color:#808030; '>|</span>
        ORRS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        LSRS     r1<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>2</span>
        ANDS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r2
        ANDS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r2
        LSLS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>2</span>
        LDR      r2<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.100</span><span style='color:#808030; '>|</span>
        ORRS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r0
        LSRS     r0<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        ANDS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r2
        ANDS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r2
        LSLS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        ORRS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1
        <span style='color:#000080; '>BX</span>       lr
        <span style='color:#004a43; '>ENDP</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.88</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x00ff00ff</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.92</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x0f0f0f0f</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.96</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x33333333</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.100</span><span style='color:#808030; '>|</span>
        DCD      <span style='color:#008000; '>0x55555555</span>
</pre>

<p>Optimizing GCC 4.4.5 MIPS:</p>

<!--
_PRE_BEGIN
f:
        sll     $2,$4,16
        srl     $4,$4,16
        or      $2,$2,$4
        li      $3,-16777216                    # 0xffffffffff000000
        li      $4,16711680                     # 0xff0000
        ori     $3,$3,0xff00
        ori     $4,$4,0xff
        and     $4,$2,$4
        and     $2,$2,$3
        srl     $2,$2,8
        sll     $4,$4,8
        or      $4,$4,$2
        li      $3,-252706816                   # 0xfffffffff0f00000
        li      $2,252641280                    # 0xf0f0000
        ori     $3,$3,0xf0f0
        ori     $2,$2,0xf0f
        and     $2,$4,$2
        and     $4,$4,$3
        srl     $4,$4,4
        sll     $2,$2,4
        or      $2,$2,$4
        li      $3,858980352                    # 0x33330000
        li      $4,-859045888                   # 0xffffffffcccc0000
        ori     $4,$4,0xcccc
        ori     $3,$3,0x3333
        and     $3,$2,$3
        and     $2,$2,$4
        srl     $2,$2,2
        sll     $3,$3,2
        or      $3,$3,$2
        li      $4,-1431699456                  # 0xffffffffaaaa0000
        li      $2,1431633920                   # 0x55550000
        ori     $4,$4,0xaaaa
        ori     $2,$2,0x5555
        and     $2,$3,$2
        and     $3,$3,$4
        srl     $3,$3,1
        sll     $2,$2,1
        j       $31
        or      $2,$2,$3
_PRE_END
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>f:</span>
        sll     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>16</span>
        srl     <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>16</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>-16777216</span>                    # <span style='color:#008000; '>0xffffffffff000000</span>
        li      <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>16711680</span>                     # <span style='color:#008000; '>0xff0000</span>
        ori     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xff00</span>
        ori     <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xff</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        srl     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>8</span>
        sll     <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>8</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>-252706816</span>                   # <span style='color:#008000; '>0xfffffffff0f00000</span>
        li      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>252641280</span>                    # <span style='color:#008000; '>0xf0f0000</span>
        ori     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xf0f0</span>
        ori     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xf0f</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        srl     <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>4</span>
        sll     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>4</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>858980352</span>                    # <span style='color:#008000; '>0x33330000</span>
        li      <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>-859045888</span>                   # <span style='color:#008000; '>0xffffffffcccc0000</span>
        ori     <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xcccc</span>
        ori     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x3333</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>
        srl     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>2</span>
        sll     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>2</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        li      <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>-1431699456</span>                  # <span style='color:#008000; '>0xffffffffaaaa0000</span>
        li      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1431633920</span>                   # <span style='color:#008000; '>0x55550000</span>
        ori     <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0xaaaa</span>
        ori     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x5555</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        <span style='color:#800000; font-weight:bold; '>and</span>     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>
        srl     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
        sll     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
        j       <span style='color:#008000; '>$31</span>
        <span style='color:#800000; font-weight:bold; '>or</span>      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span>
</pre>

<p>I'll post solution couple of days later.</p>

_EXERCISE_FOOTER()

_BLOG_FOOTER()

