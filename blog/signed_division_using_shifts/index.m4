m4_include(`commons.m4')

_HEADER_HL1(`22-Apr-2016: Signed division using shifts')

<p>Unsigned division by $2^n$ numbers is easy, just use bit shift right by $n$.
Signed division by $2^n$ is easy as well, but some correction needs to be done before or after shift opeartion.</p>

<p>First, most CPU architectures supports two right shift operations: logical and arithmetical.
During logical shift right, free bit(s) at left are set to zero bit(s).
During arithmetical shift right, free bit(s) at left are set equal to the bit which was at the same place.</p>

<p>Hence, arithmetical shift right is used for signed numbers.
For example, if you shift -4 (11111100b) by 1 bit right, logical shift right operation will produce 01111110b, which is 126.
Arithmetical shift right will produce 11111110b, which is -2.
So far so good.</p>

<p>What if we need to divide -5 by 2? This is 2.5 in, but just 2 in integer arithmetic.
-5 is 11111011b, shifting this value by 1 bit right, we'll get 11111101b, which is -3.
This is slightly incorrect.</p>

<p>Another example: $\frac{-1}{2}=0.5$ or just 0 in integer arithmetic.
But -1 is 11111111b, and 11111111b >> 1 = 11111111b, which is -1 again.
This is also incorrect.</p>

<p>One solution is to add 1 to the input value if it's negative.</p>

<p>That is why, if we compile "x/2" expression, where x is <i>signed int</i>, GCC 4.8 will produce something like that:</p>

_PRE_BEGIN
	mov	eax, edi
	shr	eax, 31  ; isolate leftmost bit, which is 1 if the number is negative and 0 if positive
	add	eax, edi ; add 1 to the input value if it's negative, do nothing otherwise
	sar	eax      ; arithmetical shift right by one bit
	ret
_PRE_END

<p>If you divide by 4, 3 will needs to be added to the input value if it's negative. So this is what GCC 4.8 does for "x/4":</p>

_PRE_BEGIN
	lea	eax, [rdi+3] ; prepare x+3 value ahead of time
	test	edi, edi
	
	; if the sign is not negative (i.e., positive), move input value to EAX
	; if the sign is negative, x+3 value is left in EAX untouched
	cmovns	eax, edi
	; do arithmetical shift right by 2 bits
	sar	eax, 2
	ret
_PRE_END

<p>If you divide by 8, 7 will be added to the input value, etc.</p>

<p>MSVC 2013 is slightly different. This is division by 2:</p>

_PRE_BEGIN
	mov	eax, DWORD PTR _a$[esp-4]
	; sign-extend input value to 64-bit value into EDX:EAX
	; effectively, that means EDX will be set to 0FFFFFFFFh if the input value is negative
	; ... or to 0 if positive
	cdq
	; subtract -1 from input value if it's negative
	; this is the same as adding 1
	sub	eax, edx 
	; do arithmetical shift right
	sar	eax, 1
	ret	0
_PRE_END

<p>Division by 4 in MSVC 2013 is little more complex:</p>

_PRE_BEGIN
	mov	eax, DWORD PTR _a$[esp-4]
	cdq
	; now EDX is 0FFFFFFFFh if input value is negative
	; EDX is 0 if it's positive
	and	edx, 3
	; now EDX is 3 if input is negative or 0 otherwise
	; add 3 to input value if it's negative or do nothing otherwise:
	add	eax, edx
	; do arithmetical shift
	sar	eax, 2
	ret	0
_PRE_END

<p>Division by 8 in MSVC 2013 is similar, but 3 bits from EDX is taken instead of 2, producing correction value of 7 instead of 3.</p>

<p>Sometimes, Hex-Rays 6.8 can't handle such code correctly, and it may produce something like this:</p>

_PRE_BEGIN
int v0;
...
__int64 v14
...
          
v14 = ...;
v0 = ((signed int)v14 - HIDWORD(v14)) >> 1;
_PRE_END

<p>... it can be safely rewritten to "v0=v14/2".</p>

<p>Also, such correction code is used often when division is replaced by multiplication by "magic numbers": 
read _HTML_LINK(`http://yurichev.com/blog/modulo/',`here') about multiplicative inverse.
And sometimes, additional shifting is used after multiplication.
For example, when GCC optimizes $\frac{x}{10}$, it can't find multiplicative inverse for 10, because diophantine equation has no solutions.
So it generates code for $\frac{x}{5}$ and then adds arithmetical shift right operation by 1 bit, to divide the result by 2.
Of course, this is only valid for signed integers.</p>

<p>So here is division by 10 by GCC 4.8:</p>

_PRE_BEGIN
	mov	eax, edi
	mov	edx, 1717986919 ; magic number
	sar	edi, 31         ; isolate leftmost bit
	imul	edx             ; multiplication by magic number, do x/5
	sar	edx, 2          ; do (x/5)/2

        ; subtract -1 (or add 1) if the input value was negative.
	; do nothing otherwise:
	sub	edx, edi        
	mov	eax, edx
	ret
_PRE_END

<p>Summary: $2^n-1$ must be added to input value before arithmetical shift, or 1 must be added to the final result after shift.</p>

_BLOG_FOOTER_GITHUB(`signed_division_using_shifts')

_BLOG_FOOTER()

