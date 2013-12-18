m4_include(`commons.m4')

_HEADER(`Windows')

_HL1(`Notes about Windows OS')

_HL2(`Unbuffered copy of huge files')

... in Windows 7, 2008, etc 
(buffered copy have _HTML_LINK(`http://blogs.technet.com/b/askperf/archive/2007/05/08/slow-large-file-copy-issues.aspx',`cache issues') there):

<pre>
xcopy c:\directory\* c:\another_directory /e /j
</pre>

_HTML_LINK(`http://technet.microsoft.com/en-us/library/cc771254(WS.10).aspx',`More on xcopy.')

_HL2(`Flattern directory')

... i.e., copy all files from all subdirectories to the current one:

<pre>
for /r %f in (*) do @copy "%f" .
</pre>

_HL2(`Sparse files')

_HTML_LINK(`cvt2sparse.html',`Convert to sparse file utility')

_HL2(`Keyboard/mouse shortcuts')

<ul>
<li> Alt-Space N: minimize window
<li> Ctrl-0: set zoom at %100
<li> Win-E: run Windows Explorer
<li> Win-L: Lock the computer (without using CTRL+ALT+DELETE)
<li> Ctrl+Shift+Esc - task manager
<li> Alt-F4: Closes the current window
<li> Ctrl-F4: Closes the current Multiple Document Interface (MDI) window
<li> Win-up, Win-down - maximize/minimize
<li> Win-M: Minimize all
<li> Shift-Win-M: Undo minimize all
<li> Alt-Space, E, P: Paste into console window from clipboard
</ul>

_HL3(`Two (or more) displays')

<ul>
<li> Win-Arrows - move window
</ul>

_HL3(`Windows Explorer shortcuts')

<ul>
<li> Win-R - run new process
<li> Win-F: Find files or folders
<li> F2: rename object
<li> Ctrl-X: Cut
<li> Ctrl-C: Copy
<li> Ctrl-V: Paste
<li> Shift-right click: Displays a shortcut menu containing alternative commands
<li> Alt-double click: Displays properties
<li> Alt-Enter: Open the properties for the selected object
<li> F5: Refreshes the current window.
<li> Ctrl-A: Select all the items in the current window
<li> Win-Break: System Properties dialog box
<li> Shift-Delete: Deletes an item immediately without placing it in the Recycle Bin
</ul>

_FOOTER()
