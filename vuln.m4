m4_include(`commons.m4')

_HEADER(`Vulnerabilities I found')

_HL1(`Vulnerabilities I found:')

_HL2(`IBM DB2')

<p>Two DoS vulnerabilities in IBM DB2 9.5 (CVE-2009-0172, CVE-2009-0173):</p>

<p>_HTML_LINK(`http://www-01.ibm.com/support/docview.wss?uid=swg1IZ36534', `IZ36534: SECURITY: MALICIOUS CONNECT DATA STREAM CAN CAUSE DENIAL OF SERV ICE.')</p>

<p>_HTML_LINK(`http://www-01.ibm.com/support/docview.wss?uid=swg1IZ39373', `IZ39373: SECURITY: MALICOUS DATA STREAM CAN CAUSE THE DB2 SERVER TO TRAP.')<p>

<p>_HTML_LINK(`http://blog.yurichev.com/node/17', `my blog post about it')</p>

_HL2(`Oracle RDBMS')

_HL3(`CVE-2009-0991 in CPUapr2009 (CVSS 5.0):')

<p>_HTML_LINK(`http://www.oracle.com/technetwork/topics/security/cpuapr2009-099563.html', `Oracle Critical Patch Update Advisory - April 2009')</p>

<p>_HTML_LINK(`http://blog.yurichev.com/node/18', `my blog post about CVE-2009-0991 Listener vulnerability')</p>

_HL3(`Four vulnerabilities patched in CPUjul2009:')

<p>_HTML_LINK(`http://www.oracle.com/technetwork/topics/security/cpujul2009-091332.html', `Oracle Critical Patch Update Advisory - July 2009')</p>

<p>CVE-2009-1970 (CVSS 5.0): _HTML_LINK(`http://blog.yurichev.com/node/26', `my blog post about CVE-2009-1970')</p>
<p>CVE-2009-1963 (CVSS 7.5): _HTML_LINK(`http://blog.yurichev.com/node/25', `my blog post about CVE-2009-1963')</p>
<p>CVE-2009-1019 (CVSS 7.5): _HTML_LINK(`http://blog.yurichev.com/node/24', `my blog post about CVE-2009-1019')</p>
<p>CVE-2009-1020 (CVSS 9.0): _HTML_LINK(`http://blog.yurichev.com/node/23', `my blog post about CVE-2009-1020')</p>

_HL3(`CVE-2009-1979 in CPUoct2009 (CVSS 10.0)')

<p>_HTML_LINK(`http://www.oracle.com/technetwork/topics/security/cpuoct2009-096303.html', `Oracle Critical Patch Update Advisory - October 2009')</p>

<p>_HTML_LINK(`http://blog.yurichev.com/node/28', `my blog post about CVE-2009-1979')</p>

_HL3(`CVE-2010-0071 in CPUjan2010 (CVSS 10.0)')

<p>_HTML_LINK(`http://www.oracle.com/technetwork/topics/security/cpujan2010-084891.html', `Oracle Critical Patch Update Advisory - January 2010') (also listed among security-in-depth contributors)</p>

<p>_HTML_LINK(`http://blog.yurichev.com/node/38', `my blog post about CVE-2010-0071')</p>

_HL3(`CVE-2010-0911 in CPUjul2010 (CVSS 7.8):')

<p>_HTML_LINK(`http://www.oracle.com/technetwork/topics/security/cpujul2010-155308.html', `Oracle Critical Patch Update Advisory - July 2010')</p>

<p>_HTML_LINK(`http://blog.yurichev.com/node/68', `my blog post about CVE-2010-0911')</p>

_HL3(`Mentioned in CPUapr2011:')

<p>_HTML_LINK(`http://www.oracle.com/technetwork/topics/security/cpuapr2011-301950.html', `Oracle Critical Patch Update Advisory - April 2011')</p>

_HL3(`CVE-2011-2242 in CPUjul2011:')

<p>_HTML_LINK(`http://www.oracle.com/technetwork/topics/security/cpujuly2011-313328.html', `Oracle Critical Patch Update Advisory - July 2011')</p>

_HL3(`CVE-2012-0072 in CPUjan2012 (on behalf of McAfee Labs):')

<p>_HTML_LINK(`http://www.oracle.com/technetwork/topics/security/cpujan2012-366304.html', `Oracle Critical Patch Update Advisory - January 2012')</p>

<p>_HTML_LINK(`http://blog.yurichev.com/node/69', `my blog post about CVE-2012-0072')</p>

_HL3(`CVE-2012-1745, CVE-2012-1746 and CVE-2012-1747 in CPUjul2012:')

<p>_HTML_LINK(`http://www.oracle.com/technetwork/topics/security/cpujul2012-392727.html', `Oracle Critical Patch Update Advisory - July 2012')</p>

<p>_HTML_LINK(`http://blog.yurichev.com/node/70', `my blog post about three PoCs from CPUjul2012')</p>

_HL2(`DoS vulnerability in binkd FidoNet mailer:')

_PRE_BEGIN
2009/02/14 15:14:46 1.0a-525 gul
protocol.c,2.193,2.194
Bugfix: segfault on crafted input sequences,
possible remote DoS for multithread versions (win32 and OS/2).
Thanks to Dennis Yurichev.
_PRE_END

<p>_HTML_LINK(`http://binkd2.grumbler.org/viewcvs/HISTORY?root=binkd&view=co', `CVS binkd history')</p>

_FOOTER()

