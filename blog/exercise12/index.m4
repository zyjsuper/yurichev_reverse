m4_include(`commons.m4')

_HEADER_HL1(`Reverse engineering exercise #12 (for x86); solution for exercise #11')

_HL2(`Reverse engineering exercise #12 (for x86)')

<p>What this code does?</p>

<p>Optimizing GCC 4.8.2:</p>

_PRE_BEGIN
.LC0:
        .string "Usage: <filename>"
.LC1:
        .string "error #1!"
.LC2:
        .string "error #2!"
main:
        push    rbx
        mov     rbx, rsi
        sub     rsp, 160
        cmp     edi, 2
        je      .L2
        mov     edi, OFFSET FLAT:.LC0
        call    puts
.L2:
        mov     rsi, QWORD PTR [rbx+8]
        lea     rdx, [rsp+16]
        mov     edi, 1
        call    __xstat
        test    eax, eax
        js      .L10
        mov     rax, QWORD PTR [rsp+88]
        xor     edi, edi
        mov     QWORD PTR [rsp], rax
        call    time
        mov     rdi, QWORD PTR [rbx+8]
        mov     rsi, rsp
        mov     QWORD PTR [rsp+8], rax
        call    utime
        test    eax, eax
        js      .L11
        add     rsp, 160
        xor     eax, eax
        pop     rbx
        ret
.L10:
        mov     edi, OFFSET FLAT:.LC1
        call    puts
        xor     edi, edi
        call    exit
.L11:
        mov     edi, OFFSET FLAT:.LC2
        call    puts
        xor     edi, edi
        call    exit
_PRE_END

<p>Executable file is also available for download: _HTML_LINK(`https://github.com/dennis714/yurichev.com/blob/master/blog/exercise12/binary/e12?raw=true',`here')</p>

<p>Solution is to be posted soon...</p>

_EXERCISE_FOOTER()

_HL2(`Solution for reverse engineering exercise #11')

_HTML_LINK(`http://yurichev.com/blog/exercise11/',`(Link to exercise)')

_EXERCISE_SPOILER_WARNING()

<p class="spoiler">
The function just unescapes URL string.
For example, "https://en.wikipedia.org/wiki/%3F" is converted into "https://en.wikipedia.org/wiki/?".
It merely finds "%xx" substrings in the input string, gets its hexadecimal value using sscanf() and replaces by the resulting byte.
</p>

<pre class="spoiler">
// copypasted from http://rosettacode.org/wiki/URL_decoding#C
//
#include &lt;stdio.h>
#include &lt;string.h>

// old func name: ishex()
int __attribute__ ((noinline)) helper(int x)
{
        return  (x >= '0' &amp;&amp; x &lt;= '9')  ||
                (x >= 'a' &amp;&amp; x &lt;= 'f')  ||
                (x >= 'A' &amp;&amp; x &lt;= 'F');
}

int f(const char *s, char *dec)
{
        char *o;
        const char *end = s + strlen(s);
        int c;

        for (o = dec; s <= end; o++) {
                c = *s++;
                if (c == '+') c = ' ';
                else if (c == '%' &amp;&amp; (  !helper(*s++)   ||
                                        !helper(*s++)   ||
                                        !sscanf(s - 2, "%2x", &c)))
                        return -1;

                if (dec) *o = c;
        }
        return o - dec;
}

int main()
{
        const char *url = "http%3A%2F%2ffoo+bar%2fabcd";
        char out[strlen(url) + 1];

        printf("length: %d\n", f(url, 0));
        puts(f(url, out) < 0 ? "bad string" : out);

        return 0;
}
</pre>

_BLOG_FOOTER()
