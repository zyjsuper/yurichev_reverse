m4_include(`commons.m4')

_HEADER_HL1(`Travelling salesman problem using Z3')

<p>This is it:</p>

_PRE_BEGIN
m4_include(`blog/TSP/TSP.py')
_PRE_END

<p>Result:</p>

_PRE_BEGIN
sat
Dallas (1240 mi to the next city) ->
Los Angeles (831 mi to the next city) ->
Denver (700 mi to the next city) ->
Minneapolis (355 mi to the next city) ->
Chicago (713 mi to the next city) ->
New York (1374 mi to the next city) ->
distance_total= 5213 mi
_PRE_END

<p>Map I generated with Wolfram Mathematica:</p>

<img src="map1.png">

<p>Maximizing:</p>

_PRE_BEGIN
sat
Dallas (862 mi to the next city) ->
Minneapolis (700 mi to the next city) ->
Denver (1631 mi to the next city) ->
New York (2451 mi to the next city) ->
Los Angeles (1745 mi to the next city) ->
Chicago (803 mi to the next city) ->
distance_total= 8192 mi
_PRE_END

<p>Map:</p>

<img src="map2.png">

<p>I could only process 6 cities, and it takes starting at several seconds up to 1 minute on my venerable Intel Quad-Core Xeon E3-1220 3.10GHz.
Perhaps, this is not a right tool for the job, well-known TSP algorithms way faster.</p>

<p>Even bruteforce enumeration is faster (6!=720 paths).</p>

<p>However, it still can serve as demonstration.</p>

_FOOTER()

