m4_include(`commons.m4')

_HEADER(`Windows')

_HL1(`Notes about Windows OS')

_HL2(`Unbuffered copy of huge files')

... in Windows 7, 2008, etc 
(buffered copy have _HTML_LINK(`http://blogs.technet.com/b/askperf/archive/2007/05/08/slow-large-file-copy-issues.aspx',`cache issues') there):

<pre>
xcopy c:\directory\* c:\another_directory /e /j
</pre>

_HTML_LINK(`http://technet.microsoft.com/en-us/library/cc771254(WS.10).aspx',`More on xcopy.')

_HL2(`Flattern directory')

... i.e., copy all files from all subdirectories to the current one:

<pre>
for /r %f in (*) do @copy "%f" .
</pre>

<!-- Explorer shortcuts -->

_FOOTER()
