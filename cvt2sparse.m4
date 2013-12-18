m4_include(`commons.m4')

_HEADER(`Convert to sparse file utility')

_HL1(`Convert to sparse file utility (win32):')

<p>The utility is intended for converting files into sparse ones on Windows NTFS file system.
Sparse files are those in which long zero blocks are not stored on hard disk, but replaced
to information about them (metadata) instead.</p>

<p>These files are very useful for saving space on storing half-empty ISO files,
half-downloaded torrent files, virtual machine disk images.</p>

<p>More about them: _HTML_LINK(`https://en.wikipedia.org/wiki/Sparse_file',`https://en.wikipedia.org/wiki/Sparse_file').</p>

<p>_HTML_IMG(`cvt2sparse.png',`screenshot')</p>

<p>_HTML_LINK(`utils/cvt2sparse.exe',`Download')</p>

<p>_HTML_LINK(`https://github.com/yurichev/cvt2sparse',`Source code')</p>

_FOOTER()

