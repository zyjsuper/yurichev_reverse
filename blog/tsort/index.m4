m4_include(`commons.m4')

_HEADER_HL1(`Dependency graphs and topological sorting using Z3 SMT-solver')

<p>Topological sorting is an operation many programmers well familiar with: this is what "make" tool
do when it find an order of items to process.
Items not dependent of anything can be processed first.
The most dependent items at the end.</p>

<p>Dependency graph is a graph and topological sorting is such a "contortion" of the graph,
when you can see an order of items.</p>

<p>For example, let's create a sample graph in Wolfram Mathematica:</p>

_PRE_BEGIN
In[]:= g = Graph[{7 -> 1, 7 -> 0, 5 -> 1, 3 -> 0, 3 -> 4, 1 -> 2, 1 -> 6, 
   1 -> 4, 0 -> 6}, VertexLabels -> "Name"]
_PRE_END

<p><img src="math.png"></p>

<p>Each arrow shows that an item is needed by an item arrow pointing to, i.e., if "a -> b", then item "a" must be first
processed, because "b" needs it, or "b" depends on "a".</p>

<p>How Mathematica would <i>sort</i> the dependency graph?</p>

_PRE_BEGIN
In[]:= TopologicalSort[g]
Out[]= {7, 3, 0, 5, 1, 4, 6, 2}
_PRE_END

<p>So you're going to process item 7, then 3, 0, and 2 at the very end.</p>

<p>_HTML_LINK(`https://en.wikipedia.org/wiki/Topological_sorting',`The algorithm in the Wikipedia article')
is probably used in "make" and whatever IDE you use for building your code.</p>

<p>However, some older UNIX platforms had separate "tsort" utility spawned from "make" during building.
This is a case at least of NetBSD:
_HTML_LINK_AS_IS(`https://www.unix.com/man-page/netbsd/1/tsort/').</p>

<p>This time, I'll use Z3 SMT-solver for topological sort, which is overkill, but quite spectacular: all we need to do
is to add constraint for each edge (or "connection") in graph, if "a -> b", then "a" must be less then "b", where
each variable reflects ordering.</p>

_PRE_BEGIN
#!/usr/bin/env python</span>

<span style='color:#800000; font-weight:bold; '>from</span> z3 <span style='color:#800000; font-weight:bold; '>import</span> <span style='color:#44aadd; '>*</span>

TOTAL<span style='color:#808030; '>=</span><span style='color:#008c00; '>8</span>

order<span style='color:#808030; '>=</span><span style='color:#808030; '>[</span><span style='color:#400000; '>Int</span><span style='color:#808030; '>(</span><span style='color:#0000e6; '>'%d'</span> <span style='color:#44aadd; '>%</span> i<span style='color:#808030; '>)</span> <span style='color:#800000; font-weight:bold; '>for</span> i <span style='color:#800000; font-weight:bold; '>in</span> <span style='color:#400000; '>range</span><span style='color:#808030; '>(</span>TOTAL<span style='color:#808030; '>)</span><span style='color:#808030; '>]</span>

s<span style='color:#808030; '>=</span>Solver<span style='color:#808030; '>(</span><span style='color:#808030; '>)</span>
s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>Distinct<span style='color:#808030; '>(</span>order<span style='color:#808030; '>)</span><span style='color:#808030; '>)</span>
<span style='color:#800000; font-weight:bold; '>for</span> i <span style='color:#800000; font-weight:bold; '>in</span> <span style='color:#400000; '>range</span><span style='color:#808030; '>(</span>TOTAL<span style='color:#808030; '>)</span><span style='color:#808030; '>:</span>
    s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span><span style='color:#800000; font-weight:bold; '>And</span><span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span><span style='color:#44aadd; '>>=</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> order<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>TOTAL<span style='color:#808030; '>)</span><span style='color:#808030; '>)</span>

s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>5</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>

s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>3</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>4</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>
s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>3</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>

s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>7</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>
s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>7</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>

s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>2</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>
s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>4</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>
s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>6</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>

s<span style='color:#808030; '>.</span>add<span style='color:#808030; '>(</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>&lt;</span>order<span style='color:#808030; '>[</span><span style='color:#008c00; '>6</span><span style='color:#808030; '>]</span><span style='color:#808030; '>)</span>

<span style='color:#800000; font-weight:bold; '>print</span> s<span style='color:#808030; '>.</span>check<span style='color:#808030; '>(</span><span style='color:#808030; '>)</span>

m<span style='color:#808030; '>=</span>s<span style='color:#808030; '>.</span>model<span style='color:#808030; '>(</span><span style='color:#808030; '>)</span>
order_to_print<span style='color:#808030; '>=</span><span style='color:#808030; '>[</span><span style='color:#074726; '>None</span><span style='color:#808030; '>]</span><span style='color:#44aadd; '>*</span><span style='color:#808030; '>(</span>TOTAL<span style='color:#808030; '>)</span>
<span style='color:#800000; font-weight:bold; '>for</span> i <span style='color:#800000; font-weight:bold; '>in</span> <span style='color:#400000; '>range</span><span style='color:#808030; '>(</span>TOTAL<span style='color:#808030; '>)</span><span style='color:#808030; '>:</span>
    order_to_print<span style='color:#808030; '>[</span>m<span style='color:#808030; '>[</span>order<span style='color:#808030; '>[</span>i<span style='color:#808030; '>]</span><span style='color:#808030; '>]</span><span style='color:#808030; '>.</span>as_long<span style='color:#808030; '>(</span><span style='color:#808030; '>)</span><span style='color:#808030; '>]</span><span style='color:#808030; '>=</span>i

<span style='color:#800000; font-weight:bold; '>print</span> order_to_print
_PRE_END

<p>Almost the same result, but also correct:</p>

_PRE_BEGIN
sat
[3, 5, 7, 0, 1, 2, 4, 6]
_PRE_END

_FOOTER()

