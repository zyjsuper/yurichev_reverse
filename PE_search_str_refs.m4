m4_include(`commons.m4')

_HEADER(`PE_search_str_refs')
_HL1(`PE_search_str_refs')

<p><i>PE_search_str_refs</i> is a simple tool for searching for a function in 
PE executables which use some text string</p>

<p>Usage:</p>

_PRE_BEGIN
PE_search_str_refs.exe [--unicode] [--verbose] filename.exe text_string
_PRE_END

<p>For example:</p>

_PRE_BEGIN
PE_search_str_refs.exe filename.exe hello
_PRE_END

<p>Resulting address will (hopefully) be an address of function which use this text string.</p>

<p>It may produce a lot of disassembling errors to stderr, so it can be redirected to NUL:</p>

_PRE_BEGIN
PE_search_str_refs.exe filename.exe hello 2> nul
_PRE_END

<p>It can also be used in pair with my other utility: 
_HTML_LINK(`PE_patcher.html',`PE_patcher').</p>

<p>Download: _HTML_LINK(`utils/PE_search_str_refs.exe',`win32 executable'), 
_HTML_LINK(`utils/PE_search_str_refs64.exe',`win64 executable')</p>
<p>_HTML_LINK(`https://github.com/dennis714/bolt/blob/master/PE_search_str_refs.c',`Source code'). 
_HTML_LINK(`https://github.com/dennis714/bolt',`Bolt library') in which this utility is incorporated</p>

_FOOTER()
