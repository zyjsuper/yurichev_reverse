m4_include(`commons.m4')

_HEADER_HL1(`3-May-2016: Simple encryption using XOR mask, part II')

<p>I've got another encrypted file, which is clearly encrypted by something simple, like XOR-ing:</p>

<center><img src="//yurichev.com/blog/XOR_mask_2/files/cipher.png"></center>

<p>The encrypted file can be downloaded _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/XOR_mask_2/files/cipher.txt',`here').</p>

<p>ent Linux utility reports about ~7.5 bits per byte, and this is high level of _HTML_LINK(`//yurichev.com/blog/entropy/',`entropy'),
close to compressed or properly encrypted file.
But still, we clearly see some pattern, there are some blocks with size of 17 bytes, hence, you see some kind of ladder, shifting by 1 byte at each 16-byte line.</p>

<p>It's also known that the plain text is just English language text.</p>

<p>Now let's assume that this piece of text is encrypted by simple XOR-ing with 17-byte key.</p>

<p>I tried to find some repeating 17-byte blocks in Mathematica, like I did before in _HTML_LINK(`//yurichev.com/blog/XOR_mask_1/',`my previous example'):</p>

_PRE_BEGIN
In[]:=input = BinaryReadList["/home/dennis/tmp/cipher.txt"];

In[]:=blocks = Partition[input, 17];

In[]:=Sort[Tally[blocks], #1[[2]] > #2[[2]] &]

Out[]:={{{248,128,88,63,58,175,159,154,232,226,161,50,97,127,3,217,80},1},
{{226,207,67,60,42,226,219,150,246,163,166,56,97,101,18,144,82},1},
{{228,128,79,49,59,250,137,154,165,236,169,118,53,122,31,217,65},1},
{{252,217,1,39,39,238,143,223,241,235,170,91,75,119,2,152,82},1},
{{244,204,88,112,59,234,151,147,165,238,170,118,49,126,27,144,95},1},
{{241,196,78,112,54,224,142,223,242,236,186,58,37,50,17,144,95},1},
{{176,201,71,112,56,230,143,151,234,246,187,118,44,125,8,156,17},1},
...
{{255,206,82,112,56,231,158,145,165,235,170,118,54,115,9,217,68},1},
{{249,206,71,34,42,254,142,154,235,247,239,57,34,113,27,138,88},1},
{{157,170,84,32,32,225,219,139,237,236,188,51,97,124,21,141,17},1},
{{248,197,1,61,32,253,149,150,235,228,188,122,97,97,27,143,84},1},
{{252,217,1,38,42,253,130,223,233,226,187,51,97,123,20,217,69},1},
{{245,211,13,112,56,231,148,223,242,226,188,118,52,97,15,152,93},1},
{{221,210,15,112,28,231,158,141,233,236,172,61,97,90,21,149,92},1}}
_PRE_END

<p>No luck, each 17-byte block is unique withing the file and occurred only once.
Perhaps, there are no 17-byte zero (or space) lacunas.
It is possible indeed: such long space indentation and padding may be absent in tightly typesetted text.</>

<p>The first idea is to try all possible 17-byte keys and find those, which will result in printable plain text after decryption.
Bruteforce is not an option, because there are $256^{17}$ possible keys ($\tilde{}10^{40}$), that's too much.
But there are good news: who said we should test 17-byte key as a whole, why can't we test each byte of key separately?
It is possible indeed.</p>

<p>Now the algorithm is:
1) try all 256 bytes for 1st byte of key;
2) decrypt 1st byte of each 17-byte blocks in the file;
3) are all decrypted bytes we got are printable? keep tabs on it;
4) do so for all 17 bytes of key.</p>

<p>I wrote with the following Python script to check this idea:</p>

_PRE_BEGIN
each_Nth_byte=[""]*KEY_LEN

content=read_file(sys.argv[1])
# split input by 17-byte chunks:
all_chunks=chunks(content, KEY_LEN)
for c in all_chunks:
    for i in range(KEY_LEN):
        each_Nth_byte[i]=each_Nth_byte[i] + c[i]

