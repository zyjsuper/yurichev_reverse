m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #5 (for x86, ARM, ARM64, MIPS)')

<p>What this code does?</p>

<p>Optimizing GCC 4.8.2:</p>

<!--
_PRE_BEGIN
<f>:
   0:	 	push   rbp
   1:	 	mov    rbp,rsp
   4:	 	mov    QWORD PTR [rbp-0x28],rdi
   8:	 	mov    QWORD PTR [rbp-0x30],rsi
   c:	 	mov    QWORD PTR [rbp-0x38],rdx
  10:	 	mov    QWORD PTR [rbp-0x40],rcx
  14:	 	mov    rax,QWORD PTR [rbp-0x40]
  18:	 	cmp    rax,QWORD PTR [rbp-0x30]
  1c:	 	jbe    28 <f+0x28>
  1e:	 	mov    eax,0x0
  23:	 	jmp    b5 <f+0xb5>
  28:	 	mov    QWORD PTR [rbp-0x10],0x0
  2f:	
  30:	 	jmp    98 <f+0x98>
  32:	 	mov    DWORD PTR [rbp-0x14],0x0
  39:	 	mov    QWORD PTR [rbp-0x8],0x0
  40:	
  41:	 	jmp    76 <f+0x76>
  43:	 	mov    rax,QWORD PTR [rbp-0x8]
  47:	 	mov    rdx,QWORD PTR [rbp-0x10]
  4b:	 	add    rdx,rax
  4e:	 	mov    rax,QWORD PTR [rbp-0x28]
  52:	 	add    rax,rdx
  55:	 	movzx  edx,BYTE PTR [rax]
  58:	 	mov    rax,QWORD PTR [rbp-0x10]
  5c:	 	mov    rcx,QWORD PTR [rbp-0x38]
  60:	 	add    rax,rcx
  63:	 	movzx  eax,BYTE PTR [rax]
  66:	 	cmp    dl,al
  68:	 	je     71 <f+0x71>
  6a:	 	mov    DWORD PTR [rbp-0x14],0x1
  71:	 	add    QWORD PTR [rbp-0x8],0x1
  76:	 	mov    rax,QWORD PTR [rbp-0x8]
  7a:	 	cmp    rax,QWORD PTR [rbp-0x40]
  7e:	 	jb     43 <f+0x43>
  80:	 	cmp    DWORD PTR [rbp-0x14],0x0
  84:	 	jne    93 <f+0x93>
  86:	 	mov    rax,QWORD PTR [rbp-0x10]
  8a:	 	mov    rdx,QWORD PTR [rbp-0x28]
  8e:	 	add    rax,rdx
  91:	 	jmp    b5 <f+0xb5>
  93:	 	add    QWORD PTR [rbp-0x10],0x1
  98:	 	mov    rax,QWORD PTR [rbp-0x40]
  9c:	 	mov    rdx,QWORD PTR [rbp-0x30]
  a0:	 	sub    rdx,rax
  a3:	 	mov    rax,rdx
  a6:	 	add    rax,0x1
  aa:	 	cmp    rax,QWORD PTR [rbp-0x10]
  ae:	 	ja     32 <f+0x32>
  b0:	 	mov    eax,0x0
  b5:	 	pop    rbp
  b6:	 	ret    
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>	 	<span style='color:#800000; font-weight:bold; '>push</span>   rbp
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;1:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rbp<span style='color:#808030; '>,</span>rsp
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x28</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span>rdi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;8:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x30</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span>rsi
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;c:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x38</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span>rdx
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x40</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span>rcx
<span style='color:#e34adc; '>&#xa0;&#xa0;14:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x40</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;18:</span>	 	<span style='color:#800000; font-weight:bold; '>cmp</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x30</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1c:</span>	 	<span style='color:#800000; font-weight:bold; '>jbe</span>    <span style='color:#e34adc; '>28</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x28</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1e:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;23:</span>	 	<span style='color:#800000; font-weight:bold; '>jmp</span>    <span style='color:#e34adc; '>b5</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0xb5</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;28:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;2f:</span>	
<span style='color:#e34adc; '>&#xa0;&#xa0;30:</span>	 	<span style='color:#800000; font-weight:bold; '>jmp</span>    <span style='color:#e34adc; '>98</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x98</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;32:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>DWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x14</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;39:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x8</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;40:</span>	
<span style='color:#e34adc; '>&#xa0;&#xa0;41:</span>	 	<span style='color:#800000; font-weight:bold; '>jmp</span>    <span style='color:#e34adc; '>76</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x76</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;43:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x8</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;47:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rdx<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;4b:</span>	 	<span style='color:#800000; font-weight:bold; '>add</span>    rdx<span style='color:#808030; '>,</span>rax
<span style='color:#e34adc; '>&#xa0;&#xa0;4e:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x28</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;52:</span>	 	<span style='color:#800000; font-weight:bold; '>add</span>    rax<span style='color:#808030; '>,</span>rdx
<span style='color:#e34adc; '>&#xa0;&#xa0;55:</span>	 	<span style='color:#800000; font-weight:bold; '>movzx</span>  <span style='color:#000080; '>edx</span><span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>BYTE</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rax<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;58:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;5c:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rcx<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x38</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;60:</span>	 	<span style='color:#800000; font-weight:bold; '>add</span>    rax<span style='color:#808030; '>,</span>rcx
<span style='color:#e34adc; '>&#xa0;&#xa0;63:</span>	 	<span style='color:#800000; font-weight:bold; '>movzx</span>  <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>BYTE</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rax<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;66:</span>	 	<span style='color:#800000; font-weight:bold; '>cmp</span>    <span style='color:#000080; '>dl</span><span style='color:#808030; '>,</span><span style='color:#000080; '>al</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;68:</span>	 	<span style='color:#800000; font-weight:bold; '>je</span>     <span style='color:#e34adc; '>71</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x71</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;6a:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#800000; font-weight:bold; '>DWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x14</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;71:</span>	 	<span style='color:#800000; font-weight:bold; '>add</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x8</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;76:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x8</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;7a:</span>	 	<span style='color:#800000; font-weight:bold; '>cmp</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x40</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;7e:</span>	 	<span style='color:#800000; font-weight:bold; '>jb</span>     <span style='color:#e34adc; '>43</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x43</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;80:</span>	 	<span style='color:#800000; font-weight:bold; '>cmp</span>    <span style='color:#800000; font-weight:bold; '>DWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x14</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;84:</span>	 	<span style='color:#800000; font-weight:bold; '>jne</span>    <span style='color:#e34adc; '>93</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x93</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;86:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;8a:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rdx<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x28</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;8e:</span>	 	<span style='color:#800000; font-weight:bold; '>add</span>    rax<span style='color:#808030; '>,</span>rdx
<span style='color:#e34adc; '>&#xa0;&#xa0;91:</span>	 	<span style='color:#800000; font-weight:bold; '>jmp</span>    <span style='color:#e34adc; '>b5</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0xb5</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;93:</span>	 	<span style='color:#800000; font-weight:bold; '>add</span>    <span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;98:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x40</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;9c:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rdx<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x30</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;a0:</span>	 	<span style='color:#800000; font-weight:bold; '>sub</span>    rdx<span style='color:#808030; '>,</span>rax
<span style='color:#e34adc; '>&#xa0;&#xa0;a3:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    rax<span style='color:#808030; '>,</span>rdx
<span style='color:#e34adc; '>&#xa0;&#xa0;a6:</span>	 	<span style='color:#800000; font-weight:bold; '>add</span>    rax<span style='color:#808030; '>,</span><span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;aa:</span>	 	<span style='color:#800000; font-weight:bold; '>cmp</span>    rax<span style='color:#808030; '>,</span><span style='color:#800000; font-weight:bold; '>QWORD</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rbp<span style='color:#808030; '>-</span><span style='color:#008000; '>0x10</span><span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;ae:</span>	 	<span style='color:#800000; font-weight:bold; '>ja</span>     <span style='color:#e34adc; '>32</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x32</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;b0:</span>	 	<span style='color:#800000; font-weight:bold; '>mov</span>    <span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span><span style='color:#008000; '>0x0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;b5:</span>	 	<span style='color:#800000; font-weight:bold; '>pop</span>    rbp
<span style='color:#e34adc; '>&#xa0;&#xa0;b6:</span>	 	<span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>Optimizing GCC 4.9.3 for ARM64:</p>

