m4_include(`commons.m4')

_HEADER_HL1(`23-Jul-2008: Intel(R) C++?')

<p>I'm not sure, which C compiler was used to compile Oracle 11.1.0.6.0 win32 (maybe Intel(R) C++ 9.1, which is used for 11.1.0.6.0 Linux), but it generate some strange things:</p>

_PRE_BEGIN
.text:0051FBF8 85 C0                             test    eax, eax
.text:0051FBFA 0F 84 8F 00 00 00                 jz      loc_51FC8F
.text:0051FC00 74 1D                             jz      short loc_51FC1F
_PRE_END

<p>(This code is from Oracle 11.1.0.6.0 Win32 CPUjul2008)</p>

_BLOG_FOOTER_GITHUB(`8')

_BLOG_FOOTER()

