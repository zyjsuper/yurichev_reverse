m4_include(`commons.m4')

_HEADER(`Oracle tables')

_HL1(`Oracle tables:')

<p>This utility intended to dump some Oracle RDBMS 11.2 tables.</p>

<pre>
Usage:

To dump kqftab, kqftap, kqfvip, kqfviw:
ora_tables.exe kqf.o

To dump kqfd_tab_registry.0
ora_tables.exe kqfd.o

These .o files can be extracted from libserver11.a:

ar -x libserver11.a
</pre>

<p>_HTML_LINK(`https://github.com/dennis714/oracle-tables', `source code')</p>

<p>Download compiled version (win32): _HTML_LINK(`oracle/ora_tables.exe', `ora_tables.exe')</p>

<p>Sample dumps:</p>

<ul>
<li>_HTML_LINK(`oracle/kqfd_tab_registry.0.txt', `kqfd_tab_registry.0.txt')
<li>_HTML_LINK(`oracle/kqftab_kqftap.txt', `kqftab_kqftap.txt')
<li>_HTML_LINK(`oracle/kqfvip_kqfviw.txt', `kqfvip_kqfviw.txt')
</ul>

_FOOTER()
