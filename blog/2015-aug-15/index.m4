m4_include(`commons.m4')

_HEADER_HL1(`15-Aug-2015: Solution for the exercise posted at 13 August; the next reverse engineering exercise (for x86, ARM, ARM64, MIPS)')

_HL2(`Solution for the exercise posted at 13 August')

<p>Link to exercise: _HTML_LINK_AS_IS(`http://yurichev.com/blog/2015-aug-13/').</p>
<p>Reddit discussion: _HTML_LINK_AS_IS(`https://www.reddit.com/r/ReverseEngineering/comments/3gtyk7/introduction_to_logarithms_yet_another_x86/').</p>
<p>Spoiler warning! The text below has white color, select it using mouse to read the text:</p>

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
	for (int i=0; i<size; i++)
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
Needless to say, LODS, STOS and LOOP instructions are very rare in compiler-generated code. Indeed, I copypasted it from Abrash's book.
This is the sign that this piece was written manually.</p>

_HL2(`The next reverse engineering exercise (for x86, ARM, ARM64, MIPS)')

<p>What this code does?</p>

<p>Optimizing GCC 4.8.2 -m32:</p>

_PRE_BEGIN
00000000 &lt;f&gt;:
   0:   8b 44 24 04             mov    eax,DWORD PTR [esp+0x4]
   4:   0f c8                   bswap  eax
   6:   89 c2                   mov    edx,eax
   8:   25 0f 0f 0f 0f          and    eax,0xf0f0f0f
   d:   81 e2 f0 f0 f0 f0       and    edx,0xf0f0f0f0
  13:   c1 ea 04                shr    edx,0x4
  16:   c1 e0 04                shl    eax,0x4
  19:   09 d0                   or     eax,edx
  1b:   89 c2                   mov    edx,eax
  1d:   25 33 33 33 33          and    eax,0x33333333
  22:   81 e2 cc cc cc cc       and    edx,0xcccccccc
  28:   c1 ea 02                shr    edx,0x2
  2b:   c1 e0 02                shl    eax,0x2
  2e:   09 d0                   or     eax,edx
  30:   89 c2                   mov    edx,eax
  32:   25 55 55 55 55          and    eax,0x55555555
  37:   81 e2 aa aa aa aa       and    edx,0xaaaaaaaa
  3d:   01 c0                   add    eax,eax
  3f:   d1 ea                   shr    edx,1
  41:   09 d0                   or     eax,edx
  43:   c3                      ret
_PRE_END

<p>Optimizing GCC 4.9.3 (Linaro) for ARM64:</p>

_PRE_BEGIN
0000000000000000 &lt;f&gt;:
   0:   5ac00800        rev     w0, w0
   4:   1200cc01        and     w1, w0, #0xf0f0f0f
   8:   1204cc00        and     w0, w0, #0xf0f0f0f0
   c:   531c6c21        lsl     w1, w1, #4
  10:   2a401020        orr     w0, w1, w0, lsr #4
  14:   1200e401        and     w1, w0, #0x33333333
  18:   1202e400        and     w0, w0, #0xcccccccc
  1c:   531e7421        lsl     w1, w1, #2
  20:   2a400821        orr     w1, w1, w0, lsr #2
  24:   1201f020        and     w0, w1, #0xaaaaaaaa
  28:   1200f021        and     w1, w1, #0x55555555
  2c:   0b010021        add     w1, w1, w1
  30:   2a400420        orr     w0, w1, w0, lsr #1
  34:   d65f03c0        ret
_PRE_END

<p>Keil 5.05 (ARM mode):</p>

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

<p>Keil 5.05 (Thumb mode):</p>

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

<p>Optimizing GCC 4.4.5 MIPS:</p>

_PRE_BEGIN
f:
        .frame  $sp,0,$31               # vars= 0, regs= 0/0, args= 0, gp= 0
        .mask   0x00000000,0
        .fmask  0x00000000,0
        .set    noreorder
        .set    nomacro

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

<p>I'll post solution couple of days later.</p>

_BLOG_FOOTER()