# try each byte of key
for N in range(KEY_LEN):
    print "N=", N
    possible_keys=[]
    for i in range(256):
        tmp_key=chr(i)*len(each_Nth_byte[N])
        tmp=xor_strings(tmp_key,each_Nth_byte[N])
        # are all characters in tmp[] are printable?
        if is_string_printable(tmp)==False:
	    continue
	possible_keys.append(i)
    print possible_keys, "len=", len(possible_keys)
_PRE_END

<p>(Full version of the source code is _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/XOR_mask_2/files/decrypt2.py',`here')).</p>

<p>Here is its output:</p>

_PRE_BEGIN
N= 0
[144, 145, 151] len= 3
N= 1
[160, 161] len= 2
N= 2
[32, 33, 38] len= 3
N= 3
[80, 81, 87] len= 3
N= 4
[78, 79] len= 2
N= 5
[142, 143] len= 2
N= 6
[250, 251] len= 2
N= 7
[254, 255] len= 2
N= 8
[130, 132, 133] len= 3
N= 9
[130, 131] len= 2
N= 10
[206, 207] len= 2
N= 11
[81, 86, 87] len= 3
N= 12
[64, 65] len= 2
N= 13
[18, 19] len= 2
N= 14
[122, 123] len= 2
N= 15
[248, 249] len= 2
N= 16
[48, 49] len= 2
_PRE_END

<p>So there are 2 or 3 possible bytes for each byte of 17-byte key.
This is much better than 256 possible bytes for each byte, but still too much.
There are up to 1 million of possible keys:</p>

_PRE_BEGIN
In[]:= 3*2*3*3*2*2*2*2*3*2*2*3*2*2*2*2*2
Out[]= 995328
_PRE_END

<p>It's possible to check all of them, but then we will need to visually check, if the decrypted text is looks like English language text.</p>

<p>Let's also take into consideration the fact that we deal with 1) natural language; 2) English language.
Natural languages has some prominent statistical features.
First of all, punctuation and word lengths.
What is average word length in English language?
Let's just count spaces in some well-known English language texts using Mathematica.</p>

