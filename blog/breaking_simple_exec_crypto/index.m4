m4_include(`commons.m4')

_HEADER_HL1(`6-May-2016: Breaking simple executable cryptor')

<p>I've got an executable file which is encrypted by relatively simple encryption.
_HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/breaking_simple_exec_crypto/files/cipher.bin',`Here is it') (only executable section is left).</p>

<p>First, all encryption function does is just adds number of position in buffer to the byte.
Here is how this can be encoded in Python:</p>

_PRE_BEGIN
#!/usr/bin/env python
def e(i, k):
    return chr ((ord(i)+k) % 256)

def encrypt(buf):
    return e(buf[0], 0)+ e(buf[1], 1)+ e(buf[2], 2) + e(buf[3], 3)+ e(buf[4], 4)+ e(buf[5], 5)+ e(buf[6], 6)+ e(buf[7], 7)+
           e(buf[8], 8)+ e(buf[9], 9)+ e(buf[10], 10)+ e(buf[11], 11)+ e(buf[12], 12)+ e(buf[13], 13)+ e(buf[14], 14)+ e(buf[15], 15)
_PRE_END

<p>Hence, if you encrypt buffer with 16 zeroes, you'll get <i>0, 1, 2, 3 ... 12, 13, 14, 15</i></p>

<p>_HTML_LINK(`https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Propagating_Cipher_Block_Chaining_.28PCBC.29',`Propagating Cipher Block Chaining (PCBC)')
is also used, here is how it works (image is taken from Wikipedia article):</p>

<center><img src="//yurichev.com/blog/breaking_simple_exec_crypto/601px-PCBC_encryption.svg.png"></center>

<p>The problem is that it's too boring to recover IV (Initialization Vector) each time.
Brute-force is also not an option, because IV is too long (16 bytes).
Let's see, if it's possible to recover IV for arbitrary encrypted executable file?</p>

<p>Let's try simple _HTML_LINK(`https://en.wikipedia.org/wiki/Frequency_analysis',`frequency analysis').
This is 32-bit x86 executable code, so let's gather statistics about most frequent bytes and opcodes.
I tried huge oracle.exe file from Oracle RDBMS version 11.2 for windows x86 and I've found that the most frequent byte (no surprise) is zero (~10%).
The next most frequent byte is (again, no surprise) 0xFF (~5%).
The next is 0x8B (~5%).</p>

<p>0x8B is opcode for MOV, this is indeed one of the most busy x86 instructions.
Now what about popularity of zero byte?
If compiler needs to encode value bigger than 127, it has to use 32-bit displacement instead of 8-bit one, but large values are very rare,
so it is padded by zeroes.
This is at least in LEA, MOV, PUSH, CALL.</p>

<p>For example:</p>

_PRE_BEGIN
8D B0 28 01 00 00                 lea     esi, [eax+128h]
8D BF 40 38 00 00                 lea     edi, [edi+3840h]
_PRE_END

<p>Displacements bigger than 127 are very popular, but they are rarely exceeds 0x10000 (indeed, such large memory buffers/structures are also rare).</p>

<p>Same story with MOV, large constants are rare, the most heavily used are 0, 1, 10, 100, $2^n$, and so on.
Compiler has to pad small constants by zeroes to represent them as 32-bit values:</p>

_PRE_BEGIN
BF 02 00 00 00                    mov     edi, 2
BF 01 00 00 00                    mov     edi, 1
_PRE_END

<p>Now about 00 and FF bytes combined: jumps (including conditional) and calls can pass execution flow forward or backwards, but very often,
within the limits of the current executable module.
If forward, displacement is not very big and also padded with zeroes.
If backwards, displacement is represented as negative value, so padded with FF bytes.
For example, transfer execution flow forward:</p>

_PRE_BEGIN
E8 43 0C 00 00                    call    _function1
E8 5C 00 00 00                    call    _function2
0F 84 F0 0A 00 00                 jz      loc_4F09A0
0F 84 EB 00 00 00                 jz      loc_4EFBB8
_PRE_END

<p>Backwards:</p>

_PRE_BEGIN
E8 79 0C FE FF                    call    _function1
E8 F4 16 FF FF                    call    _function2
0F 84 F8 FB FF FF                 jz      loc_8212BC
0F 84 06 FD FF FF                 jz      loc_FF1E7D
_PRE_END

<p>FF byte is also very often occurred in negative displacements like these:</p>

_PRE_BEGIN
8D 85 1E FF FF FF                 lea     eax, [ebp-0E2h]
8D 95 F8 5C FF FF                 lea     edx, [ebp-0A308h]
_PRE_END

<p>So far so good. Now we need to try various 16-byte keys, decrypt executable section and measure how often 00, FF ad 8B bytes are occurred.
Let's also keep in sight how PCBC decryption works:</p>

<center><img src="//yurichev.com/blog/breaking_simple_exec_crypto/640px-PCBC_decryption.svg.png"></center>

<p>The good news is that we don't really need to decrypt whole piece of data, but only slice by slice, this is exactly how I did in my previous example:
_HTML_LINK_AS_IS(`//yurichev.com/blog/XOR_mask_2/').</p>

<p>Now I'm trying all possible bytes (0..255) for each byte in key and just pick the byte producing maximal amount of 00/FF/8B bytes in a decrypted slice:</p>

_PRE_BEGIN
#!/usr/bin/env python
import sys, hexdump, array, string, operator

KEY_LEN=16

def chunks(l, n):
    # split n by l-byte chunks
    # http://stackoverflow.com/questions/312443/how-do-you-split-a-list-into-evenly-sized-chunks-in-python
    n = max(1, n)
    return [l[i:i + n] for i in range(0, len(l), n)]

def read_file(fname):
    file=open(fname, mode='rb')
    content=file.read()
    file.close()
    return content

def decrypt_byte (c, key):
    return chr((ord(c)-key) % 256)

def XOR_PCBC_step (IV, buf, k):
    prev=IV
    rt=""
    for c in buf:
	new_c=decrypt_byte(c, k)
        plain=chr(ord(new_c)^ord(prev))
	prev=chr(ord(c)^ord(plain))
	rt=rt+plain
    return rt

each_Nth_byte=[""]*KEY_LEN

content=read_file(sys.argv[1])
# split input by 16-byte chunks:
all_chunks=chunks(content, KEY_LEN)
for c in all_chunks:
    for i in range(KEY_LEN):
        each_Nth_byte[i]=each_Nth_byte[i] + c[i]

# try each byte of key
for N in range(KEY_LEN):
    print "N=", N
    stat={}
    for i in range(256):
        tmp_key=chr(i)
	tmp=XOR_PCBC_step(tmp_key,each_Nth_byte[N], N)
        # count 0, FFs and 8Bs in decrypted buffer:
	important_bytes=tmp.count('\x00')+tmp.count('\xFF')+tmp.count('\x8B')
	stat[i]=important_bytes
    sorted_stat = sorted(stat.iteritems(), key=operator.itemgetter(1), reverse=True)
    print sorted_stat[0]
_PRE_END

<p>(Source code can downloaded _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/breaking_simple_exec_crypto/files/decrypt.py',`here')).</p>

