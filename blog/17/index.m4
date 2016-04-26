m4_include(`commons.m4')

_HEADER_HL1(`2-Apr-2009: IBM DB2')

<p>IBM DB2 Version 9.5 Fix Pack 3a came out, fixing also <a href="http://www-01.ibm.com/support/docview.wss?uid=swg21372517">two DoS vulnerabilities</a> I found.</p>

<p>1. <a href="http://www-01.ibm.com/support/docview.wss?uid=swg1IZ37697">"IZ37697: SECURITY: MALICIOUS CONNECT DATA STREAM CAN CAUSE DENIAL OF SERVICE."</a>
<p>First is pre-auth DoS vulnerability. Here is exploit: it require "DB2TEST" database present on target database, because its name is hardcoded into packet.</p>
<p>Download: <a href="http://yurichev.com/non-wiki-files/blog/exploits/db2/DB2_PoC_1.py.txt">DB2_PoC_1.py</a></p>

<p>2. <a href="http://www-01.ibm.com/support/docview.wss?uid=swg1IZ39653">IZ39653: SECURITY: MALICOUS DATA STREAM CAN CAUSE THE DB2 SERVER TO TRAP.</a></p>
<p>The second DoS vulnerability, it is require also "DB2TEST" database present on target database and require "GUEST" account present with "QQ" password. All this stuff is hardcoded too.</p>
<p>Download: <a href="http://yurichev.com/non-wiki-files/blog/exploits/db2/DB2_PoC_2.py.txt">DB2_PoC_2.py</a></p>

_BLOG_FOOTER_GITHUB(`17')

_BLOG_FOOTER()