<p>Here is _HTML_LINK(`http://www.gutenberg.org/cache/epub/100/pg100.txt',`"The Complete Works of William Shakespeare" text file from Gutenberg Library'):</p>

_PRE_BEGIN
In[]:= input = BinaryReadList["/home/dennis/tmp/pg100.txt"];

In[]:= Tally[input]
Out[]= {{239, 1}, {187, 1}, {191, 1}, {84, 39878}, {104, 
  218875}, {101, 406157}, {32, 1285884}, {80, 12038}, {114, 
  209907}, {111, 282560}, {106, 2788}, {99, 67194}, {116, 
  291243}, {71, 11261}, {117, 115225}, {110, 216805}, {98, 
  46768}, {103, 57328}, {69, 42703}, {66, 15450}, {107, 29345}, {102, 
  69103}, {67, 21526}, {109, 95890}, {112, 46849}, {108, 146532}, {87,
   16508}, {115, 215605}, {105, 199130}, {97, 245509}, {83, 
  34082}, {44, 83315}, {121, 85549}, {13, 124787}, {10, 124787}, {119,
   73155}, {100, 134216}, {118, 34077}, {46, 78216}, {89, 9128}, {45, 
  8150}, {76, 23919}, {42, 73}, {79, 33268}, {82, 29040}, {73, 
  55893}, {72, 18486}, {68, 15726}, {58, 1843}, {65, 44560}, {49, 
  982}, {50, 373}, {48, 325}, {91, 2076}, {35, 3}, {93, 2068}, {74, 
  2071}, {57, 966}, {52, 107}, {70, 11770}, {85, 14169}, {78, 
  27393}, {75, 6206}, {77, 15887}, {120, 4681}, {33, 8840}, {60, 
  468}, {86, 3587}, {51, 343}, {88, 608}, {40, 643}, {41, 644}, {62, 
  440}, {39, 31077}, {34, 488}, {59, 17199}, {126, 1}, {95, 71}, {113,
   2414}, {81, 1179}, {63, 10476}, {47, 48}, {55, 45}, {54, 73}, {64, 
  3}, {53, 94}, {56, 47}, {122, 1098}, {90, 532}, {124, 33}, {38, 
  21}, {96, 1}, {125, 2}, {37, 1}, {36, 2}}

In[]:= Length[input]/1285884 // N
Out[]= 4.34712
_PRE_END

<p>There are 1285884 spaces in the whole file, and the frequence of space occurrence is 1 space per ~4.3 characters.</p>

<p>Now here is _HTML_LINK(`http://www.gutenberg.org/ebooks/11',``Alice&rsquo;s Adventures in Wonderland, by Lewis Carroll'') from the same library:</p>

_PRE_BEGIN
In[]:= input = BinaryReadList["/home/dennis/tmp/pg11.txt"];

In[]:= Tally[input]
Out[]= {{239, 1}, {187, 1}, {191, 1}, {80, 172}, {114, 6398}, {111, 
  9243}, {106, 222}, {101, 15082}, {99, 2815}, {116, 11629}, {32, 
  27964}, {71, 193}, {117, 3867}, {110, 7869}, {98, 1621}, {103, 
  2750}, {39, 2885}, {115, 6980}, {65, 721}, {108, 5053}, {105, 
  7802}, {100, 5227}, {118, 911}, {87, 256}, {97, 9081}, {44, 
  2566}, {121, 2442}, {76, 158}, {119, 2696}, {67, 185}, {13, 
  3735}, {10, 3735}, {84, 571}, {104, 7580}, {66, 125}, {107, 
  1202}, {102, 2248}, {109, 2245}, {46, 1206}, {89, 142}, {112, 
  1796}, {45, 744}, {58, 255}, {68, 242}, {74, 13}, {50, 12}, {53, 
  13}, {48, 22}, {56, 10}, {91, 4}, {69, 313}, {35, 1}, {49, 68}, {93,
   4}, {82, 212}, {77, 222}, {57, 11}, {52, 10}, {42, 88}, {83, 
  288}, {79, 234}, {70, 134}, {72, 309}, {73, 831}, {85, 111}, {78, 
  182}, {75, 88}, {86, 52}, {51, 13}, {63, 202}, {40, 76}, {41, 
  76}, {59, 194}, {33, 451}, {113, 135}, {120, 170}, {90, 1}, {122, 
  79}, {34, 135}, {95, 4}, {81, 85}, {88, 6}, {47, 24}, {55, 6}, {54, 
  7}, {37, 1}, {64, 2}, {36, 2}}

In[]:= Length[input]/27964 // N
Out[]= 5.99049
_PRE_END

<p>The result is different probably because of different formatting of these texts (maybe indentation and/or padding).</>

<p>OK, so let's assume the average frequence of space in English language is 1 space per 4..7 characters.</p>

<p>Now the good news again: we can measure frequence of spaces while decrypting our file gradually.
Now I count spaces in each "slice" and throw away 1-byte keys which produce buffers with too small number of spaces (or too large, but this is almost impossible given so short key):</p>

_PRE_BEGIN
each_Nth_byte=[""]*KEY_LEN

content=read_file(sys.argv[1])
# split input by 17-byte chunks:
all_chunks=chunks(content, KEY_LEN)
for c in all_chunks:
    for i in range(KEY_LEN):
        each_Nth_byte[i]=each_Nth_byte[i] + c[i]

# try each byte of key
for N in range(KEY_LEN):
    print "N=", N
    possible_keys=[]
    for i in range(256):
        tmp_key=chr(i)*len(each_Nth_byte[N])
        tmp=xor_strings(tmp_key,each_Nth_byte[N])
        # are all characters in tmp[] are printable?
        if is_string_printable(tmp)==False:
	    continue
        # count spaces in decrypted buffer:
	spaces=tmp.count(' ')
	if spaces==0:
            continue
	spaces_ratio=len(tmp)/spaces
	if spaces_ratio<4:
	    continue
	if spaces_ratio>7:
	    continue
	possible_keys.append(i)
    print possible_keys, "len=", len(possible_keys)
_PRE_END

<p>(Full version of the source code is _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/XOR_mask_2/files/decrypt3.py',`here')).</p>

<p>This reports just one single possible byte for each byte of key:</p>

_PRE_BEGIN
N= 0
[144] len= 1
N= 1
[160] len= 1
N= 2
[33] len= 1
N= 3
[80] len= 1
N= 4
[79] len= 1
N= 5
[143] len= 1
N= 6
[251] len= 1
N= 7
[255] len= 1
N= 8
[133] len= 1
N= 9
[131] len= 1
N= 10
[207] len= 1
N= 11
[86] len= 1
N= 12
[65] len= 1
N= 13
[18] len= 1
N= 14
[122] len= 1
N= 15
[249] len= 1
N= 16
[49] len= 1
_PRE_END

<p>Let's check this key in Mathematica:</p>

_PRE_BEGIN
In[]:= input = BinaryReadList["/home/dennis/tmp/cipher.txt"];

In[]:= blocks = Partition[input, 17];

In[]:= key = {144, 160, 33, 80, 79, 143, 251, 255, 133, 131, 207, 86, 65, 18, 122, 249, 49};

In[]:= EncryptBlock[blk_] := BitXor[key, blk]

In[]:= encrypted = Map[EncryptBlock[#] &, blocks];

In[]:= BinaryWrite["/home/dennis/tmp/plain2.txt", Flatten[encrypted]]

In[]:= Close["/home/dennis/tmp/plain2.txt"]
_PRE_END

<p>And the plain text is:</p>

_PRE_BEGIN
Mr. Sherlock Holmes, who was usually very late in the mornings, save
upon those not infrequent occasions when he was up all night, was seated
at the breakfast table. I stood upon the hearth-rug and picked up the
stick which our visitor had left behind him the night before. It was a
fine, thick piece of wood, bulbous-headed, of the sort which is known as
a "Penang lawyer." Just under the head was a broad silver band nearly
an inch across. "To James Mortimer, M.R.C.S., from his friends of the
C.C.H.," was engraved upon it, with the date "1884." It was just such a
stick as the old-fashioned family practitioner used to carry--dignified,
solid, and reassuring.

"Well, Watson, what do you make of it?"

Holmes was sitting with his back to me, and I had given him no sign of
my occupation.

...
_PRE_END

<p>(Full version of the text is _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/XOR_mask_2/files/plain.txt',`here')).</p>

<p>The text looks correct.
Yes, I made up this example and choose well-known text of Conan Doyle, but it's very close to what I had in my practice some time ago.</p>

_HL2(`Other ideas to consider')

<p>If I would fail with space counting, there are other ideas to try:</p>

<ul>

<li>Take into consideration the fact that lowercase letters are much more frequent than uppercase ones.

<li>_HTML_LINK(`https://en.wikipedia.org/wiki/Frequency_analysis',`Frequency analysis').

<li>There is also a good technique to detect language of a text: trigrams.
Each language has some very frequent letter triplets, these may be "the" and "tha" for English.
Read more about it:
_HTML_LINK_AS_IS(`http://odur.let.rug.nl/~vannoord/TextCat/textcat.pdf',`N-Gram-Based Text Categorization'),
_HTML_LINK_AS_IS(`http://code.activestate.com/recipes/326576/').
Interestingly enough, trigrams detection can be used when you decrypt a ciphertext gradually, like in this example (you just need to test 3 adjacent decrypted characters).

<li>For non-Latin writing systems encoded in UTF-8, things may be easier. For example, Russian text encoded in UTF-8 has each byte interleaved with 0xD0/0xD1 byte.
It is because Cyrillic characters are placed in _HTML_LINK(`https://en.wikipedia.org/wiki/Cyrillic_%28Unicode_block%29',`4th block of Unicode').
Other writing systems has their own blocks.
See also: _HTML_LINK_AS_IS(`//beginners.re/22-Apr-2016/RE4B-EN.pdf#page=652&zoom=auto,-107,20').
</ul>

_BLOG_FOOTER_GITHUB(`XOR_mask_2')

_BLOG_FOOTER()