<!--
_PRE_BEGIN
<f>:
   0:           cmp     x3, x1
   4:           b.hi    54 <f+0x54>
   8:           sub     x1, x1, x3
   c:           mov     x8, #0x0                        // #0
  10:           adds    x9, x1, #0x1
  14:           b.eq    54 <f+0x54>
  18:           cbz     x3, 5c <f+0x5c>
  1c:           ldrb    w7, [x2,x8]
  20:           mov     x1, #0x0                        // #0
  24:           mov     w4, #0x0                        // #0
  28:           add     x6, x0, x8
  2c:           ldrb    w5, [x6,x1]
  30:           add     x1, x1, #0x1
  34:           cmp     w5, w7
  38:           csinc   w4, w4, wzr, eq
  3c:           cmp     x1, x3
  40:           b.ne    2c <f+0x2c>
  44:           cbz     w4, 60 <f+0x60>
  48:           add     x8, x8, #0x1
  4c:           cmp     x8, x9
  50:           b.ne    18 <f+0x18>
  54:           mov     x0, #0x0                        // #0
  58:           ret
  5c:           add     x6, x0, x8
  60:           mov     x0, x6
  64:           ret
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>></span><span style='color:#808030; '>:</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;0:</span>           <span style='color:#800000; font-weight:bold; '>cmp</span>     x3<span style='color:#808030; '>,</span> x1
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;4:</span>           b.hi    <span style='color:#008c00; '>54</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x54</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;8:</span>           <span style='color:#800000; font-weight:bold; '>sub</span>     x1<span style='color:#808030; '>,</span> x1<span style='color:#808030; '>,</span> x3
<span style='color:#e34adc; '>&#xa0;&#xa0;&#xa0;c:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x8<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x0</span>                        <span style='color:#808030; '>/</span><span style='color:#808030; '>/</span> #<span style='color:#008c00; '>0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;10:</span>           adds    x9<span style='color:#808030; '>,</span> x1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;14:</span>           b.<span style='color:#004a43; '>eq</span>    <span style='color:#008c00; '>54</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x54</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;18:</span>           cbz     x3<span style='color:#808030; '>,</span> 5c <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x5c</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;1c:</span>           ldrb    w7<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x2<span style='color:#808030; '>,</span>x8<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;20:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x0</span>                        <span style='color:#808030; '>/</span><span style='color:#808030; '>/</span> #<span style='color:#008c00; '>0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;24:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     w4<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x0</span>                        <span style='color:#808030; '>/</span><span style='color:#808030; '>/</span> #<span style='color:#008c00; '>0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;28:</span>           <span style='color:#800000; font-weight:bold; '>add</span>     x6<span style='color:#808030; '>,</span> x0<span style='color:#808030; '>,</span> x8
<span style='color:#e34adc; '>&#xa0;&#xa0;2c:</span>           ldrb    w5<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x6<span style='color:#808030; '>,</span>x1<span style='color:#808030; '>]</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;30:</span>           <span style='color:#800000; font-weight:bold; '>add</span>     x1<span style='color:#808030; '>,</span> x1<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;34:</span>           <span style='color:#800000; font-weight:bold; '>cmp</span>     w5<span style='color:#808030; '>,</span> w7
<span style='color:#e34adc; '>&#xa0;&#xa0;38:</span>           csinc   w4<span style='color:#808030; '>,</span> w4<span style='color:#808030; '>,</span> wzr<span style='color:#808030; '>,</span> <span style='color:#004a43; '>eq</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;3c:</span>           <span style='color:#800000; font-weight:bold; '>cmp</span>     x1<span style='color:#808030; '>,</span> x3
<span style='color:#e34adc; '>&#xa0;&#xa0;40:</span>           b.<span style='color:#004a43; '>ne</span>    2c <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x2c</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;44:</span>           cbz     w4<span style='color:#808030; '>,</span> <span style='color:#008c00; '>60</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x60</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;48:</span>           <span style='color:#800000; font-weight:bold; '>add</span>     x8<span style='color:#808030; '>,</span> x8<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;4c:</span>           <span style='color:#800000; font-weight:bold; '>cmp</span>     x8<span style='color:#808030; '>,</span> x9
<span style='color:#e34adc; '>&#xa0;&#xa0;50:</span>           b.<span style='color:#004a43; '>ne</span>    <span style='color:#008c00; '>18</span> <span style='color:#808030; '>&lt;</span>f<span style='color:#808030; '>+</span><span style='color:#008000; '>0x18</span><span style='color:#808030; '>></span>
<span style='color:#e34adc; '>&#xa0;&#xa0;54:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x0<span style='color:#808030; '>,</span> #<span style='color:#008000; '>0x0</span>                        <span style='color:#808030; '>/</span><span style='color:#808030; '>/</span> #<span style='color:#008c00; '>0</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;58:</span>           <span style='color:#800000; font-weight:bold; '>ret</span>
<span style='color:#e34adc; '>&#xa0;&#xa0;5c:</span>           <span style='color:#800000; font-weight:bold; '>add</span>     x6<span style='color:#808030; '>,</span> x0<span style='color:#808030; '>,</span> x8
<span style='color:#e34adc; '>&#xa0;&#xa0;60:</span>           <span style='color:#800000; font-weight:bold; '>mov</span>     x0<span style='color:#808030; '>,</span> x6
<span style='color:#e34adc; '>&#xa0;&#xa0;64:</span>           <span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (ARM mode):</p>

