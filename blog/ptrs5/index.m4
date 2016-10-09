m4_include(`commons.m4')

_HEADER_HL1(`29-Jun-2016: C/C++ pointers: array as function argument')

_COPYPASTED1()

<p>(For those who have a hard time in understanding C/C++ pointers).</p>

<p>Someone may ask, what is the difference between declaring function argument type as array instead of pointer?</p>

<p>As it seems, there are no difference at all:</p>

_PRE_BEGIN
void write_something1(int a[16])
{
	a[5]=0;
};

void write_something2(int *a)
{
	a[5]=0;
};

int f()
{
	int a[16];
	write_something1(a);
	write_something2(a);
};
_PRE_END

<p>Optimizing GCC 4.8.4:</p>

_PRE_BEGIN
write_something1:
        mov     DWORD PTR [rdi+20], 0
        ret

write_something2:
        mov     DWORD PTR [rdi+20], 0
        ret
_PRE_END

<p>But you may still declare array instead of pointer for self-documenting purposes, if the size of array is always fixed.
And maybe, some static analysis tool will be able to warn you about possible buffer overflow.
Or is it possible with some tools today?</p>

<hr>
<p>My other blog posts about C/C++ pointers: [
_HTML_LINK(`http://yurichev.com/blog/ptrs',`1') |
_HTML_LINK(`http://yurichev.com/blog/ptrs2',`2') |
_HTML_LINK(`http://yurichev.com/blog/ptrs3',`3') |
_HTML_LINK(`http://yurichev.com/blog/ptrs4',`4') |
_HTML_LINK(`http://yurichev.com/blog/ptrs5',`5') ]
</p>

_BLOG_FOOTER_GITHUB(`ptrs5')

_BLOG_FOOTER()

