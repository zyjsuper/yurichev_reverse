m4_include(`commons.m4')

_HEADER(`PE_add_import')
_HL1(`PE_add_import')

<p><i>PE_add_import</i> is a simple tool for adding symbol to PE executable import table</p>

<p>Sometimes, you may need to replace existing function in binary code by function in your own DLL.</p>

<p>This utility adds yourdll.dll!function import into PE image and writes the following code at the specified point:</p>

<pre>
MOV EAX, [yourdll.dll!function]
JMP EAX
</pre>

<p>Usage:</p>

<pre>
usage: fname DLL_name sym_name sym_ordinal func_address
for example: winword.exe mydll.dll MyFunction 1 0x401122
</pre>

<p>_HTML_LINK(`utils/PE_add_import.exe',`download win32 executable')</p>
<p>_HTML_LINK(`https://github.com/dennis714/bolt',`Bolt library in which this utility is incorporated')</p>

_FOOTER()
