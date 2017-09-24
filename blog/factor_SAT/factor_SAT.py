#!/usr/bin/env python

# "BV" stands for bitvector

import itertools, subprocess, os, math, random
from operator import mul

def read_lines_from_file (fname):
    f=open(fname)
    new_ar=[item.rstrip() for item in f.readlines()]
    f.close()
    return new_ar

def run_sat_solver (CNF_fname):
    child = subprocess.Popen(["minisat", CNF_fname, "results.txt"], stdout=subprocess.PIPE)
    child.wait()
    # 10 is SAT, 20 is UNSAT
    if child.returncode==20:
        os.remove ("results.txt")
        return None

    if child.returncode!=10:
        print "(minisat) unknown retcode: ", child.returncode
        exit(0)

    solution=read_lines_from_file("results.txt")[1].split(" ")
    os.remove ("results.txt")

    return solution

def write_CNF(fname, clauses, VARS_TOTAL):
    f=open(fname, "w")
    f.write ("p cnf "+str(VARS_TOTAL)+" "+str(len(clauses))+"\n")
    [f.write(" ".join(c)+" 0\n") for c in clauses]
    f.close()

# full-adder, as found by Mathematica using truth table:
def FA (a,b,cin):
    global clauses
    s=create_var()
    cout=create_var()

    clauses.append([neg(a), neg(b), neg(cin), s])
    clauses.append([neg(a), neg(b), cout])
    clauses.append([neg(a), neg(cin), cout])
    clauses.append([neg(a), cout, s])
    clauses.append([a, b, cin, neg(s)])
    clauses.append([a, b, neg(cout)])
    clauses.append([a, cin, neg(cout)])
    clauses.append([a, neg(cout), neg(s)])
    clauses.append([neg(b), neg(cin), cout])
    clauses.append([neg(b), cout, s])
    clauses.append([b, cin, neg(cout)])
    clauses.append([b, neg(cout), neg(s)])
    clauses.append([neg(cin), cout, s])
    clauses.append([cin, neg(cout), neg(s)])

    return s, cout

# reverse list:
def rvr(i):
    return i[::-1]

# n-bit adder:
def adder(X,Y):
    global clauses, const_true, const_false
    assert len(X)==len(Y)
    # first full-adder could be half-adder
    # start with lowest bits:
    inputs=rvr(zip(X,Y))
    carry=const_false
    sums=[]
    for pair in inputs:
        # "carry" variable is replaced at each iteration.
        # so it is used in the each FA() call from the previous FA() call.
        s, carry = FA(pair[0], pair[1], carry)
        sums.append(s)
    return rvr(sums), carry

# bit is 0 or 1.
# i.e., if it's 0, output is 0 (all bits)
# if it's 1, output=input
def mult_by_bit(X, bit):
    return [AND(i, bit) for i in X]

# build multiplier using adders and mult_by_bit blocks:
def multiplier(X, Y):
    global clauses, const_false
    assert len(X)==len(Y)
    out=[]
    #initial:
    prev=[const_false]*len(X)
    # first adder can be skipped, but I left thing "as is" to make it simpler
    for Y_bit in rvr(Y):
        s, carry = adder(mult_by_bit(X, Y_bit), prev)
        out.append(s[-1])
        prev=[carry] + s[:-1]

    return prev + rvr(out)

def create_var():
    global last_var
    last_var=last_var+1
    return str(last_var-1)

def neg(v):
    if v==None:
        raise AssertionError
    if v=="0":
        raise AssertionError
    # double negation?
    if v.startswith("-"):
        return v[1:]
    return "-"+v

def AND_Tseitin(v1, v2, out):
    global clauses
    clauses.append([neg(v1), neg(v2), out])
    clauses.append([v1, neg(out)])
    clauses.append([v2, neg(out)])

def AND(v1, v2):
    global clauses
    out=create_var()
    AND_Tseitin(v1, v2, out)
    return out

