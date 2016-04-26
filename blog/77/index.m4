m4_include(`commons.m4')

_HEADER_HL1(`18-Dec-2013: Convert to sparse file utility (win32)')

<p>Just wrote utility intended for converting files into sparse ones on Windows NTFS file system.
Sparse files are those in which long zero blocks are not stored on hard disk, but replaced to information about them (metadata) instead.
These files are very useful for saving space on storing half-empty ISO files, half-downloaded torrent files, virtual machine disk images.</p>

<p>I need it primarily for VMware WS disk images "compressing".
I suppose, many other Oracle specialists use VMware machines with a lot of Oracle versions as well :-)</p>

<p>More about them: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Sparse_file')</p>

<p>Compiled executable file: _HTML_LINK_AS_IS(`http://yurichev.com/utils/cvt2sparse.exe')</p>

<p>That is how it looks after converting:</p>

<img src="http://yurichev.com/cvt2sparse.png">

<p>This one-liner is to be run inside of *NIX virtual machine to write zeroes to unused parts of file system:</p>

_PRE_BEGIN
dd if=/dev/zero of=empty_file; rm empty_file
_PRE_END

_BLOG_FOOTER_GITHUB(`77')

_BLOG_FOOTER()

