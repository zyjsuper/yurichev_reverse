m4_include(`commons.m4')

_HEADER_HL1(`[Math][Python] Forgotten password, part II')

<p>Previously: _HTML_LINK_AS_IS(`https://yurichev.com/blog/comb/').</p>

<p>Now let's use combinations from itertools Python package.</p>

<p>Let's say, you remember that your password has maybe your name, maybe name of your wife, your year of birth, or her,
and maybe couple of symbols like "!", "$", "^".</p>

_PRE_BEGIN
import itertools

parts=["den", "xenia", "1979", "1985", "secret", "!", "$", "^"]

for i in range(1, 6): # 1..5
    for combination in itertools.combinations(parts, i):
        print "".join(combination)
_PRE_END

<p>Here we enumerate all combinations of given strings, 1-string combinations, then 2-, up to 5-string combinations.
No string can appear twice.</p>

_PRE_BEGIN
...
denxenia1979
denxenia1985
denxeniasecret
denxenia!
denxenia$
denxenia^
den19791985
den1979secret
den1979!
...
xenia1985secret$^
xenia1985!$^
xeniasecret!$^
19791985secret!$
19791985secret!^
...
_PRE_END

<p>(218 passwords)</p>

<p>Now let's permute all string in all possible ways:</p>

_PRE_BEGIN
import itertools

parts=["den", "xenia", "1979", "1985", "secret", "!", "$", "^"]

for i in range(1, 6): # 1..5
    for combination in itertools.combinations(parts, i):
        for permutation in itertools.permutations(list(combination)):
            print "".join(permutation)
_PRE_END

_PRE_BEGIN
...
^den
xenia1979
1979xenia
xenia1985
1985xenia
xeniasecret
secretxenia
xenia!
!xenia
...
^!$1985secret
^!$secret1985
^$1985secret!
^$1985!secret
^$secret1985!
^$secret!1985
^$!1985secret
^$!secret1985
_PRE_END

<p>(8800 passwords)</p>

<p>And finally, let's alter all Latin characters in lower/uppercase ways and add leetspeek,
as I _HTML_LINK(`https://yurichev.com/blog/comb/',`did before'):</p>

_PRE_BEGIN
import itertools, string

parts=["den", "xenia", "1979", "1985", "!", "$", "^"]

for i in range(1, 6): # 1..5
    for combination in itertools.combinations(parts, i):
        for permutation in itertools.permutations(list(combination)):
            s="".join(permutation)
            t=[]
            for char in s:
                if char.isalpha():
                    to_be_appended=[string.lower(char), string.upper(char)]
                    if char.lower()=='e':
                        to_be_appended.append('3')
                    elif char.lower()=='i':
                        to_be_appended.append('1')
                    elif char.lower()=='o':
                        to_be_appended.append('0')
                    t.append(to_be_appended)
                else:
                    t.append([char])
            for q in itertools.product(*t):
                print "".join(q)            
_PRE_END

_PRE_BEGIN
...
dEnxenia
dEnxeniA
dEnxenIa
...
D3nx3N1a
D3nx3N1A
D3nXenia
D3nXeniA
D3nXenIa
...
^$1979!1985
^$19851979!
^$1985!1979
^$!19791985
^$!19851979
_PRE_END
( 1,348,657 passwords )

<p>Again, you can't try to crack remote server with so many attempts,
but this is really possible for password-protected archive, known hash, etc...</p>

_BLOG_FOOTER()