<p>I run it and here is a key for which 00/FF/8B bytes presence in decrypted buffer is maximal:</p>

_PRE_BEGIN
N= 0
(147, 1224)
N= 1
(94, 1327)
N= 2
(252, 1223)
N= 3
(218, 1266)
N= 4
(38, 1209)
N= 5
(192, 1378)
N= 6
(199, 1204)
N= 7
(213, 1332)
N= 8
(225, 1251)
N= 9
(112, 1223)
N= 10
(143, 1177)
N= 11
(108, 1286)
N= 12
(10, 1164)
N= 13
(3, 1271)
N= 14
(128, 1253)
N= 15
(232, 1330)
_PRE_END

<p>Let's write decryption utility with the key we got:</p>

_PRE_BEGIN
#!/usr/bin/env python
import sys, hexdump, array

def xor_strings(s,t):
    # https://en.wikipedia.org/wiki/XOR_cipher#Example_implementation
    """xor two strings together"""
    return "".join(chr(ord(a)^ord(b)) for a,b in zip(s,t))

IV=array.array('B', [147, 94, 252, 218, 38, 192, 199, 213, 225, 112, 143, 108, 10, 3, 128, 232]).tostring()

def chunks(l, n):
    n = max(1, n)
    return [l[i:i + n] for i in range(0, len(l), n)]

