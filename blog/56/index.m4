m4_include(`commons.m4')

_HEADER_HL1(`31-Oct-2010: Adding old dongle support to DosBox')

<p>An emulation of old <a href="http://en.wikipedia.org/wiki/Software_protection_dongle">copy-protection dongle</a> for DOS software can be implemented right in <a href="http://www.dosbox.com/">DosBox</a> DOS emulator.</p>

<p>Here is my patches for DosBox 0.74, enabling it to support 93c46-based dongle:</p>
<p>_HTML_LINK_AS_IS(`http://conus.info/stuff/dosbox/dongle.cpp')</p>
<p>_HTML_LINK_AS_IS(`http://conus.info/stuff/dosbox/dosbox.cpp.patch')</p>

<p>At least old Rainbow Sentinel Cplus and MicroPhar are 93c46-based dongles.</p>

<p>93c46 memory chip contain 64*16 words. More on it <a href="http://www.atmel.com/dyn/resources/prod_documents/doc0172.pdf">here</a>.</p>

<p>Source code is self-explanatory. What you need is to add dongle.cpp to project, patch dosbox.cpp, fill MEMORY array representing dongle memory. You may also need to change rewiring scheme between 93c46 and printer port. Wiring scheme may differ from dongle to dongle, but usually, DI (data input), SK (clock), CS (chip select) and power lines are taken from D0..D7 in some order. DO (data output) may be connected to ACK or BUSY printer lines.</p>

<p>Now how to read 93c46-based dongle? Get a free reader there (sread.zip):</p>
<p>_HTML_LINK_AS_IS(`http://safe-key.com/freesoftware.html')</p>
<p>It produce crypted file, however, sread.exe can be patched (write 0xC3 byte at 0xE1B address) then unencrypted dump file will be created.</p>

<p>But what if you do not have a dongle to read information from it? First, take a look on log messages: which cells are reading by your software? Try 0x6669 here, for example. Compile DosBox with heavy debug option and produce all instructions and register's state executed:</p>
<p>_HTML_LINK_AS_IS(`http://blog.yurichev.com/node/55')</p>

<p>... then just grep LOGCPU.TXT for 6669: value from dongle is probably compared with some other constant, however, it is not rule, things may be much more complex.</p>

<p>Read more about dongle emulation: _HTML_LINK_AS_IS(`http://yurichev.com/dongles.html')</p>

_BLOG_FOOTER_GITHUB(`56')

_BLOG_FOOTER()

