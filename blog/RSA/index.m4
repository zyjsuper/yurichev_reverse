m4_include(`commons.m4')

_HEADER_HL1(`9-Jul-2015: How RSA works.')

<p>RSA public-key cryptosystem (named after its inventors: Ron Rivest, Adi Shamir and Leonard Adleman) is most used asymmetric public-private key cryptosystem.</p>

<p>Let's start with some theory.</p>

_HL2(`Prime numbers')

<p>Prime numbers are the numbers which has no divisors except itself and 1.
This can be represented graphically.</p>

<p>Let's take 9 balls or some other objects. 9 balls can be arranged into rectangle:</p>

_PRE_BEGIN
ooo
ooo
ooo
_PRE_END

<p>So is 12 balls:</p>

_PRE_BEGIN
oooo
oooo
oooo
_PRE_END

<p>Or:</p>

_PRE_BEGIN
ooo
ooo
ooo
ooo
_PRE_END

<p>So 9 and 12 are not prime numbers. 7 is prime number:</p>

_PRE_BEGIN
ooooooo
_PRE_END

<p>Or:</p>

_PRE_BEGIN
o
o
o
o
o
o
o
_PRE_END

<p>It's not possible to form a rectangle using 7 balls, or 11 balls or any other prime number.</p>

<p>The fact that balls can be arranged into rectangle shows that the number can be divided by the number which is represented by height and width of rectangle.
Balls of prime number can be arranged vertically or horizontally, meaning, there are only two divisors: 1 and the prime number itself.</p>

_HL2(`Integer factorization')

<p>Natural number can be either prime or composite number. Composite number is a number which can be breaked up by product of prime numbers.
Let's take 100. It's not prime.</p>

<p>By the _HTML_LINK(`https://en.wikipedia.org/wiki/Fundamental_theorem_of_arithmetic',`fundamental theorem of arithmetic'), 
any number can be represented as product of prime numbers, in only one single way.
Let's factor 100 in Wolfram Mathematica:</p>

_PRE_BEGIN
In[]:= FactorInteger[100]
Out[]= {{2, 2}, {5, 2}}
_PRE_END

<p>This mean that 100 can be constructed using 2 and 5 prime numbers:</p>

_PRE_BEGIN
In[]:= 2^2*5^2
Out[]= 100
_PRE_END

<p>Even more than that, it's possible to encode some information in prime numbers using factoring.
Let's say, we would encode "Hello" text string.
First, let's find ASCII codes of each character in the string:</p>

_PRE_BEGIN
In[]:= ToCharacterCode["Hello"]
Out[]= {72, 101, 108, 108, 111}
_PRE_END

<p>Let's find first 5 prime numbers, each number for each character:</p>

_PRE_BEGIN
In[]:= Map[Prime[#] &, Range[5]]
Out[]= {2, 3, 5, 7, 11}
_PRE_END

<p>Build a huge number using prime numbers as bases and ASCII codes as exponents, then get a product of all them:</p>

_PRE_BEGIN
In[]:= 2^72*3^101*5^108*7^108*11^111
Out[]= \
1649465578065933994718255257642275679479006861206428830641826551739434\
9344066214616222018844835866267141943107823334187149334898562231349428\
5708281252457614466981636618940129599457183300076472809826225406689893\
5837524252859632074600687844523389231265776082000229507684707641601562\
5000000000000000000000000000000000000000000000000000000000000000000000\
000
_PRE_END

<p>It's a big number, but Wolfram Mathematica is able to factor it back:</p>

_PRE_BEGIN
In[]:= FactorInteger[%]
Out[]= {{2, 72}, {3, 101}, {5, 108}, {7, 108}, {11, 111}}
_PRE_END

<p>First number in each pair is prime number and the second is exponent.
Get the text string back:</p>

_PRE_BEGIN
In[]:= FromCharacterCode[Map[#[[2]] &, %]]
Out[]= "Hello"
_PRE_END

<p>That allows to have some fun.
Let's add exclamation point to the end of string by manipulating only the <i>big number</i>.
ASCII code of exlamation point is 33. The next prime number after 11 is 13.
So add it:</p>

_PRE_BEGIN
In[122]:= %116*13^33
Out[122]= \
9494539005656577744061615691556750598033024729435332190254469113536733\
9032823543118405499931761589928052797992206631285822671397023217541663\
5920521812548793623881568510051214975599793760307837993570818136014139\
9497958680836430182400405525832564875875193876694267121604212637095253\
0725145452728611417114734649658203125000000000000000000000000000000000\
000000000000000000000000000000000000000
_PRE_END

<p>(%116 is the number of cell is Mathematica with the <i>big number</i>).</p>

<p>So we got new number. Let's factor it back and decode:</p>

_PRE_BEGIN
In[124]:= FactorInteger[%122]
Out[124]= {{2, 72}, {3, 101}, {5, 108}, {7, 108}, {11, 111}, {13, 33}}

In[125]:= FromCharacterCode[Map[#[[2]] &, %124]]
Out[125]= "Hello!"
_PRE_END

<p>Wow, that works. Will it be possible to remove one 'l' character from the string at the third position?
'l' has ASCII code of 108 and it is exponent for two prime numbers in our expression: 5 (first 'l') and 7 (second 'l').</p>

<p>To knock out the character, we divide the <i>big number</i> by the corresponding prime number with the exponent of 108:</p>

_PRE_BEGIN
In[126]:= %122/5^108
Out[126]= \
3081154065769189664244341216329094565621009415122099836376732969546063\
1079164051611808432546107410277501678916823138724630810880390384343750\
1196528030610615786507542545262118293483878711112407171889948257893463\
8494741216231004109210436295299274515484540190050751059821909485854359\
9630924207126074604240892753608704

In[127]:= FactorInteger[%126]
Out[127]= {{2, 72}, {3, 101}, {7, 108}, {11, 111}, {13, 33}}

In[128]:= FromCharacterCode[Map[#[[2]] &, %127]]
Out[128]= "Helo!"
_PRE_END

_HL2(`Coprime numbers')

<p>Coprime numbers are the 2 or more numbers which don't have any common divisors.
In mathematical lingo, GCD (greatest common divisor) of all coprime numbers is 1.</p>

<p>3 and 5 are coprimes. So are 7 and 10. So are 4, 5 and 9.</p>

<p>Coprime numbers are the numerator and denominator in fraction which cannot be reduced further (irreducible fraction).
For example, $\frac{130}{14}$ is $\frac{65}{7}$ after reduction (or simplification), 65 and 7 are coprime to each other, but 130 and 14 are not (they has 2 as common divisor).</p>

<p>One application of coprime numbers in engineering is to make number of cogs on cogwheel and number of chain elements on chain to be coprimes.
Let's imagine bike cogwheels and chain:</p>

<center><img src="http://yurichev.com/blog/RSA/CHAINPUL.gif" alt="The picture was taken from www.mechanical-toys.com"></center>

<p>If you choose 5 as number of cogs on one of cogwhell and you have 10 or 15 or 20 chain elements, each cog on cogwheel will meet some set of the same chain elements.
For example, if there are 5 cogs on cogwheel and 20 chain elements, each cog will meet only 4 chain elements and vice versa: 
each chain element has its <i>own</i> cog on cogwheel.
This is bad because both cogwheel and chain will run out slightly faster than if each cog would interlock every chain elements at some point.
To reach this, number of cogs and chain elements could be coprime numbers, like 5 and 11, or 5 and 23.
That will make each chain element interlock each cog evenly, which is better.</p>

_HL2(`Semiprime numbers')

<p>... are also used in RSA in its core.</p>

<p>Semiprime is a product of two prime numbers.</p>

<p>An interesting property of semiprime:</p>

<blockquote>
In 1974 the Arecibo message was sent with a radio signal aimed at a star cluster. It consisted of 1679 binary digits intended to be interpreted as a 23×73 bitmap image. The number 1679 = 23×73 was chosen because it is a semiprime and therefore can only be broken down into 23 rows and 73 columns, or 73 rows and 23 columns.
</blockquote>

<p>( _HTML_LINK(`https://en.wikipedia.org/wiki/Semiprime',`Wikipedia') )</p>

_HL2(`Modular arithmetic')

<p>... is also used in RSA in its core.</p>

<p>I've written _HTML_LINK(`http://yurichev.com/blog/modulo/',`the article about it').
The only difference is that I used CPU reigsters in the article which leads to modulo base like $2^{32}$ or $2^{64}$,
while modulo bases in RSA are very large semiprimes.</p>

_HL2(`Fermat little theorem')

<p>Fermat little theorem states that if $p$ is prime, this congruence is valid for any $a$ in the environment of modulo artihemtic of base $p$:</p>

<center>$a^{p-1} \equiv 1 \pmod p.$</center>

<p>There are _HTML_LINK(`https://en.wikipedia.org/wiki/Proofs_of_Fermat%27s_little_theorem',`proofs'), which are, perhaps, too tricky for this article which is intended
for beginners.
So far, you can just take it as granted.</p>

<p>This theorem may be used to sieve prime numbers. So you take, for example, 10 and test it.
Let's take some random $a$ value (123) (Wolfram Mathematica):</p>

_PRE_BEGIN
In[]:= Mod[123^(10 - 1), 10]
Out[]= 3
_PRE_END

<p>We've got 3, which is not 1, indicating the 10 is not prime. On the other hand, 11 is prime:</p>

_PRE_BEGIN
In[]:= Mod[123^(11 - 1), 11]
Out[]= 1
_PRE_END

<p>This method is not perfect (_HTML_LINK(`https://en.wikipedia.org/wiki/Carmichael_number',`some composite p numbers can lead to 1, for example p=1105')), 
but can be used as a method to sieve vast amount of prime numbers candidates.</p>

_HL2(`Euler&rsquo;s totient function')

<p>... also used in RSA. _HTML_LINK(`https://en.wikipedia.org/wiki/Euler%27s_totient_function',`Wikipedia link').</p>

<p>It is a number of coprime numbers under some n. Denoted as φ(n) or ϕ(n), pronounced as "phi".</p>
<p>For the sake of simplification, you may just keep in mind that if $n=pq$ (i.e., product of two prime numbers), $\varphi (pq)=(p-1)(q-1)$.
This is true for RSA environment.</p>

_HL2(``Euler&rsquo;s theorem'')

<p>_HTML_LINK(`https://en.wikipedia.org/wiki/Euler%27s_theorem',``Euler&rsquo;s theorem'') is generalization of Fermat little theorem.
It states:</p>

<p><center>$a^{\varphi (n)} \equiv 1 \pmod{n}$</center></p>

<p>But again, for the sake of simplification, we may keep in mind that Euler's theorem in the RSA environment is this:</p>

<p><center>$a^{(p-1)(q-1)} \equiv 1 \pmod{n}$</center></p>

<p>... where $n=pq$ and both $p$ and $q$ are prime numbers.</p>

<p>This theorem is central to RSA algorithm.</p>

_HL2(`RSA example')

<p>There are <i>The Sender</i> and <i>The Receiver</i>.
<i>The Receiver</i> generates two big prime numbers ($p$ and $q$) and publishes its product ($n=pq$).
Both $p$ and $q$ are kept secret.</p>

<p>For the illustration, let's randomly pick p and q among the first 50 prime numbers in Wolfram Mathematica:</p>

_PRE_BEGIN
In[]:= p = Prime[RandomInteger[50]]
Out[]= 89

In[]:= q = Prime[RandomInteger[50]]
Out[]= 43

In[]:= n = p*q
Out[]= 3827
_PRE_END

<p>3827 is published as public key, named "public key modulus" or "modulo".
It is semiprime.
There is also public key exponent $e$, which is not secret, is often 65537, but we will use 17 to keep all results tiny.</p>

<p>Now <i>The Sender</i> wants to send a message (123 number) to <i>The Receiver</i> and he/she uses one-way function:</p>

_PRE_BEGIN
In[]:= e = 17
Out[]= 17

In[]:= encrypted = Mod[123^e, n]
Out[]= 3060
_PRE_END

<p>3060 is encrypted message, which can be decrypted only using $p$ and $q$ values separately.
This is one-way function, because only part of exponentiation result is left.
One and important consequence is that even <i>The Sender</i> can't decrypt it.
This is why you can encrypt a piece of text in PGP/GnuPG to someone using his/her public key, but can't decrypt it.
Perhaps, that's how CryptoLockers works, making impossible to decrypt the files.</p>

<p>To recover message (123), $p$ and $q$ values must be known.</p>

<p>First, we get the result of Euler's totient function $(p-1)(q-1)$ (this is the point where $p$ and $q$ values are needed):</p>

_PRE_BEGIN
In[]:= totient = (p - 1)*(q - 1)
Out[]= 3696
_PRE_END

<p>Now we calculating decrypting exponent using multiplicative modulo inverse 
(multiplicative inverse was also described in _HTML_LINK(`http://yurichev.com/blog/modulo/',`my previous article')) ($e^{-1} \pmod{totient=(p-q)(q-1)}$):</p>

_PRE_BEGIN
In[]:= d = PowerMod[e, -1, totient]
Out[]= 2609
_PRE_END

<p>Now decrypt the message:</p>

_PRE_BEGIN
In[18]:= Mod[encrypted^d, n]
Out[18]= 123
_PRE_END

<p>So the $d$ exponent forms another one-way function, restoring the work of what was done during encryption.</p>

_HL2(`So how it works?')

<p>It works, because $e$ and $d$ exponents are reciprocal to each other by modulo $totient=(p-1)(q-1)$:</p>

_PRE_BEGIN
In[]:= Mod[e*d, totient] (* check *)
Out[]= 1
_PRE_END

<p>This allows...</p>

<p id="equation1"><center>$m^{ed}=m \pmod n$</center><div align="right"><b>(1)</b></div></p>

Or in Mathematica:

_PRE_BEGIN
In[]:= Mod[123^(e*d), n]
Out[]= 123
_PRE_END

<p>So the encryption process is $m^{e} \pmod{n}$, decryption is $(m^{e})^{d}=m \pmod{n}$.</p>

<p>To prove congruence <a href="#equation1">(1)</a>, we first should prove the following congruence:</p>

<p><center>$ed \equiv 1 \pmod{((p-1)(q-1))}$</center></p>

<p>... using modular arithmetic rules, it can be rewritten as:</p>

<p><center>$ed = 1+h (p-1)(q-1)$</center></p>

<p>$h$ is some unknown number which is present here because it's not known how many times the final result was <i>rounded</i> while exponentiation 
(this is modulo arithmetic after all).</p>

<p>So $m^{ed}=m \pmod{n}$ can be rewritten as:</p>

<p><center>$m^{1 + h((p-1)(q-1))} \equiv m \pmod{n}$</center></p>

<p>...and then to:</p>

<p><center>$m \left(m^{(p-1)(q-1)}\right)^{h} \equiv m \pmod{n}$.</center></p>

<p>The last expression can be simplified using Euler's theorem (stating that $a^{(p-1)(q-1)} \equiv 1 \pmod{n}$).
The result is:</p>

<p><center>$m (1)^{h} \equiv m \pmod{n}$</center></p>

<p>... or just:</p>

<p><center>$m \equiv m \pmod{n}$.</center></p>

_HL2(`Breaking RSA')

<p>We can try to factor $n$ semiprime (or RSA modulus) in Mathematica:</p>

_PRE_BEGIN
In[]:= FactorInteger[n]
Out[]= {{43, 1}, {89, 1}}
_PRE_END

<p>And we getting correct $p$ and $q$, but this is possible only for small values.
When you use some big ones, factorizing is extremely slow, making RSA unbreakable, if implemented correctly.</p>

<p>The bigger $p$, $q$ and $n$ numbers, the harder to factorize $n$, so the bigger keys in bits are, the harder it to break.</p>

_HL2(`Difference between my simplified example and a real RSA algorithm')

<p>In my example, public key is $n=pq$ (product) and secret key are $p$ and $q$ values stored separately.
This is not very efficient, to calculate totient and decrypting exponent each time.
So in practice, a public key is $n$ and $e$, and a secret key is at least $n$ and $d$, and $d$ is stored in secret key precomputed.</p>

<p>For example, here is _HTML_LINK(`http://yurichev.com/pgp.html',`my PGP public key'):</p>

_PRE_BEGIN
dennis@...:~$ gpg --export-options export-reset-subkey-passwd --export-secret-subkeys 0x3B262349\! | pgpdump 
Old: Secret Key Packet(tag 5)(533 bytes)
        Ver 4 - new
        Public key creation time - Tue Jun 30 02:08:38 EEST 2015
        Pub alg - RSA Encrypt or Sign(pub 1)
        RSA n(4096 bits) - ...
        RSA e(17 bits) - ...
...
_PRE_END

<p>... so there are available openly big (4096 bits) $n$ and $e$ (17 bits).</p>

<p>And here is my PGP secret key:</p>

_PRE_BEGIN
dennis@...:~$ gpg --export-options export-reset-subkey-passwd --export-secret-subkeys 0x55B5C64F\! | pgpdump 
gpg: about to export an unprotected subkey

You need a passphrase to unlock the secret key for
user: "Dennis Yurichev <dennis@yurichev.com>"
4096-bit RSA key, ID 55B5C64F, created 2015-06-29

gpg: gpg-agent is not available in this session
Old: Secret Key Packet(tag 5)(533 bytes)
        Ver 4 - new
        Public key creation time - Tue Jun 30 02:08:38 EEST 2015
        Pub alg - RSA Encrypt or Sign(pub 1)
        RSA n(4096 bits) - ...
        RSA e(17 bits) - ...
...
Old: Secret Subkey Packet(tag 7)(1816 bytes)
        Ver 4 - new
        Public key creation time - Tue Jun 30 02:08:38 EEST 2015
        Pub alg - RSA Encrypt or Sign(pub 1)
        RSA n(4096 bits) - ...
        RSA e(17 bits) - ...
        RSA d(4093 bits) - ...
        RSA p(2048 bits) - ...
        RSA q(2048 bits) - ...
        RSA u(2048 bits) - ...
        Checksum - 94 53 
...
_PRE_END

<p>... it has all variables stored in the file, including $d$, $p$ and $q$.</p>

_HL2(`RSA signature')

<p>It's possible to sign a message to publish it, so everyone can check the signature.
For example, <i>The Publisher</i> wants to sign the message (let's say, 456).
Then he/she uses $d$ exponent to compute signature:</p>

_PRE_BEGIN
In[]:= signed = Mod[456^d, n]
Out[]= 2282
_PRE_END

<p>Now he publishes $n=pq$ (3827), $e$ (17 in our example), the message (456) and the signature (2282).
Some other <i>Consumers</i> can verify its signature using $e$ exponent and $n$:</p>

_PRE_BEGIN
In[]:= Mod[2282^e, n]
Out[]= 456
_PRE_END

<p>... this is another illustration that $e$ and $d$ exponents are complement each other, by modulo $totient=(p-1)(q-1)$.</p>

<p>The signature can only be generated with the access to $p$ and $q$ values, but it can be verified using product ($n=pq$) value.</p>

_HL2(`Hybrid cryptosystem')

<p>RSA is slow, because exponentiation is slow and exponentiation by modulo is also slow.
Perhaps, this is the reason why it was treated impractical by GCHQ when _HTML_LINK(`https://en.wikipedia.org/wiki/Clifford_Cocks',`Clifford Cocks') 
first came with this idea in 1970s.
So in practice, if <i>The Sender</i> wants to encrypt some big piece of data to <i>The Receiver</i>, a random number is generated, which is used as a key
for symmetrical cryptosystem like DES or AES. The piece of data is encrypted by the random key.
The key is then encrypted by RSA to <i>The Receiver</i> and destroyed.
<i>The Receiver</i> recovers random key using RSA and decrypts all the data using DES or AES.</p>

_BLOG_FOOTER()
