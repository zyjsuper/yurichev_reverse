m4_include(`commons.m4')

_HEADER_HL1(`8-May-2016: C/C++ pointers: yet another short example')

_COPYPASTED1()

<p>(For those who have a hard time in understanding C/C++ pointers).</p>

<p>Pointer is just an address in memory. But why we write "char* string" instead of something like "address string"?
Pointer variable is supplied with a type of the value to which pointer points.
So then compiler will able to check bugs in compilation time.</p>

<p>To be pedantic, data typing in programming languages is all about preventing bugs and self-documentation.
It's possible to use maybe two of data types like <i>int</i> (or <i>int64</i>) and byte - these are the only types which are available to assembly language programmers.
But it's just very hard task to write big and practical assembly programs without nasty bugs.
Any small typo can lead to hard-to-find bug.</p>

<p>Data type information is absent in a compiled code (and this is one of the main problems for decompilers), and I can demonstrate this:</p>

<p>This is what sane C/C++ programmer can write:</p>

_PRE_BEGIN
#include &lt;stdio.h>
#include &lt;stdint.h>

void print_string (char *s)
{
	printf ("(address: 0x%llx)\n", s);
	printf ("%s\n", s);
};

int main()
{
	char *s="Hello, world!";

	print_string (s);
};
_PRE_END

This is what I can write ("Do not try this at home" ("MythBusters")):

_PRE_BEGIN
#include &lt;stdio.h>
#include &lt;stdint.h>

void print_string (uint64_t address)
{
	printf ("(address: 0x%llx)\n", address);
	puts ((char*)address);
};

int main()
{
	char *s="Hello, world!";

	print_string ((uint64_t)s);
};
_PRE_END

<p>I use <i>uint64_t</i> because I run this example on Linux x64. <i>int</i> would work for 32-bit OS-es.</p>
First, a pointer to character (the very first in the greeting string) is casted to uint64_t, then it's passed.
print_string() function casts back incoming uint64_t value into pointer to a character.</p>

<p>What is interesting is that GCC 4.8.4 produces identical assembly output for both versions:</p>

_PRE_BEGIN
gcc 1.c -S -masm=intel -O3 -fno-inline
_PRE_END

_PRE_BEGIN
.LC0:
	.string	"(address: 0x%llx)\n"
print_string:
	push	rbx
	mov	rdx, rdi
	mov	rbx, rdi
	mov	esi, OFFSET FLAT:.LC0
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	mov	rdi, rbx
	pop	rbx
	jmp	puts
.LC1:
	.string	"Hello, world!"
main:
	sub	rsp, 8
	mov	edi, OFFSET FLAT:.LC1
	call	print_string
	add	rsp, 8
	ret
_PRE_END

<p>(I've removed all insignificant GCC directives).</p>

<p>I also tried <i>diff</i> utility and it shows no differences at all.</p>

<p>Let's continue to abuse C/C++ programming traditions heavily.
Someone may write this:</p>

_PRE_BEGIN
#include &lt;stdio.h>
#include &lt;stdint.h>

uint8_t load_byte_at_address (uint8_t* address)
{
	return *address;
	//this is also possible: return address[0]; 
};

void print_string (char *s)
{
	char* current_address=s;
	while (1)
	{
		char current_char=load_byte_at_address(current_address);
		if (current_char==0)
			break;
		printf ("%c", current_char);
		current_address++;
	};
};

int main()
{
	char *s="Hello, world!";

	print_string (s);
};
_PRE_END

<p>It can be rewritten like this:</p>

_PRE_BEGIN
#include &lt;stdio.h>
#include &lt;stdint.h>

uint8_t load_byte_at_address (uint64_t address)
{
	return *(uint8_t*)address;
	//this is also possible: return address[0]; 
};

void print_string (uint64_t address)
{
	uint64_t current_address=address;
	while (1)
	{
		char current_char=load_byte_at_address(current_address);
		if (current_char==0)
			break;
		printf ("%c", current_char);
		current_address++;
	};
};

int main()
{
	char *s="Hello, world!";

	print_string ((uint64_t)s);
};
_PRE_END

<p>Both source codes resulting in the same assembly output:</p>

_PRE_BEGIN
gcc 1.c -S -masm=intel -O3 -fno-inline
_PRE_END

_PRE_BEGIN
load_byte_at_address:
	movzx	eax, BYTE PTR [rdi]
	ret
print_string:
.LFB15:
	push	rbx
	mov	rbx, rdi
	jmp	.L4
.L7:
	movsx	edi, al
	add	rbx, 1
	call	putchar
.L4:
	mov	rdi, rbx
	call	load_byte_at_address
	test	al, al
	jne	.L7
	pop	rbx
	ret
.LC0:
	.string	"Hello, world!"
main:
	sub	rsp, 8
	mov	edi, OFFSET FLAT:.LC0
	call	print_string
	add	rsp, 8
	ret
_PRE_END

<p>(I have also removed all insignificant GCC directives).</p>

<p>No difference: C/C++ pointers are essentially addresses, but supplied with type information, in order to prevent possible mistakes at the time of compilation.
Types are not checked during runtime - it would be huge (and unneeded) overhead.</p>

<hr>
<p>My other blog posts about C/C++ pointers: [
_HTML_LINK(`http://yurichev.com/blog/ptrs',`1') |
_HTML_LINK(`http://yurichev.com/blog/ptrs2',`2') |
_HTML_LINK(`http://yurichev.com/blog/ptrs3',`3') |
_HTML_LINK(`http://yurichev.com/blog/ptrs4',`4') |
_HTML_LINK(`http://yurichev.com/blog/ptrs5',`5') ]
</p>

_BLOG_FOOTER_GITHUB(`ptrs')

_BLOG_FOOTER()

