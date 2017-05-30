m4_include(`commons.m4')

_HEADER_HL1(`30-May-2017: Using PIN DBI for XOR interception')

<p>PIN from Intel is a DBI (Dynamic Binary Instrumentation) tool.
That means, it takes compiled binary and inserts your instructions in it, where you want.</p>

<p>Let's try to intercept all XOR instructions.
These are heavily used in cryptography, and we can try to run WinRAR archiver in encryption mode with a hope
that some XOR instruction is indeed is used while encryption.</p>

<p>Here is the source code of my PIN tool: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/PIN_XOR/files/XOR_ins.cpp').</p>

<p>The code is almost self-explanatory: it scans input executable file for all XOR/PXOR instructions and inserts
a call to our function before each.
log_info() function first checks, if operands are different (since XOR is often used just to clear register,
like XOR EAX, EAX), and if they are different, it increments a counter at this EIP/RIP, so the statistics will be gathered.</p>

<p>I have prepared two files for test: test1.bin (30720 bytes) and test2.bin
(5547752 bytes), I'll compress them by RAR with password and see difference in statistics.</p>

<p>You'll also need to _HTML_LINK(`https://stackoverflow.com/questions/9560993/how-do-you-disable-aslr-address-space-layout-randomization-on-windows-7-x64',`turn off ASLR'),
so the PIN tool will report the same RIPs as in RAR executable.</p>

<p>Now let's run it:</p>

_PRE_BEGIN
c:\pin-3.2-81205-msvc-windows\pin.exe -t XOR_ins.dll -- rar a -pLongPassword tmp.rar test1.bin
c:\pin-3.2-81205-msvc-windows\pin.exe -t XOR_ins.dll -- rar a -pLongPassword tmp.rar test2.bin
_PRE_END

<p>Now here is statistics for the test1.bin: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/PIN_XOR/files/XOR_ins.out.test1').
... and for test2.bin: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/PIN_XOR/files/XOR_ins.out.test2').
So far, you can ignore all addresses other than ip=0x1400xxxxx, which are in other DLLs.</p>

<p>Now let's see a difference: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/PIN_XOR/files/XOR_ins.diff').</p>

<p>Some XOR instructions executed more often for test2.bin (which is bigger) than for test1.bin (which is smaller).
So these are clearly related to file size!</p>

<p>The first block of differences is:</p>

_PRE_BEGIN
< ip=0x140017b21 count=0xd84
< ip=0x140017b48 count=0x81f
< ip=0x140017b59 count=0x858
< ip=0x140017b6a count=0xc13
< ip=0x140017b7b count=0xefc
< ip=0x140017b8a count=0xefd
< ip=0x140017b92 count=0xb86
< ip=0x140017ba1 count=0xf01
---
> ip=0x140017b21 count=0x9eab5
> ip=0x140017b48 count=0x79863
> ip=0x140017b59 count=0x862e8
> ip=0x140017b6a count=0x99495
> ip=0x140017b7b count=0xa891c
> ip=0x140017b8a count=0xa89f4
> ip=0x140017b92 count=0x8ed72
> ip=0x140017ba1 count=0xa8a8a
_PRE_END

<p>This is indeed some kind of loop inside of RAR.EXE:</p>

_PRE_BEGIN
.text:0000000140017B21 loc_140017B21:
.text:0000000140017B21                 xor     r11d, [rbx]
.text:0000000140017B24                 mov     r9d, [rbx+4]
.text:0000000140017B28                 add     rbx, 8
.text:0000000140017B2C                 mov     eax, r9d
.text:0000000140017B2F                 shr     eax, 18h
.text:0000000140017B32                 movzx   edx, al
.text:0000000140017B35                 mov     eax, r9d
.text:0000000140017B38                 shr     eax, 10h
.text:0000000140017B3B                 movzx   ecx, al
.text:0000000140017B3E                 mov     eax, r9d
.text:0000000140017B41                 shr     eax, 8
.text:0000000140017B44                 mov     r8d, [rsi+rdx*4]
.text:0000000140017B48                 xor     r8d, [rsi+rcx*4+400h]
.text:0000000140017B50                 movzx   ecx, al
.text:0000000140017B53                 mov     eax, r11d
.text:0000000140017B56                 shr     eax, 18h
.text:0000000140017B59                 xor     r8d, [rsi+rcx*4+800h]
.text:0000000140017B61                 movzx   ecx, al
.text:0000000140017B64                 mov     eax, r11d
.text:0000000140017B67                 shr     eax, 10h
.text:0000000140017B6A                 xor     r8d, [rsi+rcx*4+1000h]
.text:0000000140017B72                 movzx   ecx, al
.text:0000000140017B75                 mov     eax, r11d
.text:0000000140017B78                 shr     eax, 8
.text:0000000140017B7B                 xor     r8d, [rsi+rcx*4+1400h]
.text:0000000140017B83                 movzx   ecx, al
.text:0000000140017B86                 movzx   eax, r9b
.text:0000000140017B8A                 xor     r8d, [rsi+rcx*4+1800h]
.text:0000000140017B92                 xor     r8d, [rsi+rax*4+0C00h]
.text:0000000140017B9A                 movzx   eax, r11b
.text:0000000140017B9E                 mov     r11d, r8d
.text:0000000140017BA1                 xor     r11d, [rsi+rax*4+1C00h]
.text:0000000140017BA9                 sub     rdi, 1
.text:0000000140017BAD                 jnz     loc_140017B21
_PRE_END

<p>What it does? No idea yet.</p>

<p>The next:</p>

_PRE_BEGIN
< ip=0x14002c4f1 count=0x4fce
---
> ip=0x14002c4f1 count=0x4463be
_PRE_END

<p>0x4fce is 20430, which is close to size of test1.bin (30720 bytes).
0x4463be is 4481982 which is close to size of test2.bin (5547752 bytes).
Not equal, but close.</p>

<p>This is a piece of code with that XOR instruction:</p>

_PRE_BEGIN
.text:000000014002C4EA loc_14002C4EA:
.text:000000014002C4EA                 movzx   eax, byte ptr [r8]
.text:000000014002C4EE                 shl     ecx, 5
.text:000000014002C4F1                 xor     ecx, eax
.text:000000014002C4F3                 and     ecx, 7FFFh
.text:000000014002C4F9                 cmp     [r11+rcx*4], esi
.text:000000014002C4FD                 jb      short loc_14002C507
.text:000000014002C4FF                 cmp     [r11+rcx*4], r10d
.text:000000014002C503                 ja      short loc_14002C507
.text:000000014002C505                 inc     ebx
_PRE_END

<p>Loop body can be written as <b>state = input_byte ^ (state<<5) & 0x7FFF</b>.
<i>state</i> is then used as index in some table. Is this some kind of CRC? I don't know, but this could be a checksumming routine.
Or maybe optimized CRC routine? Any ideas?</p>

<p>The next block:</p>

_PRE_BEGIN
< ip=0x14004104a count=0x367
< ip=0x140041057 count=0x367
---
> ip=0x14004104a count=0x24193
> ip=0x140041057 count=0x24193
_PRE_END

_PRE_BEGIN
.text:0000000140041039 loc_140041039:
.text:0000000140041039                 mov     rax, r10
.text:000000014004103C                 add     r10, 10h
.text:0000000140041040                 cmp     byte ptr [rcx+1], 0
.text:0000000140041044                 movdqu  xmm0, xmmword ptr [rax]
.text:0000000140041048                 jz      short loc_14004104E
.text:000000014004104A                 pxor    xmm0, xmm1
.text:000000014004104E
.text:000000014004104E loc_14004104E:
.text:000000014004104E                 movdqu  xmm1, xmmword ptr [rcx+18h]
.text:0000000140041053                 movsxd  r8, dword ptr [rcx+4]
.text:0000000140041057                 pxor    xmm1, xmm0
.text:000000014004105B                 cmp     r8d, 1
.text:000000014004105F                 jle     short loc_14004107C
.text:0000000140041061                 lea     rdx, [rcx+28h]
.text:0000000140041065                 lea     r9d, [r8-1]
.text:0000000140041069
.text:0000000140041069 loc_140041069:
.text:0000000140041069                 movdqu  xmm0, xmmword ptr [rdx]
.text:000000014004106D                 lea     rdx, [rdx+10h]
.text:0000000140041071                 aesenc  xmm1, xmm0
.text:0000000140041076                 sub     r9, 1
.text:000000014004107A                 jnz     short loc_140041069
.text:000000014004107C
_PRE_END

<p>This piece has both PXOR and AESENC instructions (the last is AES encryption instruction).
So yes, we found encryption function, RAR uses AES.</p>

<p>There is also another big block of almost contiguous XOR instructions:</p>

_PRE_BEGIN
< ip=0x140043e10 count=0x23006
---
> ip=0x140043e10 count=0x23004
499c510
< ip=0x140043e56 count=0x22ffd
---
> ip=0x140043e56 count=0x23002
_PRE_END

<p>But, its count is not very different during compressing/encrypting test1.bin/test2.bin.
What is on these addresses?</p>

_PRE_BEGIN
.text:0000000140043E07                 xor     ecx, r9d
.text:0000000140043E0A                 mov     r11d, eax
.text:0000000140043E0D                 and     ecx, r10d
.text:0000000140043E10                 xor     ecx, r8d
.text:0000000140043E13                 rol     eax, 8
.text:0000000140043E16                 and     eax, esi
.text:0000000140043E18                 ror     r11d, 8
.text:0000000140043E1C                 add     edx, 5A827999h
.text:0000000140043E22                 ror     r10d, 2
.text:0000000140043E26                 add     r8d, 5A827999h
.text:0000000140043E2D                 and     r11d, r12d
.text:0000000140043E30                 or      r11d, eax
.text:0000000140043E33                 mov     eax, ebx
_PRE_END

<p>Let's google 5A827999h constant... this looks like SHA-1! But why would RAR use SHA-1 during encryption?</p>

<p>Here is the answer:</p>

<blockquote>
In comparison, WinRAR uses its own key derivation scheme that requires (password length * 2 + 11)*4096 SHA-1 transformations. That’s why it takes longer to brute-force attack encrypted WinRAR archives.
</blockquote>
<p>( _HTML_LINK_AS_IS(`http://www.tomshardware.com/reviews/password-recovery-gpu,2945-8.html') )</p>

<p>This is key scheduling: input password hashed many times and the hash is then used as AES key.
This is why we see the count of XOR instruction is almost unchanged during we switched to bigger test file.</p>

<p>This is it, it took couple of hours for me to write this tool and to get at least 3 points: 1) probably checksumming; 2) AES encryption; 3) SHA-1 calculation.
The first function is still unknown for me.</p>

<p>Still, this is impressive, because I didn't dig into RAR code (which is proprietary, of course). I didn't even peek into UnRAR source code (which is available).</p>

<p>The files, including test files and RAR executable I've used (win64, 5.40): _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/PIN_XOR/files').</p>

_HL2(`Why "instrumentation"?')

<p>Perhaps, this is term of code profiling.
There are at least two methods:
1) "sampling": you break into running code as many times as possible (hundreds per second), and see, where it is executed at the moment;
2) "instrumentation": compiled code is interleaved with other code, which can increment counters, etc.</p>

<p>Perhaps, DBI tools inherited the term?</p>

_BLOG_FOOTER()

