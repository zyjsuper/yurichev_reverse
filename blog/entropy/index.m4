m4_include(`commons.m4')

_HEADER(`13-May-2015: (Beginners level) Analyzing unknown binary files using information entropy.')

_HL1(`13-May-2015: (Beginners level) Analyzing unknown binary files using information entropy.')

<p>For the sake of simplification, I would say, information entropy is a measure, how tightly some piece of data can be compressed.
For example, it is usually not possible to compress already compressed archive file, so it has high entropy.
On the other hand, one megabyte of zero bytes can be compressed to a tiny output file.
Indeed, in plain English language, one million of zeroes can be described just as "resulting file is one million zero bytes".
Compressed files are usually a list of instructions to decompressor, like this: "put 1000 zeroes, then 0x23 byte, then 0x45 byte, then 2000 more zeroes, etc".</p>

<p>Texts written in natural languages are also can be compressed tightly, because natural languages has a lot of redundancy
(otherwise, a tiny typo will always lead to misunderstanding), some words are used very often, etc.</p>

<p>Code for CPUs is also can be compressed, because some ISA instructions are always used more often than others.
In x86, most used instructions are MOV/PUSH/CALL -- indeed, most of the time, computer CPU is just shuffling data and switching between
levels of abstractions.</p>

<p>Data compressors and encryptors tend to produce very high entropy results.
Good perudorandom number generators also produce data which cannot be compressed 
(it is possible to measure their quality by this sign).</p>

<p>So, in other words, entropy is a measure which can help to probe unknown data block.
Even more than that, it is possible to slice some file by blocks, probe each and draw a graph.
I did this in Wolfram Mathematica for demonstration and here is a source code (Mathematica 10):</p>

<pre>
(* loading the file *)
input=BinaryReadList["file.bin"];

(* setting block sizes *)
BlockSize=4096;BlockSizeToShow=256;

(* slice blocks by 4k *)
blocks=Partition[input,BlockSize];

(* how many blocks we've got? *)
Length[blocks]

(* calculate entropy for each block. 2 in Entropy[] (base) is set with the intention so Entropy[] 
function will produce the same results as Linux ent utility does *)
entropies=Map[N[Entropy[2,#]]&,blocks];

(* helper functions *)
fBlockToShow[input_,offset_]:=Take[input,{1+offset,1+offset+BlockSizeToShow}]
fToASCII[val_]:=FromCharacterCode[val,"PrintableASCII"]
fToHex[val_]:=IntegerString[val,16]
fPutASCIIWindow[data_]:=Framed[Grid[Partition[Map[fToASCII,data],16]]]
fPutHexWindow[data_]:=Framed[Grid[Partition[Map[fToHex,data],16],Alignment->Right]]

(* that will be the main knob here *)
{Slider[Dynamic[offset],{0,Length[input]-BlockSize,BlockSize}],Dynamic[BaseForm[offset,16]]}

(* main UI part *)
Dynamic[{ListLinePlot[entropies,GridLines->{{-1,offset/BlockSize,1}},Filling->Axis,AxesLabel->{"offset","entropy"}],
CurrentBlock=fBlockToShow[input,offset];
fPutHexWindow[CurrentBlock],
fPutASCIIWindow[CurrentBlock]}]
</pre>

_HL2(`GeoIP ISP database:')

<p>Let's start with the <a href="https://www.maxmind.com/en/geoip-demo">GeoIP</a> file (which assigns ISP to the block of IP addresses).
This binary file (<i>GeoIPISP.dat</i>) has some tables (which are IP address ranges perhaps) plus some text blob at the end of the file
(containing ISP names).</p>

<p>When I load it to Mathematica, I see this:</p>

<img src="geoipisp1.png">

<p>There are two parts in graph: first is somewhat chaotic, second is more steady.</p>

<p>0 in horizontal axis in graph mean lowest entropy (the data which can be compressed very tightly, "ordered" in other words) 
and 8 is highest (cannot be compressed at all, "chaotic" or "random" in other words).
Why 0 and 8? 0 mean 0 bits per byte (byte slot is not filled at all) 
and 8 mean 8 bits per byte, i.e., the whole byte slot is filled with the information tightly.</p>

<p>So I put slider to point in the middle of the first block, and I clearly see some array of 32-bit integers.
Now I put slider in the middle of the second block and I see English text:</p>

<img src="geoipisp2.png">

<p>Indeed, this are names of ISPs.
So, entropy of English text is 4.5-5.5 bits per byte? Yes, something like this.
Wolfram Mathematica has some well-known English literature corpus embedded, and we can see entropy of Shakespeare's sonnets:</p>

<pre>
In[]:= Entropy[2,ExampleData[{"Text","ShakespearesSonnets"}]]//N
Out[]= 4.42366
</pre>

<p>4.4 is close to what we've got (4.7-5.3). 
Of course, classic English literature texts are somewhat different from ISP names and other English texts we can find in binary files 
(debugging/logging/error messages), but this value is close.</p>

_HL2(`TP-Link WR941 firmware:')

<p>Now more complex example. I've got firmware for TP-Link WR941 router:</p>

<img src="tplink.png">

<p>Wee see here 3 blocks with empty lacunas.
The first block (started at address 0) is small, second (address somewhere at 0x22000) is bigger and third (address 0x123000) is biggest.
I can't be sure about exact entropy of the first block, but 2nd and 3rd has very high entropy, meaning that these blocks are either
compressed and/or encrypted.<p>

<p>I tried <a href="http://binwalk.org/">binwalk</a> for this firmware file:</p>

<pre>
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             TP-Link firmware header, firmware version: 0.-15221.3, image version: "", product ID: 0x0, product version: 155254789, kernel load address: 0x0, kernel entry point: 0x-7FFFE000, kernel offset: 4063744, kernel length: 512, rootfs offset: 837431, rootfs length: 1048576, bootloader offset: 2883584, bootloader length: 0
14832         0x39F0          U-Boot version string, "U-Boot 1.1.4 (Jun 27 2014 - 14:56:49)"
14880         0x3A20          CRC32 polynomial table, big endian
16176         0x3F30          uImage header, header size: 64 bytes, header CRC: 0x3AC66E95, created: 2014-06-27 06:56:50, image size: 34587 bytes, Data Address: 0x80010000, Entry Point: 0x80010000, data CRC: 0xDF2DBA0B, OS: Linux, CPU: MIPS, image type: Firmware Image, compression type: lzma, image name: "u-boot image"
16240         0x3F70          LZMA compressed data, properties: 0x5D, dictionary size: 33554432 bytes, uncompressed size: 90000 bytes
131584        0x20200         TP-Link firmware header, firmware version: 0.0.3, image version: "", product ID: 0x0, product version: 155254789, kernel load address: 0x0, kernel entry point: 0x-7FFFE000, kernel offset: 3932160, kernel length: 512, rootfs offset: 837431, rootfs length: 1048576, bootloader offset: 2883584, bootloader length: 0
132096        0x20400         LZMA compressed data, properties: 0x5D, dictionary size: 33554432 bytes, uncompressed size: 2388212 bytes
1180160       0x120200        Squashfs filesystem, little endian, version 4.0, compression:lzma, size: 2548511 bytes, 536 inodes, blocksize: 131072 bytes, created: 2014-06-27 07:06:52
</pre>

<p>Indeed: there are some stuff at the beginning, but two large LZMA compressed blocks are started at 0x20400 and 0x120200.
These are roughly addresses we have seen in Mathematica.
Oh, and by the way, binwalk can show entropy information as well (-E option):</p>

<pre>
DECIMAL       HEXADECIMAL     ENTROPY
--------------------------------------------------------------------------------
0             0x0             Falling entropy edge (0.419187)
16384         0x4000          Rising entropy edge (0.988639)
51200         0xC800          Falling entropy edge (0.000000)
133120        0x20800         Rising entropy edge (0.987596)
968704        0xEC800         Falling entropy edge (0.508720)
1181696       0x120800        Rising entropy edge (0.989615)
3727360       0x38E000        Falling entropy edge (0.732390)
</pre>

<p>Rising edges are corresponding to rising edges of block on our graph.
Falling edges are the points where empty lacunas are started.</p>

<p>I didn't able to force binwalk to generate PNG graphs (due to absence of some Python library), but here is an example how binwalk
can do them: _HTML_LINK_AS_IS(`http://binwalk.org/wp-content/uploads/2013/12/lg_dtv.png').</p>

<p>What can we say about lacunas? By looking in hex editor, we see that these are just filled with 0xFF bytes.
Why developers put them? Perhaps, because they didn't able to calculate precise compressed blocks sizes, so they allocated space
for them with some reserve.</p>

_HL2(`Notepad:')

<p>Another example is notepad.exe I've picked in Windows 8.1:</p>

<img src="notepad1.png">

<p>There is cavity at ~0x19000 (absolute file offset).
I opened the executable file in hex editor and found imports table there (which has lower entropy than x86-64 code
in the first half of graph).</p>

<p>There are also high entropy block started at ~0x20000:</p>

<img src="notepad2.png">

<p>In hex editor I can see PNG file here, embedded in the PE file resource section (it is large image of notepad icon).
PNG files are compressed, indeed.</p>

_HL2(`Unnamed dashcam:')

<p>Now the most complex example in this article is the firmware of some unnamed dashcam I've received from friend:</p>

<img src="dashcam_text.png">

<p>The cavity at the very beginning is a English text: debugging messages.
I checked various ISAs and I found that 
the first third of the whole file (with the text segment inside) is in fact MIPS (little-endian) code!</p>

<p>For instance, this is very distinctive function epilogue:</p>

<pre>
ROM:000013B0                 move    $sp, $fp
ROM:000013B4                 lw      $ra, 0x1C($sp)
ROM:000013B8                 lw      $fp, 0x18($sp)
ROM:000013BC                 lw      $s1, 0x14($sp)
ROM:000013C0                 lw      $s0, 0x10($sp)
ROM:000013C4                 jr      $ra
ROM:000013C8                 addiu   $sp, 0x20
</pre>

<p>From our graph we can see that MIPS code has entropy of 5-6 bits per byte.
Indeed, I once measured various ISAs entropy and I've got these values:</p>

<ul>
<li> x86: .text section of ntoskrnl.exe file from Windows 2003: 6.6
<li> x64: .text section of ntoskrnl.exe file from Windows 7 x64: 6.5
<li> ARM (thumb mode), Angry Birds Classic: 7.05
<li> ARM (ARM mode) Linux Kernel 3.8.0: 6.03
<li> MIPS (little endian), .text section of user32.dll from Windows NT 4: 6.09
</ul>

<p>So the entropy of executable code is higher than of English text, but still can be compressed.</p>

<p>Now the second third is started at 0xF5000. I don't know what this is. I tried different ISAs but without success.
The entropy of the block is looks even steadier than for executable one.
Maybe some kind of data?</p>

<p>There is also a spike at ~0x213000. I checked it in hex editor and I found JPEG file there 
(which, of course, compressed)!
I also don't know what is at the end.
Let's try binwalk for this file:</p>

<pre>
dennis@ubuntu:~/P/entropy$ binwalk FW96650A.bin 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
167698        0x28F12         Unix path: /15/20/24/25/30/60/120/240fps can be served..
280286        0x446DE         Copyright string: "Copyright (c) 2012 Novatek Microelectronic Corp."
2169199       0x21196F        JPEG image data, JFIF standard 1.01
2300847       0x231BAF        MySQL MISAM compressed data file Version 3

dennis@ubuntu:~/P/entropy$ binwalk -E FW96650A.bin 

WARNING: pyqtgraph not found, visual entropy graphing will be disabled

DECIMAL       HEXADECIMAL     ENTROPY
--------------------------------------------------------------------------------
0             0x0             Falling entropy edge (0.579792)
2170880       0x212000        Rising entropy edge (0.967373)
2267136       0x229800        Falling entropy edge (0.802974)
2426880       0x250800        Falling entropy edge (0.846639)
2490368       0x260000        Falling entropy edge (0.849804)
2560000       0x271000        Rising entropy edge (0.974340)
2574336       0x274800        Rising entropy edge (0.970958)
2588672       0x278000        Falling entropy edge (0.763507)
2592768       0x279000        Rising entropy edge (0.951883)
2596864       0x27A000        Falling entropy edge (0.712814)
2600960       0x27B000        Rising entropy edge (0.968167)
2607104       0x27C800        Rising entropy edge (0.958582)
2609152       0x27D000        Falling entropy edge (0.760989)
2654208       0x288000        Rising entropy edge (0.954127)
2670592       0x28C000        Rising entropy edge (0.967883)
2676736       0x28D800        Rising entropy edge (0.975779)
2684928       0x28F800        Falling entropy edge (0.744369)
</pre>

<p>Yes, it found JPEG file and even MySQL data!
But I'm not sure if it's true -- I didn't checked it yet.</p>

<p>It's also interesting to try <a href="http://en.wikipedia.org/wiki/Cluster_analysis">clusterization</a> in Mathematica:</p>

<img src="dashcam_clusters.png">

<p>Here is an example of how Mathematica grouped various entropy values into distinctive groups.
Indeed, there is something credible. Blue dots in range of 5.0-5.5 are probably related to English text.
Yellow dots in 5.5-6 are MIPS code. A lot of green dots in 6.0-6.5 is the unknown second third.
Orange dots close to 8.0 are related to compressed JPEG file.
Other orange dots are probably related to the end of the firmware (unknown to us data).</p>

_HL2(`Conclusion')

<p>Information entropy can be used as a quick-n-dirty method for inspecting unknown binary files.
In particular, it is a very quick way to find compressed/encrypted pieces of data.
Someone say it's possible to find RSA (and other asymmetric cryptographic algorithms) public/private keys 
in executable code (which has high entropy as well), but I didn't tried this by myself.</p>

_HL2(`Links')

<p>Binary files used while writing: _HTML_LINK_AS_IS(`http://yurichev.com/blog/entropy/files/').
Wolfram Mathematica notebook file: _HTML_LINK_AS_IS(`http://yurichev.com/blog/entropy/files/binary_file_entropy.nb').</p>

<p>There is a great (and more complex) online entropy visualizer made by Aldo Cortesi, 
which I tried to mimic: _HTML_LINK_AS_IS(`http://binvis.io').
His articles about entropy visualization are worth reading:
_HTML_LINK(`http://corte.si/posts/visualisation/entropy/index.html',`1'), 
_HTML_LINK(`http://corte.si/posts/visualisation/malware/index.html',`2'), 
_HTML_LINK(`http://corte.si/posts/visualisation/binvis/index.html',`3').</p>

<p>General article about informational entropy in Wikipedia: _HTML_LINK_AS_IS(`http://en.wikipedia.org/wiki/Entropy_(information_theory)').</p>

<p>Handy Linux <i>ent</i> utility to measure entropy of a file: _HTML_LINK_AS_IS(`http://www.fourmilab.ch/random/').</p>

<p><a href="http://rada.re/">radare2</a> framework has <i>&#35;entropy</i> command for this.</p>

_HL2(`A word about XOR encryption.')

<p>It's interesting that simple XOR encryption doesn't affect entropy of data.
I've shown this in "Norton Guide" example in my book (<a href="http://beginners.re/">"Reverse Engineering for Beginners" free book</a>).
(The page about XOR encryption is also accessible in LaTeX form: <a href="https://github.com/dennis714/RE-for-beginners/blob/master/ff/XOR/ng/main.tex">link</a>).</p>

_HL2(`More about entropy of executable code.')

<p>It is quickly noticeable that probably biggest source of high-entropy in executable code is relative offsets.
For example, these two consequent instructions will produce different relative offsets in their opcodes, 
while they are in fact pointing to the same function:</p>

<pre>
function proc
...
function endp

...

CALL function
CALL function
</pre>

<p>Ideal executable code compressor would encode information like this:
"there is a CALL to a "function" at address X and the same CALL at address Y" without need to encode
address of the "function" twice.</p>

<p>To deal with this, executable compressors are sometimes able to reduce entropy here.
One example is UPX: _HTML_LINK_AS_IS(`http://sourceforge.net/p/upx/code/ci/default/tree/doc/filter.txt').</p>

_BLOG_FOOTER()
