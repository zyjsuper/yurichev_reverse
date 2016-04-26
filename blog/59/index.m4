m4_include(`commons.m4')

_HEADER_HL1(`14-Jan-2011: Generic tracer 0.5 beta')

<p>Generic Tracer 0.5 beta is published for testing.</p>

<p>Among fixes and one small feature (see <a href="http://conus.info/gt/gt05beta/manual/changelog.txt">changelog.txt</a> file), major feature I added is TRACE.</p>

<p><b>TRACE</b>: trace each instruction in function and collect all interesting values from registers and memory. After execution, all that information is saved to process.exe.idc, process.exe.txt, process.exe_clear.idc files. .idc-files are IDA scripts, .txt file is grepable by grep, awk and sed.</p>

<p>For example, let's take add_member function from <a href="http://research.swtch.com/2008/03/using-uninitialized-memory-for-fun-and.html">Using Uninitialized Memory for Fun and Profit</a> article:</p>

_PRE_BEGIN
int dense[256];
int dense_next=0;
int sparse[256];

void add_member(int i)
{
	dense[dense_next]=i;
	sparse[i]=dense_next;
	dense_next++;

};

int main ()
{
	add_member(123);
	add_member(5);
	add_member(71);
	add_member(99);
}
_PRE_END

<p>Let's compile it and run tracing on add_member function (determine function address in IDA before):</p>

_PRE_BEGIN
gt -l:trace_test4.exe bpf=0x00401000,trace
_PRE_END

<p>We'll get trace_test4.exe.txt file:</p>

_PRE_BEGIN
0x401000, e=       4
0x401001, e=       4
0x401003, e=       4, [0x403818]=0..3
0x401008, e=       4, [EBP+8]=5, 0x47('G'), 0x63('c'), 0x7b('{')
0x40100b, e=       4, ECX=5, 0x47('G'), 0x63('c'), 0x7b('{')
0x401012, e=       4, [EBP+8]=5, 0x47('G'), 0x63('c'), 0x7b('{')
0x401015, e=       4, [0x403818]=0..3
0x40101a, e=       4, EAX=0..3
0x401021, e=       4, [0x403818]=0..3
0x401027, e=       4, ECX=0..3
0x40102a, e=       4, ECX=1..4
0x401030, e=       4
0x401031, e=       4, EAX=0..3
_PRE_END

<p><i>e</i> field in how many times was executed this instruction.</p>

<p>Let's execute trace_test4.exe.idc script in IDA and we'll see:</p>

<!-- FIXME -->
<img src="http://conus.info/gt/gt05beta/manual/trace_test4.png">

<p>Now it is much simpler to understand how this function work during execution.</p>

<p>Executed instructions are highlighed by blue color. Not-executed instructions are leaved white.</p>

<p>If you need to clear all comments and highlight, execute trace_test4.exe_clear.idc script.</p>

<p>All collected information in IDA-script may be reduced to shorten form like <i>EAX=[ 64 unique items. min=0xbca6eb7, max=0xffffffed ]</i> (because IDA has comment size limitation). On contrary, everything is saved to text file without shortening, that is why resulting text file may be sometimes pretty big.</p>

<p>One problem of TRACE feature that it is slow, however, functions from system DLLs are skipped (system DLL is that DLL residing in %SystemRoot%) Another problem is that things like exceptions, setjmp/longjmp and other unexpected codeflow alterations are not correctly handled so far.</p>

<p>One more problem is that this feature is only available in x86 (because only x86-disassembler currently present in gt project)</p>

<p>More examples: _HTML_LINK_AS_IS(`http://conus.info/gt/gt05beta/manual/gt.html#bpf_ex_trace')</p>

<p>Download gt executables, source code and manuals: _HTML_LINK_AS_IS(`http://conus.info/gt/gt05beta/gt05beta.rar')</p>

_BLOG_FOOTER_GITHUB(`59')

_BLOG_FOOTER()

