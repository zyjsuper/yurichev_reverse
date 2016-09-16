m4_include(`commons.m4')

_HEADER_HL1(`24-Jul-2009: CVE-2009-1970 PoC (CPUjul2009)')

<p>This PoC works with at least these Listeners:</p>

<p>11.1.0.6.0 win32</p>
<p>10.2.0.4 win32</p>
<p>10.1.0.5 win32</p>

<p>It makes Listener crashing and require relatively fast network. 
On other side, server's heavy load may be very helpful environment for this.</p>

<p>Basically, all what it do, is just sending these two TNS commands to host, in eternal loop:</p>

<p><i>(CONNECT_DATA=(COMMAND=service_register)(SERVICE_ID=1CB5887660D7-11DD-9EBE-000C29E11606)(ADDRESS=(PROTOCOL=TCP)(HOST=some_host)(PORT=1098))(FLAGS=2))</i></p>

<p>and</p>

<p><i>(CONNECT_DATA=(COMMAND=service_register)(SERVICE_ID=1CB5887660D7-11DD-9EBE-000C29E11606)(ADDRESS=(PROTOCOL=TCP)(HOST=some_host)(PORT=1098))(FLAGS=2)(HANDOFF=OFF))</i></p>

<p>Probably, it is not a matter of service_register command parameters, but parameters set should be slightly different.</p>

<p>Use hostname or IP-address of victim host as argument in command-line and run.</p>

<p>If I'm correct (I may not) this problem is related to nsdisc() function in network layer. Listener closes connection using this function. It frees
some memory, but the same chunk of memory is used again for next connection.</p>

<p><a href="//yurichev.com/non-wiki-files/blog/exploits/oracle/CVE-2009-1970.zip">Download source code + win32 executable.</a></p>

_BLOG_FOOTER_GITHUB(`26')

_BLOG_FOOTER()

