m4_include(`commons.m4')

_HEADER(`Duplicate Directories and Files Finder')

_HL1(`Duplicate Directories and Files Finder:')

_PRE_BEGIN
* How to run it:

Usage: ddff.exe <directory1> <directory2> ...
For example: ddff.exe C:\ D:\ E:\

Some information (partial and full filehashes) are stored into NTFS streams, so the next
scanning will be much faster.

* Comparison to other duplicate finding utilities:

+ Very fast
+ Comparing only file contents, ignoring file name/attributes. 
+ Comparing directories too.
+ Often, two directories contain, let's say, 4 equal files and 5th file is different.
  We handle it too and output these as "common files in directories"
+ Absence of unnecessary switches.

- Win32 only
- Command-line only
_PRE_END

<p>_HTML_LINK(`http://conus.info/utils/ddff.exe', `Download for win32').</p>
<p>_HTML_LINK(`https://github.com/DennisYurichev/DDFF', `source code').</p>

_FOOTER()

