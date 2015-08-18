m4_include(`commons.m4')

_HEADER_HL1(`18-Aug-2015: Solution for the exercise posted at 15 August; the next reverse engineering exercise (for x86, ARM, ARM64, MIPS)')

_HL2(`Solution for the exercise posted at 13 August')

<p>Link to exercise: _HTML_LINK_AS_IS(`http://yurichev.com/blog/2015-aug-15/').</p>
<p>Spoiler warning! The text below has white color, select it using mouse to read the text (or press Ctrl-A):</p>

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

<p>What this code does? The function has array of 64 32-bit integers, I removed it in each assembly code snippet.
The array is:</p>

_PRE_BEGIN
int v[64]=
	{ -1,31, 8,30, -1, 7,-1,-1, 29,-1,26, 6, -1,-1, 2,-1,
	  -1,28,-1,-1, -1,19,25,-1, 5,-1,17,-1, 23,14, 1,-1,
	   9,-1,-1,-1, 27,-1, 3,-1, -1,-1,20,-1, 18,24,15,10,
	  -1,-1, 4,-1, 21,-1,16,11, -1,22,-1,12, 13,-1, 0,-1 };
_PRE_END

<p>The algorithm is well-known, but I've changed constant so it wouldn't be googleable.</p>

<p>Optimizing GCC 4.8.2:</p>

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

<p>Optimizing GCC 4.9.3 for ARM64:</p>

_PRE_BEGIN
0000000000000000 <f>:
   0:   2a400400        orr     w0, w0, w0, lsr #1
   4:   529be1a1        mov     w1, #0xdf0d                     // #57101
   8:   72a09741        movk    w1, #0x4ba, lsl #16
   c:   2a400800        orr     w0, w0, w0, lsr #2
  10:   2a401000        orr     w0, w0, w0, lsr #4
  14:   2a402000        orr     w0, w0, w0, lsr #8
  18:   2a404000        orr     w0, w0, w0, lsr #16
  1c:   1b017c00        mul     w0, w0, w1
  20:   90000001        adrp    x1, 0 <f>
  24:   91000021        add     x1, x1, #0x0
  28:   531a7c00        lsr     w0, w0, #26
  2c:   b8605820        ldr     w0, [x1,w0,uxtw #2]
  30:   d65f03c0        ret
_PRE_END

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

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

<p>(ARM) Optimizing Keil 5.05 (thumb mode):</p>

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

<p>Optimizing GCC 4.4.5 for MIPS:</p>

_PRE_BEGIN
f:
        .frame  $sp,0,$31               # vars= 0, regs= 0/0, args= 0, gp= 0
        .mask   0x00000000,0
        .fmask  0x00000000,0
        .set    noreorder
        .set    nomacro

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

<p>I'll post solution couple of days later.</p>

_BLOG_FOOTER()


