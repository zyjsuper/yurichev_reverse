m4_include(`commons.m4')

_HEADER_HL1(`10-Jul-2016: Another loop optimization')

<p>If you process all elements of some array which happens to be located in global memory, compiler can optimize it.
For example, let's calculate a sum of all elements of array of 128 int's:</p>

_PRE_BEGIN
#include &lt;stdio.h>

int a[128];

int sum_of_a()
{
	int rt=0;
	
	for (int i=0; i<128; i++)
		rt=rt+a[i];

	return rt;
};

int main()
{
	// initialize
	for (int i=0; i<128; i++)
		a[i]=i;
	
	// calculate the sum
	printf ("%d\n", sum_of_a());
};
_PRE_END

<p>Optimizing GCC 5.3.1 (x86) can produce this (IDA):</p>

_PRE_BEGIN
.text:080484B0 sum_of_a        proc near
.text:080484B0                 mov     edx, offset a
.text:080484B5                 xor     eax, eax
.text:080484B7                 mov     esi, esi
.text:080484B9                 lea     edi, [edi+0]
.text:080484C0
.text:080484C0 loc_80484C0:                            ; CODE XREF: sum_of_a+1B
.text:080484C0                 add     eax, [edx]
.text:080484C2                 add     edx, 4
.text:080484C5                 cmp     edx, offset __libc_start_main@@GLIBC_2_0
.text:080484CB                 jnz     short loc_80484C0
.text:080484CD                 rep retn
.text:080484CD sum_of_a        endp
.text:080484CD

...

.bss:0804A040                 public a
.bss:0804A040 a               dd 80h dup(?)           ; DATA XREF: main:loc_8048338
.bss:0804A040                                         ; main+19
.bss:0804A040 _bss            ends
.bss:0804A040
extern:0804A240 ; ===========================================================================
extern:0804A240
extern:0804A240 ; Segment type: Externs
extern:0804A240 ; extern
extern:0804A240                 extrn __libc_start_main@@GLIBC_2_0:near
extern:0804A240                                         ; DATA XREF: main+25
extern:0804A240                                         ; main+5D
extern:0804A244                 extrn __printf_chk@@GLIBC_2_3_4:near
extern:0804A248                 extrn __libc_start_main:near
extern:0804A248                                         ; CODE XREF: ___libc_start_main
extern:0804A248                                         ; DATA XREF: .got.plt:off_804A00C
_PRE_END

<p>What the heck is <b>__libc_start_main@@GLIBC_2_0</b> at <b>0x080484C5</b>?
This is a label just after end of <b>a[]</b> array. The function can be rewritten like this:</p>

_PRE_BEGIN
int sum_of_a_v2()
{
	int *tmp=a;
	int rt=0;
	
	do
	{
		rt=rt+(*tmp);
		tmp++;
	}
	while (tmp<(a+128));

	return rt;
};
_PRE_END

<p>First version has <b>i</b> counter, and the address of each element of array is to be calculated at each iteration.
The second version is more optimized: the pointer to each element of array is always ready and is sliding 4 bytes left at each iteration.
How to check if the loop is ended? Just compare the pointer with the address just behind array's end, which is, in our case, is happens to be address of imported <b>__libc_start_main()</b> function from Glibc 2.0.
Sometimes code like this is confusing, and this is very popular optimizing trick, so that's why I made this example.</p>

<p>My second version is very close to what GCC did, and when I compile it, the code is almost the same as in first version, but two first instructions are swapped:</p>

_PRE_BEGIN
.text:080484D0                 public sum_of_a_v2
.text:080484D0 sum_of_a_v2     proc near
.text:080484D0                 xor     eax, eax
.text:080484D2                 mov     edx, offset a
.text:080484D7                 mov     esi, esi
.text:080484D9                 lea     edi, [edi+0]
.text:080484E0
.text:080484E0 loc_80484E0:                            ; CODE XREF: sum_of_a_v2+1B
.text:080484E0                 add     eax, [edx]
.text:080484E2                 add     edx, 4
.text:080484E5                 cmp     edx, offset __libc_start_main@@GLIBC_2_0
.text:080484EB                 jnz     short loc_80484E0
.text:080484ED                 rep retn
.text:080484ED sum_of_a_v2     endp
_PRE_END

<p>Needless to say, this optimization is possible if the compiler can calculate address of the end of array during compilation time.
This happens if the array is global and it's size is fixed.</p>

<p>However, if the address of array is unknown during compilation, but size is fixed, address of the label just behind array's end can be calculated at the beginning of the loop.</p>
<!-- \ref{} to example -->

_BLOG_FOOTER_GITHUB(`loop_optimization')

_BLOG_FOOTER()

