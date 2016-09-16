m4_include(`commons.m4')

_HEADER_HL1(`15-Oct-2013: New tracer features for software testing')

<p>For my software testers friends I added two features to my <a href="//yurichev.com/tracer-en.html">tracer</a>.</p>

<p>* Pause</p>

<p>PAUSE:number: Make a pause in milliseconds. 1000 - one second. It is convinient for testing, for creating artifical delays. For example, it is important to know program's behaviour in very slow network environment:</p>

_PRE_BEGIN
tracer.exe -l:test1.exe bpf=WS2_32.dll!WSARecv,pause:1000
_PRE_END

<p>... or if it will read from some very slow storage:</p>

_PRE_BEGIN
tracer.exe -l:test1.exe bpf=kernel32.dll!ReadFile,pause:1000
_PRE_END

<p>* Probability</p>

<p>RT_PROBABILITY:number: Used with RT: option in pair, defines probability of RT triggering. For example, if RT:0 and RT_PROBABILITY:30% were set, 0 will be set instead of function's return value in 30% of cases. It's convenient for testing - good written program should handle errors correctly. For example, that's how we can simulate memory allocation errors, 1 malloc() call of 100 will return NULL:</p>

_PRE_BEGIN
tracer.exe -l:test1.exe bpf=msvcrt.dll!malloc,rt:0,rt_probability:1%
_PRE_END

<p>... in 10% of cases, the file will fail to open:</p>

_PRE_BEGIN
tracer.exe -l:test1.exe bpf=kernel32.dll!CreateFile,rt:0,rt_probability:10%
_PRE_END

<p>Probability may be set in usual manner, as a number in 0 (never) to 1 (always) interval. 10% is 0.1, 3% is 0.03, etc.</p>

<p>About ideas on errors also may be simulated, read here: <a href="http://blog.yurichev.com/node/43">Oracle RDBMS internal self-testing features</a>.</p>

_BLOG_FOOTER_GITHUB(`75')

_BLOG_FOOTER()

