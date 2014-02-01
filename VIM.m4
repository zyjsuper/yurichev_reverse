m4_include(`commons.m4')

_HEADER(`VIM')

_HL1(`Notes about VIM text editor')

_HL2(`Color schemes I found appealing')

<ul>

<li><p>_HTML_LINK(`http://www.vim.org/scripts/script.php?script_id=3139',`phd')</p>
_HTML_IMG(`VIM/vim_phd.png',`VIM phd color scheme')

<li><p>_HTML_LINK(`http://www.vim.org/scripts/script.php?script_id=1677',`twilight')</p>
_HTML_IMG(`VIM/vim_twilight.png',`VIM twilight color scheme')

<li><p>_HTML_LINK(`http://www.vim.org/scripts/script.php?script_id=415',`zenburn')</p>
_HTML_IMG(`VIM/vim_zenburn.png',`VIM zenburn color scheme')

</ul>

_HL2(`Regular expressions')

Prepend it with \C to match case and \c to ignore case.

_HL2(`Grepping')

Search for pattern in all *.c files:

<pre>
:vimgrep /regexp/ *.c
</pre>

Search for pattern in all *.c files in all folders:

<pre>
:vimgrep /regexp/ **/*.c
</pre>

Jump to next result:

<pre>
:cn
</pre>

Open window with results:

<pre>
:cw
</pre>

Close results window: <kbd>C-w</kbd> <kbd>c</kbd>

_HL2(`Selecting')

<p>Count lines/words/chars/bytes selected: <kbd>g</kbd> <kbd>C-g</kbd></p>

<p>Result may be in form:</p>

<pre>
Selected 7 of 22 Lines; 8 of 32 Words; 201 of 491 Chars; 201 of 497 Bytes
</pre>

_HL2(`File formats')

EOLs:

<pre>
:set ff?
:set ff=unix
:set ff=dos
</pre>

Suppress writing Unicode BOM:

<pre>
:set nobomb
</pre>

_HL2(`Command-line')

<p>Commands separator: |</p>

<p>For exampe:</p>

<pre>
set nobomb|w|bd
</pre>

_FOOTER()
