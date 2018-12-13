m4_include(`commons.m4')

_HEADER_HL1(`(C, C++, x86/x64 assembly): The case of forgotten return')

<p>This is a bug I once hit.</p>

<p>And this is also yet another demonstration, how C/C++ places return value into EAX/RAX register.</p>

<p>In the piece of code like that, I forgot to add "return":</p>

_PRE_BEGIN
#include &lt;stdio.h>                                                                                                                
#include &lt;stdlib.h>

struct color
{
        int R;
        int G;
        int B;
};

struct color* create_color (int R, int G, int B)
{
        struct color* rt=(struct color*)malloc(sizeof(struct color));

        rt->R=R;
        rt->G=G;
        rt->B=B;
        // must be "return rt;" here
};

int main()
{
        struct color* a=create_color(1,2,3);
        printf ("%d %d %d\n", a->R, a->G, a->B);
};
_PRE_END

<p>Non-optimizing GCC 5.4 silently compiles this with no warnings.
AND THE CODE WORKS!
Let's see, why:</p>

_PRE_BEGIN
m4_include(`blog/no_return/O0_no_return_works.lst')
_PRE_END

<p>If I add "return rt;", the only instruction is added at the end, which is redundant:</p>

_PRE_BEGIN
m4_include(`blog/no_return/O0_return_works.lst')
_PRE_END

<p>Bugs like that are very dangerous, sometimes they appear, sometimes hide.
It's like: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Heisenbug').</p>

<p>Now I'm trying optimizing GCC:</p>

_PRE_BEGIN
m4_include(`blog/no_return/O3_no_return_crash.lst')
_PRE_END

<p>Compiler deducing that nothing returns from the function, so it optimizes it away.
And it assumes, that is returns 0 by default. The zero is then used as an address to a structure in main()..
Of course, this code crashes.</p>

<p>GCC is C++ mode silent about it as well.</p>

<p>Let's try non-optimizing MSVC 2015 x86.
It warns about the problem:</p>

_PRE_BEGIN
c:\tmp\3.c(19) : warning C4716: 'create_color': must return a value                                                               
_PRE_END

<p>And generates crashing code:</p>

_PRE_BEGIN
m4_include(`blog/no_return/MSVC_x86_crash.lst')
_PRE_END

<p>Now optimizing MSVC 2015 x86 generates crashing code as well, but for the different reason:</p>

_PRE_BEGIN
m4_include(`blog/no_return/MSVC_Ox_x86_crash.lst')
_PRE_END

<p>However, non-optimizing MSVC 2015 x64 generates working code:</p>

_PRE_BEGIN
m4_include(`blog/no_return/MSVC_x64_works.lst')
_PRE_END

<p>Optimizing MSVC 2015 x64 also inlines the function, as in case of x86, and the resulting code also crashes.</p>

<p>The moral of the story: warnings are very important, use "-Wall", etc, etc...
When "return" statement is absent, compiler can just silently do nothing at that point.</p>

<p>Such a bug left unnoticed can make an extremely bad day.</p>

_BLOG_FOOTER()