# vals=list
# as in Tseitin transformations.
def OR(vals):
    global clauses
    out=create_var()
    clauses.append(vals+[neg(out)])
    clauses=clauses+[[neg(v), out] for v in vals]
    return out

def alloc_BV(n):
    global last_var
    return [create_var() for i in range(n)]

def var_always(var,b):
    global clauses
    if b==True or b==1:
        clauses.append([var])
    else:
        clauses.append([neg(var)])

# BV is a list of True/False/0/1
def BV_always(vars, BV):
    assert len(vars)==len(BV)
    for var, bool in zip(vars, BV):
        var_always (var, bool)

def get_var_from_solution(var, solution):
    # 1 if var is present in solution, 0 if present in negated form:
    if var in solution:
        return 1
    if "-"+var in solution:
        return 0
    raise AssertionError # incorrect var number

def get_BV_from_solution(BV, solution):
    return [get_var_from_solution(var, solution) for var in BV]

# BV=[MSB...LSB]
def BV_to_number(BV):
    # coeff=1, 2^1, 2^2 ... 2^(len(BV)-1)
    coeff=1
    rt=0
    for v in rvr(BV):
        rt=rt+coeff*v
        coeff=coeff*2
    return rt

# 'size' is desired width of bitvector, in bits:
def n_to_BV (n, size):
    out=[0]*size
    i=0
    for var in rvr(bin(n)[2:]):
        if var=='1':
            out[i]=1
        else:
            out[i]=0
        i=i+1
    return rvr(out)

def solve(clauses):
    print "len(clauses)=",len(clauses)
    write_CNF("1.cnf", clauses, last_var-1)
    solution=run_sat_solver("1.cnf")
    os.remove("1.cnf")
    return solution

def factor(n):
    global clauses, last_var, const_false

    print "factoring",n

    clauses=[]
    last_var=1

    # allocate a single variable fixed to False:
    const_false=create_var()
    var_always(const_false,False)

    # size of inputs.
    # in other words, how many bits we have to allocate to store 'n'?
    input_bits=int(math.ceil(math.log(n,2)))
    print "input_bits=", input_bits

    factor1,factor2=alloc_BV(input_bits),alloc_BV(input_bits)
    product=multiplier(factor1,factor2)

    # at least one bit in each input must be set, except lowest.
    # hence we restrict inputs to be greater than 1
    var_always(OR(factor1[:-1]), True)
    var_always(OR(factor2[:-1]), True)

    # output has a size twice as bigger as each input:
    BV_always(product, n_to_BV(n,input_bits*2))

    solution=solve(clauses)
    if solution==None:
        print n,"is prime (unsat)"
        return [n]

    # get inputs of multiplier:
    factor1_n=BV_to_number(get_BV_from_solution(factor1, solution))
    factor2_n=BV_to_number(get_BV_from_solution(factor2, solution))

    print "factors of", n, "are", factor1_n, "and", factor2_n
    # factor factors recursively:
    rt=sorted(factor (factor1_n) + factor (factor2_n))
    assert reduce(mul, rt, 1)==n
    return rt

# infinite test:
def test():
    while True:
        print factor (random.randrange(100000000000))

#test()

# tested by Mathematica:
#print factor(123456) # {{2, 6}, {3, 1}, {643, 1}} 
#print factor(256)
#print factor(999999) # {{3, 3}, {7, 1}, {11, 1}, {13, 1}, {37, 1}}
print factor(1234567890) # {{2, 1}, {3, 2}, {5, 1}, {3607, 1}, {3803, 1}}
#print factor(10000) # {{2, 4}, {5, 4}}

# ~8m:
#print factor(12345678901234567890) # {{2, 1}, {3, 2}, {5, 1}, {101, 1}, {3541, 1}, {3607, 1}, {3803, 1}, {27961, 1}} 

#print factor(2345678901234567890) # too long
#print factor(123456789012345678901) # too long

