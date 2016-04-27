m4_include(`commons.m4')

_HEADER_HL1(`13-Jul-2008: Network trace in Oracle RDBMS')

<p>There're well-known parameters <i>trace_level_server</i> and <i>trace_level_client</i> in <a href="http://download.oracle.com/docs/cd/B19306_01/network.102/b14268/asoappa.htm">sqlnet.ora</a>, which are defining debugging level of trace files.</p>
<p>A lot of network functions may call a special trace writer function which put passed information into trace file.</p>
<p>Usually, software developer with common sense makes trace writer function checking current debug level and let this tracer writer decide if to write any information to file. In this case his code is relatively clean and clear.</p>
<p>Oracle RDBMS developers make decision about this before trace writer function called, so code may looks like: </p>

_PRE_BEGIN
if (trace_is_enabled) write_to_trace (current_function_name, trace_level, message);
_PRE_END

<p>Most likely, this code is actually written using <a href="http://en.wikipedia.org/wiki/C_preprocessor#Macro_definition_and_expansion">#define macros</a>.</p>
<p>At least, Oracle 8.1.5 win32 installation contain <i>C:\Oracle\Ora81\NETWORK\TNSAPI\SRC\</i> folder where <i>TNSAPI.C</i> file may be found: it contain some trace writer calls using macros, although, I cannot found there a macros definition.</p>
<p>For example:</p>

_PRE_BEGIN
    /* enable the tracing */
    {
	NLTRDEFINE("tnsopen", npd, NLDTTNSAPI, NLDTTDUMMY, NLDTTDUMMY);
	NLTRENTER();
...
		/* it is an explicit NVstring, so use it directly */
		NLTRUSR((NLTRTRC, "Name is already an NVstring.\n"));
...
		    NLTRUSR((NLTRTRC, "Name is %s.\n", hdl->service_tnshdl));
...
	NLTREXIT();
_PRE_END

<p>So, in this case, code is not so clear, but here we can see time economy at the place of trace writer function prolog and epilog. 
Not a bad idea at all.</p>

_BLOG_FOOTER_GITHUB(`7')

_BLOG_FOOTER()

