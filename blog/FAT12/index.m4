m4_include(`commons.m4')

_HEADER_HL1(`(Beginners level) packing 12-bit values into array using bit operations (x64, ARM/ARM64, MIPS)')

_COPYPASTED1()

_HL2(`Introduction')

<p>File Allocation Table (FAT) was a widely popular filesystem.
Hard to believe, but it's still used on flash drives, perhaps, for the reason of simplicity and compatibility.
The FAT table itself is array of elements, each of which points to the next cluster number of a file 
(FAT supports files scattered across the whole disk).
That implies that maximum of each element is maximum number of clusters on the disk.
In MS-DOS era, most hard disks has FAT16 filesystem, because cluster number could be packed into 16-bit value.
Hard disks then become cheaper, and FAT32 emerged, where 32-bit value was allocated for cluster number.
But there were also a times, when floppy diskettes were not that cheap and has no much space, so FAT12 were used on them,
for the reason of packing all filesystem structures as tight as possible:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/File_Allocation_Table#FAT12').</p>

<p>So the FAT table in FAT12 filesystem is an array where each two subsequent 12-bit elements are stored into 3 bytes (triplet).
Here is how 6 12-bit values (AAA, BBB, CCC, DDD, EEE and FFF) are packed into 9 bytes:</p>

_PRE_BEGIN
 +0 +1 +2 +3 +4 +5 +6 +7 +8
|AA|AB|BB|CC|CD|DD|EE|EF|FF|...
_PRE_END

<p>Pushing values into array and pulling them back can be good example of bit twiddling operations (in both C/C++ and low-level machine code),
so that's why I'll use FAT12 as an example here.</p>

_HL2(`Data structure')

<p>We can quickly observe that each byte triplet will store 2 12-bit values: the first one is located at the left side, second one is at right:</p>

_PRE_BEGIN
 +0 +1 +2
|11|12|22|...
_PRE_END

<p>We will pack nibbles (4 bit chunks) in the following way (1 - highest nibble, 3 - lowest):</p>

<p>(Even)</p>

_PRE_BEGIN
 +0 +1 +2
|12|3.|..|...
_PRE_END

<p>(Odd)</p>

_PRE_BEGIN
 +0 +1 +2
|..|.1|23|...
_PRE_END

_HL2(`The algorithm')

<p>So the algorithm can be as follows: if the element's index is even, put it at left side, if the index is odd, place it at right side.
The middle byte: if the element's index is even, place part of it in high 4 bits, if it's odd, place its part in low 4 bits.
But first, find the right triplet, this is easy: $\frac{index}{2}$.
Finding the address of right byte in array of bytes is also easy: $\frac{index}{2} \cdot 3$ or $index \cdot \frac{3}{2}$ or just $index \cdot 1.5$.</p>

<p>Pulling values from array: if index is even, get leftmost and middle bytes and combine its parts.
If index is odd, get middle and rightmost bytes and combine them.
Do not forget to isolate unneeded bits in middle byte.</p>

<p>Pushing values is almost the same, but be careful not to overwrite some <i>other's</i> bits in the middle byte, correcting only <i>yours</i>.</p>

_HL2(`The C/C++ code')

m4_include(`blog/FAT12/C.html')

<p>During test, all 12-bit elements are filled with values in 0..0xFFF range.
And here is a dump of all triplets, each line has 3 bytes:</p>

_PRE_BEGIN
0x000001
0x002003
0x004005
0x006007
0x008009
0x00A00B
0x00C00D
0x00E00F
0x010011
0x012013
0x014015

...

0xFECFED
0xFEEFEF
0xFF0FF1
0xFF2FF3
0xFF4FF5
0xFF6FF7
0xFF8FF9
0xFFAFFB
0xFFCFFD
0xFFEFFF
_PRE_END

<p>Here is also GDB byte-level output of 300 bytes (or 100 triplets) started at 512/2*3, i.e., it's address where 512th element (0x200) is beginning.
I added square brackets in my text editor to show triplets explicitely.
Take a notice at the middle bytes, where the last element is ended and the next is started.
In other words, each middle byte has lowest 4 bits of even element and highest 4 bits of odd element.</p>

m4_include(`blog/FAT12/GDB.html')

_HL2(`How it works')

<p>Let array be a global buffer to make simpler access to it.</p>

_HL3(`Getter')

<p>Let's first start at the function getting values from the array, because it's simpler.</p>

<p>The method of finding triplet's number is just division input index by 2, but we can do it just by shifting right by 1 bit.
This is a very common way of dividing/multiplication by numbers in form of $2^n$.</p>

<p>I can demonstrate how it works. Let's say, you need to divide 123 by 10.
Just drop last digit (3, which is remainder of division) and 12 is left.
Division by 2 is just dropping least significant bit. Dropping can be done by shifting right.</p>

<p>Now the functions must decide if the input index even (so 12-bit value is placed at the left) or odd (at the right).
Simplest way to do so is to isolate lowest bit (x&1). If it's zero, our value is even, otherwise it's odd.</p>

<p>This fact can be illustrated easily, take a look at the lowest bit:</p>

_PRE_BEGIN
decimal binary even/odd

0       0000   even
1       0001   odd
2       0010   even
3       0011   odd
4       0100   even
5       0101   odd
6       0110   even
7       0111   odd
8       1000   even
9       1001   odd
10      1010   even
11      1011   odd
12      1100   even
13      1101   odd
14      1110   even
15      1111   odd
...
_PRE_END

<p>_HTML_LINK(`https://en.wikipedia.org/wiki/Parity_of_zero',`Zero is also even number'), 
it's so in _HTML_LINK(`https://en.wikipedia.org/wiki/Two%27s_complement',`two&rsquo;s complement system'), 
where it's located between two odd numbers (-1 and 1).</p>

<p>For math geeks, I could also say that even or odd sign is also remainder of division by 2.
Division of a number by 2 is merely dropping the last bit, which is remainder of division.
Well, we do not need to do shifts here, just isolate lowest bit.</p>

<p>If the element is odd, we take middle and right bytes ("array[array_idx+1]" and "array[array_idx+2]").
Lowest 4 bits of the middle byte is isolated.
Right byte is taken as a whole.
Now we need to combine these parts into 12-bit value.
To do so, shift 4 bits from the middle byte by 8 bits left, so these 4 bits will be allocated right behind highest 8th bit of byte.
Then, using OR operation, we just add these parts.</p>

<p>If the element is even, high 8 bits of 12-bit value is located in left byte, while lowest 4 bits are located in the high 4 bits of middle byte.
We isolate highest 4 bits in the middle byte by shifting it 4 bits right and then applying AND operation, just to be sure that nothing is left there.
We also take left byte and shift its value 4 bits left, because it has bits from 11th to 4th (inclusive, starting at 0),
Using OR operation, we combine these two parts.</p>

_HL3(`Setter')

<p>Setter calculates triplet's address in the same way.
It also operates on left/right bytes in the same way.
But it's not correct just to write to the middle byte, because write operation will destroy the information related to the other element.
So the common way is to load byte, drop bits where you'll write, write it there, but leave other part intact.
Using AND operation (& in C/C++), we drop everything except <i>our</i> part.
Using OR operation (| in C/C++), we then update the middle byte.</p>

_HL2(`Optimizing GCC 4.8.2 for x86-64')

<p>Let's see what optimizing GCC 4.8.2 for Linux x64 will do.
I added comments.
Sometimes readers are confused because instructions order is not logical.
It's OK, because optimizing compilers take CPU out-of-order-execution mechanisms into considerations, and sometimes,
swapped instructions performing better.</p>

_HL3(`Getter')

m4_include(`blog/FAT12/GCC_getter.html')

_HL3(`Setter')

m4_include(`blog/FAT12/GCC_setter.html')

_HL3(`Other comments')

<p>All addresses in Linux x64 are 64-bit ones, so during pointer arithmetics, all values should also be 64-bit.
The code calculating offsets inside of array operates on 32-bit values (input <b>idx</b> argument has type of <b>int</b>, which has width of 32 bits),
and so these values should be converted to 64-bit addresses before actual memory load/store.
So there are a lot of sign-extending instructions (like <b>CDQE</b>, <b>MOVSX</b>) used for conversion.
Why to extend sign? By C/C++ standards, pointer arithmetics can operate on negative values 
(it's possible to access array using negative index like <b>array[-123]</b>).
Since GCC compiler cannot be sure if all indices are always positive, it adds sign-extending instructions.</p>

_HL2(`Optimizing Keil 5.05 (Thumb mode)')

_HL3(`Getter')

<p>The following code has final OR operation in the function epilogue.
Indeed, it executes at the end of both branches, so it's possible to save some space.</p>

m4_include(`blog/FAT12/Keil_thumb_O3_getter.html')

<p>There are at least of redundancy: <i>idx*1.5</i> is calculated twice.
As an exercise, reader may try to rework assembly function to make it shorter. Do not forget about testing!</p>

<p>Another thing to mention is that it's hard to generate big constants in 16-bit Thumb instructions, so Keil compiler often generates
tricky code using shifting instructions to achieve the same effect.
For example, it's tricky to generate <b>AND Rdest, Rsrc, 1</b> or <b>TST Rsrc, 1</b> code in Thumb mode, 
so Keil generates the code which shifts input <b>idx</b> by 31 bits left and then check, if the resulting value zero or not.</p>

_HL3(`Setter')

<p>The first half of setter code is very similar to getter, address of triplet is calculated first,
then the jump is occurred in order to dispatch to the right handler's code.</p>

m4_include(`blog/FAT12/Keil_thumb_O3_setter.html')

_HL2(`Optimizing Keil 5.05 (ARM mode)')

_HL3(`Getter')

<p>Getter function for ARM mode has no conditional branches at all!
Thanks to the suffixes (like <b>-EQ</b>, <b>-NE</b>), which can be supplied to many instructions in ARM mode,
so the instruction will be only executed if the corresponding flag(s) are set.</p>

<p>Many arithmetical instructions in ARM mode can have shifting suffix like <b>LSL #1</b> (it means, the last operand is shifted left by 1 bit).</p>

m4_include(`blog/FAT12/Keil_ARM_O3_getter.html')

_HL3(`Setter')

m4_include(`blog/FAT12/Keil_ARM_O3_setter.html')

<p>Value of <i>idx*1.5</i> is calculated twice, this is redundancy Keil compiler produced can be eliminated.
You can rework assembly function as well to make it shorter. Do not forget about tests!</p>

_HL2(`(32-bit ARM) Comparison of code density in Thumb and ARM modes')

<p>Thumb mode in ARM CPUs was introduced to make instructions shorter (16-bits) instead of 32-bit instructions in ARM mode.
But as we can see, it's hard to say, if it was worth it: code in ARM mode is always shorter (however, instructions are longer).</p>

_HL2(`Optimizing GCC 4.9.3 for ARM64')

_HL3(`Getter')

m4_include(`blog/FAT12/ARM64_getter.html')

<p>ARM64 has new cool instruction <b>UBFIZ</b> (<i>Unsigned bitfield insert in zero, with zeros to left and right</i>), 
which can be used to place specified number of bits from one register to another.
It's alias of another instruction, <b>UBFM</b> (<i>Unsigned bitfield move, with zeros to left and right</i>).
<b>UBFM</b> is the instruction used internally in ARM64 instead of <b>LSL/LSR</b> (bit shifts).</p>

_HL3(`Setter')

m4_include(`blog/FAT12/ARM64_setter.html')

_HL2(`Optimizing GCC 4.4.5 for MIPS')

<p>Needless to keep in mind that each instruction after jump/branch instruction is executed first.
It's called "branch delay slot" in RISC CPUs lingo.
To make things simpler, just swap instructions (mentally) in each instruction pair which is started with branch or jump instruction.</p>

<p>MIPS has no flags (apparently, to simplify data dependencies), so branch instructions (like <b>BNE</b>) does both comparison and branching.</p>

<p>There is also GP (Global Pointer) set up code in the function prologue, which can be ignored so far.</p>
_HL3(`Getter')


m4_include(`blog/FAT12/MIPS_getter.html')

_HL3(`Setter')

m4_include(`blog/FAT12/MIPS_setter.html')

_HL2(`Difference from the real FAT12')

<p>The real FAT12 table is slightly different: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Design_of_the_FAT_file_system#Cluster_map'):</p>

<p>For even elements:</p>

_PRE_BEGIN
 +0 +1 +2
|23|.1|..|..
_PRE_END

<p>For odd elements:</p>

_PRE_BEGIN
 +0 +1 +2
|..|3.|12|..
_PRE_END

<p>Here are FAT12-related functions in Linux Kernel:
_HTML_LINK(`https://github.com/torvalds/linux/blob/de182468d1bb726198abaab315820542425270b7/fs/fat/fatent.c#L117',`fat12_ent_get()'),
_HTML_LINK(`https://github.com/torvalds/linux/blob/de182468d1bb726198abaab315820542425270b7/fs/fat/fatent.c#L153',`fat12_ent_put()').</p>

<p>Nevertheless, I did as I did because values are better visible and recognizable in byte-level GDB dump, for the sake of demonstration.</p>

_HL2(`Exercise')

<p>Perhaps, there could be a way to store data in a such way, so getter/setter functions would be faster.
If we would place values in this way:</p>

<p>(Even elements)</p>

_PRE_BEGIN
 +0 +1 +2
|23|1.|..|..
_PRE_END

<p>(Odd elements)</p>

_PRE_BEGIN
 +0 +1 +2
|..|.1|23|..
_PRE_END

<p>This schema of storing data will allow to eliminate at least one shift operation.
As an exercise, you may rework my C/C++ code in that way and see what compiler will produce.</p>

_HL2(`Summary')

<p>Bit shifts ("&lt;&lt;" and "&gt;&gt;" in C/C++, SHL/SHR/SAL/SAR in x86, LSL/LSR in ARM, SLL/SRL in MIPS) are used to place bit(s) to specific place.</p>

<p>AND operation ("&" in C/C++, AND in x86/ARM) is used to drop unneeded bits, also during isolation.</p>

<p>OR operation ("|" in C/C++, OR in x86/ARM) is used to merge or combine several values into one.
One input value must have zero space at the place where another value has its information-caring bits.</p>

<p>ARM64 has new instructions UBFM, UFBIZ to move specific bits from one register to another.</p>

_HL2(`Conclusion')

<p>FAT12 is hardly used somewhere nowadays, but if you have space constraints and you need to store values limited to 12 bits,
you may consider tightly-packed array in the manner it's done in FAT12 table.</p>

_HL2(`Further reading')

<p>More examples like this (for x86/x64/ARM/ARM64 and MIPS) can be found in my book: _HTML_LINK_AS_IS(`//beginners.re/').</p>

_BLOG_FOOTER()