<!--
_PRE_BEGIN
f PROC
        PUSH     {r4-r7,lr}
        CMP      r3,r1
        SUBLS    r1,r1,r3
        MOVLS    r12,#0
        ADDLS    r5,r1,#1
        BHI      |L0.96|
|L0.24|
        CMP      r12,r5
        MOVCC    r4,#0
        MOVCC    r1,r4
        BCS      |L0.96|
|L0.40|
        CMP      r1,r3
        BCS      |L0.76|
        ADD      r6,r12,r1
        LDRB     r6,[r0,r6]
        LDRB     r7,[r2,r12]
        ADD      r1,r1,#1
        CMP      r6,r7
        MOVNE    r4,#1
        B        |L0.40|
|L0.76|
        CMP      r4,#0
        ADDNE    r12,r12,#1
        ADDEQ    r0,r0,r12
        BNE      |L0.24|
        POP      {r4-r7,pc}
|L0.96|
        MOV      r0,#0
        POP      {r4-r7,pc}
        ENDP
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        <span style='color:#800000; font-weight:bold; '>PUSH</span>     <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r7<span style='color:#808030; '>,</span>lr<span style='color:#808030; '>}</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r3<span style='color:#808030; '>,</span>r1
        SUBLS    r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r3
        MOVLS    r1<span style='color:#008c00; '>2</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        ADDLS    r5<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        BHI      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.96</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.24</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r1<span style='color:#008c00; '>2</span><span style='color:#808030; '>,</span>r5
        MOVCC    r4<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        MOVCC    r1<span style='color:#808030; '>,</span>r4
        BCS      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.96</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.40</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r1<span style='color:#808030; '>,</span>r3
        BCS      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.76</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>ADD</span>      r6<span style='color:#808030; '>,</span>r1<span style='color:#008c00; '>2</span><span style='color:#808030; '>,</span>r1
        LDRB     r6<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r0<span style='color:#808030; '>,</span>r6<span style='color:#808030; '>]</span>
        LDRB     r7<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r2<span style='color:#808030; '>,</span>r1<span style='color:#008c00; '>2</span><span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>ADD</span>      r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r6<span style='color:#808030; '>,</span>r7
        MOVNE    r4<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        B        <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.40</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.76</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r4<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        ADDNE    r1<span style='color:#008c00; '>2</span><span style='color:#808030; '>,</span>r1<span style='color:#008c00; '>2</span><span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        ADDEQ    r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r1<span style='color:#008c00; '>2</span>
        BNE      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.24</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>POP</span>      <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r7<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.96</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOV</span>      r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        <span style='color:#800000; font-weight:bold; '>POP</span>      <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r7<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
        <span style='color:#004a43; '>ENDP</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

