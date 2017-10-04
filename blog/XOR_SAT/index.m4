m4_include(`commons.m4')

_HEADER_HL1(`Proving bizarre XOR alternative using SAT solver')

<p>(The following text has been moved to the article at _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf').)</p>

<p>I once wrote about quite bizarre XOR alternative I've found using aha! superoptimizer:
_HTML_LINK_AS_IS(`https://github.com/dennis714/SAT_SMT_article/blob/master/SMT/XOR_EN.tex').
See also here: _HTML_LINK_AS_IS(`https://yurichev.com/writings/SAT_SMT_draft-EN.pdf').</p>

<p>In short, x^y = -2*(x&y) + (x+y) or x^y = x+y - (x&y)<<1.</p>

<p>I've proved it using Z3.
Now let's try to prove it using SAT.</p>

<p>We would build an electric circuit for x^y = -2*(x&y) + (x+y) like that:</p>

_PRE_BEGIN
x --- +---+
      |AND| --- +---+     
y --- +---+     |MUL| --- +---+
             -2 +---+     |ADD| --- +---+
                      x - +---+     |ADD| --> output1 --- +-------+
                                y - +---+                 |       |      +----+
                                                          |  XOR  | ---> | OR | ---> must be 0
x --- +---+                                               |       |      +----+
      |XOR| --------------------------------> output2 --- +-------+
y --- +---+
_PRE_END

<p>So it has two parts: generic XOR block and a block which must be equivalent to XOR.
Then we compare its outputs using XOR and OR.
If outputs of these parts are always equal to each other for all possible x and y, output of the whole block must be 0.</p>

<p>I do otherwise, I'm trying to find such an input pair, for which output will be 1:</p>

_PRE_BEGIN
def chk1():
    global clauses, last_var, const_false

    clauses=[]
    last_var=1

    # allocate a single variable fixed to False:
    const_false=create_var()
    var_always(const_false,False)
    const_true=create_var()
    var_always(const_true,True)

    input_bits=8

    x,y=alloc_BV(input_bits),alloc_BV(input_bits)
    step1=BV_AND(x,y)
    minus_2=[const_true]*(input_bits-1)+[const_false]
    product=multiplier(step1,minus_2)[input_bits:]
    result1=adder(adder(product, x)[0], y)[0]

    result2=BV_XOR(x,y)

    var_always(OR(BV_XOR(result1, result2)), True)

    solution=solve(clauses)
    if solution==None:
        print "unsat"
        return

    print "sat"
    print "x=%x" % BV_to_number(get_BV_from_solution(x, solution))
    print "y=%x" % BV_to_number(get_BV_from_solution(y, solution))
    print "step1=%x" % BV_to_number(get_BV_from_solution(step1, solution))
    print "product=%x" % BV_to_number(get_BV_from_solution(product, solution))
    print "result1=%x" % BV_to_number(get_BV_from_solution(result1, solution))
    print "result2=%x" % BV_to_number(get_BV_from_solution(result2, solution))
    print "minus_2=%x" % BV_to_number(get_BV_from_solution(minus_2, solution))
_PRE_END

<p>( Many functions used here has been reused from my previous example: _HTML_LINK_AS_IS(`https://yurichev.com/blog/factor_SAT/') )

<p>The full source code: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/XOR_SAT/XOR_SAT.py').</p>

<p>SAT solver returns "unsat", meaning, it could find such a pair.
In other words, it couldn't find a counterexample.
So the circuit always outputs 0, for all possible inputs, meaning, outputs of two parts are always the same.</p>

<p>Modify the circuit, and the program will find such a state, and print it.</p>

<p>That circuit also called "miter".
According to Google translate, one of meaning of this word is:</p>

_PRE_BEGIN
a joint made between two pieces of wood or other material at an angle of 90°, such that the line of junction bisects this angle.
_PRE_END

<p>It's also slow, because multiplier block is used: so we use small 8-bit x's and y's.</p>

<p>But the whole thing can be rewritten: x^y = x+y - (x&y)<<1.
And subtraction is addition, but with one negated operand.
So, x^y = (-(x&y))<<1 + (x+y) or x^y = (x&y)*2 - (x+y).</p>

_PRE_BEGIN
x --- +---+     +---+     +---+
      |AND| --- |NEG| --- |<<1| -+ 
y --- +---+     +---+     +---+  +- +---+
                                    |ADD| --- +---+
                                x - +---+     |ADD| --> output1 --- +-------+
                                          y - +---+                 |       |      +----+
                                                                    |  XOR  | ---> | OR | ---> must be 0
x --- +---+                                                         |       |      +----+
      |XOR| ------------------------------------------> output2 --- +-------+
y --- +---+
_PRE_END

<p>NEG is negation block, in two's complement system.
It just inverts all bits and adds 1:</p>

_PRE_BEGIN
def NEG(x):
    # invert all bits
    tmp=BV_NOT(x)
    # add 1
    one=alloc_BV(len(tmp))
    BV_always(one,n_to_BV(1, len(tmp)))
    return adder(tmp, one)[0]
_PRE_END

<p>Shift by one bit does nothing except rewiring.</p>

<p>That works way faster, and can prove correctness for 64-bit x's and y's, or for even bigger input values:</p>

_PRE_BEGIN
def chk2():
    global clauses, last_var, const_false, const_true

    clauses=[]
    last_var=1

    # allocate a single variable fixed to False:
    const_false=create_var()
    var_always(const_false,False)
    const_true=create_var()
    var_always(const_true,True)

    input_bits=64

    x,y=alloc_BV(input_bits),alloc_BV(input_bits)
    step1=BV_AND(x,y)
    step2=shift_left_1(NEG(step1))
    result1=adder(adder(step2, x)[0], y)[0]

    result2=BV_XOR(x,y)

    var_always(OR(BV_XOR(result1, result2)), True)

    solution=solve(clauses)
    if solution==None:
        print "unsat"
        return

    print "sat"
    print "x=%x" % BV_to_number(get_BV_from_solution(x, solution))
    print "y=%x" % BV_to_number(get_BV_from_solution(y, solution))
    print "step1=%x" % BV_to_number(get_BV_from_solution(step1, solution))
    print "step2=%x" % BV_to_number(get_BV_from_solution(step2, solution))
    print "result1=%x" % BV_to_number(get_BV_from_solution(result1, solution))
    print "result2=%x" % BV_to_number(get_BV_from_solution(result2, solution))
_PRE_END

<p>The source code: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/XOR_SAT/XOR_SAT.py').</p>

_BLOG_FOOTER()

