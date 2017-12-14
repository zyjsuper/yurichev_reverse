m4_include(`commons.m4')

_HEADER_HL1(`Crossword generator based on Z3')

<p>We assign an integer to each character in crossword, it reflects ASCII code of it.</p>

<p>Then we enumerate all possible horizontal/vertical "sticks" longer than 1 and assign words to them.</p>

<p>For example, there is a horizontal stick of length 3.
And we have such 3-letter words in our dictionary: "the", "she", "xor".</p>

<p>We add the following constraint:</p>

_PRE_BEGIN
Or(
	And(chars[X][Y]=='t', chars[X][Y+1]=='h', chars[X][Y+2]=='e'),
	And(chars[X][Y]=='s', chars[X][Y+1]=='h', chars[X][Y+2]=='e'),
	And(chars[X][Y]=='x', chars[X][Y+1]=='o', chars[X][Y+2]=='r'))
_PRE_END

<p>One of these words would be choosen automatically.</p>

<p>Index of each word is also considered, because duplicates are not allowed.</p>

<p>Sample pattern:</p>

_PRE_BEGIN
**** **********
 * * *  * * * *
***************
 * * *  * * * *
********* *****
 * * * * * *  *
****** ********
   * * * * *   
******** ******
*  * * * * * * 
***** *********
* * * *  * * * 
***************
* * * *  * * * 
********** ****
_PRE_END

<p>Sample result:</p>

_PRE_BEGIN
spur stimulated
 r e c  i a h e
congratulations
 m u t  a i s c
violation niece
 s a e p e n  n
rector penitent
   i i o c e
accounts herald
s  n g e a r o
press edinburgh
e x e n  t p i
characteristics
t c l r  n e a
satisfying dull

horizontal:
((0, 0), (0, 3)) spur
((0, 5), (0, 14)) stimulated
((2, 0), (2, 14)) congratulations
((4, 0), (4, 8)) violation
((4, 10), (4, 14)) niece
((6, 0), (6, 5)) rector
((6, 7), (6, 14)) penitent
((8, 0), (8, 7)) accounts
((8, 9), (8, 14)) herald
((10, 0), (10, 4)) press
((10, 6), (10, 14)) edinburgh
((12, 0), (12, 14)) characteristics
((14, 0), (14, 9)) satisfying
((14, 11), (14, 14)) dull
vertical:
((8, 0), (14, 0)) aspects
((0, 1), (6, 1)) promise
((10, 2), (14, 2)) exact
((0, 3), (10, 3)) regulations
((10, 4), (14, 4)) seals
((0, 5), (9, 5)) scattering
((10, 6), (14, 6)) entry
((4, 7), (10, 7)) opposed
((0, 8), (4, 8)) milan
((5, 9), (14, 9)) enchanting
((0, 10), (4, 10)) latin
((4, 11), (14, 11)) interrupted
((0, 12), (4, 12)) those
((8, 13), (14, 13)) logical
((0, 14), (6, 14)) descent
_PRE_END

<p>Unsat is possible if the dictionary is too small or have no words of length present in pattern.</p>

<p>The source code:</p>

_PRE_BEGIN
m4_include(`blog/crossword_Z3/cross_Z3.py')
_PRE_END

<p>The files, including my dictionary: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/tree/master/blog/crossword_Z3').</p>

_BLOG_FOOTER()