<!--
_PRE_BEGIN
f PROC
        PUSH     {r4-r7,lr}
        CMP      r3,r1
        MOV      r12,r2
        BHI      |L0.52|
        MOVS     r4,#0
        SUBS     r5,r1,r3
        ADDS     r5,r5,#1
        B        |L0.48|
|L0.16|
        MOVS     r6,#0
        MOVS     r1,r6
        B        |L0.38|
|L0.22|
        ADDS     r2,r4,r1
        LDRB     r7,[r0,r2]
        MOV      r2,r12
        LDRB     r2,[r2,r4]
        CMP      r7,r2
        BEQ      |L0.36|
        MOVS     r6,#1
|L0.36|
        ADDS     r1,r1,#1
|L0.38|
        CMP      r1,r3
        BCC      |L0.22|
        CMP      r6,#0
        BEQ      |L0.56|
        ADDS     r4,r4,#1
|L0.48|
        CMP      r5,r4
        BHI      |L0.16|
|L0.52|
        MOVS     r0,#0
        POP      {r4-r7,pc}
|L0.56|
        ADDS     r0,r0,r4
        POP      {r4-r7,pc}
        ENDP
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        <span style='color:#800000; font-weight:bold; '>PUSH</span>     <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r7<span style='color:#808030; '>,</span>lr<span style='color:#808030; '>}</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r3<span style='color:#808030; '>,</span>r1
        <span style='color:#800000; font-weight:bold; '>MOV</span>      r1<span style='color:#008c00; '>2</span><span style='color:#808030; '>,</span>r2
        BHI      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.52</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r4<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        SUBS     r5<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>r3
        ADDS     r5<span style='color:#808030; '>,</span>r5<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        B        <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.48</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.16</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r6<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r1<span style='color:#808030; '>,</span>r6
        B        <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.38</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.22</span><span style='color:#808030; '>|</span>
        ADDS     r2<span style='color:#808030; '>,</span>r4<span style='color:#808030; '>,</span>r1
        LDRB     r7<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r0<span style='color:#808030; '>,</span>r2<span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>MOV</span>      r2<span style='color:#808030; '>,</span>r1<span style='color:#008c00; '>2</span>
        LDRB     r2<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r2<span style='color:#808030; '>,</span>r4<span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r7<span style='color:#808030; '>,</span>r2
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.36</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r6<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.36</span><span style='color:#808030; '>|</span>
        ADDS     r1<span style='color:#808030; '>,</span>r1<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.38</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r1<span style='color:#808030; '>,</span>r3
        BCC      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.22</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r6<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.56</span><span style='color:#808030; '>|</span>
        ADDS     r4<span style='color:#808030; '>,</span>r4<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.48</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r5<span style='color:#808030; '>,</span>r4
        BHI      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.16</span><span style='color:#808030; '>|</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.52</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        <span style='color:#800000; font-weight:bold; '>POP</span>      <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r7<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.56</span><span style='color:#808030; '>|</span>
        ADDS     r0<span style='color:#808030; '>,</span>r0<span style='color:#808030; '>,</span>r4
        <span style='color:#800000; font-weight:bold; '>POP</span>      <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>-</span>r7<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
        <span style='color:#004a43; '>ENDP</span>
