m4_include(`commons.m4')

_HEADER_HL1(`Yet another compiler anomaly')

<p>Just found in some old code:</p>

<!--
_PRE_BEGIN
                 fabs
                 fild    [esp+50h+var_34]
                 fabs
                 fxch    st(1) ; first instruction
                 fxch    st(1) ; second instruction
                 faddp   st(1), st
                 fcomp   [esp+50h+var_3C]
                 fnstsw  ax
                 test    ah, 41h
                 jz      short loc_100040B7
_PRE_END
-->
<pre style='color:#000000;background:#ffffff;'><span style='color:#800000; font-weight:bold; '>fabs</span>
                 <span style='color:#800000; font-weight:bold; '>fild</span>    <span style='color:#808030; '>[</span><span style='color:#000080; '>esp</span><span style='color:#808030; '>+</span><span style='color:#008000; '>50h</span><span style='color:#808030; '>+</span>var_<span style='color:#008c00; '>34</span><span style='color:#808030; '>]</span>
                 <span style='color:#800000; font-weight:bold; '>fabs</span>
                 <span style='color:#800000; font-weight:bold; '>fxch</span>    <span style='color:#000080; '>st</span><span style='color:#808030; '>(</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span> <span style='color:#696969; '>; first instruction</span>
                 <span style='color:#800000; font-weight:bold; '>fxch</span>    <span style='color:#000080; '>st</span><span style='color:#808030; '>(</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span> <span style='color:#696969; '>; second instruction</span>
                 <span style='color:#800000; font-weight:bold; '>faddp</span>   <span style='color:#000080; '>st</span><span style='color:#808030; '>(</span><span style='color:#008c00; '>1</span><span style='color:#808030; '>)</span><span style='color:#808030; '>,</span> <span style='color:#000080; '>st</span>
                 <span style='color:#800000; font-weight:bold; '>fcomp</span>   <span style='color:#808030; '>[</span><span style='color:#000080; '>esp</span><span style='color:#808030; '>+</span><span style='color:#008000; '>50h</span><span style='color:#808030; '>+</span>var_3C<span style='color:#808030; '>]</span>
                 <span style='color:#800000; font-weight:bold; '>fnstsw</span>  <span style='color:#000080; '>ax</span>
                 <span style='color:#800000; font-weight:bold; '>test</span>    <span style='color:#000080; '>ah</span><span style='color:#808030; '>,</span> <span style='color:#008000; '>41h</span>
                 <span style='color:#800000; font-weight:bold; '>jz</span><span style='color:#800000; font-weight:bold; '>      short</span> <span style='color:#e34adc; '>loc_100040B7</span>
</pre>

<p>The firsst FXCH instruction swaps ST(0) and ST(1), the second do the same, so both do nothing.
This is a program uses MFC42.dll, so it could be MSVC 6.0, 5.0 or maybe even MSVC 4.2 from 1990s.</p>

<p>This pair do nothing, so it probably wasn't catched by MSVC compiler tests. Or maybe I wrong?</p>

<p>There are another compiler anomalies 
_HTML_LINK(`https://github.com/dennis714/RE-for-beginners/blob/3e16e8f3b56aefd69eb6fa931b04cc9a8a354b73/other/compiler_anomalies.tex',`in my book'),
or just open _HTML_LINK(`http://beginners.re/Reverse_Engineering_for_Beginners-en.pdf',`PDF') and then Ctrl-F "anomaly".</p>

<p>The reason I cite them is that sometimes practicing reverse engineers are stumbled by them while they should just ignore such quirks.</p>

_BLOG_FOOTER()

