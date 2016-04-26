m4_include(`commons.m4')

_HEADER_HL1(`2-Jun-2010: About SAP network packets decompressing and also SAP network password sniffing')

<p>It is known that by default, SAP network exchange is <a href="http://blog.yurichev.com/node/44">compressed rather than encrypted</a>.</p>

<p>It is also known that on client side, it is possible to turn off compression in SAP GUI by setting TDW_NOCOMPRESS environment option to 1.</p>

<p>But what if client sending compressed packets anyway and we would like to see what is inside?</p>

<p>You may reveal compressed packets in network traffic by bytes 0x1f and 0x9d at positions 0x11 and 0x12 and, of course, these packets has such flaring property as high <a href="http://en.wikipedia.org/wiki/Entropy_(information_theory)">information entropy</a>.</p>

<p>Here is my SAP network packets decompressor, readme file with username/password sniffing example, and win32/linux binaries:</p>

<p>_HTML_LINK_AS_IS(`http://conus.info/utils/#sap')</p>

<p>Part three: _HTML_LINK_AS_IS(`http://blog.yurichev.com/node/52')</p>

_BLOG_FOOTER_GITHUB(`47')

_BLOG_FOOTER()

