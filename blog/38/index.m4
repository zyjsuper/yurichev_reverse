m4_include(`commons.m4')

_HEADER_HL1(`22-Jan-2010: CVE-2010-0071')

<p>CVE-2010-0071 discovered by me was patched in CPUjan2010:</p>

<p><a href="http://blogs.oracle.com/security/2010/01/january_2010_critical_patch_up.html">The CVSS Base Score of 10.0 for the Windows platform denotes that a successful exploitation of this vulnerability can result in a full compromise of the targeted system down to the Operating System level. However, for Linux, Unix, and other platforms, a compromise down to the Operating System is not possible. For these platforms, a successful exploitation of the vulnerability will result in a compromise limited to the database server layer.</a></p>

<p><a href="http://yurichev.com/non-wiki-files/blog/exploits/oracle/CVE-2010-0071.py_.txt">Here is PoC</a> (Python script). It is not full exploit, what it do is: while running on 11.1.0.7.0 win32, nsglvcrt() Listener function attempt to allocate huge memory block and copy *something* to it.</p>

<pre>
TID=3052|(1) MSVCR71.dll!malloc (0x4222fc5) (called from 0x438631 (TNSLSNR.EXE!nsglvcrt+0x95))
TID=3052|(1) MSVCR71.dll!malloc -> 0x2530020
TID=3052|(0) TNSLSNR.EXE!__intel_fast_memcpy (0x2530020, 0, 0x4222fc4) (called from 0x438647 (TNSLSNR.EXE!nsglvcrt+0xab))
</pre>

<p>(addresses are for TNS Listener 11.1.0.7.0 win32 unpatched)</p>
<p>If I correct, nsglvcrt() function is involved in new service creation.</p>

_BLOG_FOOTER_GITHUB(`38')

_BLOG_FOOTER()

