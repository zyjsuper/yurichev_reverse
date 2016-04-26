m4_include(`commons.m4')

_HEADER_HL1(`5-Oct-2009: Oracle RDBMS passwords solver')

<p>I finally spent some time to finish my my <a href="http://blog.yurichev.com/node/5">FPGA-based Oracle passwords solver</a>, I also made web-interface for it.</p>
<p>It is connected to Internet right now.</p>
<p>Read more about it:</p>
<p>_HTML_LINK_AS_IS(`http://conus.info/ops/')</p>
<p><strike>Please remember, for the sake of demonstration speed, now it's solving <b>only</b> 1-8 alpha symbol passwords within one hour, e.g., passwords <b>without</b> digits and punctuation marks.</strike></p>
<p>Please also do not submit any hashes from production systems: they are visible.</p>

<p>Update:</p>
<p><strike>Today, 7 Oct 2009, I switched it to 1-7 symbol passwords, all possible symbols are checked now (A-Z0-9#$_). All 7-symbols passwords checked within about 23 minutes.</strike></p>
<p>Today, 17 Oct 2009, I switched it to 1-8 symbol passwords, all possible symbols are checked now (A-Z0-9#$_). All 8-symbols passwords checked within about 15.5 hours minutes.</p>

_BLOG_FOOTER_GITHUB(`27')

_BLOG_FOOTER()

