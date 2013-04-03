m4_include(`commons.m4')

_HEADER(`FPGA-based Oracle RDBMS passwords cracker')

_HL1(`FPGA-based Oracle RDBMS passwords cracker')

<p>This is FPGA-based Oracle passwords (_HTML_LINK(`https://groups.google.com/forum/?fromgroups#!msg/comp.security.misc/F0uSWBy9e_Q/7bZ_l3pVroMJ', `DES-based')) solver, connected directly to Internet and working 24h (for demonstration purpose).</p>

<p>It was made on top of _HTML_LINK(`http://www.altera.com/products/devkits/altera/kit-niosii-2S60.html', `Altera Nios II Development Kit, Stratix II Edition').</p>

<p>It is capable to search nearly 60 million passwords per second. Compare to _HTML_LINK(`http://www.red-database-security.com/whitepaper/oracle_password_benchmark.html', `software Oracle password solvers'): on Intel Core Duo they do at most 1.5 million passwords per second.</p>

<p>This means, you need at least 40 of these computers to achieve the same results.
60 million passwords per second is enough to search all possible 8-symbol alpha passwords within one hour (considering short usernames like SYS or DBSNMP).</p>

<p>It also allow to search all possible 8-symbol Oracle RDBMS passwords (A-Z0-9#$_) within 16.5 hours.</p>

<p>Unfortunately, speed is depends on username length, so, while solving passwords for 20-symbol username, speed is about 33 million passwords per second.</p>

_HTML_LINK(`pix/ops_FPGA.jpg', `<img src="pix/ops_FPGA_400px.jpg" alt="Here is how it looks like (without fan). Click for larger photo">')

<p>_HTML_LINK(`http://conus.info/ops/ops.html', `Article about it.')</p>

<p>_HTML_LINK(`http://conus.info/ops/ops_RU_old.html', `Previous version of the article in Russian language.')</p>

<p>_HTML_LINK(`http://ops.conus.info:669/', `Click here') to access its web-interface. It is possible to submit any hash you'd like to queue.</p>

<p>A following SQL query can be used for passwords hash fetching (login as SYS):</p>

<pre>select name,password from sys.user$;</pre>

<p>After the moment of password solved or not, it will remain in table for 14 days.
Usernames with only alpha symbols and underscore (_) are allowed (so far).
Please do not submit any hashes from production systems: they are visible to anyone.</p>

<p>Currently, it solving all 1-8 symbol passwords within about about 16.5 hours.</p>

<p>See also: _HTML_LINK(`http://conus.info/utils/ops_SIMD/', `Oracle passwords (DES) solver 0.3 (SSE2/AVX)')</p>

_HL2(`Source code')

<p>Here is full source code. It is ready to compile and run on top of Nios II dev kit I already mentioned here.
The first part is Altera Quartus archived project. It is derived from Altera empty project example, hence its name.</p>

<p>_HTML_LINK(`http://conus.info/ops/src/NiosII_stratixII_2s60_RoHS_full_featured.qar', `NiosII_stratixII_2s60_RoHS_full_featured.qar')</p>

<p>Here is archive of most important verilog sources: _HTML_LINK(`http://conus.info/ops/src/ops_src_v.zip', `ops_src_v.zip')</p>

<p>Here is also clumsy C++ utility to generate oracle_hashes.v file with variable block count.
_HTML_LINK(`http://conus.info/ops/src/gen_oracle_hashes_v.zip', `gen_oracle_hashes_v.zip')</p>

<p>The second part is written in C and running on Nios II processor. It is derived from modified _HTML_LINK(`http://www.altera.com/support/examples/nios2/exm-micro_tutorial.html', `web server example').</p>

<p>_HTML_LINK(`http://conus.info/ops/src/nios_ops.rar', `nios_ops.rar')</p>

_FOOTER()
