m4_include(`commons.m4')

_HEADER_HL1(`24-Dec-2009: Events checked in some major Oracle RDBMS versions')

<p>
I prepared lists of events checked in some major Oracle RDBMS versions.</p>

<ul>
<li><a href="http://yurichev.com/non-wiki-files/blog/events/10.2.0.1_linux86_events.txt">10.2.0.1 Linux x86</a>
<li><a href="http://yurichev.com/non-wiki-files/blog/events/10.2.0.4_linux86_events.txt">10.2.0.4 Linux x86</a>
<li><a href="http://yurichev.com/non-wiki-files/blog/events/11.1.0.6.0_linux86_events.txt">11.1.0.6.0 Linux x86</a>
<li><a href="http://yurichev.com/non-wiki-files/blog/events/11.1.0.7.0_linux86_events.txt">11.1.0.7.0 Linux x86</a>
<li><a href="http://yurichev.com/non-wiki-files/blog/events/11.2.0.1.0_linux86_events.txt">11.2.0.1.0 Linux x86</a>
</ul>

<p>Remember, something may be missing there.</p>

<p>How I did it: just disassembled by IDA all .o files from libserver10.a or libserver11.a:</p>

<pre>idaw -B [each_file]</pre>

<p>Then:</p>

<pre>cat *.asm | grep -B 1 ksdpec | grep push | sort | uniq > _events</pre>

<p>... or for 11g:</p>

<pre>cat *.asm | grep -B 1 dbkdChkEventRdbmsErr | grep push | sort | uniq > _events</pre>

_BLOG_FOOTER_GITHUB(`33')

_BLOG_FOOTER()

