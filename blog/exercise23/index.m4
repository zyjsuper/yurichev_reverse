m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #23 (for x64, ARM, ARM64, MIPS); solution for exercise #22')

_HL2(`Reverse engineering exercise #23 (for x64, ARM, ARM64, MIPS)')

<p>
This is another implementation of well-known library function, works only in 64-bit environment.
What the following code does?
</p>

<p>Additional questions:

<ul>
<li> The code may crash under some specific circumstances. Which are...?
<li> The code can be easily optimized using SSEx. How?
<li> The code will not work correctly on big-endian architectures. How to fix it?
</ul>

_HL3(`Optimizing GCC 4.8.2 for x64')

_PRE_BEGIN
f:
        mov     rdx, QWORD PTR [rdi]
        test    dl, dl
        je      .L18
        test    dh, 255
        je      .L19
        test    edx, 16711680
        je      .L20
        test    edx, 4278190080
        je      .L21
        movabs  r8, 1095216660480
        test    rdx, r8
        je      .L22
        movabs  r9, 280375465082880
        test    rdx, r9
        je      .L26
        xor     eax, eax
        movabs  rcx, 71776119061217280
        movabs  rsi, -72057594037927936
        jmp     .L14
.L15:
        test    rdx, rsi
        je      .L27
        add     rax, 8
        mov     rdx, QWORD PTR [rdi+rax]
        test    dl, dl
        je      .L28
        test    dh, 255
        je      .L29
        test    edx, 16711680
        je      .L30
        test    edx, 4278190080
        je      .L31
        test    rdx, r8
        je      .L32
        test    rdx, r9
        je      .L33
.L14:
        test    rdx, rcx
        jne     .L15
        add     rax, 6
        ret
.L27:
        add     rax, 7
        ret
.L28:
        rep ret
.L29:
        add     rax, 1
        ret
.L30:
        add     rax, 2
        ret
.L31:
        add     rax, 3
        ret
.L32:
        add     rax, 4
        ret
.L33:
        add     rax, 5
        ret
.L18:
        xor     eax, eax
        ret
.L20:
        mov     eax, 2
        ret
.L19:
        mov     eax, 1
        ret
.L21:
        mov     eax, 3
        ret
.L26:
        mov     eax, 5
        ret
.L22:
        mov     eax, 4
        ret
_PRE_END

_HL3(`Optimizing GCC 4.9.3 for ARM64')

_PRE_BEGIN
f:
        ldr     x1, [x0]
        and     x2, x1, 255
        cbz     x2, .L18
        tst     x1, 65280
        beq     .L19
        tst     x1, 16711680
        beq     .L20
        tst     x1, 4278190080
        beq     .L21
        tst     x1, 1095216660480
        beq     .L22
        tst     x1, 280375465082880
        mov     x2, 0
        bne     .L14
        b       .L32
.L15:
        tst     x1, -72057594037927936
        beq     .L33
        add     x2, x2, 8
        ldr     x1, [x0, x2]
        and     x3, x1, 255
        tst     x1, 65280
        cbz     x3, .L2
        beq     .L34
        tst     x1, 16711680
        beq     .L35
        tst     x1, 4278190080
        beq     .L36
        tst     x1, 1095216660480
        beq     .L37
        tst     x1, 280375465082880
        beq     .L38
.L14:
        tst     x1, 71776119061217280
        bne     .L15
        add     x0, x2, 6
        ret
.L18:
        mov     x2, 0
.L2:
        mov     x0, x2
        ret
.L33:
        add     x0, x2, 7
        ret
.L34:
        add     x0, x2, 1
        ret
.L35:
        add     x0, x2, 2
        ret
.L36:
        add     x0, x2, 3
        ret
.L37:
        add     x0, x2, 4
        ret
.L38:
        add     x0, x2, 5
        ret
.L20:
        mov     x0, 2
        ret
.L19:
        mov     x0, 1
        ret
.L21:
        mov     x0, 3
        ret
.L32:
        mov     x0, 5
        ret
.L22:
        mov     x0, 4
        ret
_PRE_END

<p>Solution is to be posted soon...</p>
<!-- <p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise24/')</p> -->

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #22')

_HTML_LINK(`http://yurichev.com/blog/exercise22',`(Link to exercise)')

m4_include(`spoiler_show.inc')

<div id="example" class="hidden">

<p>
This code is quicksort algorithm with swapping operation replaced by cryptic XOR swapping algorithm:
</p>

<!--
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

// https://en.wikipedia.org/wiki/XOR_swap_algorithm
#define XORSWAP(a, b)	((a)^=(b),(b)^=(a),(a)^=(b))

// copypasted from http://www.comp.dit.ie/rlawlor/Alg_DS/sorting/quickSort.c and reworked

//int partition( int* a, int l, int r)
int f2( int* a, int l, int r)
{
	int pivot, i, j, t;
	pivot = a[l];
	i = l; j = r+1;

	while( 1)
	{
		do ++i; while( a[i] <= pivot && i <= r );
		do --j; while( a[j] > pivot );
		if( i >= j ) break;
		//t = a[i]; a[i] = a[j]; a[j] = t;
		XORSWAP(a[i], a[j]);
	}
	//t = a[l]; a[l] = a[j]; a[j] = t;
	XORSWAP(a[l], a[j]);
	return j;
}

//void quickSort( int* a, int l, int r)
void f1( int* a, int l, int r)
{
	int j;

	if( l < r ) 
	{
		// divide and conquer
		j = f2( a, l, r);
		f1( a, l, j-1);
		f1( a, j+1, r);
	}

}

void main() 
{
	int a[] = { 7, 12, 1, -2, 0, 15, 4, 11, 9};

	int i;
	printf("\n\nUnsorted array is:  ");
	for(i = 0; i < 9; ++i)
		printf(" %d ", a[i]);

	f1( a, 0, 8);

	printf("\n\nSorted array is:  ");
	for(i = 0; i < 9; ++i)
		printf(" %d ", a[i]);
	printf ("\n");
}
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdio.h</span><span style='color:#800000; '>></span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdint.h</span><span style='color:#800000; '>></span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdbool.h</span><span style='color:#800000; '>></span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdlib.h</span><span style='color:#800000; '>></span>

<span style='color:#696969; '>// </span><span style='color:#5555dd; '>https://en.wikipedia.org/wiki/XOR_swap_algorithm</span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>define</span><span style='color:#004a43; '> XORSWAP</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>a</span><span style='color:#808030; '>,</span><span style='color:#004a43; '> b</span><span style='color:#808030; '>)</span><span style='color:#004a43; '>	</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>a</span><span style='color:#808030; '>)</span><span style='color:#808030; '>^</span><span style='color:#808030; '>=</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>b</span><span style='color:#808030; '>)</span><span style='color:#808030; '>,</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>b</span><span style='color:#808030; '>)</span><span style='color:#808030; '>^</span><span style='color:#808030; '>=</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>a</span><span style='color:#808030; '>)</span><span style='color:#808030; '>,</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>a</span><span style='color:#808030; '>)</span><span style='color:#808030; '>^</span><span style='color:#808030; '>=</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>b</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span>

<span style='color:#696969; '>// copypasted from </span><span style='color:#5555dd; '>http://www.comp.dit.ie/rlawlor/Alg_DS/sorting/quickSort.c</span><span style='color:#696969; '> and reworked</span>

<span style='color:#696969; '>//int partition( int* a, int l, int r)</span>
<span style='color:#800000; font-weight:bold; '>int</span> f2<span style='color:#808030; '>(</span> <span style='color:#800000; font-weight:bold; '>int</span><span style='color:#808030; '>*</span> a<span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>int</span> l<span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>int</span> r<span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
	<span style='color:#800000; font-weight:bold; '>int</span> pivot<span style='color:#808030; '>,</span> i<span style='color:#808030; '>,</span> j<span style='color:#808030; '>,</span> t<span style='color:#800080; '>;</span>
	pivot <span style='color:#808030; '>=</span> a<span style='color:#808030; '>[</span>l<span style='color:#808030; '>]</span><span style='color:#800080; '>;</span>
	i <span style='color:#808030; '>=</span> l<span style='color:#800080; '>;</span> j <span style='color:#808030; '>=</span> r<span style='color:#808030; '>+</span><span style='color:#008c00; '>1</span><span style='color:#800080; '>;</span>

	<span style='color:#800000; font-weight:bold; '>while</span><span style='color:#808030; '>(</span> <span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span>
	<span style='color:#800080; '>{</span>
		<span style='color:#800000; font-weight:bold; '>do</span> <span style='color:#808030; '>+</span><span style='color:#808030; '>+</span>i<span style='color:#800080; '>;</span> <span style='color:#800000; font-weight:bold; '>while</span><span style='color:#808030; '>(</span> a<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span> <span style='color:#808030; '>&lt;</span><span style='color:#808030; '>=</span> pivot <span style='color:#808030; '>&amp;</span><span style='color:#808030; '>&amp;</span> i <span style='color:#808030; '>&lt;</span><span style='color:#808030; '>=</span> r <span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>do</span> <span style='color:#808030; '>-</span><span style='color:#808030; '>-</span>j<span style='color:#800080; '>;</span> <span style='color:#800000; font-weight:bold; '>while</span><span style='color:#808030; '>(</span> a<span style='color:#808030; '>[</span>j<span style='color:#808030; '>]</span> <span style='color:#808030; '>></span> pivot <span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
		<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span> i <span style='color:#808030; '>></span><span style='color:#808030; '>=</span> j <span style='color:#808030; '>)</span> <span style='color:#800000; font-weight:bold; '>break</span><span style='color:#800080; '>;</span>
		<span style='color:#696969; '>//t = a[i]; a[i] = a[j]; a[j] = t;</span>
		XORSWAP<span style='color:#808030; '>(</span>a<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span><span style='color:#808030; '>,</span> a<span style='color:#808030; '>[</span>j<span style='color:#808030; '>]</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	<span style='color:#800080; '>}</span>
	<span style='color:#696969; '>//t = a[l]; a[l] = a[j]; a[j] = t;</span>
	XORSWAP<span style='color:#808030; '>(</span>a<span style='color:#808030; '>[</span>l<span style='color:#808030; '>]</span><span style='color:#808030; '>,</span> a<span style='color:#808030; '>[</span>j<span style='color:#808030; '>]</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	<span style='color:#800000; font-weight:bold; '>return</span> j<span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span>

<span style='color:#696969; '>//void quickSort( int* a, int l, int r)</span>
<span style='color:#800000; font-weight:bold; '>void</span> f1<span style='color:#808030; '>(</span> <span style='color:#800000; font-weight:bold; '>int</span><span style='color:#808030; '>*</span> a<span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>int</span> l<span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>int</span> r<span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
	<span style='color:#800000; font-weight:bold; '>int</span> j<span style='color:#800080; '>;</span>

	<span style='color:#800000; font-weight:bold; '>if</span><span style='color:#808030; '>(</span> l <span style='color:#808030; '>&lt;</span> r <span style='color:#808030; '>)</span> 
	<span style='color:#800080; '>{</span>
		<span style='color:#696969; '>// divide and conquer</span>
		j <span style='color:#808030; '>=</span> f2<span style='color:#808030; '>(</span> a<span style='color:#808030; '>,</span> l<span style='color:#808030; '>,</span> r<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
		f1<span style='color:#808030; '>(</span> a<span style='color:#808030; '>,</span> l<span style='color:#808030; '>,</span> j<span style='color:#808030; '>-</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
		f1<span style='color:#808030; '>(</span> a<span style='color:#808030; '>,</span> j<span style='color:#808030; '>+</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> r<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	<span style='color:#800080; '>}</span>

<span style='color:#800080; '>}</span>

<span style='color:#800000; font-weight:bold; '>void</span> <span style='color:#400000; '>main</span><span style='color:#808030; '>(</span><span style='color:#808030; '>)</span> 
<span style='color:#800080; '>{</span>
	<span style='color:#800000; font-weight:bold; '>int</span> a<span style='color:#808030; '>[</span><span style='color:#808030; '>]</span> <span style='color:#808030; '>=</span> <span style='color:#800080; '>{</span> <span style='color:#008c00; '>7</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>12</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>1</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>-</span><span style='color:#008c00; '>2</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>15</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>4</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>11</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>9</span><span style='color:#800080; '>}</span><span style='color:#800080; '>;</span>

	<span style='color:#800000; font-weight:bold; '>int</span> i<span style='color:#800080; '>;</span>
	<span style='color:#603000; '>printf</span><span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0f69ff; '>\n</span><span style='color:#0f69ff; '>\n</span><span style='color:#0000e6; '>Unsorted array is:  </span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	<span style='color:#800000; font-weight:bold; '>for</span><span style='color:#808030; '>(</span>i <span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#800080; '>;</span> i <span style='color:#808030; '>&lt;</span> <span style='color:#008c00; '>9</span><span style='color:#800080; '>;</span> <span style='color:#808030; '>+</span><span style='color:#808030; '>+</span>i<span style='color:#808030; '>)</span>
		<span style='color:#603000; '>printf</span><span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '> </span><span style='color:#007997; '>%d</span><span style='color:#0000e6; '> </span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> a<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>

	f1<span style='color:#808030; '>(</span> a<span style='color:#808030; '>,</span> <span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>8</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>

	<span style='color:#603000; '>printf</span><span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0f69ff; '>\n</span><span style='color:#0f69ff; '>\n</span><span style='color:#0000e6; '>Sorted array is:  </span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	<span style='color:#800000; font-weight:bold; '>for</span><span style='color:#808030; '>(</span>i <span style='color:#808030; '>=</span> <span style='color:#008c00; '>0</span><span style='color:#800080; '>;</span> i <span style='color:#808030; '>&lt;</span> <span style='color:#008c00; '>9</span><span style='color:#800080; '>;</span> <span style='color:#808030; '>+</span><span style='color:#808030; '>+</span>i<span style='color:#808030; '>)</span>
		<span style='color:#603000; '>printf</span><span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0000e6; '> </span><span style='color:#007997; '>%d</span><span style='color:#0000e6; '> </span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> a<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
	<span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span>
</pre>

m4_include(`spoiler_hide.inc')
</div>

_BLOG_FOOTER_GITHUB(`exercise23')

_BLOG_FOOTER()

