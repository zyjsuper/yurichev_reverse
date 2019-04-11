#!/usr/bin/python

import SAT_lib

WIDTH=9
HEIGHT=9
VARS_TOTAL=(WIDTH+2)*(HEIGHT+2)

known=[
"01?10001?",
"01?100011",
"011100000",
"000000000",
"111110011",
"????1001?",
"????3101?",
"?????211?",
"?????????"]

def POPCNT(s, n, vars):
    sorted=s.sorting_network(vars)
    s.fix_always_false(sorted[n])
    if n!=0:
        s.fix_always_true(sorted[n-1])

def chk_bomb(row, col):
    s=SAT_lib.SAT_lib(False)
    vars=[[s.create_var() for c in range(WIDTH+2)] for r in range(HEIGHT+2)]

    # make empty border
    # all variables are negated (because they must be False)
    for c in range(WIDTH+2):
        s.fix_always_false(vars[0][c])
        s.fix_always_false(vars[HEIGHT+1][c])
    for r in range(HEIGHT+2):
        s.fix_always_false(vars[r][0])
        s.fix_always_false(vars[r][WIDTH+1])

    for r in range(1,HEIGHT+1):
        for c in range(1,WIDTH+1):
            t=known[r-1][c-1]
            if t in "012345678":
                # cell at r, c is empty (False):
                s.fix_always_false(vars[r][c])
                # we need an empty border so the following expression would work for all possible cells:
                neighbours=[vars[r-1][c-1], vars[r-1][c], vars[r-1][c+1], vars[r][c-1],
                        vars[r][c+1], vars[r+1][c-1], vars[r+1][c], vars[r+1][c+1]]
                POPCNT(s, int(t), neighbours)

    # place a bomb
    s.fix_always_true (vars[row][col])

    if s.solve()==False:
        print "row=%d, col=%d, unsat!" % (row, col)

for r in range(1,HEIGHT+1):
    for c in range(1,WIDTH+1):
        if known[r-1][c-1]=="?":
            chk_bomb(r, c)

