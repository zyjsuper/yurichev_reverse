m4_include(`commons.m4')

_HEADER_HL1(`Numberlink (AKA Flow Free) as a MaxSAT problem + toy PCB router')

<p>Let's revisit _HTML_LINK(`https://yurichev.com/blog/numberlink/',`my solution for Numberlink (AKA Flow Free) puzzle written for Z3Py').</p>

<p>What if holes in the puzzle exist?
Can we make all paths as short as possible?</p>

<p>I've rewritten the puzzle solver using my own SAT library _HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/numberlink_MaxSAT/Xu.py',`Xu.py')
and now I use _HTML_LINK(`http://sat.inesc-id.pt/open-wbo/',`Open-WBO MaxSAT solver'), see the source code, which is almost the same:
_HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/numberlink_MaxSAT/numberlink_WBO.py').</p>

<p>But now we "maximize" number of empty cells:</p>

_PRE_BEGIN
┏1 5┏━3┏━6
┃ ┏┛┃ ┏┛ 2
┃5┛ ┃ ┃  ┃
┗━┓ ┃┏┛ ┏┛
7 ┗┓┃┃ ┏┛
┗━┓┃3┃ 2
 4┃┃6┛┏━━┓
┏┛┃┃┏━┛┏8┃
┃ ┃19┏7┃┏┛
4 ┗━━┛ 89
_PRE_END

<p>This is a solution with shortest possible paths. Others are possible, but their sum wouldn't be shorter.
This is like toy PCB routing.</p>

<p>What if we comment the <b>s.fix_soft_always_true(cell_is_empty[r][c], 1)</b> line?</p>

_PRE_BEGIN
┏1 5┓ 3┓┏6
┃┏┓┏┛ ┏┛┃2
┃5┗┛┏━┛ ┃┃
┗┓  ┗┓  ┃┃
7┗━┓ ┃┏━┛┃
┗━┓┃3┛┃2━┛
 4┃┃6━┛┏━┓
 ┃┃┃┏━━┛8┃
 ┃┃19┏7┏┛┃
4┛┗━━┛ 89┛
_PRE_END

<p>Lines 5 and 3 "roaming" chaotically, but the solution is correct, under given constraints.</p>

<p>The files: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/tree/master/blog/numberlink_MaxSAT').</p>

_FOOTER()

