m4_include(`commons.m4')

_HEADER_HL1(`Solving Numberlink (AKA Flow Free) puzzle using Z3')

<p>This time, _HTML_LINK(`https://twitter.com/masahiro_sakai',`Masahiro Sakai') has helped me, who also have _HTML_LINK(`https://github.com/msakai/toysolver/tree/master/samples/programs/numberlink',`numberlink puzzle solver') 
in his _HTML_LINK(`https://github.com/msakai/toysolver',`toysolver').</p>

<p>You probably saw Flow Free puzzle:</p>

<p><img src="flow-extreme-11-11.png" width="15%"></p>

<p>I'll stick to Numberlink version of the puzzle. This is the example puzzle from Wikipedia:</p>

<p><img src="424px-Numberlink_puzzle.svg.png" width="10%"></p>

<p>This is solved:</p>

<p><img src="424px-Numberlink_puzzle_solution.svg.png" width="10%"></p>

<p>See also:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Numberlink'),
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Flow_Free').</p>

<p>The code:</p>

_PRE_BEGIN
m4_include(`blog/numberlink/numberlink.py')
_PRE_END

<p>The solution:</p>

_PRE_BEGIN
m4_include(`blog/numberlink/solution.txt')
_PRE_END

_FOOTER()

