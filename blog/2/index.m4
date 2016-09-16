m4_include(`commons.m4')

_HEADER_HL1(`26-Jun-2008: Oracle X$KSMLRU fixed table')

<p>Regarding question on Oracle X$KSMLRU fixed table.</p>

<p><a href="http://blogs.oracle.com/schan/2007/05/29">The x$ksmlru table keeps track of the current shared pool objects and the corresponding number of objects flushed out of the shared pool to allocate space for the load.  These objects are stored and flushed out based on the Least Recently Used (LRU) algorithm.
....
Note:  This is a fixed table: once you query the table, the database will automatically reset the table.  Make sure that you spool the output to a file so you can capture it for analysis.</a></p>

<p>I cannot yet answer why this table reset after each SELECT, but at least, I know at which point.
Information in this table is constructed using function ksmlrs() (at least for 10.2), which also calls ksmsplu(). The last function allocate memory chunks for the table, marking them as <b>x$\$$ksmsp lrstat</b> and <b>x$\$$ksmsp lru</b>, then copy the table, then calls memset() C function to zero it.
If to bypass this last call to memset(), by debugger for example, it is possible to have such Oracle instance which will not reset this table after each SELECT. However, if you want to do this, I hope you'll backup your database first.</p>

<p>Update: The story about how did I find it, I added to my "Quick introduction to reverse engineering for beginners" book: _HTML_LINK_AS_IS(`//yurichev.com/RE-book.html').</p>

_BLOG_FOOTER_GITHUB(`2')

_BLOG_FOOTER()

