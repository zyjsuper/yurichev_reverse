#-*- coding: utf-8 -*-

#!/usr/bin/env python

import subprocess, os

BITS_PER_COLOR=3
BITS_PER_SELECTOR=5

def read_lines_from_file (fname):
    f=open(fname)
    new_ar=[item.rstrip() for item in f.readlines()]
    f.close()
    return new_ar

def run_SAT_solver (CNF_fname):
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

def create_var():
    global last_var
    last_var=last_var+1
    return str(last_var-1)

def neg(v):
    # double negation?
    if v.startswith("-"):
        return v[1:]
    return "-"+v

def add_neg_if (cond, var):
    if cond:
        return neg(var)
    return var

def create_MUX(ins, sels):
    assert 2**len(sels)==len(ins)
    global clauses
    x=create_var()
    for sel in range(len(ins)): # 32 for 5-bit selector
        tmp=[add_neg_if((sel>>i)&1==1, sels[i]) for i in range(len(sels))] # 5 for 5-bit selector

        clauses.append([neg(ins[sel])] + tmp + [x])
        clauses.append([ins[sel]] + tmp + [neg(x)])
    return x

def create_wide_MUX (ins, sels):
    out=[]
    for i in range(len(ins[0])):
        inputs=[x[i] for x in ins]
        out.append(create_MUX(inputs, sels))
    return out

# returns array of variables
def alloc_vector(n):
    global last_var
    return [create_var() for i in range(n)]

def alloc_facelets_and_selectors(states):
    global facelets
    global selectors
    facelets=[dict() for x in range(states)]

    for state in range(states):
        for prefix in "FUDRLB":
            # allocate variables for each face:
            facelets[state][prefix+"00"]=alloc_vector(BITS_PER_COLOR)
            facelets[state][prefix+"01"]=alloc_vector(BITS_PER_COLOR)
            facelets[state][prefix+"10"]=alloc_vector(BITS_PER_COLOR)
            facelets[state][prefix+"11"]=alloc_vector(BITS_PER_COLOR)

    selectors=[None]*(TURNS)
    for step in range(TURNS):
        selectors[step]=alloc_vector(BITS_PER_SELECTOR)

def add_eq(var1, var2):
    global clauses
    clauses.append([var1, neg(var2)])
    clauses.append([neg(var1), var2])

def add_eq_vector(v1, v2):
    assert len(v1)==len(v2)
    for i in range(len(v1)):
        add_eq(v1[i], v2[i])

# src=list of 18 facelets
def add_r(dst, src):
    global facelets
    global selectors
    t=create_var()
    add_always(t,True)
    for state in range(STATES-1):
        src_vectors=[]
        for s in src:
            src_vectors.append(facelets[state][s])

        # padding: there are 18 used MUX inputs, so add 32-18=14 for padding
        for i in range(32-18): 
            src_vectors.append([t,t,t])

        dst_vector=create_wide_MUX (src_vectors, selectors[state])
        add_eq_vector(dst_vector,facelets[state+1][dst])

def encode_color(color):
    return {"W":[0,0,1], "G":[0,1,0], "B":[0,1,1], "O":[1,0,0], "R":[1,0,1], "Y": [1,1,0]}[color]

def add_always(var,b):
    global clauses
    if b==True or b==1:
        clauses.append([var])
    else:
        clauses.append([neg(var)])

# vec is a list of True/False/0/1
def add_always_vector(vars, vec):
    if vec==None:
        return # do not encode this color
    assert len(vars)==len(vec)
    for var, bool in zip(vars, vec):
        add_always (var, bool)

def set_state(step, d):
    for k in d.keys():
        add_always_vector(facelets[step][k+"00"], encode_color(d[k][0]))
        add_always_vector(facelets[step][k+"01"], encode_color(d[k][1]))
        add_always_vector(facelets[step][k+"10"], encode_color(d[k][2]))
        add_always_vector(facelets[step][k+"11"], encode_color(d[k][3]))

def get_var_from_solution(var, solution):
    # 1 if variable is true, 0 if false (in negated form):
    if var in solution:
        return 1
    else:
        return 0

