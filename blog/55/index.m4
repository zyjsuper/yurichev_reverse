m4_include(`commons.m4')

_HEADER_HL1(`29-Oct-2010: Using debugging features of DosBox')

<p><a href="http://www.dosbox.com/">DosBox</a> is DOS emulator, one can say, it is a kind of virtual machine, mainly used for retrocomputing and retrogaming.
One interesting feature of DosBox compiled with "heavydebug" option is <a href="http://vogons.zetafleet.com/viewtopic.php?t=3944">built-in disassembler</a>, not very powerful, but it can log every instruction it executes with full registers' states.</p>

<p>Load your old DOS software by typing "DEBUG program.exe" in command line, and debugger will be activated. Type "LOG 100000": it means to run program and log 100,000 executed instructions. All of them are dumped into LOGCPU.TXT file:</p>

_PRE_BEGIN
2AF4:0000005A  mov  dx,ds EAX:00000000 EBX:00002AF4 ECX:00000004 EDX:00001AB0 ESI:0000FFF2
EDI:0000FFD2 EBP:00000000 ESP:00000080 DS:0FBF ES:1AB7 FS:0000 GS:0000
SS:2C6E CF:1 ZF:1 SF:0 OF:0 AF:4 PF:4 IF:1

2AF4:0000005C  sub  dx,ax EAX:00000000 EBX:00002AF4 ECX:00000004 EDX:00000FBF ESI:0000FFF2
EDI:0000FFD2 EBP:00000000 ESP:00000080 DS:0FBF ES:1AB7 FS:0000 GS:0000
SS:2C6E CF:1 ZF:1 SF:0 OF:0 AF:4 PF:4 IF:1

2AF4:00000064  shl  ax,cl EAX:00000000 EBX:00002AF4 ECX:00000004 EDX:00000FBF ESI:0000FFF2
EDI:0000FFD2 EBP:00000000 ESP:00000080 DS:0FBF ES:1AB7 FS:0000 GS:0000
SS:2C6E CF:0 ZF:0 SF:0 OF:0 AF:0 PF:0 IF:1
_PRE_END

<p>What we got is relatively big text file (can be as big as couple of gigabytes), which can be easily parsed with <a href="http://en.wikipedia.org/wiki/Grep">grep</a>, <a href="http://en.wikipedia.org/wiki/Sed">sed</a>, <a href="http://en.wikipedia.org/wiki/AWK">AWK</a> or whatever you like.
Let's get back to real-world task. I have a very old DOS program that requires access to very old piece of hardware, such as <a href="http://yurichev.com/index.php?title=Dongles">copy-protection dongle</a>, and we need to get rid of it. Back to DOS days, these dongles were connected to LPT printer port. So what we know is that our DOS program is accessing it at least via port 0x378. 
Let's run our program in DosBox without dongle and take all "out dx,al" instructions (writes to port) where EDX register state is port number 0x378.</p>

_PRE_BEGIN
cat LOGCPU.TXT | grep "out  dx,al" | grep "EDX:00000378"
_PRE_END

<p>We got something like:</p>

_PRE_BEGIN
1311:000002CA  out  dx,al EAX:00001212 EBX:00000000 ECX:00000001 EDX:00000378 ESI:00000378 
EDI:00007C2E EBP:00007BEC ESP:00007B7E DS:1311 ES:0000 FS:0000 GS:0000
SS:26E7 CF:0 ZF:0 SF:0 OF:0 AF:0 PF:4 IF:1
_PRE_END

<p>Wow, we see the places where program tries to access the dongle.
Now let's get deeper.
When our program can't find the dongle connected, it exits to DOS. We suppose it calls <a href="http://en.wikipedia.org/wiki/MS-DOS_API">INT21 interrupt</a> with AH=4C function code meaning "exit to DOS". But It is not common to call it right after IN/OUT instructions in the same function. There might be functions like "check for dongle presence", "read memory cell from dongle" at the top level. At the lowest level of dongle library there can be "write to dongle", "read from dongle", and "perform a delay so that slow dongle can respond".
We must find the function like "check for OUR dongle presence: read feature flags from it and get evidence it is ours, it is not expired, etc". Most often, when such functions fail, we see error messages like "dongle not connected", "invalid dongle", and program terminates.
I wrote a <a href="http://conus.info/blogs.conus.info-files/logcpu_process.c">very small utility</a> for LOGCPU.TXT file parsing. It tracks not only the place where IN/OUT instructions are executed, but also call stack at the moment. It also tracks all INT21 interrupts.</p>

<p>Here is what I got:</p>

_PRE_BEGIN
OUT  |EDX:00000378|9BD2:2FF 9D09:88 1A7:34 1A7:53 1A7:251 1A7:26F
1A7:42E 1A7:5A3 1A7:1B81 1A7:1B8C 1A7:1B31 1A7:1B3C 1A7:7E8 1A7:80B
786:147E 786:1992 9CA:375 9CA:118 9CA:1FE
...
IN   |EDX:00000379|9BD2:2FF 9D09:88 1A7:34 1A7:53 1A7:251 1A7:26F
1A7:42E 1A7:5A3 1A7:1B81 1A7:1B8C 1A7:1B31 1A7:1B3C 1A7:7E8 1A7:80B
786:147E 786:1992 9CA:375 9CA:118
...
INT21|EAX:00004C00|9BD2:2FF 9D09:88 1A7:34 1A7:53 1A7:251 1A7:26F
1A7:42E 1A7:5A3 1A7:1B81 1A7:1B8C 1A7:1B31 1A7:1B3C 1A7:7E8 1A7:80B
786:147E 786:1A1C 8ED4:160
_PRE_END

<p>The chain dumped is call stack at the moment when IN/OUT/INT21 was executed. Now all we need is to find most common chain part and find the most important moment where program decided to exit because dongle was not connected.</p>

<p>That moment is probably somewhere at the place where chain paths are diverged.</p>

_BLOG_FOOTER_GITHUB(`55')

_BLOG_FOOTER()

