m4_include(`commons.m4')

_HEADER_HL1(`Typeless programming languages (BCPL, B), C evolution and decompilation')

_HL2(`DCC decompiler by Cristina Cifuentes')

<p>The early _HTML_LINK(`http://www.program-transformation.org/Transform/DccDecompiler',`DCC decompiler') 
by Cristina Cifuentes produces results in C-like code in the files with .B extension.</p>

<p>Here is example:</p>

_PRE_BEGIN
/*
 * Input file   : STRLEN.EXE
 * File type    : EXE
 */
#include "dcc.h"


void proc_1 (int arg0)
/* Takes 2 bytes of parameters.
 * High-level language prologue code.
 * C calling convention.
 */
{
int loc1;

    loc1 = 0;
    arg0 = (arg0 + 1);

    while ((*arg0 != 0)) {
        loc1 = (loc1 + 1);
        arg0 = (arg0 + 1);
    }   /* end of while */
}


void main ()
/* Takes no parameters.
 */
{
int loc1;
    loc1 = 404;
    proc_1 (loc1);
}
_PRE_END

<p>Perhaps, she kept in mind B programming language?</p>

_HL2(`B programming language')

<p>B programming language was developed by Ken Thompson and Dennis Ritchie before they work on C.
In essence, B language is typeless C language.</p>

<p>Here is B code snippet:</p>

_PRE_BEGIN
strcopy(sl,s2)
{
	auto i;
	i = 0;
	while (lchar(sl,i,char(s2,i)) != '*e') i++;
}
_PRE_END

<p>Very similar to C, but there are no types in function definition.
Local variables are declared with <i>auto</i> keyword.</p>

<p>All arguments and variables has just one possible type -- CPU register or <i>word</i> in old computers environment, or <i>int</i> in C lingo.</p>

<p>As far as I right, B language was used in UNIX v2.</p>

_HL3(`Strings handling in B')

<p>String handling in B is tricky, since B has no idea of bytes.
So each 4 characters are packed into one register (or word).
"Hello world" program is then (if I correct, I have no B compiler):</p>

_PRE_BEGIN
main()
{
 putchar('hell'); putchar('o, w'); putchar('orld'); putchar('!*n');
}
_PRE_END

<p>putchar() prints all 4 characters in input word. If you need to print 1 or 2 or 3 characters packed in <i>word</i>, the word is padded by zero bytes.</p>

<p>Here is the function to get character at some index from a vector of <i>words</i>:</p>

_PRE_BEGIN
char(s, n)
{
	auto y,sh,cpos;
	y = s[n/4];        /* word containing n-th char */
	cpos = n%4;        /* position of char in word */
	sh = 27-9*cpos;    /* bit positions to shift */
	y =  (y>>sh)&0777; /* shift and mask all but 9 bits */
	return(y);         /* return character to caller */
}
_PRE_END

<p>The code snippet is taken from _HTML_LINK(`https://www.bell-labs.com/usr/dmr/www/btut.html',`this article') written by B.W.Kernighan,
and since we see that 9 bits are allocated for character, and 4 characters were packed in a word, this code was intended for 36-bit computer.
As I understand, _HTML_LINK(`https://en.wikipedia.org/wiki/Honeywell_6000_series',`36-bit Honeywell 6000 series') is meant.</p>

<p>As Dennis Ritchie _HTML_LINK(`https://www.bell-labs.com/usr/dmr/www/chist.html',`states'),
C was developed to overcome limits of typeless variables, first to make string handling easier and also to handle floating point variables.</p>

_HL2(`B&rsquo;s heritage in C')

<p>Amusingly, latest GCC still can compile B code.
I tried this and GCC compiled in, treating all types as <i>int</i>:</p>

_PRE_BEGIN
f(a, b, c)
{
	return a+b+c;
};
_PRE_END

<p>GCC compiles even this:</p>

_PRE_BEGIN
f1(a, b, c)
{
	auto tmp;
	tmp=a+b;
	return tmp+c;
};
_PRE_END

<p>It was an oddity to C learners in past, no one could understand <i>auto</i> keyword.
C textbooks are also omitted explanations.
But it seems, it's just heritage of B. GCC treats <i>auto</i> just as <i>int</i>.</p>

<p>Why B has <i>auto</i> keyword? Well, if to replace <i>auto</i> to <i>static</i>,
the variable will be declared as global variable instead of to be placed in the stack.
This is still true for latest C/C++ standards as well.
So <i>auto</i> means that these variables are to be placed in the stack.</p>

<p>Apparently, all this stuff were in C to ease porting from B source code?
Or C was just <i>typed B</i> at the time, like <i>C++ is C with classes</i>?</p>

<p>And it's still possible in C/C++ to pack 4 (or less) characters into a word:</p>

_PRE_BEGIN
int a='test';
_PRE_END

<p>Looks like unique feature to C/C++?</p>

_HL2(`K&R C syntax')

<p>Sometimes, in ancient C code, we can find a function definitions, where argument types are enumerated after the first line:</p>

_PRE_BEGIN
f2(a, b, c)
char a;
char b;
{
	return a+b+c;
};
_PRE_END

<p>That still compiles by the latest GCC: <i>a</i> and <i>b</i> are treated as arguments of <i>char</i> type and <i>c</i> still has default <i>int</i> type.</p>

<p>Perhaps, K&R C function definition syntax is appeared when programmers ported B code to C and just supplied each function arguments by corresponding data types.
Looks clumsy, so late ANSI C standard allows much more familiar definitions:</p>

_PRE_BEGIN
f2(char a, char b, int c)
{
	return a+b+c;
};
_PRE_END

_HL2(`Hungarian notation')

<p>When you write a lot in typeless languages (including assembly language), you need to keep track, which variable has which type.
Apparently, _HTML_LINK(`https://en.wikipedia.org/wiki/Hungarian_notation',`Hungarian notation') was heavily used here:</p>

<blockquote>
The Hungarian notation was developed to help programmers avoid inadvertent type errors.
</blockquote>

( _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/BCPL') )

<p>Well, maybe not in this precise form, but you've got the idea: variable (and function) name can also encode its data type.</p>

_HL3(`Hungarian notation in typed languages (C/C++)')

<p>It was (or still?) heavily used by Microsoft.
Perhaps (I'm not sure) it was attempt to improve C/C++ code readability?</p>

_HL2(`Can B still be used today?')

<p>The B language is even simpler than C. Maybe it can be still used on cheap CPUs with no byte-level instructions?</p>

<p>Maybe it can be used for teaching: many toy-level compiler writers first start at typeless C-like compilers.</p>

<p>Decompiler writers are also start here, at typeless C-like languages.</p>

_HL2(`Manual decompilataion and typeless languages')

<p>When you decompile some piece of machine code manually, you can think of CPU registers as temporary typeless variables.
Hungarian notation can also be used heavily in IDA, to keep track, what variable data type has a variable in stack or everywhere else.</p>

_HL2(`Links')

<ul>
<li> _HTML_LINK(`https://en.wikipedia.org/wiki/B_%28programming_language%29',`Wikipedia page on B (programming language)')
<li> _HTML_LINK(`https://www.bell-labs.com/usr/dmr/www/chist.html',`Dennis M. Ritchie - The Development of the C Language')
<li> _HTML_LINK(`https://www.bell-labs.com/usr/dmr/www/kbman.html',`Ken Thompson - Users&rsquo; Reference to B')
<li> _HTML_LINK(`https://www.bell-labs.com/usr/dmr/www/btut.html',`B. W. Kernighan - A TUTORIAL INTRODUCTION TO THE LANGUAGE B')
<li> _HTML_LINK(`https://www.bell-labs.com/usr/dmr/www/bref.html',`S. C. Johnson - USERS&rsquo; REFERENCE TO B ON MH-TSS')
<li> _HTML_LINK(`http://www.program-transformation.org/Transform/DccDecompiler',`Dcc Decompiler')
<li> _HTML_LINK(`https://github.com/nemerle/dcc',`...heavily updated version of the old DOS executable decompiler DCC')
</ul>

_BLOG_FOOTER()

