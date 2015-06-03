m4_include(`commons.m4')

_HEADER(`My Wget patches')

_HL1(`My Wget patches:')

<p><i>--limit-size</i> option support. Nothing special: just skip any HTTP/FTP file with size bigger than set in <i>--limit-size=</i> while mirroring some website.</p> 

<p>Size can be set as nnnM, nnnk (megabytes, kilobytes).</p>

<p>_HTML_LINK(`http://yurichev.com/non-wiki-files/wget-1.13.4-limitsize/wget-1.13.4-limitsize.patch', `Wget 1.13.4 patch')</p>

<p>_HTML_LINK(`http://yurichev.com/non-wiki-files/wget-1.13.4-limitsize/wget-1.13.4-limitsize-src.zip', `Full patched 1.13.4 source tree')</p>

<p>_HTML_LINK(`http://yurichev.com/non-wiki-files/wget-1.13.4-limitsize/wget-1.13.4-limitsize-win32-cygwin.zip', `Patched and compiled (cygwin, win32)')</p>

<p>_HTML_LINK(`http://yurichev.com/non-wiki-files/wget-1.13.4-limitsize/wget-1.13.4-limitsize_linux_x86.tar.bz2', `Patched and compiled (linux x86)')</p>

<hr>

<p>Make it exit on specific HTTP error (patch for 1.12):</p>

_PRE_BEGIN
--- http.c~	2009-09-22 06:02:18.000000000 +0300
+++ http.c	2011-08-03 14:43:00.000000000 +0300
@@ -2673,6 +2673,8 @@
               logprintf (LOG_NOTQUIET, _("%s ERROR %d: %s.\n"),
                          tms, hstat.statcode,
                          quotearg_style (escape_quoting_style, hstat.error));
+              if (hstat.statcode==503)
+                  exit(1);
             }
           logputs (LOG_VERBOSE, "\n");
           ret = WRONGCODE;
_PRE_END

_FOOTER()

