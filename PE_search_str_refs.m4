m4_include(`commons.m4')

_HEADER(`PE_search_str_refs')
_HL1(`PE_search_str_refs')

<p><i>PE_search_str_refs</i> is a simple tool for searching for a function in 
PE executables which use some text string</p>

<p>Usage:</p>

<pre>
PE_search_str_refs.exe [--unicode] [--verbose] filename.exe text_string
</pre>

<p>For example:</p>

<pre>
PE_search_str_refs.exe filename.exe hello
</pre>

<p>Resulting address will (hopefully) be an address of function which use this text string.</p>

<p>It may produce a lot of disassembling errors to stderr, so it can be redirected to NUL:</p>

<pre>
PE_search_str_refs.exe filename.exe hello 2> nul
</pre>

<p>Download: _HTML_LINK(`utils/PE_search_str_refs.exe',`win32 executable'), 
_HTML_LINK(`utils/PE_search_str_refs64.exe',`win64 executable')</p>
<p>_HTML_LINK(`https://github.com/dennis714/bolt/blob/master/PE_search_str_refs.c',`Source code'). 
_HTML_LINK(`https://github.com/dennis714/bolt',`Bolt library') in which this utility is incorporated</p>

_UTIL_DONATE()

_FOOTER()
