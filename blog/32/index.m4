m4_include(`commons.m4')

_HEADER_HL1(`24-Dec-2009: Radiohead lyrics in Oracle RDBMS code')

<pre>strings oracle.exe | grep radiohead</pre>

<p>Starting at least at 10.2.0.1, function kfasSelfTest_update() (located in kfas.o) use <a href="http://en.wikipedia.org/wiki/Creep_(Radiohead_song)">Radiohead</a> lyrics to test... something related to ASM probably.</p>

<p>Schematic pseudocode:</p>

<pre>
#define STRING "I'm a creep, I'm a winner, what the hell am I doing here.I don't belong here - radiohead"

kfasSelfTest_update()
{
	kfasOpen (...);
	somestruct.somevalue=STRING;
	kfasUpdate (somestruct);
	kfasClose (...);
	newstruct=kfasOpen (...);
	if (strncmp (newstruct.somevalue, STRING, ...)!=0)
	{
		// raise error 99999?
		kserec1(99999, 1, ...);
		kserec2(99999, 1, ..., STRING, 1, ...);
		return 0;
	};
	kfasClose (...);
	return 1;
};
</pre>

<p>Update:
Lyrics is seems <a href="http://groups.google.com/group/comp.databases.oracle.server/browse_thread/thread/bfb6bb7e27cfd35a">not correct</a>...</p>

_BLOG_FOOTER_GITHUB(`32')

_BLOG_FOOTER()

