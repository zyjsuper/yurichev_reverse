m4_include(`commons.m4')

_HEADER_HL1(`[Math][Python][Z3] Graph drawing and ILP')

<p>Graph drawing is a tricky subject.</p>

<p>My favorite method is to represent graph using springs or strings, solder them together and leave the construction to let it open up.
You can simulate this algorithmically:</p>

_PRE_BEGIN
In force-based layout systems, the graph drawing software modifies an initial vertex placement by continuously moving the vertices according to a system of forces based on physical metaphors related to systems of springs or molecular mechanics. Typically, these systems combine attractive forces between adjacent vertices with repulsive forces between all pairs of vertices, in order to seek a layout in which edge lengths are small while vertices are well-separated. These systems may perform gradient descent based minimization of an energy function, or they may translate the forces directly into velocities or accelerations for the moving vertices.
_PRE_END
( _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Graph_drawing') )

<p>But what if we are not good at programming and we are locked on a desert island with no Internet?
The first thing which came to mind is to fix length of each edge at some constant...</p>

<p>This is what we can do. We define coordinates of all vertices on a 2D plane and measure distances between them.
If edge is present, a distance must be in some range.
In out case, this range is 7..8.
(You can't set a distance without some tolerance...)</p>

<p>A distance between two vertices is calculated using a simple equation we may remember from school...</p>

<p>Then, we output the result to GraphViz, it has an option for setting vertex coordinates forcibly:</p>

_PRE_BEGIN
m4_include(`blog/graph/1.py')
_PRE_END

<p>The result:</p>

_PRE_BEGIN
m4_include(`blog/graph/tmp.gv')
_PRE_END

<p><img src="blog/graph/tmp.png"></p>

<p>This is far from what GraphViz can usually do, but this is bettern than nothing.
Also, it was a fun to do it!</p>

<p>Further work:
Try to render _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Unit_distance_graph'), all edges of which are of similar length...</p>

_BLOG_FOOTER()
