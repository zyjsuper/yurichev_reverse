m4_include(`commons.m4')

_HEADER_HL1(`Autocomplete using Markov chains')
 
<p>What are most chess moves played after 1.e4 e5 2.Nf3 Nf6?
A big database of chess games can be queried, showing statistics:</p>

<img src="chess.png">

<p>( from _HTML_LINK_AS_IS(`https://chess-db.com/') )</p>

<p>Statistics shown is just number of games, where a corresponding 3rd move was played.</p>

<p>The same database can be made for natural language words.</p>

_HL2(`Dissociated press')

<p>This is a well-known joke:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Dissociated_press'),
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/SCIgen'),
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Mark_V._Shaney').</p>

<p>I wrote a Python script, took Sherlock Holmes stories from Gutenberg library...</p>

_PRE_BEGIN
m4_include(`blog/markov/dissociated.py')
_PRE_END

<p>And here are some 1st-order Markov chains.
First part is a first word.
Second is a list of words + probabilities of appearance of each one, in the Sherlock Holmes stories.
However, probabilities are in form of words' numbers.</p>

<p>In other word, how often each word appears after a word?</p>

_PRE_BEGIN
m4_include(`blog/markov/tbl1.txt')
_PRE_END

<p>Now some snippets from 2nd-order Markov chains.</p>

_PRE_BEGIN
m4_include(`blog/markov/tbl2.txt')
_PRE_END

<p>Now two words is a key in dictionary.
And we see here an answer for the question "how often each words appears after a sequence of two words?"</p>

<p>Now let's generate some rubbish:</p>

_PRE_BEGIN
m4_include(`blog/markov/diss.txt')
_PRE_END

<p>By first look, these pieces of text are visually OK, but it is senseless.
Some people (including me) find it funny.</p>

_HL2(`Autocomplete')

<p>It's surprising how easy this can be turned into something rather practically useful.</p>

_PRE_BEGIN
m4_include(`blog/markov/autocomplete.py')
_PRE_END

<p>First, let's also make 3rd-order Markov chains tables.
There are some snippets from it:</p>

_PRE_BEGIN
m4_include(`blog/markov/tbl3.txt')
_PRE_END

<p>You see, they looks as more precise, but tables are just smaller.
You can't use them to generate rubbish.
1st-order tables big, but "less precise".</p>

<p>And here I test some 3-words queries, like as if they inputted by user:</p>

_PRE_BEGIN
m4_include(`blog/markov/res.txt')
_PRE_END

<p>Perhaps, results from all 3 tables can be combined, with the data from 3rd order table used in highest priority (or weight).</p>

<p>And this is it - this can be shown to user.
Aside of Conan Doyle works, your software can collect user's input to adapt itself for user's lexicon, slang, memes, etc.
Of course, user's "tables" should be used with highest priority.</p>

<p>I have no idea, what Apple/Android devices using for hints generation, when user input text, but this is what I would use
as a first idea.</p>

<p>As a bonus, this can be used for language learners, to get the idea, how a word is used in a sentence.</p>

_HL2(`random.choices() in Python 3')

<p>... was used.
This is a very _HTML_LINK(`https://docs.python.org/3/library/random.html#random.choices',`useful function'): weights (or probabilities) can be added.</p>

<p>For example:</p>

_PRE_BEGIN
m4_include(`blog/markov/tst.py')
_PRE_END

<p>Let's generate 1000 random numbers in 1..3 range:</p>

_PRE_BEGIN
$ python3 tst.py | sort | uniq -c
    234 ['1']
    613 ['2']
    153 ['3']
_PRE_END

<p>"1" is generated in 25% of cases, "2" in 60% and "3" in 15%.
Well, almost.</p>

_HL2(`The files')

<p>... including Conan Doyle's stories (2.5M).
_HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/tree/master/blog/markov').
Surely, any other texts can be used, in any language...</p>

<p>Other related post is about typos:
_HTML_LINK_AS_IS(`https://yurichev.com/blog/fuzzy_string/').</p>

_BLOG_FOOTER()

