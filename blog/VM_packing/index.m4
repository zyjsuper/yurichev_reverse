m4_include(`commons.m4')

_HEADER_HL1(`[SMT][Z3] Packing virtual machines into servers')

<p>You've got these servers (all in GBs):</p>

_PRE_BEGIN
RAM storage
  2     100
  4     800
  4    1000
 16    8000
  8    3000
 16    6000
 16    4000
 32    2000
  8    1000
 16   10000
  8    1000
_PRE_END

<p>And you're going to put these virtual machines to servers:</p>

_PRE_BEGIN
RAM storage
  1     100
 16     900
  4     710
  2     800
  4    7000
  8    4000
  2     800
  4    2500
 16     450
 16    3700
 12    1300
_PRE_END

<p>The problem: use as small number of servers, as possible.
Fit VMs into them in the most efficient way, so that the free RAM/storage would be minimal.</p>

<p>This is like knapsack problem.
But the classic knapsack problem is about only one dimension (weight or size).
We've two dimensions here: RAM and storage.
This is called "multidimensional knapsack problem".</p>

<p>Another problem we will solve here is a _HTML_LINK(`https://en.wikipedia.org/wiki/Bin_packing_problem',`bin packing problem').</p>

_PRE_BEGIN
m4_include(`blog/VM_packing/VM_pack.py')
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/VM_packing/VM_pack.py') (syntax highlighed version) )</p>

<p>The result:</p>

_PRE_BEGIN
m4_include(`blog/VM_packing/result.txt')
_PRE_END

<p>Choose any solution you like...</p>

<p>Further work: storage can be both HDD and/or SDD. That would add 3rd dimension. Or maybe number of CPU cores, network bandwidth, etc...</p>

_BLOG_FOOTER()

