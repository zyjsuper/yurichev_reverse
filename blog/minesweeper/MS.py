#!/usr/bin/python

import itertools
    
digits="0123456789"

def get_from_known_or_empty(known, r, c):
    # I'm lazy to do overflow checks
    try:
        return known[r][c]
    except IndexError:
        return ""

def valid_coord(coord, HEIGHT, WIDTH):
    r=coord[0]
    c=coord[1]
    return not(r<0 or c<0 or r>=HEIGHT or c>=WIDTH)

def have_neighbour_digit(known, r, c, HEIGHT, WIDTH):
    # returns True if neighbour is digit, False otherwise
    t=[]
    t.append(get_from_known_or_empty(known, r-1, c-1) in digits)
    t.append(get_from_known_or_empty(known, r-1, c) in digits)
    t.append(get_from_known_or_empty(known, r-1, c+1) in digits)
    t.append(get_from_known_or_empty(known, r, c-1) in digits)
    t.append(get_from_known_or_empty(known, r, c+1) in digits)
    t.append(get_from_known_or_empty(known, r+1, c-1) in digits)
    t.append(get_from_known_or_empty(known, r+1, c) in digits)
    t.append(get_from_known_or_empty(known, r+1, c+1) in digits)
    return any(t)

# check all equations under an assignment
# busiest function
def check_all_eqs(eqs, assignment):
    for eq in eqs:
        result=0
        for term in eq[0]:
            if term in assignment:
                result=result+assignment[term]
        if eq[1]!=result:
            # at least one eq is UNSAT
            return "UNSAT"
    # all eqs are SAT
    return "SAT"

def chk_bomb(known, bomb, eqs):
    WIDTH=len(known[0])
    HEIGHT=len(known)

    to_be_assigned=[]
    for r in range(HEIGHT):
        for c in range(WIDTH):
            if known[r][c]=="?" and have_neighbour_digit(known, r, c, HEIGHT, WIDTH) and bomb!=(r,c):
                to_be_assigned.append((r, c))
    print "to_be_assigned", to_be_assigned
    to_be_assigned_t=len(to_be_assigned)
    # bruteforce. try all 0/1 for all coords in to_be_assigned[]:
    # we do full bruteforce to be sure that no equation can be SAT under any assignment
    for assignment in itertools.product([0,1], repeat=to_be_assigned_t):
        t={}
        for i in zip(to_be_assigned, assignment):
            t[i[0]]=i[1]
        # add bomb to assignment:
        t[bomb]=1
        if check_all_eqs(eqs, t)=="SAT":
            # bomb can be at $bomb$
            return None

    # all assignments checked at this point
    # UNSAT
    # no bomb can be at $bomb$
    return bomb

def find_safe_cells(known):

    WIDTH=len(known[0])
    HEIGHT=len(known)

    eqs=[]
    # make a system of equations:
    for r in range(HEIGHT):
        for c in range(WIDTH):
            digit=known[r][c]
            if digit in digits:
                eq=[]
                if valid_coord((r-1, c-1), HEIGHT, WIDTH):
                    eq.append((r-1, c-1))
                if valid_coord((r-1, c), HEIGHT, WIDTH):
                    eq.append((r-1, c))
                if valid_coord((r-1, c+1), HEIGHT, WIDTH):
                    eq.append((r-1, c+1))

                if valid_coord((r, c-1), HEIGHT, WIDTH):
                    eq.append((r, c-1))
                if valid_coord((r, c+1), HEIGHT, WIDTH):
                    eq.append((r, c+1))

                if valid_coord((r+1, c-1), HEIGHT, WIDTH):
                    eq.append((r+1, c-1))
                if valid_coord((r+1, c), HEIGHT, WIDTH):
                    eq.append((r+1, c))
                if valid_coord((r+1, c+1), HEIGHT, WIDTH):
                    eq.append((r+1, c+1))

                eqs.append ((eq, int(digit)))

    # enumerate all hidden cells bordering to digit-in-cells:
    rt=[]
    for r in range(HEIGHT):
        for c in range(WIDTH):
            if known[r][c]=="?" and have_neighbour_digit(known, r, c, HEIGHT, WIDTH):
                print "checking", r, c
                rt.append(chk_bomb(known, (r, c), eqs))
    return filter(None, rt)

# known cells
# safe cells (as found by SAT or SMT solver)
tests=[
([
"01?10001?",
"01?100011",
"011100000",
"000000000",
"111110011",
"????1001?",
"????3101?",
"?????211?",
"?????????"],
[(0, 2), (5, 1), (5, 2), (6, 3), (6, 8), (7, 8)]),

([
"01110001?",
"01?100011",
"011100000",
"000000000",
"111110011",
"?11?1001?",
"???331011",
"?????2110",
"???????10"],
[(6, 0), (6, 1), (6, 2), (7, 2), (8, 4), (8, 5)]),

([
"01110001?",
"01?100011",
"011100000",
"000000000",
"111110011",
"?11?1001?",
"222331011",
"??2??2110",
"????22?10"],
[(7, 1), (8, 3)]),

([
"01110001?",
"01?100011",
"011100000",
"000000000",
"111110011",
"?11?1001?",
"222331011",
"?22??2110",
"???322?10"],
[(8, 0), (8, 1)]),
]

def main():
    for test in tests:
        print "test=", test
        safe_cells=find_safe_cells(test[0])
        print "safe_cells=", safe_cells
        assert test[1]==safe_cells

main()

