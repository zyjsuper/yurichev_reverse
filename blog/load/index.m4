m4_include(`commons.m4')

_HEADER_HL1(`Loading a constant into register using ASCII-only x86 code')

<p>... this is a task often required when constructing shellcodes.
I'm not sure if this is still relevant these days, however, it was fun to do it.</p>

<p>I've picked 3 instructions with ASCII-only opcodes:</p>

_PRE_BEGIN
26 25 xx xx xx xx    and     eax, imm32
26 2D xx xx xx xx    sub     eax, imm32
26 35 xx xx xx xx    xor     eax, imm32
_PRE_END

<p>Will it be possible to generate such a sequence of instructions, so that the arbitrary 32-bit constant would be loaded
into EAX regiser?
Given the fact that the initial value of EAX is unknown, because, let's say, we can't reset it?
Surely, all 32-bit operands must have ASCII-only bytes as well.</p>

<p>The answer is... using Z3 SMT-solver:</p>

_PRE_BEGIN
m4_include(`blog/load/load_const.py')
_PRE_END

<p>This is reworked and simplified piece of code I've already used in my 
"_HTML_LINK(`https://yurichev.com/writings/SAT_SMT_by_example.pdf',`SAT/SMT by example')"
(under "Program Synthesis" section).</p>

<p>What it can generate for zero:</p>

_PRE_BEGIN
AND EAX, 0x3e5a3e28
AND EAX, 0x40214040
_PRE_END

<p>These two instructions clears EAX. You can understand how it works if you'll see these operands in binary form:</p>

_PRE_BEGIN
0x3e5a3e28 =    111110010110100011111000101000
0x40214040 =   1000000001000010100000001000000
_PRE_END

<p>It's best to have a zero bit for both operands, but this is not always possible, because each of 4 bytes in 32-bit operand
must be in [0x21..0x7e] range, so the Z3 solver find a way to reset other bits using second instruction.</p>

<p>Running it again:</p>

_PRE_BEGIN
AND EAX, 0x3c5e3621
AND EAX, 0x42214850
_PRE_END

<p>Operands are different, because SAT solver is probably initialized randomly.</p>

<p>Now 0x0badf00d:</p>

_PRE_BEGIN
AND EAX, 0x48273048
AND EAX, 0x31504325
XOR EAX, 0x61212251
SUB EAX, 0x55733244
_PRE_END

<p>First two AND instruction clears EAX, 3th and 4th makes 0x0badf00d value.</p>

<p>Now 0x12345678:</p>

_PRE_BEGIN
AND EAX, 0x41212230
XOR EAX, 0x292f2224
AND EAX, 0x365e4048
XOR EAX, 0x323a5678
_PRE_END

<p>Slightly different, but also correct.</p>

<p>For some constants, more instructions required:</p>

_PRE_BEGIN
CONST=0xf3c37766
...
AND EAX, 0x21283024
AND EAX, 0x58504050
SUB EAX, 0x31377b56
SUB EAX, 0x3f2f3b5e
XOR EAX, 0x7c5a3e2a
_PRE_END

<p>Now what if, for aesthetical reasons maybe, we would limit all printable characters to 0..9, a..z, A..Z (comment/uncomment
corresponding fragments of the source code)?
This is not a problem at all.</p>

<p>However, if to limit to a..z, A..Z, it needs more instructions, but this is still correct
(8 instructions to clear EAX register):</p>

_PRE_BEGIN
CONST=0x0
...
XOR EAX, 0x43685575
SUB EAX, 0x6c747a6f
XOR EAX, 0x59525541
AND EAX, 0x65755454
XOR EAX, 0x57416643
AND EAX, 0x76767757
SUB EAX, 0x556f7547
AND EAX, 0x42424242
_PRE_END

<p>However, 7 instructions for 0x12345678 constant:</p>

_PRE_BEGIN
CONST=0x12345678
...
AND EAX, 0x6f77414d
SUB EAX, 0x646b7845
AND EAX, 0x41674a54
SUB EAX, 0x47414744
AND EAX, 0x49486d41
XOR EAX, 0x53757778
AND EAX, 0x7274567a
_PRE_END

<p>Further work: use ForAll quantifier instead of randomly generated test inputs...
also, we could try INC EAX/DEC EAX instructions.</p>

_BLOG_FOOTER()

