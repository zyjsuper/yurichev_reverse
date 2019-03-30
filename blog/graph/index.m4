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
from z3 import *
import os

# Petersen graph
# https://en.wikipedia.org/wiki/Petersen_graph

VERTICES=10
edges=[ (0,2), (2,3), (3,4), (4,1), (1,0), (0,6), (2,7), (3,8), (4,9), (1,5), (6,8), (6,9), (5,7), (5,8), (9,7)]

vertex_r=[Int('vertex_r_%d' % r) for r in range(VERTICES)]
vertex_c=[Int('vertex_c_%d' % c) for c in range(VERTICES)]

s=Solver()

def abs(a):
    return If(a<0, -a, a)

MIN_DISTANCE=7
MAX_DISTANCE=8

for v in range(VERTICES):
    s.add(vertex_r[v]>=0)
    s.add(vertex_c[v]>=0)

for e in edges:
    v_src=e[0]
    v_dst=e[1]

    diff_vertical=abs(vertex_r[v_src]-vertex_r[v_dst])
    diff_horizontal=abs(vertex_c[v_src]-vertex_c[v_dst])
    t=diff_vertical*diff_vertical + diff_horizontal*diff_horizontal
    s.add(t<MAX_DISTANCE*MAX_DISTANCE)
    s.add(t>MIN_DISTANCE*MIN_DISTANCE)

print s.check()
m=s.model()

f=open("tmp.gv","wt")

f.write("digraph finite_state_machine {\n");
f.write("\trankdir=LR;\n");
f.write("\tsize=\"8\"\n");
f.write("\tnode [shape = circle];\n");
# https://stackoverflow.com/questions/5343899/how-to-force-node-position-x-and-y-in-graphviz
for v in range(VERTICES):
    f.write("\t%d [pos=\"%d,%d!\"];\n" % (v, m[vertex_c[v]].as_long(), m[vertex_r[v]].as_long()))

# TODO: undirected graph
for e in edges:
    f.write("\t%d -> %d;\n" % (e[0], e[1]))
f.write ("}\n");
f.close()
os.system("dot -Kfdp -n -Tpng tmp.gv > tmp.png")
_PRE_END

<p>The result:</p>

_PRE_BEGIN
m4_include(`blog/graph/tmp.gv')
_PRE_END

<p>As rendered by GraphViz:</p>

<p><img src="tmp.png"></p>

<p>This is far from what GraphViz can usually do, but this is better than nothing.
Also, it was a fun to do it!</p>

<p>Further work:
Try to render _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Unit_distance_graph'), all edges of which are of similar length...</p>

<p>Also, we can enumerate as many solutions as possible to find the one, where vertices are not intersected by edges, as in our case.</p>

_BLOG_FOOTER()
