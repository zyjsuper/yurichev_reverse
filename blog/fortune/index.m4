m4_include(`commons.m4')

_HEADER(`25-Apr-2015: (Beginners level) reverse engineering of simple <i>fortune</i> program indexing file.')

_HL1(`25-Apr-2015: (Beginners level) reverse engineering of simple <i>fortune</i> program indexing file.')

<p><i>fortune</i> is <a href="http://en.wikipedia.org/wiki/Fortune_%28Unix%29">well-known UNIX program</a> which shows random phrase from a collection.
Some geeks are often set up their system in such way, so <i>fortune</i> can be called after logging on.
<i>fortune</i> takes phrases from the text files laying in <i>/usr/share/games</i> (as of Ubuntu Linux).
Here is example ('fortunes' text file):</p>

<pre>
A day for firm decisions!!!!!  Or is it?
%
A few hours grace before the madness begins again.
%
A gift of a flower will soon be made to you.
%
A long-forgotten loved one will appear soon.

Buy the negatives at any price.
%
A tall, dark stranger will have more fun than you.
%
...
</pre>

<p>So it is just phrases, sometimes multiline ones, divided by percent sign.
The task of <i>fortune</i> program is to find random phrase and to print it.
In order to achieve this, it should scan the whole text file, count phrases, choose random and print it.
But the text file can get bigger, and even on modern computers, this naive algorithm is a bit uneconomical to computer resources.
The straightforward way is to keep binary index file containing offset of each phrase in text file.
With index file, <i>fortune</i> program can work much faster: just to choose random index element, take offset from there, set offset in text file and read phrase from it.
This is actually done in <i>fortune</i> file.
Let's inspect what is in its index file inside (these are .dat files in the same directory) in hexdecimal editor.
This program is open-source of course, but intentionally, I will not peek into its source code.</p>

<pre>
$ od -t x1 --address-radix=x fortunes.dat
000000 00 00 00 02 00 00 01 af 00 00 00 bb 00 00 00 0f
000010 00 00 00 00 25 00 00 00 00 00 00 00 00 00 00 2b
000020 00 00 00 60 00 00 00 8f 00 00 00 df 00 00 01 14
000030 00 00 01 48 00 00 01 7c 00 00 01 ab 00 00 01 e6
000040 00 00 02 20 00 00 02 3b 00 00 02 7a 00 00 02 c5
000050 00 00 03 04 00 00 03 3d 00 00 03 68 00 00 03 a7
000060 00 00 03 e1 00 00 04 19 00 00 04 2d 00 00 04 7f
000070 00 00 04 ad 00 00 04 d5 00 00 05 05 00 00 05 3b
000080 00 00 05 64 00 00 05 82 00 00 05 ad 00 00 05 ce
000090 00 00 05 f7 00 00 06 1c 00 00 06 61 00 00 06 7a
0000a0 00 00 06 d1 00 00 07 0a 00 00 07 53 00 00 07 9a
0000b0 00 00 07 f8 00 00 08 27 00 00 08 59 00 00 08 8b
0000c0 00 00 08 a0 00 00 08 c4 00 00 08 e1 00 00 08 f9
0000d0 00 00 09 27 00 00 09 43 00 00 09 79 00 00 09 a3
0000e0 00 00 09 e3 00 00 0a 15 00 00 0a 4d 00 00 0a 5e
0000f0 00 00 0a 8a 00 00 0a a6 00 00 0a bf 00 00 0a ef
000100 00 00 0b 18 00 00 0b 43 00 00 0b 61 00 00 0b 8e
000110 00 00 0b cf 00 00 0b fa 00 00 0c 3b 00 00 0c 66
000120 00 00 0c 85 00 00 0c b9 00 00 0c d2 00 00 0d 02
000130 00 00 0d 3b 00 00 0d 67 00 00 0d ac 00 00 0d e0
000140 00 00 0e 1e 00 00 0e 67 00 00 0e a5 00 00 0e da
000150 00 00 0e ff 00 00 0f 43 00 00 0f 8a 00 00 0f bc
000160 00 00 0f e5 00 00 10 1e 00 00 10 63 00 00 10 9d
000170 00 00 10 e3 00 00 11 10 00 00 11 46 00 00 11 6c
000180 00 00 11 99 00 00 11 cb 00 00 11 f5 00 00 12 32
000190 00 00 12 61 00 00 12 8c 00 00 12 ca 00 00 13 87
0001a0 00 00 13 c4 00 00 13 fc 00 00 14 1a 00 00 14 6f
0001b0 00 00 14 ae 00 00 14 de 00 00 15 1b 00 00 15 55
0001c0 00 00 15 a6 00 00 15 d8 00 00 16 0f 00 00 16 4e
...
</pre>

<p>Without any special aid we could see that there are four 4-byte elements on each 16-byte line.
It's probably our index array.
I'm trying to load the whole file in Wolfram Mathematica as 32-bit integer array:</p>

<pre>
In[]:= BinaryReadList["c:/tmp1/fortunes.dat", "UnsignedInteger32"]

Out[]= {33554432, 2936078336, 3137339392, 251658240, 0, 37, 0, \
721420288, 1610612736, 2399141888, 3741319168, 335609856, 1208025088, \
2080440320, 2868969472, 3858825216, 537001984, 989986816, 2046951424, \
3305242624, 67305472, 1023606784, 1745027072, 2801991680, 3775070208, \
419692544, 755236864, 2130968576, 2902720512, 3573809152, 84213760, \
990183424, 1678049280, 2181365760, 2902786048, 3456434176, \
4144300032, 470155264, 1627783168, 2047213568, 3506831360, 168230912, \
1392967680, 2584150016, 4161208320, 654835712, 1493696512, \
2332557312, 2684878848, 3288858624, 3775397888, 4178051072, \
...
</pre>

<p>Nope, something wrong. Numbers are suspiciously big.
But let's back to <i>od</i> output: each common 4-byte element has two zero bytes and two non-zero bytes, so the offsets (at least at the beginning of the file) are 16-bit at maximum.
Probably different endiannes is used in file?
Default endiannes in Mathematica is little-endian, as used in Intel CPUs.
Now I'm changing it to big-endian:</p>

<pre>
In[]:= BinaryReadList["c:/tmp1/fortunes.dat", "UnsignedInteger32", 
 ByteOrdering -> 1]

Out[]= {2, 431, 187, 15, 0, 620756992, 0, 43, 96, 143, 223, 276, \
328, 380, 427, 486, 544, 571, 634, 709, 772, 829, 872, 935, 993, \
1049, 1069, 1151, 1197, 1237, 1285, 1339, 1380, 1410, 1453, 1486, \
1527, 1564, 1633, 1658, 1745, 1802, 1875, 1946, 2040, 2087, 2137, \
2187, 2208, 2244, 2273, 2297, 2343, 2371, 2425, 2467, 2531, 2581, \
2637, 2654, 2698, 2726, 2751, 2799, 2840, 2883, 2913, 2958, 3023, \
3066, 3131, 3174, 3205, 3257, 3282, 3330, 3387, 3431, 3500, 3552, \
...
</pre>

<p>Yes, this is something readable.
I choose random element (3066) which is 0xBFA in hexadecimal form.
I'm opening 'fortunes' text file in hex editor, I'm setting 0xBFA as offset and I see this phrase:</p>

<pre>
$ od -t x1 -c --skip-bytes=0xbfa --address-radix=x fortunes
000bfa  44  6f  20  77  68  61  74  20  63  6f  6d  65  73  20  6e  61
         D   o       w   h   a   t       c   o   m   e   s       n   a
000c0a  74  75  72  61  6c  6c  79  2e  20  20  53  65  65  74  68  65
         t   u   r   a   l   l   y   .           S   e   e   t   h   e
000c1a  20  61  6e  64  20  66  75  6d  65  20  61  6e  64  20  74  68
             a   n   d       f   u   m   e       a   n   d       t   h
....
</pre>

Or:

<pre>
Do what comes naturally.  Seethe and fume and throw a tantrum.
%
</pre>

<p>Other offset are also can be checked, yes, they are valid offsets.</p>

<p>I can also check in Mathematica that each subsequent element is bigger than previous.
I.e., the array is ascending.
In mathematics lingo, this is called <i>strictly increasing monotonic function</i>.</p>

<pre>
In[]:= Differences[input]

Out[]= {429, -244, -172, -15, 620756992, -620756992, 43, 53, 47, \
80, 53, 52, 52, 47, 59, 58, 27, 63, 75, 63, 57, 43, 63, 58, 56, 20, \
82, 46, 40, 48, 54, 41, 30, 43, 33, 41, 37, 69, 25, 87, 57, 73, 71, \
94, 47, 50, 50, 21, 36, 29, 24, 46, 28, 54, 42, 64, 50, 56, 17, 44, \
28, 25, 48, 41, 43, 30, 45, 65, 43, 65, 43, 31, 52, 25, 48, 57, 44, \
69, 52, 62, 73, 62, 53, 37, 68, 71, 50, 41, 57, 69, 58, 70, 45, 54, \
38, 45, 50, 42, 61, 47, 43, 62, 189, 61, 56, 30, 85, 63, 48, 61, 58, \
81, 50, 55, 63, 83, 80, 49, 42, 94, 54, 67, 81, 52, 57, 68, 43, 28, \
120, 64, 53, 81, 33, 82, 88, 29, 61, 32, 75, 63, 70, 47, 101, 60, 79, \
33, 48, 65, 35, 59, 47, 55, 22, 43, 35, 102, 53, 80, 65, 45, 31, 29, \
69, 32, 25, 38, 34, 35, 49, 59, 39, 41, 18, 43, 41, 83, 37, 31, 34, \
59, 72, 72, 81, 77, 53, 53, 50, 51, 45, 53, 39, 70, 54, 103, 33, 70, \
51, 95, 67, 54, 55, 65, 61, 54, 54, 53, 45, 100, 63, 48, 65, 71, 23, \
28, 43, 51, 61, 101, 65, 39, 78, 66, 43, 36, 56, 40, 67, 92, 65, 61, \
31, 45, 52, 94, 82, 82, 91, 46, 76, 55, 19, 58, 68, 41, 75, 30, 67, \
92, 54, 52, 108, 60, 56, 76, 41, 79, 54, 65, 74, 112, 76, 47, 53, 61, \
66, 53, 28, 41, 81, 75, 69, 89, 63, 60, 18, 18, 50, 79, 92, 37, 63, \
88, 52, 81, 60, 80, 26, 46, 80, 64, 78, 70, 75, 46, 91, 22, 63, 46, \
34, 81, 75, 59, 62, 66, 74, 76, 111, 55, 73, 40, 61, 55, 38, 56, 47, \
78, 81, 62, 37, 41, 60, 68, 40, 33, 54, 34, 41, 36, 49, 44, 68, 51, \
50, 52, 36, 53, 66, 46, 41, 45, 51, 44, 44, 33, 72, 40, 71, 57, 55, \
39, 66, 40, 56, 68, 43, 88, 78, 30, 54, 64, 36, 55, 35, 88, 45, 56, \
76, 61, 66, 29, 76, 53, 96, 36, 46, 54, 28, 51, 82, 53, 60, 77, 21, \
84, 53, 43, 104, 85, 50, 47, 39, 66, 78, 81, 94, 70, 49, 67, 61, 37, \
51, 91, 99, 58, 51, 49, 46, 68, 72, 40, 56, 63, 65, 41, 62, 47, 41, \
43, 30, 43, 67, 78, 80, 101, 61, 73, 70, 41, 82, 69, 45, 65, 38, 41, \
57, 82, 66}
</pre>

<p>As we can see, except of the very first 6 values (which is probably belongs to index file header), all numbers are in fact length of all text phrases (offset of the next phrase minus offset of the current phrase is in fact length of the current phrase).</p>

<p>It's very important to keep in mind that bit-endiannes can be confused with incorrect array start.
Indeed, from <i>od</i> output we see that each element started with two zeroes.
But when shifted by two bytes in either side, we can interpret this array as little-endian:</p>

<pre>
$ od -t x1 --address-radix=x --skip-bytes=0x32 fortunes.dat
000032 01 48 00 00 01 7c 00 00 01 ab 00 00 01 e6 00 00
000042 02 20 00 00 02 3b 00 00 02 7a 00 00 02 c5 00 00
000052 03 04 00 00 03 3d 00 00 03 68 00 00 03 a7 00 00
000062 03 e1 00 00 04 19 00 00 04 2d 00 00 04 7f 00 00
000072 04 ad 00 00 04 d5 00 00 05 05 00 00 05 3b 00 00
000082 05 64 00 00 05 82 00 00 05 ad 00 00 05 ce 00 00
000092 05 f7 00 00 06 1c 00 00 06 61 00 00 06 7a 00 00
0000a2 06 d1 00 00 07 0a 00 00 07 53 00 00 07 9a 00 00
0000b2 07 f8 00 00 08 27 00 00 08 59 00 00 08 8b 00 00
0000c2 08 a0 00 00 08 c4 00 00 08 e1 00 00 08 f9 00 00
0000d2 09 27 00 00 09 43 00 00 09 79 00 00 09 a3 00 00
0000e2 09 e3 00 00 0a 15 00 00 0a 4d 00 00 0a 5e 00 00
...
</pre>

<p>If we would interpret this array as little-endian, the first element is 0x4801, second is 0x7C01, etc.
High 8-bit part of each of these 16-bit values are seems random to us, and the lowest 8-bit part is seems ascending.</p>

<p>But I'm sure that this is big-endian array, because the very last 32-bit element of the file is big-endian 
(00 00 5f c4 here):</p>

<pre>
$ od -t x1 --address-radix=x fortunes.dat
...
000660 00 00 59 0d 00 00 59 55 00 00 59 7d 00 00 59 b5
000670 00 00 59 f4 00 00 5a 35 00 00 5a 5e 00 00 5a 9c
000680 00 00 5a cb 00 00 5a f4 00 00 5b 1f 00 00 5b 3d
000690 00 00 5b 68 00 00 5b ab 00 00 5b f9 00 00 5c 49
0006a0 00 00 5c ae 00 00 5c eb 00 00 5d 34 00 00 5d 7a
0006b0 00 00 5d a3 00 00 5d f5 00 00 5e 3a 00 00 5e 67
0006c0 00 00 5e a8 00 00 5e ce 00 00 5e f7 00 00 5f 30
0006d0 00 00 5f 82 00 00 5f c4
0006d8
</pre>

<p>Perhaps, <i>fortune</i> program developer had big-endian computer or maybe it was ported from something like it.</p>

<p>OK, so the array is big-endian, and, judging by common sense, the very first phrase in the text file should be started at zeroth offset. So zero value should be present in the array somewhere at the very beginning.
We've got couple of zero elements at the beginning. But the second is most appealing: 43 is going right after it and 43 is valid offset to valid English phrase in the text file.</p>

<p>The last array element is 0x5FC4, and there are no such byte at this offset in the text file.
So the last array element is pointing behind the end of file.
It's probably done because phrase length is calculated as difference between offset to the current phrase
and offset to the next phrase. 
This can be faster than traversing phrase string for percent character.
But this wouldn't work for the last element.
So the <i>dummy</i> element is also added at the end of array.</p>

<p>So the first 6 32-bit integer values are probably some kind of header.</p>

<p>Oh, I forgot to count phrases in text file:</p>

<pre>
$ cat fortunes | grep % | wc -l
432
</pre>

<p>The number of phrases can be present in index, but may be not.
In case of very simple index files, number of elements can be easily deduced from index file size.
Anyway, there are 432 phrases in the text file.
And we see something very familiar at the second element (value 431).
I've checked other files (literature.dat and riddles.dat in Ubuntu Linux) and yes, the second 32-bit element is indeed number of phrases minus 1.
Why <i>minus 1</i>? Probably, this is not number of phrases, but rather index of the last phrase (starting at zero)?</p>

<p>And there are some other elements in the header.
In Mathematica, I'm loading each of three available files and I'm taking a look on the header:</p>

<center><img src="mathematica.png"></center>

<p>I have no idea what other values mean, except the size of index file.
Some fields are the same for all files, some are not.
From my own experience, there could be:</p>

<ul>
<li> file version;
<li> some other flags;
<li> maybe even text language identifier;
<li> text file timestamp, so <i>fortune</i> program will regenerate index file if user added some new phrase(s) to it.
</ul>

<p>For example, Oracle .SYM files which contain symbols table for DLL files, also contain timestamp of corresponding DLL file, so to be sure it is still valid.
But there are still possibility that the index file is regenerated if modification time of index file is older than text file.
On the other hand, text file and index file timestamps can gone out of sync after archiving/unarchiving/installing/deploying/etc.</p>

<p>But there are no timestamp, in my opinion. The most compact way of representing date and time is UNIX time value, which is big 32-bit number. We don't see any of such here. Other ways are even less compact.</p>

<p>For the sake of demonstration, I still didn't take a look in <i>fortune</i> source code.
If you want to try to understand meaning of other values in index file header, you may try to achieve it without looking into source code as well.
Files I took from Ubuntu Linux 14.04 are here:
<a href="http://beginners.re/examples/fortune/">http://beginners.re/examples/fortune/</a></p>

<p>Oh, and I took the files from x64 version of Ubuntu, but array elements are still has size of 32 bit.
It is because <i>fortune</i> text files are probably never exceeds 4GB size.
But if it will, all elements must have size of 64 bit so to be able to store offset to the text file larger than 4GB.</p>

_BLOG_FOOTER()
