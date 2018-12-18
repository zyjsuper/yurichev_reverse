m4_include(`commons.m4')

_HEADER_HL1(`[MaxSAT][Python] Pack students into dorm')

<p>Given, say, 15 students.
And they all have various interests/hobbies in their life, like
hiking, clubbing, dancing, swimming, maybe hanging out with girls, etc.
</p>

<p>The dormitory has 5 rooms.
Three students can be accommodated in each room.</p>

<p>The problem to pack them all in such a way, so that all roommates would
share as many interests/hobbies with each other, as possible.
To make them happy and tight-knit.</p>

<p>This is what I will do using Open-WBO MaxSAT solver (
_HTML_LINK(`http://sat.inesc-id.pt/open-wbo/',`1'), 
_HTML_LINK(`https://github.com/sat-group/open-wbo',`2')
) this time,
and my small _HTML_LINK(`https://github.com/DennisYurichev/SAT_SMT_by_example/blob/master/libs/SAT_lib.py',`Python library').</p>

_PRE_BEGIN
m4_include(`blog/pack_students/1.py')
_PRE_END

<p>Most significant parts from the library used, are:</p>

_PRE_BEGIN
    # bitvectors must be different.
    def fix_BV_NEQ(self, l1, l2):
        #print len(l1), len(l2)
        assert len(l1)==len(l2)
        self.add_comment("fix_BV_NEQ")
        t=[self.XOR(l1[i], l2[i]) for i in range(len(l1))]
        self.add_clause(t)

    def make_distinct_BVs (self, lst):
        assert type(lst)==list
        assert type(lst[0])==list
        for pair in itertools.combinations(lst, r=2):
            self.fix_BV_NEQ(pair[0], pair[1])

...

    def create_MUX(self, ins, sels):
        assert 2**len(sels)==len(ins)
        x=self.create_var()
        for sel in range(len(ins)): # for example, 32 for 5-bit selector
            tmp=[self.neg_if((sel>>i)&1==1, sels[i]) for i in range(len(sels))] # 5 for 5-bit selector
   
            self.add_clause([self.neg(ins[sel])] + tmp + [x])
            self.add_clause([ins[sel]] + tmp + [self.neg(x)])
        return x
    
    # for 1-bit sel
    # ins=[[outputs for sel==0], [outputs for sel==1]]
    def create_wide_MUX (self, ins, sels):
        out=[]
        for i in range(len(ins[0])):
            inputs=[x[i] for x in ins]
            out.append(self.create_MUX(inputs, sels))
        return out
_PRE_END
<p>( _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/SAT_SMT_by_example/blob/master/libs/SAT_lib.py') )</p>

<p>... and then Open-WBO MaxSAT searches such a solution, for which as many
soft clauses as possible would be satisfied, i.e., as many hobbies shared,
as possible.</p>

<p>And the result:</p>

_PRE_BEGIN
m4_include(`blog/pack_students/res.txt')
_PRE_END

_BLOG_FOOTER()

