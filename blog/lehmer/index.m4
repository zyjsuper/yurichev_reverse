m4_include(`commons.m4')

_HEADER_HL1(`Executable file watermarking/steganography using Lehmer code and factorial number system')

<p>TL;DR: how to hide information not in objects, but in *order* of objects.</p>

<p>Almost any binary executable file has text strings like (these are from CRT):</p>

_PRE_BEGIN
.rdata:0040D398 aR6002FloatingP:
.rdata:0040D398                 text "UTF-16LE", 'R6002',0Dh,0Ah
.rdata:0040D398                 text "UTF-16LE", '- floating point support not loaded',0Dh,0Ah,0
.rdata:0040D3F2                 align 8
.rdata:0040D3F8 aR6008NotEnough:
.rdata:0040D3F8                 text "UTF-16LE", 'R6008',0Dh,0Ah
.rdata:0040D3F8                 text "UTF-16LE", '- not enough space for arguments',0Dh,0Ah,0
.rdata:0040D44C                 align 10h
.rdata:0040D450 aR6009NotEnough:
.rdata:0040D450                 text "UTF-16LE", 'R6009',0Dh,0Ah
.rdata:0040D450                 text "UTF-16LE", '- not enough space for environment',0Dh,0Ah,0
.rdata:0040D4A8 aR6010AbortHasB:
.rdata:0040D4A8                 text "UTF-16LE", 'R6010',0Dh,0Ah
.rdata:0040D4A8                 text "UTF-16LE", '- abort() has been called',0Dh,0Ah,0
.rdata:0040D4EE                 align 10h
.rdata:0040D4F0 aR6016NotEnough:
.rdata:0040D4F0                 text "UTF-16LE", 'R6016',0Dh,0Ah
.rdata:0040D4F0                 text "UTF-16LE", '- not enough space for thread data',0Dh,0Ah,0
.rdata:0040D548 aR6017Unexpecte:
.rdata:0040D548                 text "UTF-16LE", 'R6017',0Dh,0Ah
.rdata:0040D548                 text "UTF-16LE", '- unexpected multithread lock error',0Dh,0Ah,0
.rdata:0040D5A2                 align 8
.rdata:0040D5A8 aR6018Unexpecte:
.rdata:0040D5A8                 text "UTF-16LE", 'R6018',0Dh,0Ah
.rdata:0040D5A8                 text "UTF-16LE", '- unexpected heap error',0Dh,0Ah,0
.rdata:0040D5EA                 align 10h
_PRE_END

<p>Can we hide some information there?
Not in string themselves, but in *order* of strings?
Given the fact, that compiler doesn't guarantee at all,
in which order the strings will be stored in object/executable file.</p>

<p>Let's say, we've got 26 text strings, and we can swap them how we want, because their order isn't important at all.
All possible _HTML_LINK(`https://en.wikipedia.org/wiki/Permutation',`permutations') of 26 objects is 
26! = 403291461126605635584000000</p>

<p>How much information can be stored here?
log2(26!)=~88, i.e., 88 bits or 11 bytes!</p>

<p>11 bytes of your data can be converted to a (big) number and back, OK.</p>

<p>What is next?
Naive way is: enumerate all permutations of 26 objects, number each, find permutation of the number we've got and
permute 26 text strings, store to file and that's it.
But we can't iterate over 403291461126605635584000000 permutations.</p>

<p>This is where _HTML_LINK(`https://en.wikipedia.org/wiki/Factorial_number_system',`factorial number system') and 
_HTML_LINK(`https://en.wikipedia.org/wiki/Lehmer_code',`Lehmer code') can be used.
In short, for all my non-mathematically inclined readers, this is a way to find a permutation of specific number
without use of any significant resources.
And back: gived specific permutation, we can find its number.</p>

<p>This piece of code I've copypasted from _HTML_LINK_AS_IS(`https://gist.github.com/lukmdo/7049748') and reworked slightly:</p>

_PRE_BEGIN
m4_include(`blog/lehmer/lehmer.py')
_PRE_END

<p>I'm encoding a "HelloWorld" binary string (in fact, any 11 bytes can be used) into a number.
Number is then converted into Lehmer code.
Then the perm_from_code() function permute initial *order* according to the input Lehmer code:</p>

_PRE_BEGIN
s= HelloWorld
num= 341881320659934023674980
Lehmer code= [14, 16, 7, 16, 7, 11, 17, 7, 1, 4, 10, 7, 9, 11, 6, 2, 6, 1, 2, 4, 0, 0, 0, 0, 0, 0]
swapping 0, 14
swapping 1, 17
swapping 2, 9
swapping 3, 19
swapping 4, 11
swapping 5, 16
swapping 6, 23
swapping 7, 14
swapping 8, 9
swapping 9, 13
swapping 10, 20
swapping 11, 18
swapping 12, 21
swapping 13, 24
swapping 14, 20
swapping 15, 17
swapping 16, 22
swapping 17, 18
swapping 18, 20
swapping 19, 23
permutation/order= [14, 17, 9, 19, 11, 16, 23, 0, 2, 13, 20, 18, 21, 24, 10, 1, 22, 4, 7, 6, 15, 12, 5, 3, 8, 25]
_PRE_END

<p>This is it: [14, 17, 9, 19, 11, 16, 23, 0, 2, 13, 20, 18, 21, 24, 10, 1, 22, 4, 7, 6, 15, 12, 5, 3, 8, 25].
First put 14th string, then 17s string, then 9th one, etc.</p>

<p>Now you've got a binary file from someone and want to read watermark from it.
Get an order of strings from it and convert it back to binary string:</p>

_PRE_BEGIN
recovered num= 341881320659934023674980
recovered s= HelloWorld
_PRE_END

<p>If you have more text strings (not unusual for most executable files), you can encode more.</p>

<p>100 strings: log2(100!) = ~524 bits = ~65 bytes.</p>

<p>1000 strings: log2(1000!) = ~8529 bits = ~1066 bytes! You can store some text here!</p>

<p>How would you force a C/C++ compiler to make specific order of text strings?
This is crude, but workable:</p>

_PRE_BEGIN
char blob[]="hello1\0hello2\0";
char *msg1=blob;
char *msg2=blob+8;

printf ("%s\n", msg1);
printf ("%s\n", msg2);
_PRE_END

<p>They can be even aligned on 16-byte border.</p>

<p>... or they can be placed into .s/.asm assembly file and compiled into .o/.obj and then linked to your program.</p>

<p>... or you can swap text strings in already compiled executable and correct their addresses in corresponding instructions.
If an executable file is not packed/obfuscated, this is possible.</p>

<p>Aside of order of text strings, you can try to hack a linker and reorder object files in the final executable.
Of course, no one cares about its order.
And go figure out, what is hidden there.</p>

<p>Surely, hidden data can be encrypted, checksum or MAC can be added, etc.</p>

<p>Other ideas to consider: reorder functions and fix all addresses,
reorder basic blocks within a function, register allocator hacking, etc.</p>

<p>Links I find helpful in understanding factorial number system and Lehmer code, aside of Wikipedia:</p>

<ul>
<li> _HTML_LINK_AS_IS(`https://gist.github.com/lukmdo/7049748')
<li> _HTML_LINK_AS_IS(`https://github.com/scmorse/permutils/blob/master/src/permutils.js')
<li> _HTML_LINK_AS_IS(`http://2ality.com/2013/03/permutations.html')
<li> _HTML_LINK_AS_IS(`http://www.keithschwarz.com/interesting/code/factoradic-permutation/FactoradicPermutation')
</ul>

_BLOG_FOOTER()

