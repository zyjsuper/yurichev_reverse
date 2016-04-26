m4_include(`commons.m4')

_HEADER_HL1(`24-Jul-2009: CVE-2009-1963 PoC (CPUjul2009)')

<p><a href="http://blogs.oracle.com/security/2009/07/july_2009_critical_patch_update_released.html">- Finally, CVE-2009-1963 also receives a CVSS Base Score of 7.5; however it is not remotely exploitable without authentication, and only affects Oracle Database Server 11.1.0.6.</a></p>

<p>Here is explanation of vulnerability I did found.</p>

<p>This exploit makes Oracle 11g win32 instance DoS (spinning to 100% CPU) and raise heap corruption problems.</p>

<p>Because, I'm not sure in exact packets structures, please use exactly this:</p>

<p>1. Win32 box with Oracle 11g RDBMS.</p>
<p>2. Win32 box with Oracle 10gR2 (10.2) client installed.</p>

<p>Client is needed by version.cpp/exe program which logon as SCOTT/TIGER and executes "select * from v$version".
Do not forget to unlock SCOTT user or change user in version.cpp and recompile it.</p>

<p>Run tcp_fwd program:</p>

<pre>
tcp_fwd (IP address of 1st box) 1521 (IP address of 2nd box) 1521
</pre>

<p>All what this simple TCP forwarder do is only modify one packet in our sequence:</p>

<pre>
	      if (buf[0xA]==0x11 && r==229) // TTIPFN, that's our packet
		{
		  printf ("TTIPFN from client, we modify it.\n");

                  buf[4]=0xF;
                };
</pre>

<p>So, if packet have TTIPFN type and its size is 229, then this is a packet where "select * from v$version" statement goes.
tcp_fwd program modify TNS type of packet to 0xF type. Please note that this is so-called "DD packet" TNS packet type, introduced in 11g.</p>

<p>Run version.exe on box 2:</p>

<pre>
version (IP address of 2nd box)@orcl
</pre>

<p>After that, Oracle 11g instance will be spinning to 100% CPU and heap corruption problem should be raised.</p>

<p>Download:</p>
<p><a href="http://yurichev.com/non-wiki-files/blog/exploits/oracle/CVE-2009-1963/tcp_fwd_0.zip">TCP forwarder with source code.</a></p>
<p><a href="http://yurichev.com/non-wiki-files/blog/exploits/oracle/CVE-2009-1963/version_10g.zip">Simple program asking for version, to be running on 10.2 client.</a></p>

_BLOG_FOOTER_GITHUB(`25')

_BLOG_FOOTER()

