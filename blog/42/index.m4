m4_include(`commons.m4')

_HEADER_HL1(`30-Jan-2010: Random Oracle hosts statistics')

<p><a href="http://en.wikipedia.org/wiki/Nmap">Nmap</a> is a powerful tool, not only for scanning a remote host for open ports, by also for random stalking for something in the Internet.</p>
<p>For experiment, I and my friends ran nmap with <i>-iR 0 -p1521</i> options, meaning checking for open port 1521 on randomly generated IP addresses, infinitely.</p>

<p>Result: one working Oracle TNS Listener among nearly 69,000 random IP addresses.</p>

<p>Here is statistics on listener versions and operation systems.</p>

<p>Top 3 operation systems:</p>

<ul>
<li>37% - Linux
<li>52% - Windows
<li>6% - Solaris
</ul>

<p>Oracle TNS Listener versions:</p>

<ul>
<li>55% - 10.2
<li>23% - 9.2
<li>7% - 11.1
<li>5% - 8.1
<li>4% - 10.1
<li>2% - 8.0
<li>2% - 9.0
</ul>

<p>Didn't found any 11.2 working.</p>

<p>Full statistics: number is percentage and listener version reply.</p>

<pre>
21.22 TNSLSNR for Linux: Version 10.2.0.1.0 - Production
19.50 TNSLSNR for 32-bit Windows: Version 10.2.0.1.0 - Production
9.56 TNSLSNR for 32-bit Windows: Version 9.2.0.1.0 - Production
4.78 TNSLSNR for Linux: Version 9.2.0.4.0 - Production
2.68 TNSLSNR for 32-bit Windows: Version 10.2.0.4.0 - Production
2.68 TNSLSNR for Linux: Version 11.1.0.6.0 - Production
2.10 TNSLSNR for 32-bit Windows: Version 11.1.0.6.0 - Production
2.10 TNSLSNR for 32-bit Windows: Version 9.0.1.1.1 - Production
1.91 TNSLSNR for 32-bit Windows: Version 10.1.0.2.0 - Production
1.72 TNSLSNR for 32-bit Windows: Version 9.2.0.6.0 - Production
1.72 TNSLSNR for 32-bit Windows: Version 9.2.0.8.0 - Production
1.72 TNSLSNR for Linux: Version 10.2.0.3.0 - Production
1.53 TNSLSNR for 32-bit Windows: Version 10.2.0.3.0 - Production
1.53 TNSLSNR for 32-bit Windows: Version 8.1.7.0.0 - Production
1.53 TNSLSNR for Linux: Version 10.2.0.4.0 - Production
1.34 TNSLSNR for Solaris: Version 10.2.0.4.0 - Production
1.15 TNSLSNR for 32-bit Windows: Version 11.1.0.7.0 - Production
1.15 TNSLSNR for Solaris: Version 9.2.0.1.0 - Production
0.96 TNSLSNR for Linux: Version 8.1.7.0.0 - Development
0.96 TNSLSNR for Linux: Version 9.2.0.1.0 - Production
0.96 TNSLSNR for Solaris: Version 10.2.0.3.0 - Production
0.76 TNSLSNR for 64-bit Windows: Version 10.2.0.1.0 - Production
0.76 TNSLSNR for 64-bit Windows: Version 10.2.0.3.0 - Production
0.76 TNSLSNR for 64-bit Windows: Version 10.2.0.4.0 - Production
0.76 TNSLSNR for Linux: Version 11.1.0.7.0 - Production
0.76 TNSLSNR for MacOS X Server: Version 10.1.0.5.0 - Production
0.57 TNSLSNR for 32-bit Windows: Version 10.2.0.2.0 - Production
0.57 TNSLSNR for 32-bit Windows: Version 8.1.5.0.0 - Production
0.57 TNSLSNR for Linux: Version 10.1.0.3.0 - Production
0.57 TNSLSNR for Linux: Version 9.2.0.6.0 - Production
0.57 TNSLSNR for Solaris: Version 9.2.0.6.0 - Production
0.38 TNSLSNR for 32-bit Windows: Version 10.1.0.4.2 - Production
0.38 TNSLSNR for 32-bit Windows: Version 8.1.6.0.0 - Production
0.38 TNSLSNR for 32-bit Windows: Version 8.1.7.4.0 - Production
0.38 TNSLSNR for 32-bit Windows: Version 9.2.0.5.0 - Production
0.38 TNSLSNR for 64-bit Windows: Version 11.1.0.6.0 - Production
0.38 TNSLSNR for 64-bit Windows: Version 11.1.0.7.0 - Production
0.38 TNSLSNR for IBM/AIX RISC System/6000: Version 9.2.0.1.0 - Production
0.38 TNSLSNR for Linux: Version 10.2.0.2.0 - Production
0.38 TNSLSNR for Linux: Version 9.0.1.0.0 - Production
0.38 TNSLSNR for Solaris: Version 10.1.0.5.0 - Production
0.38 TNSLSNR for Solaris: Version 10.2.0.1.0 - Production
0.38 TNSLSNR for Solaris: Version 8.1.7.0.0 - Production
0.38 TNSLSNR80 for 32-bit Windows: Version 8.0.5.0.0 - Production
0.19 TNSLSNR for 32-bit Windows: Version 10.2.0.1.0 - Beta
0.19 TNSLSNR for 32-bit Windows: Version 8.1.7.3.0 - Production
0.19 TNSLSNR for 32-bit Windows: Version 9.0.1.4.1 - Production
0.19 TNSLSNR for 32-bit Windows: Version 9.2.0.7.0 - Production
0.19 TNSLSNR for DEC OSF/1 AXP: Version 8.1.6.0.0 - Production
0.19 TNSLSNR for DEC OSF/1 AXP: Version 8.1.7.4.0 - Production
0.19 TNSLSNR for HPUX: Version 10.1.0.5.0 - Production
0.19 TNSLSNR for HPUX: Version 10.2.0.3.0 - Production
0.19 TNSLSNR for HPUX: Version 9.2.0.1.0 - Production
0.19 TNSLSNR for HPUX: Version 9.2.0.4.0 - Production
0.19 TNSLSNR for HPUX: Version 9.2.0.8.0 - Production
0.19 TNSLSNR for IBM/AIX RISC System/6000: Version 10.2.0.1.0 - Production
0.19 TNSLSNR for IBM/AIX RISC System/6000: Version 10.2.0.2.0 - Production
0.19 TNSLSNR for IBM/AIX RISC System/6000: Version 10.2.0.3.0 - Production
0.19 TNSLSNR for IBM/AIX RISC System/6000: Version 10.2.0.4.0 - Production
0.19 TNSLSNR for IBM/AIX RISC System/6000: Version 9.2.0.4.0 - Production
0.19 TNSLSNR for Linux: Version 10.1.0.4.2 - Production
0.19 TNSLSNR for Linux: Version 8.1.6.0.0 - Production
0.19 TNSLSNR for Linux: Version 9.2.0.5.0 - Production
0.19 TNSLSNR for Linux: Version 9.2.0.7.0 - Production
0.19 TNSLSNR for Linux: Version 9.2.0.8.0 - Production
0.19 TNSLSNR for OS400: Version 10.2.0.1.0 - Production
0.19 TNSLSNR for Solaris: Version 11.1.0.6.0 - Production
0.19 TNSLSNR for Solaris: Version 8.0.5.0.0 - Production
0.19 TNSLSNR for Solaris: Version 8.1.5.0.0 - Production
0.19 TNSLSNR for Solaris: Version 8.1.7.4.0 - Production
0.19 TNSLSNR for Solaris: Version 9.0.1.0.0 - Production
0.19 TNSLSNR for Solaris: Version 9.2.0.7.0 - Production
0.19 TNSLSNR for Solaris: Version 9.2.0.8.0 - Production
</pre>

_BLOG_FOOTER_GITHUB(`42')

_BLOG_FOOTER()

