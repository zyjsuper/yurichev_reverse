m4_include(`commons.m4')

_HEADER(`PE_add_imports')
_HL1(`PE_add_imports')

<p><i>PE_add_imports</i> is a simple tool for adding symbol(s) to PE executable import table</p>

<p>Sometimes, you may need to replace existing function in binary code by function in your own DLL.</p>

<p>This utility adds yourdll.dll!function import into PE image and writes the following code at the specified point:</p>

_PRE_BEGIN
JMP [yourdll.dll!function]
_PRE_END

A FIXUP is also added at the relevant place of JMP instruction.

<p>Usage:</p>

First, prepare a file with imports, in the following format:

_PRE_BEGIN
address1 yourdll.dll!symbol1
address2 yourdll.dll!symbol2
..etc.._PRE_END

For example:

_PRE_BEGIN
0x11223344 yourdll.dll!symbol1
0x10203040 yourdll.dll!symbol2
..etc.._PRE_END

Let it be in imports_table.txt file.

Then run:

_PRE_BEGIN
PE_add_imports.exe fname.exe imports_table.txt
_PRE_END

<p>Download: _HTML_LINK(`utils/PE_add_imports.exe',`win32 executable'), 
_HTML_LINK(`utils/PE_add_imports64.exe',`win64 executable')</p>
<p>_HTML_LINK(`https://github.com/DennisYurichev/bolt/blob/master/PE_add_imports.c',`Source code'). 
_HTML_LINK(`https://github.com/DennisYurichev/bolt',`Bolt library') in which this utility is incorporated</p>

_FOOTER()
