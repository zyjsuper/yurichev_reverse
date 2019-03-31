m4_include(`commons.m4')

_HEADER_HL1(`[Math][Python][Z3] Bit reverse function verification')

<p>This is quite popular function.
Unfortunately, such a hackish code is error-prone, an unnoticed typo can easily creep in.</p>

<p>While you can check all possible 32-bit values in brute-force manner, this is infeasible for 64-bit function(s).</p>

<p>As before, I'm not proving here the function is "correct" in some sense,
but I'm proving equivalence of two functions: bitrev64()
and bitrev64_unoptimized(), which use bitrev32(), which in turn uses bitrev16(), etc...</p>

_PRE_BEGIN
m4_include(`blog/bitrev/bitrev_Z3.py')
_PRE_END

<p>The problem is easy enough to be solved using my toy MK85 bitblaster, with only tiny modifications:</p>

_PRE_BEGIN
m4_include(`blog/bitrev/bitrev_MK85.py')
_PRE_END


_BLOG_FOOTER()

