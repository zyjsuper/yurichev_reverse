m4_include(`commons.m4')

_HEADER_HL1(`21-May-2009: Generic tracer')

<p><a href="http://conus.info/gt/">gt</a> is very simple win32 tracer, in some way similar to <a href="http://en.wikipedia.org/wiki/Strace">strace</a> *NIX tool.</p>
<p>One reason I blog about it here because it supports Oracle RDBMS .SYM symbol files.</p>
<p>Readme file is <a href="http://conus.info/gt/gt.txt">here</a> and download it <a href="http://conus.info/gt/">here</a>.</p>

<p>Few examples:</p>

<p>Memory allocations and deallocations:</p>

<pre>gt.exe -a:oracle.exe bpf=.*!_kghalf,args:6 bpf=.*!_kghfrf,args:4</pre>

<p>Dump calling stack before each call:</p>

<pre>gt.exe -a:oracle.exe -s bpf=.*!_kghalf,args:6 bpf=.*!_kghfrf,args:4</pre>

<p>gt tool can easily supersede my old "Oracle SPY" utility ( _HTML_LINK_AS_IS(`http://blogs.conus.info/node/9') ):</p>
<p>For 11g:</p>

<pre>gt.exe -a:oracle.exe bpf=oracle.exe!_rpisplu,args:8 bpf=oracle.exe!_kprbprs,args:7 bpf=oracle.exe!_opiprs,args:6 bpf=oraclient11.dll!_OCIStmtPrepare,args:6</pre>

<p>For 10gR2:</p>

<pre>gt.exe -a:oracle.exe bpf=oracle.exe!_rpisplu,args:7 bpf=oracle.exe!_kprbprs,args:7 bpf=oracle.exe!_opiprs,args:6 bpf=oraclient10.dll!_OCIStmtPrepare,args:6</pre>

<p>gt can also supersede my old "Oracle SPY Events" uility ( _HTML_LINK_AS_IS(`http://blogs.conus.info/node/14') ).</p>
<p>Unfortunately, this works only for 10gR2:</p>

<pre>gt.exe -a:oracle.exe bpf=oracle.exe!_ksdpec,args:1 bpf=oracle.exe!_ss_wrtf,args:3</pre>

<p>Please note that all printed arguments are in hexadecimal form.</p>

_BLOG_FOOTER_GITHUB(`22')

_BLOG_FOOTER()

