m4_include(`commons.m4')

_HEADER(`Cordbg.exe from .NET 1.1 patch')

_HL1(`Cordbg.exe from .NET 1.1 patch:')

<p>My patch enables logging (into <i>cordbg.log</i> file) and new <i>pcont</i> command executing <i>print</i> and <i>cont</i> in turn. This is useful when you need to handle a lot of breakpoint hits and log all function arguments into file: just by pressing Enter.</p>

<p>Note: <i>print</i> command will not work as just <i>p</i> anymore, use <i>pr</i> as shortcut for <i>print</i>.</p>

<p>_HTML_LINK(`http://yurichev.com/non-wiki-files/cordbg11_patch.rar', `Patch, patched source code and compiled cordbg.exe.')</p>

_FOOTER()

