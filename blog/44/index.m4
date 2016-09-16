m4_include(`commons.m4')

_HEADER_HL1(`12-Mar-2010: SAP')

<p>(<a href="//yurichev.com/non-wiki-files/blog/SAP/sniffing_diag.pdf">A paper about SAP plain-text passwords in network packets</a>).</p>

<p>From this paper I got information that, by default, all network packets between SAP server and SAPGUI are not encrypted, rather compressed. SAPGUI also contain an option (TDW_NOCOMPRESS) to turn compression off, then we can use wireshark to see user's plain-text password.</p>

<p>But what really amazed me is that a function which is in charge of data compression, contain call to <a href="http://www.opengroup.org/onlinepubs/000095399/functions/rand.html">rand()</a> C stdlib function (in BitBufInit() function, which is, in turn, called from CsRComprLZH()). That is the reason, why SAP's server compressed answers are always different. This is true for at least version 701 patch 32.</p>

<p>They probably emulate encryption?</p>

<p><i>Almost all good computer programs contain at least one random-number generator.</i> (<a href="http://fortunes.cat-v.org/plan_9/">fortune file</a> in plan 9 OS)</p>

<p>Part two: _HTML_LINK_AS_IS(`http://blog.yurichev.com/node/47')</p>

_BLOG_FOOTER_GITHUB(`44')

_BLOG_FOOTER()

