m4_include(`commons.m4')

_HEADER_HL1(`27-Jul-2011: Strings in Oracle RDBMS network layer')

<p>Not sure if it's worth blogging...</p>

<p>All strings in Oracle RDBMS network layer are usual C-strings terminated by zero byte, but often, string length is also passing as a separate function argument.
This makes some things much faster.</p>

<ul>
<li> strlen() is not necessary anymore - just take string length you already have.
<li> strcat() do not need to calculate string lengths.
<li> strcmp() against const string is working much faster:
</ul>

<p>Instead of:</p>

_PRE_BEGIN
if (strcmp (s, "STRING")) ...
_PRE_END

<p>We have (we first check 's' string len against "STRING" length, if it doesn't equal, we may not compare each byte):</p>

_PRE_BEGIN
if (s_len==6)
    if (strcmp (s, "STRING"))..
_PRE_END

<p>Another example is:</p>

_PRE_BEGIN
if (strcmp (s, "ASD"))...
if (strcmp (s, "DEF"))...

if (strcmp (s, "ASD1"))...
if (strcmp (s, "ORCL"))...
_PRE_END

<p>Instead, we can write:</p>

_PRE_BEGIN
void f(char* s, int s_len)
{

if (s_len==3)
{
... check s against all 3-char strings here: ASD, DEF
}
else
if (s_len==4)
{
... check s against all 4-char strings here: ASD1, ORCL
}
else
{
... check the rest
}
_PRE_END

<p>... which is much faster, of course.</p>

<p>All strings are still C-strings with zero byte at the end, so they are all can be used as argument to any C standard library function.</p>

_BLOG_FOOTER_GITHUB(`64')

_BLOG_FOOTER()

