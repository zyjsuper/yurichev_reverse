m4_include(`commons.m4')

_HEADER_HL1(`4-Sep-2008: Oracle internals')

<p>Once upon a time, I disassembled all object files (*.o) extracted from libserver10.a file which is main Oracle RDBMS library, from version 10.2.0.4 Linux x86.</p>
<p>After, I fetched essentials from each one: which functions are in each object file are present, which other functions they may call and possible arguments list.</p>
<p>Here is a short example of what I got:</p>

_PRE_BEGIN
* Function krvsats

May call krvsarts ()
May call ksdwrf ("krvsats->\n")
May call ksdpec (0x3FAC)
May call ksdpec (0x545)
May call kspgip (ds:kxfpx2_, 1, ...)
May call kslgetl (offset krvsvl_, 1, 0, offset krvsvl_alo_)
May call kslfre (offset krvsvl_)
May call kghfre (ds:ksmgpp_, offset ksmsgh_, ?, 0x2000, "krvslfv: init")
May call kghalo (ds:ksmgpp_, offset ksmsgh_, ?, ?, ?, ?, 0x1002000, ?, "krvslfv: init")
May call kgesic0 (?, ?, 0x42CB)
May call ksdwrf ("krvsats:: Fatal error(%d) during X$LOGSTDBY allocation\n")
May call kgedes (ds:ksmgpp_)
May call kgerse (ds:ksmgpp_)
May call krvssmsg (...)
May call ksdwrf ("->krvxats\n")
May call krvxats (...)
May call krvuam (?, ?, 1, 0x58, ?, "krvslctx")
May call krvsle (?, ?, 0x3EEF, ...)
May call kghalp (ds:ksmgpp_, offset ksmsgh_, 0x330, 1, 0, "krvsats: krvslsv")
May call kslhclt (offset krvsvl_)
_PRE_END

<p>Here we can easily see a list of functions which krvsats() may call and its arguments.</p>
<p>Throughout all that files, we can see how Oracle RDBMS checks for turned on trace events (using function ksdpec()), how it raise ORA- errors (using functions ksesic*, ksesec*, etc), how it write to trace logs (using functions ksdwrf(), ksdwra()), and how it allocate memory marked with comment (functions ksmals(), kghalf(), kghalo(), etc), and how it prepare many internal SQL statements for internal execution (functions rpisplu(), kprbprs(), opiprs(), OCIStmtPrepare(), etc).</p>

<p>Excerpts from opiodr() function, which is one of central point of Oracle OPI call dispatcher (see full file <a href="http://yurichev.com/non-wiki-files/blog/oracle-10.2.0.4-linux/opiodr.txt">here</a>):</p>

_PRE_BEGIN
May call ksesec0 (0x0C29)
May call ksesec0 (0x3F4)
May call ksesec0 (0x3E9)

....

May call kgeasnmierr (ds:ksmgpp_, ds:ksefac_, "opiodr-fma", 0)

....

May call ksdwrf ("OPI CALL: type=%2d argc=%2d cursor=%3d name=%s\n")
May call ksdpec (0x2743)
_PRE_END

<p>First three calls are errors signalling: ORA-3113 ("end-of-file on communication channel"), ORA-1012 ("not logged on"), ORA-1001 ("invalid cursor"), etc.</p>

<p>Last ksdpec() function call is check out, whether trace event 10051 ("trace OPI calls") is turned on. Near that call we can see also call to the function which produce write to trace log, in <a href="http://en.wikipedia.org/wiki/Printf">printf-like format</a>.</p>

<p>.. etc, etc ..</p>

<p>Happy hacking!</p>

<p><a href="http://yurichev.com/non-wiki-files/blog/oracle-10.2.0.4-linux.zip">All files in one archive for 10.2.0.4 (1679 files, 3.5M)</a> and for <a href="http://yurichev.com/non-wiki-files/blog/oracle-11.1.0.7.0-linux.zip">11.1.0.7.0</a>.</p>

<p><a href="http://yurichev.com/non-wiki-files/blog/oracle-10.2.0.4-linux/">All 1679 files separately for 10.2.0.4</a> and for <a href="http://yurichev.com/non-wiki-files/blog/oracle-11.1.0.7.0-linux/">11.1.0.7.0</a>.</p>

<p>Using some text reformatting, it is possible to add <a href="http://en.wikipedia.org/wiki/Wikipedia:How_to_edit_a_page">wiki-markup</a> to all these text files and import it to some wiki software (I prefer <a href="http://en.wikipedia.org/wiki/MediaWiki">MediaWiki</a>).</p>
<p>Then, it is possible to use simple navigation: e.g., opening web-browser on a page dedicated to some function, using "<a href="http://en.wikipedia.org/wiki/Help:What_links_here">what links here</a>" feature, to see then which functions may call this one. Or, to see, which functions may raise some specific error. And so on.</p>

_BLOG_FOOTER_GITHUB(`10')

_BLOG_FOOTER()

