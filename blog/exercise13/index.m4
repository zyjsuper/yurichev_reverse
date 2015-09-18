m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #13 (for x86 SSE2); solution for exercise #12')

_HL2(`Reverse engineering exercise #13 (for x86 SSE2)')

<p>What this code does?</p>

<p>Optimizing GCC 4.8.2:</p>

_PRE_BEGIN
f:
	xor	rax, rax
.L4:
	movdqu	xmm0, XMMWORD PTR [rsi+rax]
	movdqu	xmm1, XMMWORD PTR [rdx+rax]
	pmaxub	xmm0, xmm1
	movdqu	XMMWORD PTR [rdi+rax], xmm0
	add	rax, 16
	cmp	rax, 1024
	jne	.L4
	rep ret
_PRE_END

<p>Solution is to be posted soon...</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #12')

_HTML_LINK(`http://yurichev.com/blog/exercise12',`(Link to exercise)')

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">
The program just sets current date/time to the file supplied.
It's simplified version of the <a href="https://en.wikipedia.org/wiki/Touch_%28Unix%29" class="spoiler">touch UNIX utility</a>.
</p>

<pre class="spoiler">
#include &lt;sys/stat.h>
#include &lt;stdio.h>
#include &lt;time.h>
#include &lt;utime.h>
 
// copypasted from http://rosettacode.org/wiki/File_modification_time#C and reworked slightly
int main(int argc, char* argv[])
{
	struct stat foo;
	time_t mtime;
	struct utimbuf new_times;
 
	if (argc!=2)
		printf ("Usage: &lt;filename>\n");

	if (stat(argv[1], &foo) &lt; 0)
	{
		printf ("error #1!\n");
		exit(0);
	}
	mtime = foo.st_mtime; /* seconds since the epoch */
 
	new_times.actime = foo.st_atime; /* keep atime unchanged */
	new_times.modtime = time(NULL);    /* set mtime to current time */
	if (utime(argv[1], &new_times) &lt; 0) 
	{
		printf ("error #2!\n");
		exit(0);
	}
	return 0;
}
</pre>

_BLOG_FOOTER()
