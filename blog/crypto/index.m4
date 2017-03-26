m4_include(`commons.m4')

_HEADER_HL1(`28-Feb-2017: Symbolic execution and (amateur) cryptography')

_HL2(`Serious cryptography')

<p>Let's back to _HTML_LINK(`https://yurichev.com/blog/symbolic/',`the method we previously used') to construct expressions using running Python function.</p>

<p>We can try to build expression for the output of XXTEA encryption algorithm:</p>

_PRE_BEGIN
m4_include(`blog/crypto/xxtea.py')
_PRE_END

<p>A key is choosen according to input data, and, obviously, we can't know it during symbolic execution, so we leave expression like k[...].</p>

<p>Now results for just one round, for each of 4 outputs:</p>

_PRE_BEGIN
m4_include(`blog/crypto/1round.txt')
_PRE_END

<p>
Somehow, size of expression for each subsequent output is bigger. I hope I haven't been mistaken?
And this is just for 1 round.
For 2 rounds, size of all 4 expression is ~970KB.
For 3 rounds, this is ~115MB.
For 4 rounds, I have not enough RAM on my computer.
Expressions exploding exponentially.
And there are 19 rounds.
You can weigh it.
</p>

<p>
Perhaps, you can simplify these expressions: there are a lot of excessive parenthesis, but I'm highly pessimistic, cryptoalgorithms constructed in such a way to not have any
spare operations.
</p>

<p>
In order to crack it, you can use these expressions as system of equation and try to solve it using SMT-solver.
This is called algebraic attack.
</p>

<p>
In other words, theoretically, you can build system of equation like this: $MD5(x)=12341234...$, but expressions are so huge so it's impossible to solve them.
Yes, cryptographers are fully aware of this and one of the goals of the successful cipher is to make expressions as big as possible, using resonable time and size of code.
</p>

<p>
Nevertheless, you can find numerous papers about breaking these cryptosystems with reduced number of rounds: when expression isn't exploded yet, sometimes it's possible.
It's not practical, but such experience has some interesting and theoretical interest.
</p>

_HL3(`Attempts to break "serious" crypto')

<p>CryptoMiniSat itself exist to support XOR operation, which is ubiquitous in cryptography.</p>

<ul>
<li>Bitcoin mining with SAT solver: _HTML_LINK_AS_IS(`http://jheusser.github.io/2013/02/03/satcoin.html'), _HTML_LINK_AS_IS(`https://github.com/msoos/sha256-sat-bitcoin').

<li>_HTML_LINK(`http://2015.phdays.ru/program/dev/40400/',`Alexander Semenov, attempts to break A5/1, etc. (Russian presentation)')

<li>_HTML_LINK(`https://yurichev.com/mirrors/SAT_SMT_crypto/thesis-output.pdf',`Vegard Nossum - SAT-based preimage attacks on SHA-1')

<li>_HTML_LINK(`https://yurichev.com/mirrors/SAT_SMT_crypto/166.pdf',`Algebraic Attacks on the Crypto-1 Stream Cipher in MiFare Classic and Oyster Cards')

<li>_HTML_LINK(`https://yurichev.com/mirrors/SAT_SMT_crypto/Attacking-Bivium-Using-SAT-Solvers.pdf',`Attacking Bivium Using SAT Solvers')

<li>_HTML_LINK(`https://yurichev.com/mirrors/SAT_SMT_crypto/Extending_SAT_2009.pdf',`Extending SAT Solvers to Cryptographic Problems')

<li>_HTML_LINK(`https://yurichev.com/mirrors/SAT_SMT_crypto/sat-hash.pdf',`Applications of SAT Solvers to Cryptanalysis of Hash Functions')

<li>_HTML_LINK(`https://yurichev.com/mirrors/SAT_SMT_crypto/slidesC2DES.pdf',`Algebraic-Differential Cryptanalysis of DES')
</ul>

_HL2(`Amateur cryptography')

<p>This is what you can find in serial numbers, license keys, executable file packers, CTF, malware, etc.
Sometimes even ransomware (but rarely nowadays).
</p>

<p>Amateur cryptography is often can be broken using SMT solver, or even KLEE.</p>

<p>
Amateur cryptography is usually based not on theory, but on visual complexity: if one getting results which are seems chaotic enough, one stops to improve it further.
This is security not even on obscurity, but on chaotic mess.
This is also sometimes called "The Fallacy of Complex Manipulation" (see _HTML_LINK(`https://tools.ietf.org/html/rfc4086',`RFC4086')).
</p>

<p>
Devising your own cryptoalgorithm is very tricky thing to do.
This can be compared to devising your own pseudorandom number generator.
Even famous Donald Knuth in 1959 constructed one, and it was visually very complex, but, as it turns out in practice, it has very short cycle of length 3178.
See also: TAOCP volume II page 4, (1997).
</p>

<p>
The very first problem is that making an algorithm which can generate very long expressions is tricky thing itself.
Common error is to use operations like XOR and rotations/permutations, which can't help much.
Even worse: some people think that XORing a value several times can be better, like: (x^1234)^5678.
Obviously, these two XOR operations (or many more) can be reduced to a single one.
Same story about applied operations like addition and subtraction - they all also can be reduced to single one.
</p>

<p>
Real cryptoalgorithms, like IDEA, can use several operations from different groups, like XOR, addition and multiplication.
Applying them all in specific order will make your expression irreducible.
</p>

<p>
When I prepared this blog post, I tried to make an example of such amateur hash function:
</p>

_PRE_BEGIN
m4_include(`blog/crypto/1.c')
_PRE_END

<p>KLEE can break it with little effort.
Functions of such complexity is common in shareware, which checks license keys, etc.
</p>

<p>Here is how we can make its work harder by making rotations dependent of inputs, and this makes number of possible inputs much, much bigger:</p>

_PRE_BEGIN
m4_include(`blog/crypto/2.c')
_PRE_END

<p>Addition (or _HTML_LINK(`https://yurichev.com/blog/modulo/',`modular addition'), as cryptographers say) can make thing even harder:</p>

_PRE_BEGIN
m4_include(`blog/crypto/3.c')
_PRE_END

<p>
As en exercise, you can try to make a block cipher which KLEE wouldn't break.
This is quite sobering experience.
But even if you can, this is not a panacea, there is a huge array of other cryptoanalytical methods to break it.
</p>

<p>
Summary: if you deal with amateur cryptography, you can always give KLEE and SMT solver a try.
Even more: sometimes you have only decryption function, and if algorithm is simple enough, KLEE or SMT solver can reverse things back.
</p>

<p>
One fun thing to mention: if you try to implement amateur cryptoalgorithm in Verilog/VHDL language to run it on FPGA, maybe in brute-force way,
you can find that EDA tools can optimize many things during synthesis (this is the word they use for "compilation") and can leave amateur cryptoalgorithm much smaller/simpler/faster than it was.
Even if you try to define DES algorithm with a fixed key, Altera Quartus can optimize first round of it and make it smaller than others.
</p>

_HL3(`Bugs')

<p>
Another prominent feature of amateur cryptography is bugs.
Bugs here often left uncaught because output of encrypting function visually looked "good enough",
so programmer stopped to work on it.<p>

<p>This is especially feature of hashes, because when you work on block cipher, you have to do two functions
(encryption/decryption), while hashing function is single.</p>

<p>Weirdest ever amateur encryption algorithm I once saw, encrypted only odd bytes of input block, while even bytes
left untouched, so the input plain text has been partially seen in the resulting encrypted block.
It was encryption routine used in license key validation.
Hard to believe someone did this on purpose.
Most likely, it was just an unnoticed bug.
</p>

_HL3(`Links')

<p>Pegasus Mail Password Decoder: _HTML_LINK_AS_IS(`http://phrack.org/issues/52/3.html') -
very typical example of amateur cruptography.</p>

<p>You can find a lot of blog posts about breaking CTF-level crypto using Z3, etc.
Here is one of them: _HTML_LINK_AS_IS(`http://doar-e.github.io/blog/2015/08/18/keygenning-with-klee/').</p>

<p>Another: _HTML_LINK(`http://blog.cr4.sh/2015/03/automated-algebraic-cryptanalysis-with.html',`Automated algebraic cryptanalysis with OpenREIL and Z3').
By the way, this solution tracks state of each register at each EIP/RIP, this is almost the same as SSA (Static single assignment form), which is heavily used in compiers and worth learning.</p>

_BLOG_FOOTER()

