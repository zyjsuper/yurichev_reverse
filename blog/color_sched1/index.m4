m4_include(`commons.m4')

_HEADER_HL1(`Graph coloring and scheduling, part I')

<p>It's possible to color all countries on political map using only 4 colors.
This is example from Wolfram Mathematica's website (using _HTML_LINK(`http://reference.wolfram.com/language/ref/FindInstance.html',`FindInstance')):</p>

<p><img src="map.png"></p>

<p>( _HTML_LINK_AS_IS(`https://www.wolfram.com/mathematica/new-in-10/entity-based-geocomputation/find-a-four-coloring-of-a-map-of-europe.html') )</p>

<p>Any map or vertices on planar graph can be colored using at most 4 colors.
This is quite interesting story behind this.
This is a first serious proof finished using automated theorem prover (Coq):
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Four_color_theorem').</p>

<p>Another example where I use graph coloring: _HTML_LINK_AS_IS(`https://yurichev.com/blog/tiling_Z3/').</p>

<p>Now what about something practical? Four-colored maps are not used in cartography, however, graph coloring is used in scheduling.</p>

_HL2(`Using graph coloring in scheduling')

<p>I've found this problem in the "Discrete Structures, Logic and Computability" book by James L. Hein:</p>

<p><img src="fig144.png"></p>

_PRE_BEGIN
Suppose some people form committees to do various tasks. The problem is to schedule the committee meetings in as few time slots as possible.
To simplify the discussion, we’ll represent each person with a number. For example, let S = {1, 2, 3, 4, 5, 6, 7} represent a set of seven people,
and suppose they have formed six three-person committees as follows:
S1 = {1, 2, 3}, S2 = {2, 3, 4}, S3 = {3, 4, 5}, S4 = {4, 5, 6}, S5 = {5, 6, 7}, S6 = {1, 6, 7}.
We can model the problem with the graph pictured in Figure 1.4.4, where the committee names are the vertices and an edge connects 
two vertices if a person belongs to both committees represented by the vertices.
If each committee meets for one hour, what is the smallest number of hours needed for the committees to do their work?
From the graph, it follows that an edge between two committees means that they have at least one member in common.
Thus, they cannot meet at the same time. No edge between committees means that they can meet at the same time.
For example, committees S1 and S4 can meet the first hour. Then committees S2 and S5 can meet the second hour.
Finally, committees S3 and S6 can meet the third hour. Can you see why three hours is the smallest number of hours that the six committees can meet?
_PRE_END

<p>And this is solution:</p>

_PRE_BEGIN
m4_include(`blog/color_sched1/1.py')
_PRE_END

<p>Result:</p>

_PRE_BEGIN
hour: 0 committees: [1, 4]
hour: 1 committees: [2, 5]
hour: 2 committees: [3, 6]
_PRE_END

<p>If you increase total number of hours to 4, the result is somewhat sparser:</p>

_PRE_BEGIN
hour: 0 committees: [3]
hour: 1 committees: [1, 4]
hour: 2 committees: [2, 5]
hour: 3 committees: [6]
_PRE_END

_BLOG_FOOTER()

