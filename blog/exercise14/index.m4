m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #14 (for Java VM and .NET); solution for exercise #13')

_HL2(`Reverse engineering exercise #14 (for Java VM and .NET)')

<p>Now that's easy. What this code does?</p>

<p>Optimizing csc .NET compiler from MSVS 2015 (/o switch), ildasm output:</p>

_PRE_BEGIN
  .method public hidebysig static bool  f(char a) cil managed
  {
    // Code size       26 (0x1a)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldc.i4.s   97
    IL_0003:  blt.s      IL_000c

    IL_0005:  ldarg.0
    IL_0006:  ldc.i4.s   122
    IL_0008:  bgt.s      IL_000c

    IL_000a:  ldc.i4.1
    IL_000b:  ret

    IL_000c:  ldarg.0
    IL_000d:  ldc.i4.s   65
    IL_000f:  blt.s      IL_0018

    IL_0011:  ldarg.0
    IL_0012:  ldc.i4.s   90
    IL_0014:  bgt.s      IL_0018

    IL_0016:  ldc.i4.1
    IL_0017:  ret

    IL_0018:  ldc.i4.0
    IL_0019:  ret
  } // end of method some_class::f

_PRE_END

<p>Java 1.8 compiler:</p>

_PRE_BEGIN
  public boolean f(char);
    descriptor: (C)Z
    flags: ACC_PUBLIC
    Code:
      stack=2, locals=2, args_size=2
         0: iload_1
         1: bipush        97
         3: if_icmplt     14
         6: iload_1
         7: bipush        122
         9: if_icmpgt     14
        12: iconst_1
        13: ireturn
        14: iload_1
        15: bipush        65
        17: if_icmplt     28
        20: iload_1
        21: bipush        90
        23: if_icmpgt     28
        26: iconst_1
        27: ireturn
        28: iconst_0
        29: ireturn
_PRE_END

<p>Solution is to be posted soon...</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #13')

_HTML_LINK(`http://yurichev.com/blog/exercise13',`(Link to exercise)')

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">
The code is a result of automatic GCC SSE2 vectorizing. 
It takes two arrays of 1024 bytes, picks maximum value from the each pair and stores it to output array.
</p>

<pre class="spoiler">
#define max(a,b) (((a) > (b)) ? (a) : (b))

void f (uint8_t* dst, uint8_t* src1, uint8_t* src2)
{
	for (size_t i=0; i<1024; i++)
	{
		dst[i]=max(src1[i],src2[i]);
	};
};
</pre>

_BLOG_FOOTER()
