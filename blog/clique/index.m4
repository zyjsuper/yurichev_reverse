m4_include(`commons.m4')

_HEADER_HL1(`22-Jul-2015: Clique in graph theory.')

<p>
Graph is a group of nodes, some of them may be connected with each other, some are not.
One of the popular examples is the map of country: there are cities and roads.
<i>Cities</i> are called <i>nodes</i> or <i>vertices</i> in mathematics lingo, while <i>roads</i> are called <i>edges</i>.
Another popular example of graph is computer network, including Internet.
Computer network is graph indeed, but it's closer to <i>sparse graph</i>, because for the most part, computer networks are trees.
</p>

<p>
<i>Clique</i> in everyday speech (especially in political news) denotes a tight-knit group of people inside of some community.
In graph theory, <i>clique</i> is a <i>subgraph</i> (part of graph) each <i>vertices</i> (<i>nodes</i> or <i>members</i>) of which are connected to each other.
</p>

_HL2(`Social graph: simple example')

<p><i>Social graph</i> is a graph representing social links.
Her is example I made in Wolfram Mathematica:</p>

_PRE_BEGIN
community = 
 Graph[{John <-> Mark, John <-> Alice, Mark <-> Alice, Tim <-> Alice, 
   Matthew <-> John, Matthew <-> Mark, Tim <-> John, Drake <-> Tim, 
   Bob <-> Drake, Bill <-> Mark, Bob <-> Alice, Tim <-> Mark}, 
  VertexLabels -> "Name"]
_PRE_END

<p><center><img src="http://yurichev.com/blog/clique/graph1.jpg"></center></p>

<p>Let's try to find largest clique:</p>

_PRE_BEGIN
In[]:= clique = FindClique[community]
Out[]= {{John, Mark, Alice, Tim}}
_PRE_END

<p>Indeed, each of these four persons is connected to every other 3.
Wolfram Mathematica can highlight subgraph in graph:</p>

_PRE_BEGIN
HighlightGraph[community, clique]
_PRE_END

<p><center><img src="http://yurichev.com/blog/clique/graph2.jpg"></center></p>

_HL2(`Social graph: IRC network')

<p>Internet Relay Chat (IRC) is popular among open-source developers.
One of the most popular IRC networks is Freenode.
And one of the most crowded IRC channel there is #ubuntu, devoted to Ubuntu Linux.
I used data from it, because all logs are available (starting at 2004), for example: _HTML_LINK_AS_IS(`http://irclogs.ubuntu.com/2015/01/01/%23ubuntu.txt').</p>

<p>When someone asks, and someone another going to answer the question, IRC users are address each other in this way:</p>

_PRE_BEGIN
[00:11] &lt;synire&gt; How would one find the path of an application installed using terminal?
[00:11] &lt;zykotick9&gt; synire: "whereis foo"
[00:11] &lt;synire&gt; zykotick9: thanks!
_PRE_END

<p>
It's not a rule, but well-established practice, so we can recover the information, which users talks to which users most often.
Let's say, we would build a link between two IRC users if 
1) they talk to each other at least 10-11 days (not necessary consequent);
2) do this at least 6 months (not necessary consequent).
</p>

<p>The largest cliques of #ubuntu IRC channel is then these:</p>

_PRE_BEGIN
* clique size 11
['ubottu', 'ActionParsnip', 'ikonia', 'Ben64', 'zykotick9', 'theadmin', 'dr_willis', 'MonkeyDust', 'usr13', 'bekks', 'iceroot']
* clique size 10
['ubottu', 'ActionParsnip', 'ikonia', 'jrib', 'bazhang', 'Pici', 'iceroot', 'theadmin', 'IdleOne', 'erUSUL']
* clique size 10
['ubottu', 'ActionParsnip', 'ikonia', 'jrib', 'bazhang', 'Pici', 'iceroot', 'theadmin', 'zykotick9', 'usr13']
* clique size 10
['ubottu', 'ActionParsnip', 'ikonia', 'jrib', 'bazhang', 'Pici', 'iceroot', 'sebsebseb', 'IdleOne', 'erUSUL']
* clique size 10
['ubottu', 'ActionParsnip', 'ikonia', 'jrib', 'Dr_Willis', 'Pici', 'edbian', 'IdleOne', 'Jordan_U', 'theadmin']
* clique size 10
['ubottu', 'ActionParsnip', 'ikonia', 'jrib', 'Dr_Willis', 'Pici', 'edbian', 'IdleOne', 'Jordan_U', 'sebsebseb']
* clique size 10
['ubottu', 'ActionParsnip', 'ikonia', 'jrib', 'Dr_Willis', 'Pici', 'erUSUL', 'iceroot', 'IdleOne', 'theadmin']
* clique size 10
['ubottu', 'ActionParsnip', 'ikonia', 'jrib', 'Dr_Willis', 'Pici', 'erUSUL', 'iceroot', 'IdleOne', 'sebsebseb']
* clique size 10
['ubottu', 'ActionParsnip', 'ikonia', 'jrib', 'Dr_Willis', 'Pici', 'erUSUL', 'iceroot', 'ubuntu', 'sebsebseb']
* clique size 10
['ubottu', 'ActionParsnip', 'ikonia', 'Ben64', 'histo', 'bekks', 'MonkeyDust', 'dr_willis', 'iceroot', 'usr13']
...
_PRE_END

<p>
Perhaps, these users are frequenters of the channel. List of all cliques are _HTML_LINK(`https://github.com/dennis714/blog.yurichev.com/blob/master/blog/clique/files/IRC/results.txt',`here').
The output is not terse, because all listed cliques are cliques indeed, and single user or users group can be member of several cliques, that's correct.
It's possible to produce more human-like results using 
_HTML_LINK(`https://en.wikipedia.org/wiki/Community_structure#Algorithms_for_finding_communities',`more complex algorithms for finding communities').
</p>

<p>The source code of my scripts _HTML_LINK(`https://github.com/dennis714/blog.yurichev.com/tree/master/blog/clique/files/IRC',`here'). I used excellent _HTML_LINK(`https://networkx.github.io/',`networkx graph library').</p>

_HL2(`Links graph: Wikipedia')

<p>Wikipedia has a lot of internal links, ~450,000,000 in English Wikipedia as of summer 2015, if not to count user/talk/media pages, etc.
It's possible to build a graph where Wikipedia article is a vertice (or node) and a link from one article to another is edge.
By link between articles we would call the case when the first article has the link to the second article, but also the second has the link to the first one.</p>

<p>Here are some examples of cliques I found this way. Number in parenthesis is clique size.</p>

<ul>
<li>Chess-related articles (9): Reuben Fine, Mikhail Botvinnik, Samuel Reshevsky, Max Euwe, FIDE, Alexander Alekhine, World Chess Championship, José Raúl Capablanca, AVRO 1938 chess tournament.

<li>Utah-related articles (9): Red Line (TRAX), Utah Transit Authority, Blue Line (TRAX), TRAX (light rail), Salt Lake City, Green Line (TRAX), FrontRunner, University of Utah, Utah.

<li>Articles related to Doctor Who (9): Doctor Who (film), Doctor Who, The Doctor (Doctor Who), Eighth Doctor, The Master (Doctor Who), Gallifrey, TARDIS, Doctor Who Magazine, Seventh Doctor.

<li>Space (9): New Horizons, Pioneer 11, Voyager 1, Europa (moon), Callisto (moon), Ganymede (moon), Jupiter, Io (moon), Pioneer 10.

<li>Hip hop music (9): G-funk, Dr. Dre, Death Row Records, Snoop Dogg, The Chronic, Gangsta rap, West Coast hip hop, N.W.A, Hip hop music.

<li>Metal music (9): Master of Puppets, Thrash metal, Cliff Burton, James Hetfield, Kirk Hammett, Metallica, Kill 'Em All, Ride the Lightning, Dave Mustaine.

<li>The Beatles (8): Break-up of the Beatles, The Beatles, George Harrison, Let It Be, John Lennon, Paul McCartney, Ringo Starr, Abbey Road.
</ul>

<p>Each Wikipedia article within any of these cliques has links to each article in clique.</p>

<p>Full lists of first 1000 largest cliques in English, Russian and Ukrainian Wikipedias plus source code of my scripts is _HTML_LINK(`https://github.com/dennis714/blog.yurichev.com/tree/master/blog/clique/files/wikipedia',`here').</p>

_HL2(`Social graph: LiveJournal spammers')

<p>LiveJournal is popular blogging platform in Russian-speaking Internet, which, as any other platform, flooded by spammers.
I once tried, for experiment, to find a way to make distinction between them and human users.
(I did this in 2010-2011, so this information may be not relevant these days).</p>

<p>Aside of false texts spammers posted to their blogs, spammers also mutually friended may spam accounts, so it was not unusual to register, let's say, 1000 fake
accounts and friend each other.</p>

<p>If to build a graph of all links between LiveJournal users, and find largest cliques, there will be prominent unusually large cliques of LiveJournal users, 
up to ~1000.
In real world, you would not easliy find a social group of ~1000 persons who keeps mutual links with each other 
(there is interesting reading about it: _HTML_LINK(`https://en.wikipedia.org/w/index.php?title=Dunbar%27s_number',`Dunbar&rsquo;s number').</p>

<p>Well, spammers could lower this number, so each fake user would have 100-200 mutual friends instead of ~1000 (which is less suspicious), but still, 
cliques were too perfect: each node connected to each other with very low
amount of <i>external</i> links, leading to other spammer's cliques and human users.</p>

_HL2(`Links graph: link farms')

<p>Talking about spammers, there was (or maybe still used today?) also a Black Hat SEO method to build 
_HTML_LINK(`https://en.wikipedia.org/wiki/Link_farm',`link farms'):
this is a collection of many websites which has links to each other.
Interestingly, if you analyze link graph and find cliques, such farms are clearly visible.<p>

_BLOG_FOOTER()

