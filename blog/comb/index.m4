m4_include(`commons.m4')

_HEADER_HL1(`[Math][Python] Simple combinatorics: soldering headphone wires; vehicle license plate; forgotten password')

_HL2(`Soldering headphone wires')

<p>
This is a real story: I tried to repair my headphone's cable, soldering 3 wires with minijack together.
But which is left? Right? I couldn't even find ground wire.
I asked myself, how many ways there are to solder 3 wires to 3-pin minijack?
I could try them all and pick the combination that sounds best.
</p>

<p>With Python's itertools module this is just:</p>

_PRE_BEGIN
m4_include(`blog/comb/wires3.py')
_PRE_END

_PRE_BEGIN
m4_include(`blog/comb/wires3.txt')
_PRE_END

<p>(Just 6 ways.)</p>

<p>What if there are 4 wires?</p>

_PRE_BEGIN
m4_include(`blog/comb/wires4.py')
_PRE_END

_PRE_BEGIN
m4_include(`blog/comb/wires4.txt')
_PRE_END

<p>(24 ways.)</p>

<p>This is what is called "permutation" in combinatorics.</p>

_HL2(`Vehicle license plate')

<p>
There was a hit and run.
And you're police officer.
And this is what your only witness says about 4-digit license plate of the guilty vehicle:
</p>

_PRE_BEGIN
There was 13: 1 and 3 together, I'm sure, but not sure where, 13 as first 2 digits, last 2 digits or in the middle.
And there was also 6, or maybe 8, or maybe even 9, not sure which, but one of them.
_PRE_END

<p>Combinatorics textbooks are abound with exercises like this: can you enumerate all possible 4-digit numbers constrained in this way?</p>

_PRE_BEGIN
m4_include(`blog/comb/plate.py')
_PRE_END

_PRE_BEGIN
1360
1306
6130
6013

...

9139
9913
9139
9913
_PRE_END

( 180 numbers )

<p>This is something you can query registered vehicle database with...</p>

_HL2(`Forgotten password')

<p>
You forgot a password, but this is what you remember: there was a name of your parent, or wife, or one of children.
Also, someone's year of birth.
And one punctuation character, which are so recommended in passwords.
Can you enumerate all possible passwords?
</p>

_PRE_BEGIN
m4_include(`blog/comb/pw1.py')
_PRE_END

_PRE_BEGIN
jake1987!
jake!1987
1987jake!
1987!jake
!jake1987

...

1963emily,
1963,emily
,emily1963
,1963emily
_PRE_END

<p>( 936 of them in total )</p>

<p>But nested for's are not aesthetically pleasing.
They can be replaced with "cartesian product" operation:</p>

_PRE_BEGIN
m4_include(`blog/comb/pw2.py')
_PRE_END

<p>And this is a way to memorize it: the length of the final result equals to lengths of all input lists multiplied with each other.</p>

_PRE_BEGIN
m4_include(`blog/comb/pw21.py')
_PRE_END

_PRE_BEGIN
('jake', '1987', '!')
('jake', '1987', '@')
('jake', '1987', '#')
('jake', '1987', '$')
('jake', '1987', '%')
('jake', '1987', '&')
('jake', '1987', '*')

...

('emily', '1963', '*')
('emily', '1963', '-')
('emily', '1963', '=')
('emily', '1963', '_')
('emily', '1963', '+')
('emily', '1963', '.')
('emily', '1963', ',')
_PRE_END

<p>4*3*13=156, and this is long a list is, to be permuted...</p>

<p>Now the new problem: some Latin characters may be uppercased, some are lowercased.
I'll add another "cartesian product" operation to alter a string in all possible ways:</p>

_PRE_BEGIN
m4_include(`blog/comb/pw3.py')
_PRE_END

_PRE_BEGIN
JAke1987!
JAkE1987!
JAKe1987!
JAKE1987!
jake!1987
jakE!1987
jaKe!1987
jaKE!1987

...

,1963eMIly
,1963eMIlY
,1963eMILy
,1963eMILY
,1963Emily
,1963EmilY
,1963EmiLy
_PRE_END

<p>( 56160 passwords )</p>

<p>Now _HTML_LINK(`https://www.urbandictionary.com/define.php?term=leet%20speak',`leetspeak').
This is somewhat popular only among youngsters, but still, this is what people of all age groups do:
replacing "o" with "0" in passwords, "e" with "3", etc.
Let's add this as well:</p>

_PRE_BEGIN
m4_include(`blog/comb/pw4.py')
_PRE_END

_PRE_BEGIN
jake1987!
jakE1987!
jak31987!
jaKe1987!
jaKE1987!
jaK31987!

...

,1963EM1lY
,1963EM1Ly
,1963EM1LY
,19633mily
,19633milY
,19633miLy
_PRE_END

<p>( 140400 passwords )</p>

<p>Obviously, you can't try all 140400 passwords on Facebook, Twitter or any other well-protected internet service.
But this is a peace of cake to brute-force them all on password protected RAR-archive or feed them all to John the Ripper, etc.</p>

<p>All the files: ...</p>

_BLOG_FOOTER()

