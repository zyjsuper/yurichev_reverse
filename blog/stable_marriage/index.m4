m4_include(`commons.m4')

_HEADER_HL1(`Stable marriage problem and Z3')

<p>See also in _HTML_LINK(`https://en.wikipedia.org/wiki/Stable_marriage_problem',`Wikipedia') and _HTML_LINK(`https://rosettacode.org/wiki/Stable_marriage_problem',`Rosetta code').</p>

<p>Layman's explanation in Russian: _HTML_LINK_AS_IS(`https://lenta.ru/articles/2012/10/15/nobel/').</p>

<p>My solution is much less efficient, because much simpler/better algorithm exists (Gale/Shapley algorithm), but I did it to demonstrate the essence of the problem plus as a yet another SMT-solvers and Z3 demonstration.</p>

<p>See comments:</p>

_PRE_BEGIN
m4_include(`blog/stable_marriage/stable.py')
_PRE_END

<p>The source code: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/stable_marriage/stable.py')</p>

<p>Result is seems to be correct:</p>

_PRE_BEGIN
sat

ManChoice:
abe <-> ivy
bob <-> cath
col <-> dee
dan <-> fay
ed <-> jan
fred <-> bea
gav <-> gay
hal <-> eve
ian <-> hope
jon <-> abi

WomanChoice:
abi <-> jon
bea <-> fred
cath <-> bob
dee <-> col
eve <-> hal
fay <-> dan
gay <-> gav
hope <-> ian
ivy <-> abe
jan <-> ed
_PRE_END

<p>This is what we did in plain English language. "Connect men and women somehow, we don't care how. But no pair must exist of those who prefer each other (simultaneously) over their current spouses".
Gale/Shapley algorithm uses "steps" to "stabilize" marriage.
There are no "steps", all pairs are married couples already.</p>

_BLOG_FOOTER()