def read_file(fname):
    file=open(fname, mode='rb')
    content=file.read()
    file.close()
    return content

def decrypt_byte(i, k):
    return chr ((ord(i)-k) % 256)

def decrypt(buf):
    return "".join(decrypt_byte(buf[i], i) for i in range(16))

fout=open(sys.argv[2], mode='wb')

prev=IV
content=read_file(sys.argv[1])
tmp=chunks(content, 16)
for c in tmp:
    new_c=decrypt(c)
    p=xor_strings (new_c, prev)
    prev=xor_strings(c, p)
    fout.write(p)
fout.close()
_PRE_END

<p>(Source code can downloaded _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/breaking_simple_exec_crypto/files/decrypt2.py',`here')).</p>

<p>Let's check resulting file:</p>

_PRE_BEGIN
$ objdump -b binary -m i386 -D decrypted.bin

...

       5:       8b ff                   mov    %edi,%edi
       7:       55                      push   %ebp
       8:       8b ec                   mov    %esp,%ebp
       a:       51                      push   %ecx
       b:       53                      push   %ebx
       c:       33 db                   xor    %ebx,%ebx
       e:       43                      inc    %ebx
       f:       84 1d a0 e2 05 01       test   %bl,0x105e2a0
      15:       75 09                   jne    0x20
      17:       ff 75 08                pushl  0x8(%ebp)
      1a:       ff 15 b0 13 00 01       call   *0x10013b0
      20:       6a 6c                   push   $0x6c
      22:       ff 35 54 d0 01 01       pushl  0x101d054
      28:       ff 15 b4 13 00 01       call   *0x10013b4
      2e:       89 45 fc                mov    %eax,-0x4(%ebp)
      31:       85 c0                   test   %eax,%eax
      33:       0f 84 d9 00 00 00       je     0x112
      39:       56                      push   %esi
      3a:       57                      push   %edi
      3b:       6a 00                   push   $0x0
      3d:       50                      push   %eax
      3e:       ff 15 b8 13 00 01       call   *0x10013b8
      44:       8b 35 bc 13 00 01       mov    0x10013bc,%esi
      4a:       8b f8                   mov    %eax,%edi
      4c:       a1 e0 e2 05 01          mov    0x105e2e0,%eax
      51:       3b 05 e4 e2 05 01       cmp    0x105e2e4,%eax
      57:       75 12                   jne    0x6b
      59:       53                      push   %ebx
      5a:       6a 03                   push   $0x3
      5c:       57                      push   %edi
      5d:       ff d6                   call   *%esi

...

_PRE_END

<p>Yes, this is seems correctly disassembled piece of x86 code.
The whole dectyped file can be downloaded _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/breaking_simple_exec_crypto/files/decrypted.bin',`here').</p>

<p>In fact, this is text section from regedit.exe from Windows 7.
But this example is based on a real case I encountered, so just executable is different (and key), algorithm is the same.</p>

_HL2(`Other ideas to consider')

<p>What if I would fail with such simple frequency analysis?
There are other ideas on how to measure correctness of decrypted/decompressed x86 code:</p>

<ul>
<li>Many modern compilers aligns functions on 0x10 border.
So the space left before is filled with NOPs (0x90) or other NOP instructions with known opcodes:
_HTML_LINK_AS_IS(`//beginners.re/22-Apr-2016/RE4B-EN.pdf#page=876&zoom=auto,-107,683').

<li>Probably, the most frequent pattern in any assembly language is function call: <i>PUSH chain / CALL / ADD ESP, X</i>.
This sequence can easily detected and found.
I've even gathered statistics about average number of function arguments: _HTML_LINK_AS_IS(`//yurichev.com/blog/args_stat/') 
(hence, this is average lenght of PUSH chain).

</ul>

<p>By the way, 
it is interesting to know that the fact that function calls (PUSH/CALL/ADD) and MOV instructions are the most frequently executed pieces of code in almost all
programs we use.
In other words, CPU is very busy passing information between levels of abstractions, or, it can be said, it's very busy switching between these levels.
This is a cost of splitting problems into several levels of abstractions.</p>

_BLOG_FOOTER_GITHUB(`breaking_simple_exec_crypto')

_BLOG_FOOTER()

