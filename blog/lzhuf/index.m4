m4_include(`commons.m4')

_HEADER_HL1(`19-Apr-2016: Bug in LZHuf.c by Haruyasu Yoshizaki')

<p>There is a highly popular LZHuf compressor/decompressor written by Haruyasu Yoshizaki as early as in 1988.</p>

<p>Andrey "herm1t" Baranovich (owner of _HTML_LINK(`http://vxheaven.org/',`VX Heaven website')) _HTML_LINK(`https://www.facebook.com/andrey.baranovich/posts/942909195785782',`found that many variations of this source code has a bug') (_HTML_LINK(`https://archive.is/cDd0U',`archived')):</p>

_PRE_BEGIN
...

unsigned freq[T + 1];	/* frequency table */

...

void reconst(void)
{

...
		l = (j - k) * 2; // "sizeof(unsigned)" should be instead of "2"
		memmove(&freq[k + 1], &freq[k], l);
		freq[k] = f;
		memmove(&son[k + 1], &son[k], l);

...
_PRE_END

<p>The <i>reconst()</i> function treats <i>freq[]</i> array's elements as 16-bit ones (notice <i>* 2</i> in expression, calculates address within <i>freq[]</i> array), and they really are if the code is compiled on 16-bit platform, but by C standard, <i>unsigned</i> type has size of 32 bit on any modern 32-bit and 64-bit architectures.</p>

<p>I tried to crash it, and found a very easy way to do so: just try to compress big enough file (I had success with 178KiB text file), and it crashes during compressing.
Now we can fix a bug (to set <i>unsigned short</i> type instead of <i>unsigned</i>), the program giving us compressed file, which is, in turn, can crash older unfixed LZHuf.c decompression function.</p>

<p>Input file (no matter, compressed or plain) must be big enough, so <i>reconst()</i> function will be called.</p>

<p>Probably (I'm not sure) this is a way to crash unfixed LZHuf.c program on a 32-bit or 64-bit system, just feed this file to it.
Unfixed LZHuf.c version has <i>unsigned</i> type for <i>freq[]</i> array, fixed has <i>unsigned short</i> type for it.</p>

<p>For example, this one is unfixed, but still very popular: _HTML_LINK_AS_IS(`https://raw.githubusercontent.com/tyll/tinyos-2.x-contrib/89a1419cb84ccf0747f95cdea2423a18e4fb13a7/eon/eon/src/util/lzss-c/lzhuf.c')</p>

<p>This one is fixed: _HTML_LINK_AS_IS(`https://github.com/msmiley/lzh/blob/9ed1946a3f6c7d124ee90c3a1fd4123b7418be57/src/lzh.c')</p>

<p>Crash happens in DecodePosition() function, when it attempts to read beyond <i>d_code[]</i> array.
Perhaps, someone else may check this and analyze further.</p>

<p>File I used as a plain text (~178KiB): _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/lzhuf/files/plain.txt').</p>

<p>Compressed file which crashes unfixed LZHuf.c (~45KiB): _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/lzhuf/files/compressed.dat').</p>

<p>Unfixed LZHuf.c I used: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/lzhuf/files/lzhuf.c').</p>

_BLOG_FOOTER_GITHUB(`lzhuf')

_BLOG_FOOTER()