def do_all(turns):
    global TURNS, STATES, clauses, last_var, facelets, selectors

    TURNS=turns
    STATES=TURNS+1
    clauses=[]
    last_var=1
    facelets=None
    selectors=None

    alloc_facelets_and_selectors(STATES)

    # solved state:
    set_state(STATES-1, {"F":"WWWW", "U":"GGGG", "D":"BBBB", "R":"OOOO", "L":"RRRR", "B":"YYYY"})

    # 4: rdur, 2 solutions (picosat)
    set_state(0, {"F":"RYOG", "U":"YRGO", "D":"WRBO", "R":"GYWB", "L":"BYWG", "B":"BOWR"})

    # other tests:
    
    # 9 or less 
    #set_state(0, {"F":"OROB", "U":"GYGG", "D":"BRWO", "R":"WGYY", "L":"RWRW", "B":"OYBB"})

    # 5
    #set_state(0, {"F":"BROW", "U":"YWOB", "D":"WROY", "R":"YGBG", "L":"BWYG", "B":"RORG"})
   
    # 5 
    #set_state(0, {"F":"RYOG", "U":"YBGO", "D":"WRBW", "R":"GOWB", "L":"RYYG", "B":"WBRO"})

    # 1 (RCW)
    #set_state(0, {"F":"WGWG", "U":"GYGY", "D":"BWBW", "R":"OOOO", "L":"RRRR", "B":"BYBY"})

    # 9 or less
    #set_state(0, {"F":"ROWB", "U":"RYYB", "D":"RYWG", "R":"WGOR", "L":"WBOG", "B":"OBYG"})

    # 6, 2 solutions (picosat)...
    #set_state(0, {"F":"RBGW", "U":"YRGW", "D":"YGWB", "R":"OBRO", "L":"RYOO", "B":"WBYG"})

    # 4, 1 solution (picosat)!
    #set_state(0, {"F":"GGYB", "U":"GRRY", "D":"RWBO", "R":"OGRY", "L":"OWOB", "B":"YWBW"})
    
    # 6, 6 solutions (picosat)
    #set_state(0, {"F":"GRRB", "U":"YYWY", "D":"WOBW", "R":"GGWR", "L":"BORB", "B":"OOGY"})

    # 6, 3 solutions (picosat)
    #set_state(0, {"F":"RWBG", "U":"BWYR", "D":"WYYO", "R":"GORG", "L":"RBOO", "B":"GWYB"})
    
    # 10 or less
    #set_state(0, {"F":"RORW", "U":"BRBB", "D":"GOOR", "R":"WYGY", "L":"OWYW", "B":"BYGG"})
    
    # 4
    #set_state(0, {"F":"RBRO", "U":"WGWY", "D":"YWOB", "R":"RWBO", "L":"BGYG", "B":"ORYG"})
    
    # 8
    #set_state(0, {"F":"GBOO", "U":"BBRO", "D":"BYGY", "R":"YWGG", "L":"YWWW", "B":"RRRO"})

    # 8
    #set_state(0, {"F":"BGBO", "U":"GWYR", "D":"YGYO", "R":"YRWB", "L":"WOGR", "B":"BRWO"})

    # 10 or less
    #set_state(0, {"F":"GRBG", "U":"BYOG", "D":"WYOY", "R":"WORR", "L":"RYGO", "B":"BWBW"})

    # 7
    #set_state(0, {"F":"BBWY", "U":"OGOR", "D":"ROYY", "R":"WYBO", "L":"WWBG", "B":"RGGR"})

    # 8
    #set_state(0, {"F":"YRRO", "U":"WWBY", "D":"WYWB", "R":"GBGO", "L":"RROB", "B":"OGYG"})

    # 10 or less (stuck)
    # set_state(0, {"F":"OWBB", "U":"RYBG", "D":"RORG", "R":"ORWY", "L":"BYWW", "B":"GYOG"})

    # 9 or less
    # set_state(0, {"F":"GGRW", "U":"BBYO", "D":"GRBO", "R":"WYBG", "L":"WRRW", "B":"OOYY"})
 
    # 8 or less
    #set_state(0, {"F":"WBRG", "U":"RGBR", "D":"GORB", "R":"WWYO", "L":"YOYW", "B":"OGYB"})

    # 8
    #set_state(0, {"F":"GOWW", "U":"RYRG", "D":"GRBY", "R":"YOBG", "L":"BWOO", "B":"BYRW"})

    # FCW, RCW
    #set_state(0, {"F":"WOWB", "U":"GWRW", "D":"OYBY", "R":"GGOO", "L":"RBRB", "B":"RYGY"})

    # 9
    #set_state(0, {"F":"YOWY", "U":"OGGY", "D":"OBGR", "R":"BRRW", "L":"WOYB", "B":"WGBR"})

    # 1 F
    #set_state(0, {"F":"WWWW", "U":"GGRR", "D":"OOBB", "R":"GOGO", "L":"RBRB", "B":"YYYY"})    

    # 2 BCW / FCCW
    #set_state(0, {"F":"WWWW", "U":"RRRR", "D":"OOOO", "R":"GGGG", "L":"BBBB", "B":"YYYY"})

    # 4 RDUR, but backwards: RCCW UCCW DCCW RCCW
    #set_state(0, {"F":"OBRY", "U":"GOWR", "D":"BOYR", "R":"WGBY", "L":"WBGY", "B":"WRGO"})

    # 2, UCCW / DCW
    #set_state(0, {"F":"OOOO", "U":"GGGG", "D":"BBBB", "R":"YYYY", "L":"WWWW", "B":"RRRR"})

    # 2, RCCW / LCW
    #set_state(0, {"F":"BBBB", "U":"WWWW", "D":"YYYY", "R":"OOOO", "L":"RRRR", "B":"GGGG"})

    # 1, UCCW
    #set_state(0, {"F":"OOWW", "U":"GGGG", "D":"BBBB", "R":"YYOO", "L":"WWRR", "B":"RRYY"})

    # 1, UCW
    #set_state(0, {"F":"RRWW", "U":"GGGG", "D":"BBBB", "R":"WWOO", "L":"YYRR", "B":"OOYY"})

    # 1, RCCW
    #set_state(0, {"F":"WBWB", "U":"GWGW", "D":"BYBY", "R":"OOOO", "L":"RRRR", "B":"GYGY"})

    # 1, RCW
    #set_state(0, {"F":"WGWG", "U":"GYGY", "D":"BWBW", "R":"OOOO", "L":"RRRR", "B":"BYBY"})

    # 1, DCCW
    #set_state(0, {"F":"WWRR", "U":"GGGG", "D":"BBBB", "R":"OOWW", "L":"RRYY", "B":"YYOO"})

    # 1. DCW
    #set_state(0, {"F":"WWOO", "U":"GGGG", "D":"BBBB", "R":"OOYY", "L":"RRWW", "B":"YYRR"})

    # 1 LCCW
    #set_state(0, {"F":"GWGW", "U":"YGYG", "D":"WBWB", "R":"OOOO", "L":"RRRR", "B":"YBYB"})

    # 1 LCW
    #set_state(0, {"F":"BWBW", "U":"WGWG", "D":"YBYB", "R":"OOOO", "L":"RRRR", "B":"YGYG"})

    # 1 FCCW
    #set_state(0, {"F":"WWWW", "U":"GGRR", "D":"OOBB", "R":"GOGO", "L":"RBRB", "B":"YYYY"})

    # 1. FCW
    #set_state(0, {"F":"WWWW", "U":"GGOO", "D":"RRBB", "R":"BOBO", "L":"RGRG", "B":"YYYY"})

    # 1 BCCW
    #set_state(0, {"F":"WWWW", "U":"OOGG", "D":"BBRR", "R":"OBOB", "L":"GRGR", "B":"YYYY"})

    # 1. BCW
    #set_state(0, {"F":"WWWW", "U":"RRGG", "D":"BBOO", "R":"OGOG", "L":"BRBR", "B":"YYYY"})    

    # 10 or less. right top corner rotated CW, left top rotated CCW
    #set_state(0, {"F":"ROWW", "U":"GGWW", "D":"BBBB", "R":"GOOO", "L":"RGRR", "B":"YYYY"})

    # 8
    #set_state(0, {"F":"RWWY", "U":"YOWB", "D":"OOOR", "R":"RYBY", "L":"RGGB", "B":"GBGW"})

    #       dst,  FCW   FH    FCCW  UCW   UH    UCCW  DCW   DH    DCCW  RCW   RH    RCCW  LCW   LH    LCCW  BCW   BH    BCCW
    add_r("F00",["F10","F11","F01","R00","B00","L00","F00","F00","F00","F00","F00","F00","U00","B11","D00","F00","F00","F00"])
    add_r("F01",["F00","F10","F11","R01","B01","L01","F01","F01","F01","D01","B10","U01","F01","F01","F01","F01","F01","F01"])
    add_r("F10",["F11","F01","F00","F10","F10","F10","L10","B10","R10","F10","F10","F10","U10","B01","D10","F10","F10","F10"])
    add_r("F11",["F01","F00","F10","F11","F11","F11","L11","B11","R11","D11","B00","U11","F11","F11","F11","F11","F11","F11"])
    add_r("U00",["U00","U00","U00","U10","U11","U01","U00","U00","U00","U00","U00","U00","B11","D00","F00","R01","D11","L10"])
    add_r("U01",["U01","U01","U01","U00","U10","U11","U01","U01","U01","F01","D01","B10","U01","U01","U01","R11","D10","L00"])
    add_r("U10",["L11","D01","R00","U11","U01","U00","U10","U10","U10","U10","U10","U10","B01","D10","F10","U10","U10","U10"])
    add_r("U11",["L01","D00","R10","U01","U00","U10","U11","U11","U11","F11","D11","B00","U11","U11","U11","U11","U11","U11"])
    add_r("D00",["R10","U11","L01","D00","D00","D00","D10","D11","D01","D00","D00","D00","F00","U00","B11","D00","D00","D00"])
    add_r("D01",["R00","U10","L11","D01","D01","D01","D00","D10","D11","B10","U01","F01","D01","D01","D01","D01","D01","D01"])
    add_r("D10",["D10","D10","D10","D10","D10","D10","D11","D01","D00","D10","D10","D10","F10","U10","B01","L00","U01","R11"])
    add_r("D11",["D11","D11","D11","D11","D11","D11","D01","D00","D10","B00","U11","F11","D11","D11","D11","L10","U00","R01"])
    add_r("R00",["U10","L11","D01","B00","L00","F00","R00","R00","R00","R10","R11","R01","R00","R00","R00","R00","R00","R00"])
    add_r("R01",["R01","R01","R01","B01","L01","F01","R01","R01","R01","R00","R10","R11","R01","R01","R01","D11","L10","U00"])
    add_r("R10",["U11","L01","D00","R10","R10","R10","F10","L10","B10","R11","R01","R00","R10","R10","R10","R10","R10","R10"])
    add_r("R11",["R11","R11","R11","R11","R11","R11","F11","L11","B11","R01","R00","R10","R11","R11","R11","D10","L00","U01"])
    add_r("L00",["L00","L00","L00","F00","R00","B00","L00","L00","L00","L00","L00","L00","L10","L11","L01","U01","R11","D10"])
    add_r("L01",["D00","R10","U11","F01","R01","B01","L01","L01","L01","L01","L01","L01","L00","L10","L11","L01","L01","L01"])
    add_r("L10",["L10","L10","L10","L10","L10","L10","B10","R10","F10","L10","L10","L10","L11","L01","L00","U00","R01","D11"])
    add_r("L11",["D01","R00","U10","L11","L11","L11","B11","R11","F11","L11","L11","L11","L01","L00","L10","L11","L11","L11"])
    add_r("B00",["B00","B00","B00","L00","F00","R00","B00","B00","B00","U11","F11","D11","B00","B00","B00","B10","B11","B01"])
    add_r("B01",["B01","B01","B01","L01","F01","R01","B01","B01","B01","B01","B01","B01","D10","F10","U10","B00","B10","B11"])
    add_r("B10",["B10","B10","B10","B10","B10","B10","R10","F10","L10","U01","F01","D01","B10","B10","B10","B11","B01","B00"])
    add_r("B11",["B11","B11","B11","B11","B11","B11","R11","F11","L11","B11","B11","B11","D00","F00","U00","B01","B00","B10"])
    
    print "len(clauses)=",len(clauses)
    write_CNF("1.cnf", clauses, last_var-1)
    solution=run_SAT_solver("1.cnf")
    #os.remove("1.cnf")
    if solution==None:
        print "unsat!"
        exit(0)
    
    turn_name=["FCW","FH","FCCW","UCW","UH","UCCW","DCW","DH","DCCW","RCW","RH","RCCW","LCW","LH","LCCW","BCW","BH","BCCW"]

    print "sat!"
    for turn in selectors:
        # 'turn' is array of 5 variables
        # convert each variable to "1" or "0" string and create 5-digit string:
        rt="".join([str(get_var_from_solution(bit, solution)) for bit in turn])
        # reverse string, convert it to integer and use it as index for array to get a move name:
        print turn_name[int(rt[::-1],2)]

    print ""

def main():
    for i in range(11,0,-1):
        print "TURNS=", i
        do_all(i)

main()