</pre>

<p>Optimizing GCC 4.4.5 for MIPS:</p>

<!--
_PRE_BEGIN
f:
        sltu    $2,$5,$7
        beq     $2,$0,$L16
        move    $2,$0

$L17:
        j       $31
        nop
$L16:
        addiu   $5,$5,1
        subu    $5,$5,$7
        beq     $5,$0,$L17
        nop
        beq     $7,$0,$L17
        move    $2,$4
        move    $13,$0
$L9:
        addu    $3,$6,$13
        addu    $2,$4,$13
        lbu     $11,0($3)
        move    $8,$2
        move    $3,$0
        move    $12,$0
$L6:
        lbu     $10,0($8)
        addiu   $3,$3,1
        beq     $10,$11,$L5
        sltu    $9,$3,$7

        li      $12,1                   # 0x1
$L5:
        bne     $9,$0,$L6
        addiu   $8,$8,1

        beq     $12,$0,$L17
        addiu   $13,$13,1

        sltu    $2,$13,$5
        bne     $2,$0,$L9
        move    $2,$0

        b       $L17
        nop
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>f:</span>
        sltu    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$7</span>
        beq     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L1<span style='color:#008c00; '>6</span>
        move    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span>

<span style='color:#e34adc; '>$L17:</span>
        j       <span style='color:#008000; '>$31</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
<span style='color:#e34adc; '>$L16:</span>
        addiu   <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
        subu    <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$7</span>
        beq     <span style='color:#008000; '>$5</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L1<span style='color:#008c00; '>7</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
        beq     <span style='color:#008000; '>$7</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L1<span style='color:#008c00; '>7</span>
        move    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span>
        move    <span style='color:#008000; '>$13</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span>
<span style='color:#e34adc; '>$L9:</span>
        addu    <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$6</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$13</span>
        addu    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$13</span>
        lbu     <span style='color:#008000; '>$11</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>)</span>
        move    <span style='color:#008000; '>$8</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span>
        move    <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span>
        move    <span style='color:#008000; '>$12</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span>
<span style='color:#e34adc; '>$L6:</span>
        lbu     <span style='color:#008000; '>$10</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$8</span><span style='color:#808030; '>)</span>
        addiu   <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>
        beq     <span style='color:#008000; '>$10</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$11</span><span style='color:#808030; '>,</span>$L5
        sltu    <span style='color:#008000; '>$9</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$7</span>

        li      <span style='color:#008000; '>$12</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>                   # <span style='color:#008000; '>0x1</span>
<span style='color:#e34adc; '>$L5:</span>
        bne     <span style='color:#008000; '>$9</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L6
        addiu   <span style='color:#008000; '>$8</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$8</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>

        beq     <span style='color:#008000; '>$12</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L1<span style='color:#008c00; '>7</span>
        addiu   <span style='color:#008000; '>$13</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$13</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>

        sltu    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$13</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$5</span>
        bne     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L9
        move    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span>

        b       $L1<span style='color:#008c00; '>7</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
</pre>

<p>Solution: _HTML_LINK_AS_IS(`http://yurichev.com/blog/2015-aug-26/').</p>

_EXERCISE_FOOTER()

_BLOG_FOOTER()
