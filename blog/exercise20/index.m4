m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #20 (for x64, ARM, ARM64, MIPS); solution for exercise #19')

_HL2(`Reverse engineering exercise #20 (for x64, ARM, ARM64, MIPS)')

<p>
This is easy.
What the following code does?
</p>

_HL3(`Optimizing GCC 4.8.2 for x64')

_PRE_BEGIN
f4:
.LFB40:
        sub     rsp, 8
        call    rand
        cvtsi2ss        xmm0, eax
        mulss   xmm0, DWORD PTR .LC0[rip]
        add     rsp, 8
        ret
.LC0:
        .long   805306368
_PRE_END

<p>As you may notice, it uses SSEx instructions for floating point number processing.
The code below was compiled by the same version of GCC, but using <b>-march=pentium3 -m32</b> switches, that forces it to compile code for 80x87 FPU:</p>

_PRE_BEGIN
f4:
        sub     esp, 28
        call    rand
        mov     DWORD PTR [esp+12], eax
        fild    DWORD PTR [esp+12]
        fmul    DWORD PTR .LC0
        add     esp, 28
        ret
.LC0:
        .long   805306368
_PRE_END

_HL3(`Optimizing Keil 5.05 (ARM mode)')

_PRE_BEGIN
||f4|| PROC
        PUSH     {r4,lr}
        BL       rand
        BL       __aeabi_i2f
        POP      {r4,lr}
        MVN      r1,#0x1e
        B        __ARM_scalbnf
        ENDP
_PRE_END

_HL3(`Optimizing Keil 5.05 (Thumb mode)')

_PRE_BEGIN
||f4|| PROC
        PUSH     {r4,lr}
        BL       rand
        BL       __aeabi_i2f
        MOVS     r1,#0x1e
        MVNS     r1,r1
        BL       __ARM_scalbnf
        POP      {r4,pc}
        ENDP
_PRE_END

_HL3(`Optimizing GCC 4.9.3 for ARM64')

_PRE_BEGIN
f4:
        stp     x29, x30, [sp, -16]!
        add     x29, sp, 0
        bl      rand
        scvtf   s1, w0
        ldr     s0, .LC0
        ldp     x29, x30, [sp], 16
        fmul    s0, s1, s0
        ret
.LC0:
        .word   805306368
_PRE_END

_HL3(`Optimizing GCC 4.4.5 for MIPS')

_PRE_BEGIN
f4:
        lui     $28,%hi(__gnu_local_gp)
        addiu   $sp,$sp,-32
        addiu   $28,$28,%lo(__gnu_local_gp)
        sw      $31,28($sp)
        lw      $25,%call16(rand)($28)
        nop
        jalr    $25
        nop

        mtc1    $2,$f0
        lui     $2,%hi($LC0)
        cvt.s.w $f2,$f0
        lw      $31,28($sp)
        lwc1    $f0,%lo($LC0)($2)
        addiu   $sp,$sp,32
        j       $31
        mul.s   $f0,$f2,$f0
$LC0:
        .word   805306368
_PRE_END

<p>Solution is to be posted soon...</p>
<!-- <p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise21/')</p> -->

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #19')

_HTML_LINK(`http://yurichev.com/blog/exercise19',`(Link to exercise)')

m4_include(`spoiler_show.inc')

<div id="example" class="hidden">

<p>
This is _HTML_LINK(`https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm',`Knuth–Morris–Pratt algorithm') for searching for substring within string.
</p>

<!--
// Knuth–Morris–Pratt algorithm
// copypasted from http://cprogramming.com/snippets/source-code/knuthmorrispratt-kmp-string-search-algorithm
const uint8_t *f2(const uint8_t *haystack, size_t haystack_size, const uint8_t *needle, size_t needle_size)
{
	int *T;
	int i, j;
	const uint8_t *result = NULL;
 
	if (needle_size==0)
		return haystack;
 
	/* Construct the lookup table */
	T = (int*) malloc((needle_size+1) * sizeof(int));
	T[0] = -1;
	for (i=0; i<needle_size; i++)
	{
		T[i+1] = T[i] + 1;
		while (T[i+1] > 0 && needle[i] != needle[T[i+1]-1])
			T[i+1] = T[T[i+1]-1] + 1;
	}
 
	/* Perform the search */
	for (i=j=0; i<haystack_size; )
	{
		if (j < 0 || haystack[i] == needle[j])
		{
			++i, ++j;
			if (j == needle_size) 
			{
				result = haystack+i-j;
				break;
			}
		}
		else j = T[j];
	}
 
	free(T);
	return result;
}

int main()
{
#define HAYSTACK "hello world"
#define NEEDLE "world"
	printf ("%s\n", f2 (HAYSTACK, strlen(HAYSTACK), NEEDLE, strlen(NEEDLE)));
};
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#696969; '>// Knuth–Morris–Pratt algorithm</span>
<span style='color:#696969; '>// copypasted from </span><span style='color:#5555dd; '>http://cprogramming.com/snippets/source-code/knuthmorrispratt-kmp-string-search-algorithm</span>
<span style='color:#800000; font-weight:bold; '>const</span> uint8_t <span style='color:#808030; '>*</span>f2<span style='color:#808030; '>(</span><span style='color:#800000; font-weight:bold; '>const</span> uint8_t <span style='color:#808030; '>*</span>haystack<span style='color:#808030; '>,</span> <span style='color:#603000; '>size_t</span> haystack_size<span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>const</span> uint8_t <span style='color:#808030; '>*</span>needle<span style='color:#808030; '>,</span> <span style='color:#603000; '>size_t</span> needle_size<span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
	<span style='color:#800000; font-weight:bold; '>int</span> <span style='color:#808030; '>*</span>T<span style='color:#800080; '>;</span>
	<span style='color:#800000; font-weight:bold; '>int</span> i<span style='color:#808030; '>,</span> j<span style='color:#800080; '>;</span>
	<span style='color:#800000; font-weight:bold; '>const</span> uint8_t <span style='color:#808030; '>*</span>result <span style='color:#808030; '>=</span> <span style='color:#7d0045; '>NULL</span><span style='color:#800080; '>;</span>
 
	<span style='color:#800000; font-weight:bold; '>if</span> <span style='color:#808030; '>(</span>needle_size<span style='color:#808030; '>=</span><span style='color:#808030; '>=</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>)</span>
		<span style='color:#800000; font-weight:bold; '>return</span> haystack<span style='color:#800080; '>;</span>
 
	<span style='color:#696969; '>/* Construct the lookup table */</span>
	T <span style='color:#808030; '>=</span> <span style='color:#808030; '>(</span><span style='color:#800000; font-weight:bold; '>int</span><span style='color:#808030; '>*</span><span style='color:#808030; '>)</span> <span style='color:#603000; '>malloc</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>needle_size<span style='color:#808030; '>+</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span> <span style='color:#808030; '>*</span> <span style='color:#800000; font-weight:bold; '>sizeof</span><span style='color:#808030; '>(</span><span style='color:#800000; font-weight:bold; '>int</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	T<span style='color:#808030; '>[</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span> <span style='color:#808030; '>=</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#800080; '>;</span>
	<span style='color:#800000; font-weight:bold; '>for</span> <span style='color:#808030; '>(</span>i<span style='color:#808030; '>=</span><span style='color:#008c00; '>0</span><span style='color:#800080; '>;</span> i<span style='color:#808030; '>&lt;</span>needle_size<span style='color:#800080; '>;</span> i<span style='color:#808030; '>+</span><span style='color:#808030; '>+</span><span style='color:#808030; '>)</span>
	<span style='color:#800080; '>{</span>
		T<span style='color:#808030; '>[</span>i<span style='color:#808030; '>+</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span> <span style='color:#808030; '>=</span> T<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span> <span style='color:#808030; '>+</span> <span style='color:#008c00; '>1</span><span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>while</span> <span style='color:#808030; '>(</span>T<span style='color:#808030; '>[</span>i<span style='color:#808030; '>+</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span> <span style='color:#808030; '>></span> <span style='color:#008c00; '>0</span> <span style='color:#808030; '>&amp;</span><span style='color:#808030; '>&amp;</span> needle<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span> <span style='color:#808030; '>!</span><span style='color:#808030; '>=</span> needle<span style='color:#808030; '>[</span>T<span style='color:#808030; '>[</span>i<span style='color:#808030; '>+</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>
			T<span style='color:#808030; '>[</span>i<span style='color:#808030; '>+</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span> <span style='color:#808030; '>=</span> T<span style='color:#808030; '>[</span>T<span style='color:#808030; '>[</span>i<span style='color:#808030; '>+</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span> <span style='color:#808030; '>+</span> <span style='color:#008c00; '>1</span><span style='color:#800080; '>;</span>
	<span style='color:#800080; '>}</span>
 
	<span style='color:#696969; '>/* Perform the search */</span>
	<span style='color:#800000; font-weight:bold; '>for</span> <span style='color:#808030; '>(</span>i<span style='color:#808030; '>=</span>j<span style='color:#808030; '>=</span><span style='color:#008c00; '>0</span><span style='color:#800080; '>;</span> i<span style='color:#808030; '>&lt;</span>haystack_size<span style='color:#800080; '>;</span> <span style='color:#808030; '>)</span>
	<span style='color:#800080; '>{</span>
		<span style='color:#800000; font-weight:bold; '>if</span> <span style='color:#808030; '>(</span>j <span style='color:#808030; '>&lt;</span> <span style='color:#008c00; '>0</span> <span style='color:#808030; '>|</span><span style='color:#808030; '>|</span> haystack<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span> <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> needle<span style='color:#808030; '>[</span>j<span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>
		<span style='color:#800080; '>{</span>
			<span style='color:#808030; '>+</span><span style='color:#808030; '>+</span>i<span style='color:#808030; '>,</span> <span style='color:#808030; '>+</span><span style='color:#808030; '>+</span>j<span style='color:#800080; '>;</span>
			<span style='color:#800000; font-weight:bold; '>if</span> <span style='color:#808030; '>(</span>j <span style='color:#808030; '>=</span><span style='color:#808030; '>=</span> needle_size<span style='color:#808030; '>)</span> 
			<span style='color:#800080; '>{</span>
				result <span style='color:#808030; '>=</span> haystack<span style='color:#808030; '>+</span>i<span style='color:#808030; '>-</span>j<span style='color:#800080; '>;</span>
				<span style='color:#800000; font-weight:bold; '>break</span><span style='color:#800080; '>;</span>
			<span style='color:#800080; '>}</span>
		<span style='color:#800080; '>}</span>
		<span style='color:#800000; font-weight:bold; '>else</span> j <span style='color:#808030; '>=</span> T<span style='color:#808030; '>[</span>j<span style='color:#808030; '>]</span><span style='color:#800080; '>;</span>
	<span style='color:#800080; '>}</span>
 
	<span style='color:#603000; '>free</span><span style='color:#808030; '>(</span>T<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	<span style='color:#800000; font-weight:bold; '>return</span> result<span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span>

<span style='color:#800000; font-weight:bold; '>int</span> <span style='color:#400000; '>main</span><span style='color:#808030; '>(</span><span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>define</span><span style='color:#004a43; '> HAYSTACK </span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>hello world</span><span style='color:#800000; '>"</span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>define</span><span style='color:#004a43; '> NEEDLE </span><span style='color:#800000; '>"</span><span style='color:#0000e6; '>world</span><span style='color:#800000; '>"</span>
	<span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#007997; '>%s</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> f2 <span style='color:#808030; '>(</span>HAYSTACK<span style='color:#808030; '>,</span> <span style='color:#603000; '>strlen</span><span style='color:#808030; '>(</span>HAYSTACK<span style='color:#808030; '>)</span><span style='color:#808030; '>,</span> NEEDLE<span style='color:#808030; '>,</span> <span style='color:#603000; '>strlen</span><span style='color:#808030; '>(</span>NEEDLE<span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span><span style='color:#800080; '>;</span>
</pre>

m4_include(`spoiler_hide.inc')
</div>

_BLOG_FOOTER_GITHUB(`exercise20')

_BLOG_FOOTER()

