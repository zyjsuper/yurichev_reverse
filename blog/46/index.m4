m4_include(`commons.m4')

_HEADER_HL1(`24-May-2010: PEEKs and POKEs in Windows x64?')

<p>This kernel/driver-level Windows NT code:</p>

<pre>
void huh()
{
	LARGE_INTEGER a;
	KeQueryTickCount(&a);
	DbgPrint ("%d", a.QuadPart);
};
</pre>

<p>... is now translated in Windows 2003 DDK x64 environment into:</p>

<pre>
                 mov     rdx, 0FFFFF78000000320h
                 lea     rcx, Format     ; "%d"
                 mov     rdx, [rdx]
                 call    DbgPrint_0
</pre>

<p>Wow, some variable's address (KeTickCount) is now hardcoded just into driver's code during compilation.</p>

<p>Is not it just return to the PEEKs and POKEs?</p>

<p>_HTML_LINK_AS_IS(`http://en.wikipedia.org/wiki/PEEK_and_POKE')</p>

<p>Is Microsoft promise to fix this variable to this address forever?</p>

_BLOG_FOOTER_GITHUB(`46')

_BLOG_FOOTER()

