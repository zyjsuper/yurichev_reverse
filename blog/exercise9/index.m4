m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #9 (for x86, ARM, ARM64, MIPS); solution for exercise #8')

_HL2(`Reverse engineering exercise #9 (for x86, ARM, ARM64, MIPS)')

<p>Now that's easy. What this code does?</p>

<p>Optimizing GCC 4.8.2:</p>

<!--
.LC0:
	.string	"error!"
f:
	sub	rsp, 8
	movzx	eax, BYTE PTR [rdi]
	cmp	al, 89
	je	.L3
	jle	.L21
	cmp	al, 110
	je	.L6
	cmp	al, 121
	jne	.L2
.L3:
	mov	eax, 1
	add	rsp, 8
	ret
.L21:
	cmp	al, 78
	je	.L6
.L2:
	mov	edi, OFFSET FLAT:.LC0
	call	puts
	xor	edi, edi
	call	exit
.L6:
	xor	eax, eax
	add	rsp, 8
	ret
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>.LC0:</span>
	.string	<span style='color:#0000e6; '>"error!"</span>
<span style='color:#e34adc; '>f:</span>
	<span style='color:#800000; font-weight:bold; '>sub</span>	rsp<span style='color:#808030; '>,</span> <span style='color:#008c00; '>8</span>
	<span style='color:#800000; font-weight:bold; '>movzx</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>BYTE</span> <span style='color:#800000; font-weight:bold; '>PTR</span> <span style='color:#808030; '>[</span>rdi<span style='color:#808030; '>]</span>
	<span style='color:#800000; font-weight:bold; '>cmp</span>	<span style='color:#000080; '>al</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>89</span>
	<span style='color:#800000; font-weight:bold; '>je</span>	<span style='color:#e34adc; '>.L3</span>
	<span style='color:#800000; font-weight:bold; '>jle</span>	<span style='color:#e34adc; '>.L21</span>
	<span style='color:#800000; font-weight:bold; '>cmp</span>	<span style='color:#000080; '>al</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>110</span>
	<span style='color:#800000; font-weight:bold; '>je</span>	<span style='color:#e34adc; '>.L6</span>
	<span style='color:#800000; font-weight:bold; '>cmp</span>	<span style='color:#000080; '>al</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>121</span>
	<span style='color:#800000; font-weight:bold; '>jne</span>	<span style='color:#e34adc; '>.L2</span>
<span style='color:#e34adc; '>.L3:</span>
	<span style='color:#800000; font-weight:bold; '>mov</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>1</span>
	<span style='color:#800000; font-weight:bold; '>add</span>	rsp<span style='color:#808030; '>,</span> <span style='color:#008c00; '>8</span>
	<span style='color:#800000; font-weight:bold; '>ret</span>
<span style='color:#e34adc; '>.L21:</span>
	<span style='color:#800000; font-weight:bold; '>cmp</span>	<span style='color:#000080; '>al</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>78</span>
	<span style='color:#800000; font-weight:bold; '>je</span>	<span style='color:#e34adc; '>.L6</span>
<span style='color:#e34adc; '>.L2:</span>
	<span style='color:#800000; font-weight:bold; '>mov</span>	<span style='color:#000080; '>edi</span><span style='color:#808030; '>,</span> <span style='color:#800000; font-weight:bold; '>OFFSET</span> <span style='color:#004a43; '>FLAT</span><span style='color:#808030; '>:</span>.LC0
	<span style='color:#800000; font-weight:bold; '>call</span>	<span style='color:#e34adc; '>puts</span>
	<span style='color:#800000; font-weight:bold; '>xor</span>	<span style='color:#000080; '>edi</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>edi</span>
	<span style='color:#800000; font-weight:bold; '>call</span>	<span style='color:#e34adc; '>exit</span>
<span style='color:#e34adc; '>.L6:</span>
	<span style='color:#800000; font-weight:bold; '>xor</span>	<span style='color:#000080; '>eax</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>eax</span>
	<span style='color:#800000; font-weight:bold; '>add</span>	rsp<span style='color:#808030; '>,</span> <span style='color:#008c00; '>8</span>
	<span style='color:#800000; font-weight:bold; '>ret</span>
</pre>

<p>Optimizing GCC 4.9.3 for ARM64:</p>

<!--
f:
        stp     x29, x30, [sp, -16]!
        add     x29, sp, 0
        ldrb    w0, [x0]
        cmp     w0, 89
        beq     .L6
        bls     .L20
        cmp     w0, 110
        beq     .L5
        cmp     w0, 121
        bne     .L2
.L6:
        mov     w0, 1
        ldp     x29, x30, [sp], 16
        ret
.L20:
        cmp     w0, 78
        beq     .L5
.L2:
        adrp    x0, .LC0
        add     x0, x0, :lo12:.LC0
        bl      puts
        mov     w0, 0
        bl      exit
.L5:
        mov     w0, 0
        ldp     x29, x30, [sp], 16
        ret
.LC0:
        .string "error!"
-->

<pre style='color:#000000;background:#ffffff;'><span style='color:#e34adc; '>f:</span>
        stp     x2<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x3<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>-16</span><span style='color:#808030; '>]</span><span style='color:#808030; '>!</span>
        <span style='color:#800000; font-weight:bold; '>add</span>     x2<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>0</span>
        ldrb    w0<span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span>x0<span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>cmp</span>     w0<span style='color:#808030; '>,</span> <span style='color:#008c00; '>89</span>
        beq     .L6
        bls     .L2<span style='color:#008c00; '>0</span>
        <span style='color:#800000; font-weight:bold; '>cmp</span>     w0<span style='color:#808030; '>,</span> <span style='color:#008c00; '>110</span>
        beq     .L5
        <span style='color:#800000; font-weight:bold; '>cmp</span>     w0<span style='color:#808030; '>,</span> <span style='color:#008c00; '>121</span>
        bne     .L2
<span style='color:#e34adc; '>.L6:</span>
        <span style='color:#800000; font-weight:bold; '>mov</span>     w0<span style='color:#808030; '>,</span> <span style='color:#008c00; '>1</span>
        ldp     x2<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x3<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>16</span>
        <span style='color:#800000; font-weight:bold; '>ret</span>
<span style='color:#e34adc; '>.L20:</span>
        <span style='color:#800000; font-weight:bold; '>cmp</span>     w0<span style='color:#808030; '>,</span> <span style='color:#008c00; '>78</span>
        beq     .L5
<span style='color:#e34adc; '>.L2:</span>
        adrp    x0<span style='color:#808030; '>,</span> .LC0
        <span style='color:#800000; font-weight:bold; '>add</span>     x0<span style='color:#808030; '>,</span> x0<span style='color:#808030; '>,</span> <span style='color:#808030; '>:</span>lo1<span style='color:#008c00; '>2</span><span style='color:#808030; '>:</span>.LC0
        <span style='color:#000080; '>bl</span>      puts
        <span style='color:#800000; font-weight:bold; '>mov</span>     w0<span style='color:#808030; '>,</span> <span style='color:#008c00; '>0</span>
        <span style='color:#000080; '>bl</span>      exit
<span style='color:#e34adc; '>.L5:</span>
        <span style='color:#800000; font-weight:bold; '>mov</span>     w0<span style='color:#808030; '>,</span> <span style='color:#008c00; '>0</span>
        ldp     x2<span style='color:#008c00; '>9</span><span style='color:#808030; '>,</span> x3<span style='color:#008c00; '>0</span><span style='color:#808030; '>,</span> <span style='color:#808030; '>[</span><span style='color:#000080; '>sp</span><span style='color:#808030; '>]</span><span style='color:#808030; '>,</span> <span style='color:#008c00; '>16</span>
        <span style='color:#800000; font-weight:bold; '>ret</span>
<span style='color:#e34adc; '>.LC0:</span>
        .string <span style='color:#0000e6; '>"error!"</span>
</pre>

<p>(ARM) Optimizing Keil 5.05 (Thumb mode):</p>

<!--
f PROC
        PUSH     {r4,lr}
        LDRB     r0,[r0,#0]
        CMP      r0,#0x4e
        BEQ      |L0.36|
        CMP      r0,#0x59
        BEQ      |L0.32|
        CMP      r0,#0x6e
        BEQ      |L0.36|
        CMP      r0,#0x79
        BEQ      |L0.32|
        ADR      r0,|L0.40|
        BL       __2printf
        MOVS     r0,#0
        BL       exit
|L0.32|
        MOVS     r0,#1
        POP      {r4,pc}
|L0.36|
        MOVS     r0,#0
        POP      {r4,pc}
        ENDP

|L0.40|
        DCB      "error!\n",0
-->

<pre style='color:#000000;background:#ffffff;'>f <span style='color:#004a43; '>PROC</span>
        <span style='color:#800000; font-weight:bold; '>PUSH</span>     <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>,</span>lr<span style='color:#808030; '>}</span>
        LDRB     r0<span style='color:#808030; '>,</span><span style='color:#808030; '>[</span>r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span><span style='color:#808030; '>]</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r0<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x4e</span>
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.36</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r0<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x59</span>
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.32</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r0<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x6e</span>
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.36</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>CMP</span>      r0<span style='color:#808030; '>,</span>#<span style='color:#008000; '>0x79</span>
        BEQ      <span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.32</span><span style='color:#808030; '>|</span>
        ADR      r0<span style='color:#808030; '>,</span><span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.40</span><span style='color:#808030; '>|</span>
        <span style='color:#000080; '>BL</span>       __2printf
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        <span style='color:#000080; '>BL</span>       exit
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.32</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>1</span>
        <span style='color:#800000; font-weight:bold; '>POP</span>      <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.36</span><span style='color:#808030; '>|</span>
        <span style='color:#800000; font-weight:bold; '>MOVS</span>     r0<span style='color:#808030; '>,</span>#<span style='color:#008c00; '>0</span>
        <span style='color:#800000; font-weight:bold; '>POP</span>      <span style='color:#808030; '>{</span>r4<span style='color:#808030; '>,</span>pc<span style='color:#808030; '>}</span>
        <span style='color:#004a43; '>ENDP</span>

<span style='color:#808030; '>|</span>L0<span style='color:#008c00; '>.40</span><span style='color:#808030; '>|</span>
        DCB      <span style='color:#0000e6; '>"error!\n"</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span>
</pre>

<p>Optimizing Keil 5.05 for ARM mode generates nearly the same code, so it's omitted here.</p>

<p>Optimizing GCC 4.4.5 for MIPS:</p>

<!--
$LC0:
        .ascii  "error!\000"
f:
        lui     $28,%hi(__gnu_local_gp)
        addiu   $sp,$sp,-32
        addiu   $28,$28,%lo(__gnu_local_gp)
        sw      $31,28($sp)
        lb      $2,0($4)
        li      $3,89                   # 0x59
        beq     $2,$3,$L4
        slt     $3,$2,90
        bne     $3,$0,$L9
        li      $3,78                   # 0x4e
        li      $3,110                  # 0x6e
        beq     $2,$3,$L3
        li      $3,121                  # 0x79
        bne     $2,$3,$L2
        nop
$L4:
        lw      $31,28($sp)
        li      $2,1                    # 0x1
        j       $31
        addiu   $sp,$sp,32

$L9:
        beq     $2,$3,$L3
        nop
$L2:
        lw      $25,%call16(puts)($28)
        lui     $4,%hi($LC0)
        jalr    $25
        addiu   $4,$4,%lo($LC0)

        lw      $28,16($sp)
        nop
        lw      $25,%call16(exit)($28)
        nop
        jalr    $25
        move    $4,$0

$L3:
        lw      $31,28($sp)
        move    $2,$0
        j       $31
        addiu   $sp,$sp,32
-->

<pre style='color:#000000;background:#ffffff;'>.ascii  <span style='color:#0000e6; '>"error!\000"</span>
<span style='color:#e34adc; '>f:</span>
        lui     <span style='color:#008000; '>$28</span><span style='color:#808030; '>,</span><span style='color:#808030; '>%</span>hi<span style='color:#808030; '>(</span>__gnu_local_gp<span style='color:#808030; '>)</span>
        addiu   $<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>-32</span>
        addiu   <span style='color:#008000; '>$28</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$28</span><span style='color:#808030; '>,</span><span style='color:#808030; '>%</span>lo<span style='color:#808030; '>(</span>__gnu_local_gp<span style='color:#808030; '>)</span>
        sw      <span style='color:#008000; '>$31</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>28</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        lb      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>0</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>)</span>
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>89</span>                   # <span style='color:#008000; '>0x59</span>
        beq     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span>$L4
        slt     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>90</span>
        bne     <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span><span style='color:#808030; '>,</span>$L9
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>78</span>                   # <span style='color:#008000; '>0x4e</span>
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>110</span>                  # <span style='color:#008000; '>0x6e</span>
        beq     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span>$L3
        li      <span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>121</span>                  # <span style='color:#008000; '>0x79</span>
        bne     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span>$L2
        <span style='color:#800000; font-weight:bold; '>nop</span>
<span style='color:#e34adc; '>$L4:</span>
        lw      <span style='color:#008000; '>$31</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>28</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        li      <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>1</span>                    # <span style='color:#008000; '>0x1</span>
        j       <span style='color:#008000; '>$31</span>
        addiu   $<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>32</span>

<span style='color:#e34adc; '>$L9:</span>
        beq     <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$3</span><span style='color:#808030; '>,</span>$L3
        <span style='color:#800000; font-weight:bold; '>nop</span>
<span style='color:#e34adc; '>$L2:</span>
        lw      <span style='color:#008000; '>$25</span><span style='color:#808030; '>,</span><span style='color:#808030; '>%</span>call1<span style='color:#008c00; '>6</span><span style='color:#808030; '>(</span>puts<span style='color:#808030; '>)</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$28</span><span style='color:#808030; '>)</span>
        lui     <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#808030; '>%</span>hi<span style='color:#808030; '>(</span>$LC0<span style='color:#808030; '>)</span>
        jalr    <span style='color:#008000; '>$25</span>
        addiu   <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#808030; '>%</span>lo<span style='color:#808030; '>(</span>$LC0<span style='color:#808030; '>)</span>

        lw      <span style='color:#008000; '>$28</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>16</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
        lw      <span style='color:#008000; '>$25</span><span style='color:#808030; '>,</span><span style='color:#808030; '>%</span>call1<span style='color:#008c00; '>6</span><span style='color:#808030; '>(</span>exit<span style='color:#808030; '>)</span><span style='color:#808030; '>(</span><span style='color:#008000; '>$28</span><span style='color:#808030; '>)</span>
        <span style='color:#800000; font-weight:bold; '>nop</span>
        jalr    <span style='color:#008000; '>$25</span>
        move    <span style='color:#008000; '>$4</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span>

<span style='color:#e34adc; '>$L3:</span>
        lw      <span style='color:#008000; '>$31</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>28</span><span style='color:#808030; '>(</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>)</span>
        move    <span style='color:#008000; '>$2</span><span style='color:#808030; '>,</span><span style='color:#008000; '>$0</span>
        j       <span style='color:#008000; '>$31</span>
        addiu   $<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span>$<span style='color:#000080; '>sp</span><span style='color:#808030; '>,</span><span style='color:#008c00; '>32</span>
</pre>

<p>Solution is to be posted soon...</p>

<p>Other exercises like this are available in my _HTML_LINK(`http://yurichev.com/blog/',`blog') and _HTML_LINK(`http://beginners.re/',`my book').</p>

_HL2(`Reverse engineering exercise #8')

_HTML_LINK(`http://yurichev.com/blog/exercise8/',`(Link to exercise)')

<p>Spoiler warning! The text below has white color, select it using mouse to read the text (or press Ctrl-A):</p>

<p class="spoiler">The function is searching for right node in <a href="https://en.wikipedia.org/wiki/Binary_tree" class="spoiler">binary tree</a>.
Binary trees are used almost everywhere: if you use std::map or std::set in C++, it's binary tree under the hood.
Same thing about dynamically-typing programming languages like Python, Ruby, etc, dictionaries in these are usually implemented using binary trees.</p>

<pre class="spoiler">
#include &lt;stdio.h>

typedef struct rbtree_node_t
{
    void* key;
    void* value;
    struct rbtree_node_t* left;
    struct rbtree_node_t* right;
    struct rbtree_node_t* parent;
} rbtree_node;

typedef int (*compare_func)(void* left, void* right);

rbtree_node* f(compare_func cmp_func, rbtree_node* n, void* key)
{
    int comp_result;

    if (n==NULL) // empty node
        return NULL;

    comp_result = cmp_func(key, n->key);

    if (comp_result == 0) // key found
    {
        return n;
    }
    else if (comp_result&lt;0)
    {
        if (n->left)
            return f(cmp_func, n->left, key);
        else
        {
            // key not found
            return NULL;
        };
    }
    else // comp_result>0
    {
        if (n->right)
            return f(cmp_func, n->right, key);
        else
        {
            // key not found
            return NULL;
        };
    };
};
</pre>

_BLOG_FOOTER()
