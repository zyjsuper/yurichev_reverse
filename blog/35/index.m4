m4_include(`commons.m4')

_HEADER_HL1(`15-Jan-2010: More information about CVE-2009-1979 (CPUoct2009)')

<p>For those who want to research more about CVE-2009-1979 (<a href="http://www.oracle.com/technology/deploy/security/critical-patch-updates/cpuoct2009.html">CPUoct2009</a>) buffer overflow vulnerability, <a href="//yurichev.com/non-wiki-files/blog/exploits/oracle/CVE-2009-1979.py_.txt">here is simple Python script</a> to hit memcpy() inside of kpoauth() function, which result buffer overflow.</p>

<p>This script attempt to login into Oracle RDBMS by sending two DTYAUTH packets. First call kpogsk() function ("generate session key") (OPI call 0x76) and second call kpoauth() function (OPI call 0x73) (which check AUTH_SESSKEY and AUTH_PASSWORD from client). This script attempt to send string consisted of 200 'x' symbols as AUTH_SESSKEY value.</p>

<p>In Oracle RDBMS win32 version 10.2.0.2 unpatched, in function kpoauth(), first we see a call to kpzgkvl() at 0x01027700 (kpoauth()+0x488) which fetching values from DTYAUTH packets, then we see a call to __intel_fast_memcpy() at 0x01027715 (kpoauth()+0x49d), which copy this value into stack, where only 98 bytes reserved for it.</p>

<p>I never research more on that, but (if I'm correct: I may not), for successful exploitation, kpoauth() need to be finished correctly without errors. Does it mean AUTH_SESSKEY and AUTH_PASSWORD need to be correct? Not sure. Another note is that these string lengths cannot be longer than 255 symbols, because DTYAUTH packet reserve only byte value for string length (not sure here again).</p>

_BLOG_FOOTER_GITHUB(`35')

_BLOG_FOOTER()

