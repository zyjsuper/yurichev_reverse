m4_include(`commons.m4')

_HEADER_HL1(`13-Jul-2008: malloc() comments')

<p>It is clever idea used in Oracle RDBMS, where, in complex memory control environment, there are a presence of different <a href="http://en.wikipedia.org/wiki/Malloc">malloc()</a>-like functions.</p>
<p>Major portion of these malloc()-like functions also have comment-parameter, where caller pass short human-readable parameter, describing, for what this memory will be used.</p>
<p>After that, at any point of program execution, it is possible to see statistics, what are major memory consumers.</p>
<p>Also, in case of memory leakage, it is possible to see, what memory were not freed.</p>
<p>In Oracle RDBMS, if memory is allocated in <a href="http://download.oracle.com/docs/cd/B19306_01/server.102/b14220/memory.htm">SGA</a> area, statistics can be seen using <a href="http://download.oracle.com/docs/cd/B19306_01/server.102/b14237/dynviews_2106.htm">V$SGASTAT</a> view.</p>
<p>For example:</p>
<pre>
SQL> select * from v$sgastat order by bytes desc;

POOL         NAME                            BYTES
------------ -------------------------- ----------
shared pool  free memory                  78190408
             buffer_cache                 20971520
shared pool  sql area                      4756932
java pool    free memory                   4194304
large pool   free memory                   3988096
shared pool  KCB Table Scan Buffer         3981204
shared pool  KSFD SGA I/O b                3977140
shared pool  row cache                     3755444
shared pool  library cache                 3266232
             log_buffer                    2904064
shared pool  kglsim hash table bkts        2097152

POOL         NAME                            BYTES
------------ -------------------------- ----------
shared pool  ASH buffers                   2097152
shared pool  PL/SQL MPCODE                 2046600
shared pool  KGLS heap                     1654696
shared pool  event statistics per sess     1566720
shared pool  CCursor                       1438520
             fixed_sga                     1289508
shared pool  PL/SQL DIANA                  1282072
shared pool  KTI-UNDO                      1235304
shared pool  private strands               1198080
shared pool  KSXR receive buffers          1034000
shared pool  KQR M PO                       979968
</pre>

<p>Update:
Windows NT has something similar: <a href="http://msdn.microsoft.com/en-us/library/ms796989.aspx">ExAllocatePoolWithTag</a></p>

_BLOG_FOOTER_GITHUB(`6')

_BLOG_FOOTER()

