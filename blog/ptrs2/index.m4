m4_include(`commons.m4')

_HEADER_HL1(`22-May-2016: C/C++ pointers: yet another abuse')

<p>(For those who have a hard time in understanding C/C++ pointers).</p>

<p>Let's continue to abuse C/C++ language traditions and sane programming style (first part _HTML_LINK(`http://yurichev.com/blog/ptrs/',`here')).
Here is an example on how to pass values in pointers:</p>

_PRE_BEGIN
#include &lt;stdio.h>
#include &lt;stdint.h>

uint64_t multiply1 (uint64_t a, uint64_t b)
{
	return a*b;
};

uint64_t* multiply2 (uint64_t *a, uint64_t *b)
{
	return (uint64_t*)((uint64_t)a*(uint64_t)b);
};

int main()
{
	printf ("%d\n", multiply1(123, 456));
	printf ("%d\n", (uint64_t)multiply2((uint64_t*)123, (uint64_t*)456));
};
_PRE_END

<p>It works smoothly and GCC 4.8.4 compiles both multiply1() and multiply2() functions identically!</p>

_PRE_BEGIN
multiply1:
	mov	rax, rdi
	imul	rax, rsi
	ret

multiply2:
	mov	rax, rdi
	imul	rax, rsi
	ret
_PRE_END

<p>As long as you do not dereference pointer (in other words, you don't read any data from the address stored in pointer), everything will work fine.
Pointer is a variable which can store anything, like usual variable.
</p>

<p>By the way, it's well-known hack to abuse pointers a little called <i>tagged pointers</i>.
In short, if all your pointers points to blocks of memory with size of, let's say, 16 bytes (or it is always aligned on 16-byte boundary), 4 lowest bits of pointer is always zero bits and this space
can be used somehow.
It's very popular in LISP compilers and interpreters.
Read more about it: _HTML_LINK_AS_IS(`http://yurichev.com/writings/C-notes-en.pdf#page=20&zoom=auto,-107,595').</p>

<p>
Update (23-May-2016) Slava "Avid" Kazakov has asked, why signed <i>imul</i> instruction is used while pointer has type <i>uint64_t</i>?
Any idea?
</p>

<p>My other blog posts about C/C++ pointers: [
_HTML_LINK(`http://yurichev.com/blog/ptrs',`1') |
_HTML_LINK(`http://yurichev.com/blog/ptrs2',`2') |
_HTML_LINK(`http://yurichev.com/blog/ptrs3',`3') |
_HTML_LINK(`http://yurichev.com/blog/ptrs4',`4') ]</p>

_BLOG_FOOTER_GITHUB(`ptrs2')

_BLOG_FOOTER()

