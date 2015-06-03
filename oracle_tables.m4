m4_include(`commons.m4')

_HEADER(`Oracle tables')

_HL1(`Oracle tables:')

<p>This utility intended to dump some Oracle RDBMS 11.2 tables.</p>

_PRE_BEGIN
Usage:

To dump kqftab, kqftap, kqfvip, kqfviw:
ora_tables.exe kqf.o

To dump kqfd_tab_registry.0
ora_tables.exe kqfd.o

These .o files can be extracted from libserver11.a:

ar -x libserver11.a
_PRE_END

<p>_HTML_LINK(`https://github.com/dennis714/oracle-tables', `source code')</p>

<p>Download compiled version (win64): _HTML_LINK(`oracle/oracle_tables_win64.exe', `oracle_tables_win64.exe')</p>
<p>Download compiled version (Linux x64): _HTML_LINK(`oracle/oracle_tables_linux64.tar', `oracle_tables_linux64.tar')</p>

<p>Sample dumps:</p>

<ul>
<li>_HTML_LINK(`oracle/kqfd_tab_registry.0.txt', `kqfd_tab_registry.0.txt')
<li>_HTML_LINK(`oracle/kqftab_kqftap.txt', `kqftab_kqftap.txt')
<li>_HTML_LINK(`oracle/kqfvip_kqfviw.txt', `kqfvip_kqfviw.txt')
</ul>

_FOOTER()
