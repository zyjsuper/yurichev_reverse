m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #15 (for x64 SSE2); solution for exercise #14')

_HL2(`Reverse engineering exercise #15 (for x64 SSE2)')

<p>Now that's really easy. What this code does?</p>

<p>Optimizing clang 3.4, LLVM 3.4, AT&T syntax:</p>

_PRE_BEGIN
f:                                      # @f
        xorps   %xmm0, %xmm0
        movups  %xmm0, 240(%rdi)
        movups  %xmm0, 224(%rdi)
        movups  %xmm0, 208(%rdi)
        movups  %xmm0, 192(%rdi)
        movups  %xmm0, 176(%rdi)
        movups  %xmm0, 160(%rdi)
        movups  %xmm0, 144(%rdi)
        movups  %xmm0, 128(%rdi)
        movups  %xmm0, 112(%rdi)
        movups  %xmm0, 96(%rdi)
        movups  %xmm0, 80(%rdi)
        movups  %xmm0, 64(%rdi)
        movups  %xmm0, 48(%rdi)
        movups  %xmm0, 32(%rdi)
        movups  %xmm0, 16(%rdi)
        movups  %xmm0, (%rdi)
        ret
_PRE_END

<p>Solution is to be posted soon...</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #14')

_HTML_LINK(`http://yurichev.com/blog/exercise14',`(Link to exercise)')

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">The code is analogous to isalpha(). Java:</p>

<pre class="spoiler">
public class e14
{
	public boolean f (char a)
	{
		if (a>='a' && a<='z')
			return true;
		if (a>='A' && a<='Z')
			return true;
		return false;
	}
}
</pre>

<p class="spoiler">C#: </p>

<pre class="spoiler">
using System;

public class some_class
{
   public static bool f(char a)
   {
      if (a>='a' && a<='z')
	return true;
      if (a>='A' && a<='Z')
	return true;
      return false;
   }
}
</pre>

_BLOG_FOOTER()
