m4_include(`commons.m4')

_HEADER_HL1(`21-Apr-2009: CPUapr2009')

<p><a href="http://www.oracle.com/technology/deploy/security/critical-patch-updates/cpuapr2009.html">CPUapr2009</a> came out. CVE-2009-0991 Listener vulnerability was discovered by me, and here is <a href="//yurichev.com/non-wiki-files/blog/exploits/oracle/CVE-2009-0991.py.txt">PoC</a> for it (Python code).</p>

<p>Update:
It is some kind of RPC inside Oracle RDBMS, called, If I correct, RO (remote operation).
And the problem is about correct parsing of such packets.</p>

_BLOG_FOOTER_GITHUB(`18')

_BLOG_FOOTER()

