m4_include(`commons.m4')

_HEADER_HL1(`Why cellular network is a cellular network')

<p>
If you put base stations (towers) too close, they must not interfere with each other.
Hence, they must work on different frequencies.
This is where _HTML_LINK(`https://en.wikipedia.org/wiki/Graph_coloring',`graph coloring') is used.
An each distinctive color will represent each distinctive frequency.
</p>

<p>
Represent towers as vertices.
If towers are placed too close to each other, put an edge between them, meaning, different colors/frequencies must be assigned to them.
</p>

<p>
Now this is why cellular network is a cellular network -- placing stations/tower in hexagonal form, makes this graph to be colored using only two colors/frequencies:
</p>

<p><img src="cell_network_2.png"></p>

<p>(Pardon my miserable Photoshop skills.)</p>

<p>
Mathematicians say, the chromatic number of this (planar) graph is 2.
Chromatic number is a maximal number of colors.
And a planar graph is a graph that can be represented on 2D plane with no edges intersected (like a world map).</p>

<p>
Hexagonal grid is hence optimal for the task.
This is not achievable in practice (you cannot place towers in city wherever you want), but you can come close to this ideal.
</p>

_BLOG_FOOTER()

