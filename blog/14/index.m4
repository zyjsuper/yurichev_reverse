m4_include(`commons.m4')

_HEADER_HL1(`4-Nov-2008: Oracle SPY Events')

<p>Oracle SPY Events</p>
<p> -- Dennis Yurichev <dennis@conus.info> http://blogs.conus.info</p>

<p>This win32 utility intercept internal Oracle RDBMS function calls to ksdpec() and ss_wrtf() and may be used for undocumented Oracle trace events hunting.</p>

<p>Some trace events used for turning on some debug messages, some used for behavior change, some are even used for turning on and off some bug fixes.</p>

<p>Trace event may be turning on by issuing command like that:</p>

<pre>
ALTER SYSTEM SET EVENTS '10051 trace name context forever, level 255';
</pre>

<p>It assign value of 255 to event number 10051.</p>

<p>Some event numbers are present in oraus.msg file (hint: it present in Linux Oracle distribution, but not in win32), some are not.</p>

<p>Assigning value is often bit field.</p>

<p>Oracle RDBMS use ksdpec() function to check, if some event is turned on. Often, as in case of debug messaging, Oracle RDBMS write some information into trace file, if some bits are set for some event.</p>

<p>Thereby, this utility allow us to see all (As I know) Oracle RDBMS attempts to check all turned on events.</p>

<p>For example, these events are checked while user SCOTT log into 10.2.0.4:</p>

<pre>
10005 10029 10031 10032 10039 10046 10051 10053 10060 10072 10074 10075
10076 10078 10079 10089 10091 10092 10093 10103 10105 10106 10107 10108
10109 10110 10111 10112 10114 10115 10116 10121 10122 10125 10128 10131 
10132 10134 10138 10142 10144 10155 10156 10157 10158 10160 10161 10162 
10163 10164 10168 10169 10170 10171 10172 10174 10175 10176 10177 10178 
10181 10185 10186 10187 10195 10196 10197 10200 10202 10205 10222 10231
10236 10237 10250 10254 10255 10261 10262 10263 10270 10276 10277 10298
10299 10313 10319 10322 10338 10339 10340 10355 10356 10383 10392 10460
10501 10503 10505 10509 10600 10623 10649 10704 10707 10709 10723 10735
10740 10753 10787 10809 10830 10844 10850 10852 10863 10865 10866 10931
10947 12099 14199 16048 16615 16616 16634 16663 16787 19021 22815 22821
22822 22824 22827 22829 24471 25275 25472 25473 25474 28033 30047 30064
30068 32410 32761 32762 38007 38009 38039 38044 38049 38052 38055 38057
38058 38067 38069 38074 38077 38078 38079 38081 38083 38084 38085 38087
41097 41098 41099 43810 44446 906 1403
</pre>

<p>These events are checked while user SCOTT issuing "select * from v$version" SQL statement:</p>

<pre>
10031 10032 10039 10046 10051 10053 10060 10075 10076 10078 10089 10091
10092 10093 10103 10105 10106 10107 10108 10109 10110 10111 10112 10114
10115 10116 10121 10122 10125 10128 10132 10134 10144 10156 10157 10158
10160 10161 10162 10163 10164 10168 10170 10171 10172 10174 10175 10176
10177 10178 10181 10185 10186 10187 10195 10196 10197 10200 10202 10205
10222 10231 10236 10250 10255 10261 10270 10298 10299 10313 10319 10322
10338 10339 10340 10383 10501 10505 10509 10600 10623 10649 10704 10723
10740 10809 10830 22299 22815 22821 22822 22824 22827 22829 30047 30068
38001 38007 38009 38039 38049 38055 38058 38069 38077 38078 38079 38081
38083 38084 38085 38087 43810 906
</pre>

<p>So, when utility intercepts call to ksdpec() function, it writes to log and console something like:</p>

<pre>
[2008-11-04 09:18:20:205] [0x0908 / 2312] ksdpec (10319) -> 0
[2008-11-04 09:18:20:299] [0x0908 / 2312] ksdpec (10501) -> 0
[2008-11-04 09:18:20:346] [0x0908 / 2312] ksdpec (10509) -> 0
[2008-11-04 09:18:20:408] [0x0908 / 2312] ksdpec (10809) -> 0
[2008-11-04 09:18:20:455] [0x0908 / 2312] ksdpec (10809) -> 0
</pre>

<p>It is date, time, Oracle thread ID in hexadecimal and decimal form, event number checked and what this function is returned, e.g., value assigned to this event.</p>

<p>Windows thread ID can be converted to Oracle process name using this query:</p>

<pre>
select spid, program from gv$process;
</pre>

<p>Utility is also intercept ss_wrtf() function which is involved in all trace file storing.</p>

<p>Often, we do not know, which message in trace file is related to specific trace event.</p>

<p>Now we can try to see, which one, for example:</p>

<pre>
ksdpec (10051) -> 255
ss_wrtf: [*** 2008-11-04 10:15:03.174]
ss_wrtf: [OPI CALL: type=107 argc= 3 cursor=  0 name=SES OPS (80)]
ksdpec (10051) -> 255
ss_wrtf: [OPI CALL: type=59 argc= 4 cursor=  0 name=VERSION2]
ksdpec (10046) -> 0
ksdpec (10046) -> 0
ksdpec (10051) -> 255
ss_wrtf: [OPI CALL: type=94 argc=23 cursor=  0 name=V8 Bundled Exec]
</pre>

<p>It is not stable solution, though. But often, it is so: trace file updated just after trace event checked.</p>

<p>Before you run it, ORACLE_HOME environment variable should be set. 
Also, ORACLE_HOME\bin path should be present in %PATH% environment variable.</p>

<p>After start, utility attaches to oracle.exe process and allow us to see these internal calls. Press Ctrl-C (once) to detach from Oracle process.
Please note: detaching is not working in Windows 2000, so all utility can do is to kill Oracle process.</p>

<p>It is also should be noted, that Oracle RDBMS do not call ksdpec() function at all, if it knows that no events are set at all.</p>

<p>We need to turn on at least one (any) trace event, this is enough:</p>

<pre>
ALTER SYSTEM SET EVENTS '10051 trace name context forever, level 255';
</pre>

<p>After that, Oracle RDBMS will check any trace event.</p>

<p>Important notes: a) utility is working slow; b) it is only for 10.2.x.x RDBMS versions yet; c) detaching is not stable sometimes, so be prepared for RDBMS instance crash.</p>

<p>Source code was initially compiled by MSVC 2008.</p>

<p><a href="http://yurichev.com/non-wiki-files/blog/2008-ospy/ospy_events.zip">Download utility and source code.</a></p>

<p>Update: this utility was superseded by <a href="http://conus.info/gt/">generic tracer</a>.</p>

_BLOG_FOOTER_GITHUB(`14')

_BLOG_FOOTER()

