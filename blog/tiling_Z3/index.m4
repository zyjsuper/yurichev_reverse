m4_include(`commons.m4')

_HEADER_HL1(`Tiling puzzle and Z3 SMT solver')

<p>(The following text has been moved to the article at _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf').)</p>

<p>This is classic problem: given 12 polyomino titles, cover mutilated chessboard with them (it has 60 squares with no central 4 squares).</p>

<p>The problem is covered at least in _HTML_LINK(`https://arxiv.org/pdf/cs/0011047.pdf',`Donald E. Knuth - Dancing Links'), and this Z3 solution has been inspired by it.</p>

<p>Another thing I've added: graph coloring. You see, my script gives correct solutions, but somewhat unpleasant visually.
So I used colored pseudographics. There are 12 tiles, it's not a problem to assign 12 colors to them.
But there is another heavily used SAT problem: graph coloring.</p>

<p>Given a graph, assign a color to each vertex/node, so that colors wouldn't be equal in adjacent nodes.
The problem can be solved easily in SMT: assign variable to each vertex.
If two vertices are connected, add a constraint: "vertex1_color != vertex2_color".
As simple as that.
In my case, each polynomio is vertex and if polyomino is adjacent to another polyomino, an edge/link is added between vertices.
So I did, and output is now colored.</p>

<p>But this is planar graph (i.e., a graph which is, if represented in two-dimensional space has no intersected edges/links).
And here is a famous _HTML_LINK(`https://en.wikipedia.org/wiki/Four_color_theorem',`four color theorem') can be used.
The solution of tiled polynomios is in fact like planar graph, or, a map, like a world map.
Theorem states that any planar graph (or map) can be colored only 4 colors.</p>

<p>This is true, even more, several tilings can be colors with only 3 colors:</p>

<p><img src="small.png"></p>

<p>Now the classic: 12 pentominos and "mutilated" chess board, several solutions:</p>

<p><img src="big1.png"> <img src="big2.png"></p>

<p>The source code: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/tiling_Z3/tiling.py')</p>

<p>Further reading: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Exact_cover#Pentomino_tiling').</p>

<p>Four-color theorem has an interesting story, it has been finally proved in 2005 by Coq proof assistant:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Four_color_theorem').</p>

_BLOG_FOOTER()

