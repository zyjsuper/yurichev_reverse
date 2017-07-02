m4_include(`commons.m4')

_HEADER_HL1(`De Morgan's laws and decompilation')

<p>Sometimes compiler's optimizer can use _HTML_LINK(`https://en.wikipedia.org/wiki/De_Morgan's_laws',`De Morgan’s laws') to make code shorter/faster.</p>

<p>For example, this:</p>

_PRE_BEGIN
void f(int a, int b, int c, int d)
{
	if (a>0 && b>0)
		printf ("both a and b are positive\n");
	else if (c>0 && d>0)
		printf ("both c and d are positive\n");
	else
		printf ("something else\n");
};
_PRE_END

<p>... looks pretty innocent, when compiled by optimizing GCC 5.4.0 x64:</p>

_PRE_BEGIN
; int __fastcall f(int a, int b, int c, int d)
                public f
f               proc near
                test    edi, edi
                jle     short loc_8
                test    esi, esi
                jg      short loc_30

loc_8:
                test    edx, edx
                jle     short loc_20
                test    ecx, ecx
                jle     short loc_20
                mov     edi, offset s   ; "both c and d are positive"
                jmp     puts

loc_20:
                mov     edi, offset aSomethingElse ; "something else"
                jmp     puts

loc_30:
                mov     edi, offset aAAndBPositive ; "both a and b are positive"

loc_35:
                jmp     puts
f               endp
_PRE_END

<p>... also looks innocent, byt Hex-Rays 2.2.0 cannot clearly see that both AND operations were actually used in the source code:</p>

_PRE_BEGIN
int __fastcall f(int a, int b, int c, int d)
{
  int result;

  if ( a > 0 && b > 0 )
  {
    result = puts("both a and b are positive");
  }
  else if ( c <= 0 || d <= 0 )
  {
    result = puts("something else");
  }
  else
  {
    result = puts("both c and d are positive");
  }
  return result;
}
_PRE_END

<p>The "c <= 0 || d <= 0" expression is inversion of "c>0 && d>0" since 
$\overline{A \cup B} &= \overline{A} \cap \overline{B}$ and $\overline{A \cap B} &= \overline{A} \cup \overline{B}$, in other words,
"!(cond1 || cond2) == !cond1 && !cond2" and "!(cond1 && cond2) == !cond1 || !cond2".
</p>

<p>$\frac{a}{b}$</p>

<p>These rules are worth to be kept in mind, since this compiler optimization is used heavily almost everywhere.</p>

_BLOG_FOOTER()

