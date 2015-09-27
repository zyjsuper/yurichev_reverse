m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #18 (for x64, ARM64); solution for exercise #17')

_HL2(`Reverse engineering exercise #18 (for x64, ARM64)')

<p>
Now this is easy.
Keep in mind, the code is 64-bit one, because it uses 64-bit value(s).
That is why I've omitted code fragments for 32-bit ARM and MIPS.
So what it does?
</p>

<p>Optimizing GCC 4.8.2 for x64:</p>

_PRE_BEGIN
f3:
	push	r15
	mov	r15, rsi
	push	r14
	mov	r14, rdx
	push	r13
	mov	r13, rcx
	push	r12
	push	rbp
	push	rbx
	mov	rbx, rdi
	sub	rsp, 24
	mov	QWORD PTR [rsp], r8
	mov	QWORD PTR [rsp+8], r9
	call	strlen
	cmp	rax, 36
	mov	edx, -1
	jne	.L28
	mov	r12, rbx
	xor	ebp, ebp
	jmp	.L35
.L43:
	cmp	ebp, 13
	je	.L29
	cmp	ebp, 18
	je	.L29
	cmp	ebp, 23
	je	.L29
	cmp	ebp, 36
	je	.L42
.L33:
	movsx	edi, BYTE PTR [r12]
	call	isxdigit
	test	eax, eax
	je	.L37
.L32:
	add	ebp, 1
	add	r12, 1
	cmp	ebp, 37
	je	.L34
.L35:
	cmp	ebp, 8
	jne	.L43
.L29:
	cmp	BYTE PTR [r12], 45
	je	.L32
.L37:
	mov	edx, -1
.L28:
	add	rsp, 24
	mov	eax, edx
	pop	rbx
	pop	rbp
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	ret
.L42:
	cmp	BYTE PTR [r12], 0
	jne	.L33
.L34:
	mov	edx, 16
	xor	esi, esi
	mov	rdi, rbx
	call	strtoul
	lea	rdi, [rbx+9]
	mov	edx, 16
	xor	esi, esi
	mov	DWORD PTR [r15], eax
	call	strtoul
	lea	rdi, [rbx+14]
	mov	edx, 16
	xor	esi, esi
	mov	WORD PTR [r14], ax
	call	strtoul
	lea	rdi, [rbx+19]
	mov	edx, 16
	xor	esi, esi
	mov	WORD PTR [r13+0], ax
	call	strtoul
	mov	rcx, QWORD PTR [rsp]
	lea	rdi, [rbx+24]
	mov	edx, 16
	xor	esi, esi
	mov	WORD PTR [rcx], ax
	call	strtoull
	mov	rcx, QWORD PTR [rsp+8]
	xor	edx, edx
	mov	QWORD PTR [rcx], rax
	jmp	.L28
_PRE_END

<p>Optimizing GCC 4.9.3 for ARM64:</p>

_PRE_BEGIN
f3:
        stp     x29, x30, [sp, -80]!
        add     x29, sp, 0
        stp     x21, x22, [sp, 32]
        stp     x23, x24, [sp, 48]
        stp     x25, x26, [sp, 64]
        stp     x19, x20, [sp, 16]
        mov     x21, x0
        mov     x22, x1
        mov     x23, x2
        mov     x24, x3
        mov     x25, x4
        mov     x26, x5
        bl      strlen
        cmp     x0, 36
        bne     .L36
        mov     x20, x21
        mov     w19, 0
        b       .L33
.L48:
        cmp     w19, 13
        beq     .L26
        cmp     w19, 18
        beq     .L26
        cmp     w19, 23
        beq     .L26
        cmp     w19, 36
        ldrb    w0, [x20]
        beq     .L47
        bl      isxdigit
        cbz     w0, .L36
.L29:
        add     w19, w19, 1
        add     x20, x20, 1
        cmp     w19, 37
        beq     .L31
.L33:
        cmp     w19, 8
        bne     .L48
.L26:
        ldrb    w6, [x20]
        cmp     w6, 45
        beq     .L29
.L36:
        mov     w1, -1
        mov     w0, w1
        ldp     x19, x20, [sp, 16]
        ldp     x21, x22, [sp, 32]
        ldp     x23, x24, [sp, 48]
        ldp     x25, x26, [sp, 64]
        ldp     x29, x30, [sp], 80
        ret
.L47:
        cbz     w0, .L31
        bl      isxdigit
        cbz     w0, .L36
.L31:
        mov     w2, 16
        mov     x1, 0
        mov     x0, x21
        bl      strtoul
        str     w0, [x22]
        mov     w2, 16
        mov     x1, 0
        add     x0, x21, 9
        bl      strtoul
        strh    w0, [x23]
        mov     w2, 16
        mov     x1, 0
        add     x0, x21, 14
        bl      strtoul
        strh    w0, [x24]
        mov     w2, 16
        mov     x1, 0
        add     x0, x21, 19
        bl      strtoul
        strh    w0, [x25]
        mov     w2, 16
        mov     x1, 0
        add     x0, x21, 24
        bl      strtoull
        str     x0, [x26]
        mov     w1, 0
        mov     w0, w1
        ldp     x19, x20, [sp, 16]
        ldp     x21, x22, [sp, 32]
        ldp     x23, x24, [sp, 48]
        ldp     x25, x26, [sp, 64]
        ldp     x29, x30, [sp], 80
        ret
_PRE_END

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/exercise19/')</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #17')

_HTML_LINK(`http://yurichev.com/blog/exercise17',`(Link to exercise)')

m4_include(`spoiler_show.inc')

<div id="example" class="hidden">

<p>The code just picks minimal value out of 4 inputs.
The code is tricky: I've used branchless min() and max() functions and sorting network 
(which can sort values in branchless manner as well).
</p>
<!--
_PRE_BEGIN
#include <stdio.h>

#define WORDBITS 64
// branchless functions, copypasted from http://aggregate.org/MAGIC/#Integer%20Minimum%20or%20Maximum
#define MIN(x,y) (x+(((y-x)>>(WORDBITS-1))&(y-x)))
#define MAX(x,y) (x-(((x-y)>>(WORDBITS-1))&(x-y)))

// find minimal value
int __attribute__ ((noinline)) f (int a, int b, int c, int d)
{
        // taken from https://en.wikipedia.org/wiki/Sorting_network
        // https://en.wikipedia.org/wiki/File:SimpleSortingNetwork2.svg
        //
        b=MIN(b,d); d=MAX(b,d);
        a=MIN(a,c); c=MAX(a,c);
        a=MIN(a,b); b=MAX(a,b);

        return a;
};

int main()
{
        printf ("%d\n", f (123, 456, 789, 1000));
        printf ("%d\n", f (123, 456, 999, 1));
        printf ("%d\n", f (123, 456, 9,   100));
        printf ("%d\n", f (123, 45,  78,  10));
};
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#004a43; '>#</span><span style='color:#004a43; '>include </span><span style='color:#800000; '>&lt;</span><span style='color:#40015a; '>stdio.h</span><span style='color:#800000; '>></span>

<span style='color:#004a43; '>#</span><span style='color:#004a43; '>define</span><span style='color:#004a43; '> WORDBITS 64</span>
<span style='color:#696969; '>// branchless functions, copypasted from </span><span style='color:#5555dd; '>http://aggregate.org/MAGIC/#Integer%20Minimum%20or%20Maximum</span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>define</span><span style='color:#004a43; '> MIN</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>x</span><span style='color:#808030; '>,</span><span style='color:#004a43; '>y</span><span style='color:#808030; '>)</span><span style='color:#004a43; '> </span><span style='color:#808030; '>(</span><span style='color:#004a43; '>x</span><span style='color:#808030; '>+</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>y</span><span style='color:#808030; '>-</span><span style='color:#004a43; '>x</span><span style='color:#808030; '>)</span><span style='color:#808030; '>></span><span style='color:#808030; '>></span><span style='color:#808030; '>(</span><span style='color:#004a43; '>WORDBITS</span><span style='color:#808030; '>-</span><span style='color:#004a43; '>1</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#808030; '>&amp;</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>y</span><span style='color:#808030; '>-</span><span style='color:#004a43; '>x</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span>
<span style='color:#004a43; '>#</span><span style='color:#004a43; '>define</span><span style='color:#004a43; '> MAX</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>x</span><span style='color:#808030; '>,</span><span style='color:#004a43; '>y</span><span style='color:#808030; '>)</span><span style='color:#004a43; '> </span><span style='color:#808030; '>(</span><span style='color:#004a43; '>x</span><span style='color:#808030; '>-</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>x</span><span style='color:#808030; '>-</span><span style='color:#004a43; '>y</span><span style='color:#808030; '>)</span><span style='color:#808030; '>></span><span style='color:#808030; '>></span><span style='color:#808030; '>(</span><span style='color:#004a43; '>WORDBITS</span><span style='color:#808030; '>-</span><span style='color:#004a43; '>1</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#808030; '>&amp;</span><span style='color:#808030; '>(</span><span style='color:#004a43; '>x</span><span style='color:#808030; '>-</span><span style='color:#004a43; '>y</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span>

<span style='color:#696969; '>// find minimal value</span>
<span style='color:#800000; font-weight:bold; '>int</span> __attribute__ <span style='color:#808030; '>(</span><span style='color:#808030; '>(</span>noinline<span style='color:#808030; '>)</span><span style='color:#808030; '>)</span> f <span style='color:#808030; '>(</span><span style='color:#800000; font-weight:bold; '>int</span> a<span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>int</span> b<span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>int</span> c<span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>int</span> d<span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
        <span style='color:#696969; '>// taken from </span><span style='color:#5555dd; '>https://en.wikipedia.org/wiki/Sorting_network</span>
        <span style='color:#696969; '>// </span><span style='color:#5555dd; '>https://en.wikipedia.org/wiki/File:SimpleSortingNetwork2.svg</span>
        <span style='color:#696969; '>//</span>
        b<span style='color:#808030; '>=</span>MIN<span style='color:#808030; '>(</span>b<span style='color:#808030; '>,</span>d<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span> d<span style='color:#808030; '>=</span>MAX<span style='color:#808030; '>(</span>b<span style='color:#808030; '>,</span>d<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        a<span style='color:#808030; '>=</span>MIN<span style='color:#808030; '>(</span>a<span style='color:#808030; '>,</span>c<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span> c<span style='color:#808030; '>=</span>MAX<span style='color:#808030; '>(</span>a<span style='color:#808030; '>,</span>c<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        a<span style='color:#808030; '>=</span>MIN<span style='color:#808030; '>(</span>a<span style='color:#808030; '>,</span>b<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span> b<span style='color:#808030; '>=</span>MAX<span style='color:#808030; '>(</span>a<span style='color:#808030; '>,</span>b<span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>

        <span style='color:#800000; font-weight:bold; '>return</span> a<span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span><span style='color:#800080; '>;</span>

<span style='color:#800000; font-weight:bold; '>int</span> <span style='color:#400000; '>main</span><span style='color:#808030; '>(</span><span style='color:#808030; '>)</span>
<span style='color:#800080; '>{</span>
        <span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#007997; '>%d</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> f <span style='color:#808030; '>(</span><span style='color:#008c00; '>123</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>456</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>789</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>1000</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#007997; '>%d</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> f <span style='color:#808030; '>(</span><span style='color:#008c00; '>123</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>456</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>999</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#007997; '>%d</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> f <span style='color:#808030; '>(</span><span style='color:#008c00; '>123</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>456</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span>   <span style='color:#008c00; '>100</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
        <span style='color:#603000; '>printf</span> <span style='color:#808030; '>(</span><span style='color:#800000; '>"</span><span style='color:#007997; '>%d</span><span style='color:#0f69ff; '>\n</span><span style='color:#800000; '>"</span><span style='color:#808030; '>,</span> f <span style='color:#808030; '>(</span><span style='color:#008c00; '>123</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>45</span><span style='color:#808030; '>,</span>  <span style='color:#008c00; '>78</span><span style='color:#808030; '>,</span>  <span style='color:#008c00; '>10</span><span style='color:#808030; '>)</span><span style='color:#808030; '>)</span><span style='color:#800080; '>;</span>
<span style='color:#800080; '>}</span><span style='color:#800080; '>;</span>
</pre>

m4_include(`spoiler_hide.inc')
</div>

_BLOG_FOOTER()
