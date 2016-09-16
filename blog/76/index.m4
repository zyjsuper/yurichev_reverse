m4_include(`commons.m4')

_HEADER_HL1(`16-Oct-2013: Add import to PE executable file')

<p>Just wrote an utility I always missed:</p>

<p>PE_add_import is a simple tool for adding symbol to PE executable import table</p>

<p>Sometimes, you may need to replace existing function in binary code by function in your own DLL.</p>

<p>This utility adds yourdll.dll!function import into PE image and writes the following code at the specified point:</p>

_PRE_BEGIN
MOV EAX, [yourdll.dll!function]
JMP EAX
_PRE_END

<p>Usage:</p>

_PRE_BEGIN
usage: fname DLL_name sym_name sym_ordinal func_address
for example: winword.exe mydll.dll MyFunction 1 0x401122
_PRE_END

<p>_HTML_LINK_AS_IS(`//yurichev.com/PE_add_import.html')</p>

_BLOG_FOOTER_GITHUB(`76')

_BLOG_FOOTER()

