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
