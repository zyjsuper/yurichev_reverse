m4_include(`commons.m4')

_HEADER_HL1(`10-Jul-2008: _disable_txn_alert undocumented parameter in Oracle 11g')

<p>About <i>_disable_txn_alert</i> undocumented parameter - at least as for Oracle 11g win32.</p>

<p>This parameter is connected with <i>ktsmgd_</i> global variable.</p>

<p>This variable is actually bitmap. 
Default value is 0.
Bits which are checked within Oracle 11g processes: 1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200.</p>

<ul>
<li>0x1: if it is set, <i>ktuilqa()</i> function will not execute.
<li>0x2: if it is set, <i>ktrsiosa()</i> function will not execute. 
<li>0x4: if set: write some debug info to trace file using <i>ksdwrf()</i> function. 
<li>0x8: if set: write some debug info to trace file using <i>ksdwrf()</i> function. 
<li>0x10: if set, <i>ktsmguuf()</i> function will not execute. 
<li>0x20: if set: write some debug info to trace file using <i>ksdwrf()</i> function. 
<li>0x40: if set: write some debug info to trace file using <i>ksdwrf()</i> function. 
<li>0x80: affect code flow in <i>ktsmgfru()</i> function. 
<li>0x100: affect code flow in <i>ktsmgru()</i>, <i>ktsmgruarr()</i>, <i>ktsmghlth()</i>, <i>ktsmgadv()</i> functions. 
<li>0x200: affect code flow in <i>ktsmgmql()</i>, <i>ktsmgaex()</i>, <i>ktsmgmsz()</i>, <i>ktsmgbpr()</i>, <i>ktsmgru()</i>, <i>ktsmgruarr()</i>, <i>ktsmghlth()</i>, <i>ktsmgadv()</i> functions. 
</ul>

<p>Thus, turn on trace flags will be: 0x4 + 0x8 + 0x20 + 0x40 = 0x6C or 108 decimal.
Or turn on all flags: 0x1 + 0x2 + 0x4 + 0x8 + 0x10 + 0x20 + 0x40 + 0x80 + 0x100 + 0x200 = 0x3FF or 1023 decimal.</p>

<p>Note: <i>ksdwrf()</i> function write trace information to files usually named <i>&lt;SID&gt;_&lt;process_name&gt;_&lt;thread_id&gt;.trc</i>, at the folder which is usually defined by <a href="http://download.oracle.com/docs/cd/B19306_01/server.102/b14237/initparams018.htm">background_dump_dest parameter</a>.</p>

<p>Update: this command is also can be used for viewing state of ktsmgd_ variable: <i>oradebug dumpvar SGA ktsmgd_</i></p>

<p>Update: <a href="http://yong321.freeshell.org/computer/ParameterDependencyAndStatistics.doc">Article</a> where Yong Huang make use of this parameter.</p>

_BLOG_FOOTER_GITHUB(`3')

_BLOG_FOOTER()

