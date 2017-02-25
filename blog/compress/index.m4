m4_include(`commons.m4')

_HEADER_HL1(`25-Feb-2017: Text strings right in the middle of compressed data')

<p>You can download Linux kernel 3.9.2 and find a familiar name right in the middle of compressed data:</p>

_PRE_BEGIN
wget https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-3.9.2.tar.gz

xxd -g 1 -seek 0x6725320 -l 0x30 linux-3.9.2.tar.gz

06725320: 08 e2 b8 19 70 b1 90 23 0b 71 86 dd 7b 41 14 30  ....p..#.q..{A.0
06725330: e1 f8 a5 35 18 45 53 41 47 45 0c bf 60 85 ac 96  ...5.ESAGE......
06725340: 30 15 b7 90 f9 23 c5 28 42 92 19 5e 7a 02 73 72  0....#.(B..^z.sr
_PRE_END

<p>Russian hackers obviously has world domination plan, but the kernel is a bit old, oh wait, this one is newer:</p>

_PRE_BEGIN
wget https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-3.10.38.tar.xz

xxd -g 1 -seek 0x20cfbd0 -l 0x30 linux-3.10.38.tar.xz

020cfbd0: 5c 3d 93 2e ed 64 cd 37 f1 9b fb 87 a8 8c a0 7f  \=...d.7........
020cfbe0: da 66 8c 45 53 41 47 45 e2 6a e2 72 68 d9 eb bd  .f.ESAGE.j.rh...
020cfbf0: b9 fc 4f 5f 03 09 be 0a 88 50 dd 3f a4 d4 27 15  ..O_.....P.?..'.
_PRE_END

<p>One of Linux kernel patches in compressed form has the "Linux" word itself:</p>

_PRE_BEGIN
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/testing/patch-4.6-rc4.gz

xxd -g 1 -seek 0x4d03f -l 0x30 patch-4.6-rc4.gz

0004d03f: c7 40 24 bd ae ef ee 03 2c 95 dc 65 eb 31 d3 f1  .@$.....,..e.1..
0004d04f: 4c 69 6e 75 78 f2 f3 70 3c 3a bd 3e bd f8 59 7e  Linux..p<:.>..Y~
0004d05f: cd 76 55 74 2b cb d5 af 7a 35 56 d7 5e 07 5a 67  .vUt+...z5V.^.Zg
_PRE_END

<p>Compressed source code has _HTML_LINK(`http://qrzcq.com/call/UU1CC',`my friend')'s hamradio callsign _HTML_LINK(`http://www.dxwatch.com/qrz/UU1CC',`UU1CC'):</p>

_PRE_BEGIN
wget https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-3.10.62.tar.xz

xxd -g 1 -seek 0x9ada20 -l 0x30 linux-3.10.62.tar.xz

009ada20: 49 c6 83 a0 42 30 d4 1e b2 36 e5 b4 94 50 06 5f  I...B0...6...P._
009ada30: 55 55 31 43 43 d0 13 c5 8f 78 54 f5 4c 47 65 33  UU1CC....xT.LGe3
009ada40: 8c c4 17 50 f6 a3 62 51 47 3b 47 4d 29 22 59 d7  ...P..bQG;GM)"Y.
_PRE_END

<p>All these files are genuine, kernel.org website hasn't been compromised, and you can download, find these strings, check signatures.</p>

<p>Now seriously.</p>

<p>It was a nice illustration of _HTML_LINK(`https://en.wikipedia.org/wiki/Apophenia',`apophenia') and _HTML_LINK(`https://en.wikipedia.org/wiki/Pareidolia',`pareidolia')
(human's mind ability to see faces in clouds, etc) in Lurkmore, Russian counterpart of Encyclopedia Dramatica.
As _HTML_LINK(`http://lurkmore.to/%D0%AD%D0%BB%D0%B5%D0%BA%D1%82%D1%80%D0%BE%D0%BD%D0%BD%D1%8B%D0%B9_%D0%B3%D0%BE%D0%BB%D0%BE%D1%81%D0%BE%D0%B2%D0%BE%D0%B9_%D1%84%D0%B5%D0%BD%D0%BE%D0%BC%D0%B5%D0%BD',`they wrote') in the article
about <i>electronic voice phenomenon</i>,
you can open any long enough compressed file in hex editor and find well-known 3-letter Russian obscene word, and you'll find it a lot: but that means nothing, just a mere coincidence.</p>

<p>And I was interested in calculation, how big compressed file must be to contain all possible 3-letter, 4-letter, etc, words?
In my naive calculations, I've got this: probability of the first specific byte in the middle of compressed data stream with maximal entropy is $\frac{1}{256}$, probability of the 2nd is also $\frac{1}{256}$,
not probability of specific byte pair is $\frac{1}{256 \cdot 256} = \frac{1}{256^2}$.
Probabilty of specific triple is $\frac{1}{256^3}$.
If the file has maximal entropy (which is unachievable, but...) and we live in an ideal world, you've got to have file of size just $256^3=16777216$, which is 16-17MB.
You can check: get any compressed file, and use <i>rafind2</i> to search for any 3-letter word (not just that Russian obscene one).<p>

<p>My approach is naive, so I googled for mathematically grounded one, and have find this question:
_HTML_LINK(`http://math.stackexchange.com/questions/27989/time-until-a-consecutive-sequence-of-ones-in-a-random-bit-sequence/27991#27991',`Time until a consecutive sequence of ones in a random bit sequence').
The answer is: $(p^{−n}−1)/(1−p)$, where $p$ is probability of each event and $n$ is number of consecutive events.
Plug $\frac{1}{256}$ and $3$ and you'll get almost the same as my naive calculations.</p>

<p>So any 3-letter words can be found in the compressed file (with ideal entropy) of length $256^3=~17MB$, any 4-letter word - $256^4=4.7GB$ (size of DVD).
Any 5-letter word - $256^5=~1TB$.</p>

<p>For the post you are reading now, I mirrored the whole _HTML_LINK(`https://www.kernel.org/',`kernel.org') website (let sysadmins forgive me),
and it has ~430GB of compressed Linux Kernel source trees.
It has enough compressed data to contain these words, however, I cheated a bit: I searched for both lowercase and uppercase strings, thus compressed data set I need is almost halved.</p>

<p>This is quite interesting thing to think about: 1TB of compressed data with maximal entropy has all possible 5-byte chains,
but the data is encoded not in chains itself, but in the order of chains (no matter of compression algorithm, etc).</p>

<p>Now the information for gamblers: one should throw a dice ~42 times to get a pair of six, but no one will tell you, when exactly.
I don't remember, how many times coin was tossed in "Rosencrantz & Guildenstern Are Dead" movie, but one should toss it ~2048 times and at some point, you'll get 10 heads,
and some other points, 10 tails. Again, no one will tell you, when.</p>

<p>Compressed data also can be treated as random stream, so we can use the same mathematics to determine probabilities, etc.</p>

<p>Moral of the story: whenever you search for some patterns, you can find it in the middle of compressed blob, but that means nothing else then coincidence.
In philosophical sense, this is a case of _HTML_LINK(`https://en.wikipedia.org/wiki/Selection_bias',`selection')/_HTML_LINK(`https://en.wikipedia.org/wiki/Confirmation_bias',`confirmation bias'): you find what you search for.</p>

_BLOG_FOOTER()

