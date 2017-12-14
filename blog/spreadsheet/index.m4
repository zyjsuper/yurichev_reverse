m4_include(`commons.m4')

<p>(The following text has been moved to the article at _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf').)</p>

_HEADER_HL1(`29-Apr-2017: Recalculating micro-spreadsheet using Z3Py')

<p>There is a nice exercise (_HTML_LINK(`http://thesz.livejournal.com/280784.html',`blog post in Russian')): write a program to recalculate micro-spreadsheet, like this one:</p>

_PRE_BEGIN
m4_include(`blog/spreadsheet/test1')
_PRE_END

<p>As it turns out, though overkill, this can be solved using Z3 with little effort:</p>

_PRE_BEGIN
m4_include(`blog/spreadsheet/1.py')
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/spreadsheet/1.py') )</p>

<p>All we do is just creating pack of variables for each cell, named A0, B1, etc, of integer type.
All of them are stored in <i>cells[]</i> dictionary.
Key is a string.
Then we parse all the strings from cells, and add to list of constraints "A0=123" (in case of number in cell) or "A0=B1+C2" (in case of expression in cell).
There is a slight preparation: string like "A0+B2" becomes "cells["A0"]+cells["B2"]".</p>

<p>Then the string is evaluated using Python <i>eval()</i> method, which is _HTML_LINK(`http://stackoverflow.com/questions/1832940/is-using-eval-in-python-a-bad-practice',`highly dangerous'):
imagine if end-user could add a string to cell other than expression?
Nevertheless, it serves our purposes well, because this is a simplest way to pass a string with expression into Z3.</p>

<p>Z3 do the job with little effort:</p>

_PRE_BEGIN
 % python 1.py test1
sat
1       0       135     82041
123     10      12      11
667     11      1342    83383
_PRE_END

_HL2(`Unsat core')

<p>Now the problem: what if there is circular dependency? Like:</p>

_PRE_BEGIN
m4_include(`blog/spreadsheet/test_circular')
_PRE_END

<p>Two first cells of the last row (C0 and C1) are linked to each other.
Our program will just tell "unsat", meaning, it couldn't solve all constraints together.
We can't use this as error message reported to end-user, because it's highly unfriendly.</p>

<p>However, we can fetch "unsat core", i.e., list of variables which Z3 finds conflicting.</p>

_PRE_BEGIN
...
s=Solver()
s.set(unsat_core=True)
...
        # add constraint:
        s.assert_and_track(e, coord_to_name(cur_R, cur_C))
...
if result=="sat":
...
else:
    print s.unsat_core()
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/spreadsheet/2.py') )</p>

<p>We should explicitly turn on unsat core support and use <i>assert_and_track()</i> instead of <i>add()</i> method, because this feature slows down the whole process.
That works:</p>

_PRE_BEGIN
 % python 2.py test_circular
unsat
[C0, C1]
_PRE_END

<p>Perhaps, these variables could be removed from the 2D array, marked as "unresolved" and the whole spreadsheet could be recalculated again.</p>

_HL2(`Stress test')

<p>How to generate large random spreadsheet?
What we can do.
First, create random DAG (Directed acyclic graph), like this one:</p>

<img src="https://yurichev.com/blog/spreadsheet/1.png">

<p>Arrows will represent information flow.
So the vertex (node) which has no incoming arrows to it (indegree=0), can be filled with random numbers.
Then we use topological sort to find dependencies between vertices.
Then we assign spreadsheet cell names to each vertex.
Then we generate random expression with random operations and random numbers to each cell, which will use information from topological sorted graph.</p>

_PRE_BEGIN
(* Utility functions *)
In[1]:= findSublistBeforeElementByValue[lst_,element_]:=lst[[ 1;;Position[lst, element][[1]][[1]]-1]]

(* Input in 1..∞ range. 1->A0, 2->A1, etc *)
In[2]:= vertexToName[x_,width_]:=StringJoin[FromCharacterCode[ToCharacterCode["A"][[1]]+Floor[(x-1)/width]],ToString[Mod[(x-1),width]]]

In[3]:= randomNumberAsString[]:=ToString[RandomInteger[{1,1000}]]

In[4]:= interleaveListWithRandomNumbersAsStrings[lst_]:=Riffle[lst,Table[randomNumberAsString[],Length[lst]-1]]

(* We omit division operation because micro-spreadsheet evaluator can't handle division by zero *)
In[5]:= interleaveListWithRandomOperationsAsStrings[lst_]:=Riffle[lst,Table[RandomChoice[{"+","-","*"}],Length[lst]-1]]

In[6]:= randomNonNumberExpression[g_,vertex_]:=StringJoin[interleaveListWithRandomOperationsAsStrings[interleaveListWithRandomNumbersAsStrings[Map[vertexToName[#,WIDTH]&,pickRandomNonDependentVertices[g,vertex]]]]]

In[7]:= pickRandomNonDependentVertices[g_,vertex_]:=DeleteDuplicates[RandomChoice[findSublistBeforeElementByValue[TopologicalSort[g],vertex],RandomInteger[{1,5}]]]

In[8]:= assignNumberOrExpr[g_,vertex_]:=If[VertexInDegree[g,vertex]==0,randomNumberAsString[],randomNonNumberExpression[g,vertex]]

(* Main part *) 
(* Create random graph *)
In[21]:= WIDTH=7;HEIGHT=8;TOTAL=WIDTH*HEIGHT
Out[21]= 56

In[24]:= g=DirectedGraph[RandomGraph[BernoulliGraphDistribution[TOTAL,0.05]],"Acyclic"];

...

(* Generate random expressions and numbers *)
In[26]:= expressions=Map[assignNumberOrExpr[g,#]&,VertexList[g]];

(* Make 2D table of it *)
In[27]:= t=Partition[expressions,WIDTH];

(* Export as tab-separated values *)
In[28]:= Export["/home/dennis/1.txt",t,"TSV"]
Out[28]= /home/dennis/1.txt

In[29]:= Grid[t,Frame->All,Alignment->Left]
_PRE_END

<p>Here is an output from Grid[]:</p>

m4_include(`blog/spreadsheet/grid.txt')

<p>Using this script, I can generate random spreadsheet 26*500 cells (13000 cells), which seems to be processed in couple of seconds.</p>

_HL2(`Conclusion')

<p>The files, including Mathematica notebook: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/tree/master/blog/spreadsheet').</p>

<p>Other Z3-related examples: _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf').</p>

_BLOG_FOOTER()

