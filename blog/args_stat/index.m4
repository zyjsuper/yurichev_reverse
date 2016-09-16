m4_include(`commons.m4')

_HEADER_HL1(`6-May-2016: Function arguments statistics')

<p>I've always been interesting in what is average number of function arguments.</p>

<p>Just analysed many Windows 7 32-bit DLLs (crypt32.dll, mfc71.dll, msvcr100.dll, shell32.dll, 
user32.dll, d3d11.dll, mshtml.dll, msxml6.dll, sqlncli11.dll, wininet.dll, mfc120.dll, msvbvm60.dll, ole32.dll, themeui.dll, wmp.dll) 
(because they use stdcall convention, and so it is to grep disassembly output just by "RETN X").</p>

<ul>
<li>no arguments: ~29%
<li>1 argument: ~23%
<li>2 arguments: ~20%
<li>3 arguments: ~11%
<li>4 arguments: ~7%
<li>5 arguments: ~3%
<li>6 arguments: ~2%
<li>7 arguments: ~1%
</ul>

<center><img src="//yurichev.com/blog/args_stat/piechart.png"></center>

<p>This is heavily dependent on programming style and may be very different for other software products.</p>

_BLOG_FOOTER_GITHUB(`args_stat')

_BLOG_FOOTER()

