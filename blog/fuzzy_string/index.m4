m4_include(`commons.m4')

_HEADER_HL1(`23-Jul-2015: Fuzzy string matching + simplest possible spellchecking + hunting for typos and misspellings in Wikipedia.')

<p>Almost all Internet users sometimes typing so fast and see something like this:</p>

<center><img src="//yurichev.com/blog/fuzzy_string/google_typo.png" class="ImageBorder"></center>

<p>Google (and any other search engine) detect typos and misspellings with the help of information that input word ("infr<b>u</b>structure") is really rare
(according to their database) and it can be transformed to a very popular word ("infr<b>a</b>structure", again, in their database) using just single editing operation.</p>

<p>This is called <i>fuzzy string matching</i> or <i>approximate string matching</i>.</p>

_HL2(`Levenshtein distance')

<p>One of the simplest and popular fuzzy string matching metrics is Levenshtein distance, it is just a number of editing operations (inserting, deleting, replacing) 
required to transform one string to another.</p>

<p>Let's test it in Wolfram Mathematica:</p>

_PRE_BEGIN
In[]:= DamerauLevenshteinDistance["wombat", "combat"]
Out[]= 1
_PRE_END

<p>So it requires one editing operation to transform "wombat" into "combat" or back. Indeed, these words are different only in one (first) character.</p>

<p>Another example:</p>

_PRE_BEGIN
In[]:= DamerauLevenshteinDistance["man", "woman"]
Out[]= 2
_PRE_END

<p>So it takes two editing operations to transform "man" to "woman" (two insertions).
Or two deletions to transform "woman" to "man".</p>

<p>These words has only one character in common:</p>

_PRE_BEGIN
In[]:= DamerauLevenshteinDistance["water", "wine"]
Out[]= 3
_PRE_END

<p>No wonder it requires 3 operations to transform one to another.</p>

<p>And now completely different words:</p>

_PRE_BEGIN
In[]:= DamerauLevenshteinDistance["beer", "wine"]
Out[]= 4
_PRE_END

<p>4 editing operations for 4-character words meaning that each character in word must be replaced in order to transform.</p>

_HL2(`Approximate grep utility')

<p>There is a variant of grep which works <i>approximately</i>: agrep 
(_HTML_LINK(`https://en.wikipedia.org/wiki/Agrep',`wikipedia article'), 
_HTML_LINK(`https://github.com/Wikinaut/agrep',`source code'), 
_HTML_LINK(`http://www.tgries.de/agrep/',`more information')).
It is a standard package at least in Ubuntu Linux.</p>

<p>Let's pretend, I forgot how to spell name of Sherlock Holmes correctly.
I've downloaded "The Adventures of Sherlock Holmes", by Arthur Conan Doyle from the Gutenberg library 
_HTML_LINK(`http://www.gutenberg.org/cache/epub/1661/pg1661.txt',`here').</p>

<p>Let's try agrep:</p>

_PRE_BEGIN
$ agrep -1 "Holms" pg1661.txt

...
To Sherlock Holmes she is always THE woman. I have seldom heard
...
I had seen little of Holmes lately. My marriage had drifted us
...
_PRE_END

<p><i>-1</i> mean that agrep would match words with Levenshtein distance of 1 editing operation.
Indeed, "Holms" word is almost equal to "Holmes" with one character deleted.</p>

<p>The following command will not find any Holmes word ("Homs" is different from "Holmes" by 2 characters):</p>

_PRE_BEGIN
agrep -1 "Homs" pg1661.txt
_PRE_END

<p>But this will do:</p>

_PRE_BEGIN
agrep -2 "Homs" pg1661.txt
_PRE_END

_HL2(`Simplest possible spellchecking: typos and  misspellings correction in Wikipedia')

<p>Fuzzy string matching algorithms are very popular nowadays at a websites, because it's almost impossible to demand correct spelling from its users.</p>

<p>Let's try to find typos in Wikipedia.
It's size is tremendous, so I'll take only one part of june 2015 dump: 
_HTML_LINK(`http://dumps.wikimedia.org/enwiki/20150602/enwiki-20150602-pages-meta-current9.xml-p000665001p000925001.bz2',`enwiki-20150602-pages-meta-current9.xml-p000665001p000925001.bz2').</p>

<p>And _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/fuzzy_string/files/get_typos.py',`here is my Python script').
I use opensource Levenshtein distance Python module, which can be found _HTML_LINK(`https://pypi.python.org/pypi/python-Levenshtein/0.12.0',`here').
It has very simple function named <i>distance</i>, which just takes two strings on input and returns Levenshtein distance.</p>

<p>What my script just takes all words from Wikipedia dump and build a dictionary, somewhat resembling to search index, but my dictionary reflects number of occurrences
within Wikipedia dump (i.e., word popularity).
Words in dictionary are limited by 6 characters, all shorter words are ignored.
Then the script divides the whole dictionary by two parts. The first part is called "probably correct words" and contains words which are very popular, i.e.,
occurred most frequently (more than 200-300 times in the whole Wikipedia dump).
The second part is called "words to check" and contain rare words, which occurred less than 10 times in the dump.</p>

<p>Then the script takes each "word to check" and calculates distance between it and an each word in the "probably correct words" dictionary.
If the resulting distance is 1 or 2, it may be a typo and it's reported.</p>

<p>Here is example report (number in parenthesis is a number of occurrences of the "rare" word in the whole dump):</p>

_PRE_BEGIN
typo? motori (7) suggestions= [u'motors']
typo? critera (7) suggestions= [u'criteria']
typo? constitucional (7) suggestions= [u'constitutional']
typo? themselve (7) suggestions= [u'themselves']
typo? germano (7) suggestions= [u'german', u'germany', u'germans']
typo? synonim (7) suggestions= [u'synonym']
typo? choise (7) suggestions= [u'choose', u'choice']
_PRE_END

<p>These are clearly typos/misspellings.
It seems, "choise" is a very popular typo: _HTML_LINK_AS_IS(`https://archive.is/CaMTD').
(I made snapshot of Wikipedia search page because someone may correct these typos very soon).</p>

<p>Some reported words are not typos, for example:</p>

_PRE_BEGIN
typo? streel (2) suggestions= [u'street']
typo? arbour (2) suggestions= [u'harbour']
_PRE_END

<p>These are just rare words, and my script didn't collected big enough dictionary with these.
Keep in mind, my script doesn't have its own English dictionary, its dictionary is built using Wikipedia itself.</p>

<p>The full list of typos my script found is: 
_HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/fuzzy_string/files/enwiki2015-current9-dist1.txt',`enwiki2015-current9-dist1.txt').
Keep in mind, it's not whole Wikipedia, only it's part (since I do not own powerful computers and my script is very far from optimized).</p>

<p>Update: I added the list of all suspicious typos and misspellings for the whole Wikipedia:
_HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/fuzzy_string/files/enwiki2015.typos.txt',`enwiki2015.typos.txt').</p>

<hr>

<p>When the script reports words which matching words in dictionary by distance of 2, the report will be bigger.</p>

<p>For example:</p>

_PRE_BEGIN
typo? heigth (1) suggestions= [u'eighth', u'heights', u'health', u'height', u'length']
typo? contributuons (1) suggestions= [u'contribution', u'contributions', u'contributors']
typo? stapel (1) suggestions= [u'stayed', u'shaped', u'chapel', u'stated', u'states', u'staged', u'stages']
typo? seling (1) suggestions= [u'belong', u'spelling', u'sailing', u'feeling', u'setting', u'seeking', u'sending', u'spring', u'helping', u'serving', u'seeing', u'saying', u'telling', u'dealing', u'saving', u'string', u'selling', u'ruling']
typo? beading (1) suggestions= [u'meaning', u'bearing', u'heading', u'breeding', u'beating', u'hearing', u'wedding', u'beijing', u'sending', u'binding', u'needing', u'breaking', u'eating', u'pending', u'dealing', u'reading', u'wearing', u'trading', u'leading', u'leaving', u'ending', u'boarding', u'feeding']
typo? scying (1) suggestions= [u'acting', u'flying', u'buying', u'scoring', u'spring', u'seeing', u'saying', u'paying', u'saving', u'string', u'trying']
_PRE_END

<p>The full list is here:
_HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/fuzzy_string/files/enwiki2015-current9-dist2.txt',`enwiki2015-current9-dist2.txt').</p>

<hr>

<p>In this example, I use English language Wikipedia, byt my script can be easily extended to any other language.
Just write your own _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/fuzzy_string/files/get_typos.py#L70',`str_is_latin() function').</p>

_HL2(`Other applications')

<p>Another extremely important application of fuzzy string matching is data entry applications where it's very easy to make mistakes in spelling of someone's names
and surnames.</p>

<p>There is also application is spam filtering, because spammers try to write some well-known word(s) in many different ways to circumvent spam filters.</p>

_HL2(`Further reading')

<p>Peter Norvig explains how to write spelling corrector as the one used by Google: _HTML_LINK_AS_IS(`http://norvig.com/spell-correct.html').</p>

_BLOG_FOOTER()

