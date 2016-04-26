m4_include(`commons.m4')

_HEADER_HL1(`30-Jul-2008: Oracle SPY')

<p>Oracle SPY</p>
<p>-- Dennis Yurichev &lt;dennis(@)conus.info&gt; http://blog.yurichev.com</p>

<p>This is win32 utility which intercepts internal Oracle RDBMS function calls to rpisplu(), kprbprs(), opiprs() and OCIStmtPrepare() - all these 4 functions used in internal SQL processing. All they are actually "parse" command from different RDBMS layers.</p>

<p>Thereby, this utility allow us to see all (As I know) internal SQL executions.
It may be used for debugging, educational or any other purposes.</p>

<p>It was tested on Oracle 9.2.0.8, 10.1.0.5, 10.2.0.3 and 11.1.0.6.0, of course, for win32 platform.
Operation systems tested on: Windows Vista, Windows 2008 Server, Windows 2003 Server, Windows XP SP2 and SP3, Windows 2000 Server.</p>

<p>Before you run it, ORACLE_HOME environment variable should be set. 
Also, ORACLE_HOME\bin path should be present in %PATH% environment variable.</p>

<p>After start, utility attaches to oracle.exe process and allow us to see these internal calls. Press Ctrl-C (once) to detach from Oracle process.
Please note: detaching is not working in Windows 2000, so all utility can do is to kill Oracle process.</p>

<p>If Oracle RDBMS version 11.1.0.6.0 is used, Oracle internal process name will be visible also at each SQL statement. Otherwise, only win32 thread ID will be visible. Windows thread ID can be converted to Oracle process name using this query:</p>

<pre>
"select spid, program from gv$process;"
</pre>

<p>Utility is not intended to use on production servers. But if someone consciously willing to use it, one should backup database. Utility cannot be stable yet, at this level of development.</p>

<p>Source code was initially compiled by MSVC 2008.</p>

<p>Examples, which were recorded on freshly installed 11g win32:</p>

<ul>
<li>STARTUP_ospy.log: instance service startup
<li><a href="http://yurichev.com/non-wiki-files/blog/2008-ospy/SCOTT_LOGON_ospy.log">SCOTT_LOGON_ospy.log</a>: user SCOTT logon.
<li><a href="http://yurichev.com/non-wiki-files/blog/2008-ospy/VERSION_ospy.log">VERSION_ospy.log</a>: during "select * from v$version" query.
<li>SHUTDOWN_ospy.log: instance shutdown.
</ul>

<p><a href="http://yurichev.com/non-wiki-files/blog/2008-ospy/ospy.zip">Download</a></p>

<p>Update: this utility was superseded by <a href="http://conus.info/gt/">generic tracer</a>.</p>

_BLOG_FOOTER_GITHUB(`9')

_BLOG_FOOTER()

