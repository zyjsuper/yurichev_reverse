m4_include(`commons.m4')

_HEADER_HL1(`22-Dec-2009: Rare x86 instruction')

<p>Together with LOOP x86 instruction, it seems, one more os rare used: RCL (rotate through carry left).</p>
<p>LOOP in known as not optimized by Intel anymore, probably this is the reason modern compilers do not generate code with it.</p>
<p>RCL, probably, compilers blind spot:</p>
<p>... absent in Oracle 11.1.0.7.0 Win32 oracle (compiled by Intel C++).</p>
<p>... absent in ntoskrnl.exe file (windows kernel) from Windows 7 x64 (MS Visual C compiler).</p>
<p>... absent in ntoskrnl.exe file (windows kernel) from Windows 2003 x86 (MS Visual C compiler): but present only in  RtlExtendedLargeIntegerDivide function, and this might be inline assembler code case.</p>
<p>Linux kernel 2.6.18 x86 compiled with GCC 4.1.2 - only few occurrences, but it seems, it is just incorrectly disassembled, because it lay right after UD2 (generates an invalid opcode) instructions.</p>

_BLOG_FOOTER_GITHUB(`31')

_BLOG_FOOTER()

