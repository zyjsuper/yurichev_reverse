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

<p>Solution is to be posted soon...</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #17')

_HTML_LINK(`http://yurichev.com/blog/exercise17',`(Link to exercise)')

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">The code just picks minimal value out of 4 inputs.
The code is tricky: I've used branchless min() and max() functions and sorting network 
(which can sort values in branchless manner as well).
</p>

<pre class="spoiler">
#include &lt;stdio.h>

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
</pre>

_BLOG_FOOTER()
