m4_include(`commons.m4')

_HEADER_HL1(`17-Feb-2008: Oracle V$TIMER')

<p>On different OS, Oracle V$TIMER system value shows different values.
On Microsoft Windows (I tested Oracle 8.0.5, 8.1.5, 9.0.1.1.1, 9.2.0.1, 10.1.0.2, 10.2.0.1, 10.2.0.1 x64, 11.1.0.6.0 and 11.1.0.6.0 x64) this value is exactly what system call <a href="http://msdn2.microsoft.com/en-us/library/ms724408(VS.85).aspx">GetTickCount()</a> returning divided by 10.
On GNU/Linux (I tested 10.1.0.3, 10.2.0.1, 11.1.0.6.0 and 11.1.0.6.0 x64) this is exactly what <a href="http://www.scit.wlv.ac.uk/cgi-bin/mansec?2+times">times()</a> system call returning.
On Solaris 10 (I tested 10.2.0.1 x64) this is value returned by <a href="http://docs.sun.com/app/docs/doc/816-5168/gethrtime-3c?a=view">gethrtime()</a> divided by 10000000.</p>

<p>So, while we reading official Oracle manual of 11g Release 1 (11.1):</p>

<p><a href="http://download.oracle.com/docs/cd/B28359_01/server.111/b28320/dynviews_3104.htm">V$TIMER displays the elapsed time in hundredths of a second. Time is measured since the beginning of the epoch, which is operating system specific, and wraps around to 0 again whenever the value overflows four bytes (roughly 497 days).</a></p>

<p>... they probably not covering all OS-es.</p>

<p>Update: The story about how did I find it, I added to my "Quick introduction to reverse engineering for beginners" book: _HTML_LINK_AS_IS(`//yurichev.com/RE-book.html')</p>

_BLOG_FOOTER_GITHUB(`1')

_BLOG_FOOTER()

