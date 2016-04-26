m4_include(`commons.m4')

_HEADER_HL1(`13-Jul-2008: Solving Oracle passwords hashes using FPGA. ')

<p>I tried to use <a href="http://en.wikipedia.org/wiki/Field-programmable_gate_array">FPGA</a> in quick search of original Oracle RDBMS account passwords extracting their hash values from database.</p>
<p>Relatively simple <a href="http://groups.google.com/group/comp.security.misc/msg/83ae557a977fb6ed">hashing algorithm</a> used there, involving DES crypto algorithm.</p>
<p>I used three FPGA developer kits for this.</p>

<ul>
<li><a href="http://www.altera.com/products/devkits/altera/kit-cyc3-starter.html">Cyclone III FPGA Starter Kit</a>, where EP3C25F324 chip is used. I achieved roughly ~12.5 millions passwords per second, that is about 2 hours for all 7-symbol passwords.

<li><a href="http://www.altera.com/products/devkits/altera/kit-niosii-2S60.html">Nios II Development Kit, Stratix II Edition</a>, where EP2S60F672C3 chip is used. I achieved roughly ~76 millions passwords per second, that is about 20 minutes for all 7-symbol passwords.

<li><a href="http://www.altera.com/products/devkits/altera/kit-pciexpress_s2gx.html">PCI Express Development Kit, Stratix II GX Edition</a>, where EP2SGX90F1508C3 chip is used. I achieved roughyl ~109 millions passwords per second, that is about 14 minutes for all 7-symbol passwords or 9 hours for all 8-symbol passwords.
</ul>

<p><a href="http://www.red-database-security.com/whitepaper/oracle_password_benchmark.html">There</a> also relative speed of software Oracle password crackers.</p>

<p>It was showed that using mid-range FPGA chips like <a href="http://www.altera.com/products/devices/cyclone3/cy3-index.jsp">Altera Cyclone</a> is cheaper in terms cost/speed. Probably, Xilinx Spartans may show the same results.</p>

<p>Also, the interesting thing is that, although FPGA hardware is expensive, practically any board from <a href="http://shop.ebay.com/items/_W0QQ_nkwZFPGAQQ_armrsZ1QQ_fromZR40QQ_mdoZ">ebay.com</a> may be taken for this task, if it, of course, contain some useful FPGA chips + power supply + some memory for booting, etc.</p>

<p>I tend to sell source files, e.g., FPGA "firmware", then ready-to-use hardware. 
Feel free <a href="mailto:dennis@conus.info">ask me</a> any questions.</p>

_BLOG_FOOTER_GITHUB(`5')

_BLOG_FOOTER()

