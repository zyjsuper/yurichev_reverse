#!/usr/bin/python

import os
from GoL_SAT_utils import *

#"""
final_state=[
"     ",
"  *  ",
" * * ",
"  *  ",
"     "]
#"""

"""
final_state=[
"     ",
" *** ",
" * * ",
" *** ",
"     "]
"""

"""
final_state=[
"     ",
"  *  ",
"  *  ",
"  *  ",
"     "]
"""

"""
final_state=[
"       ",
"   *   ",
"       ",
"  **   ",
"   *   ",
"   *   ",
"  ***  ",
"       "]
"""

"""
final_state=[
"       ",
"   *   ",
"  * *  ",
" *   * ",
"  * *  ",
"   *   ",
"       "]
"""

"""
final_state=[
"               ",
"               ",
"    *     *    ",
"     *   *     ",
"    *******    ",
"   ** *** **   ",
"  ***********  ",
"  * ******* *  ",
"  * *     * *  ",
"     ** **     ",
"               ",
"               "]
"""

HEIGHT=len(final_state)
WIDTH=len(final_state[0])

print "HEIGHT=", HEIGHT, "WIDTH=", WIDTH

VARS_TOTAL=(WIDTH+2)*(HEIGHT+2)

def coords_to_var (row, col):
    # we always use SAT variables as strings, anyway.
    # the 1st variables is 1, not 0
    return str(row*(WIDTH+2)+col+1)

def grid_to_clause(grid):
    rt=[]
    for r in range(HEIGHT):
        for c in range(WIDTH):
            rt.append(("-" if grid[r][c]==False else "") + str(coords_to_var(r+1, c+1)))
    return rt

def cell_is_true (center, a):
    s="(!a||!b||!c||!d)&&(!a||!b||!c||!e)&&(!a||!b||!c||!f)&&(!a||!b||!c||!g)&&(!a||!b||!c||!h)&&" \
      "(!a||!b||!d||!e)&&(!a||!b||!d||!f)&&(!a||!b||!d||!g)&&(!a||!b||!d||!h)&&(!a||!b||!e||!f)&&" \
      "(!a||!b||!e||!g)&&(!a||!b||!e||!h)&&(!a||!b||!f||!g)&&(!a||!b||!f||!h)&&(!a||!b||!g||!h)&&" \
      "(!a||!c||!d||!e)&&(!a||!c||!d||!f)&&(!a||!c||!d||!g)&&(!a||!c||!d||!h)&&(!a||!c||!e||!f)&&" \
      "(!a||!c||!e||!g)&&(!a||!c||!e||!h)&&(!a||!c||!f||!g)&&(!a||!c||!f||!h)&&(!a||!c||!g||!h)&&" \
      "(!a||!d||!e||!f)&&(!a||!d||!e||!g)&&(!a||!d||!e||!h)&&(!a||!d||!f||!g)&&(!a||!d||!f||!h)&&" \
      "(!a||!d||!g||!h)&&(!a||!e||!f||!g)&&(!a||!e||!f||!h)&&(!a||!e||!g||!h)&&(!a||!f||!g||!h)&&" \
      "(a||b||c||center||d||e||f)&&(a||b||c||center||d||e||g)&&(a||b||c||center||d||e||h)&&" \
      "(a||b||c||center||d||f||g)&&(a||b||c||center||d||f||h)&&(a||b||c||center||d||g||h)&&" \
      "(a||b||c||center||e||f||g)&&(a||b||c||center||e||f||h)&&(a||b||c||center||e||g||h)&&" \
      "(a||b||c||center||f||g||h)&&(a||b||c||d||e||f||g)&&(a||b||c||d||e||f||h)&&(a||b||c||d||e||g||h)&&" \
      "(a||b||c||d||f||g||h)&&(a||b||c||e||f||g||h)&&(a||b||center||d||e||f||g)&&(a||b||center||d||e||f||h)&&" \
      "(a||b||center||d||e||g||h)&&(a||b||center||d||f||g||h)&&(a||b||center||e||f||g||h)&&(a||b||d||e||f||g||h)&&" \
      "(a||c||center||d||e||f||g)&&(a||c||center||d||e||f||h)&&(a||c||center||d||e||g||h)&&" \
      "(a||c||center||d||f||g||h)&&(a||c||center||e||f||g||h)&&(a||c||d||e||f||g||h)&&(a||center||d||e||f||g||h)&&" \
      "(!b||!c||!d||!e)&&(!b||!c||!d||!f)&&(!b||!c||!d||!g)&&(!b||!c||!d||!h)&&(!b||!c||!e||!f)&&" \
      "(!b||!c||!e||!g)&&(!b||!c||!e||!h)&&(!b||!c||!f||!g)&&(!b||!c||!f||!h)&&(!b||!c||!g||!h)&&" \
      "(!b||!d||!e||!f)&&(!b||!d||!e||!g)&&(!b||!d||!e||!h)&&(!b||!d||!f||!g)&&(!b||!d||!f||!h)&&" \
      "(!b||!d||!g||!h)&&(!b||!e||!f||!g)&&(!b||!e||!f||!h)&&(!b||!e||!g||!h)&&(!b||!f||!g||!h)&&" \
      "(b||c||center||d||e||f||g)&&(b||c||center||d||e||f||h)&&(b||c||center||d||e||g||h)&&" \
      "(b||c||center||d||f||g||h)&&(b||c||center||e||f||g||h)&&(b||c||d||e||f||g||h)&&(b||center||d||e||f||g||h)&&" \
      "(!c||!d||!e||!f)&&(!c||!d||!e||!g)&&(!c||!d||!e||!h)&&(!c||!d||!f||!g)&&(!c||!d||!f||!h)&&" \
      "(!c||!d||!g||!h)&&(!c||!e||!f||!g)&&(!c||!e||!f||!h)&&(!c||!e||!g||!h)&&(!c||!f||!g||!h)&&" \
      "(c||center||d||e||f||g||h)&&(!d||!e||!f||!g)&&(!d||!e||!f||!h)&&(!d||!e||!g||!h)&&(!d||!f||!g||!h)&&" \
      "(!e||!f||!g||!h)"
    
    return mathematica_to_CNF(s, center, a)

def cell_is_false (center, a):
    s="(!a||!b||!c||d||e||f||g||h)&&(!a||!b||c||!d||e||f||g||h)&&(!a||!b||c||d||!e||f||g||h)&&" \
      "(!a||!b||c||d||e||!f||g||h)&&(!a||!b||c||d||e||f||!g||h)&&(!a||!b||c||d||e||f||g||!h)&&" \
      "(!a||!b||!center||d||e||f||g||h)&&(!a||b||!c||!d||e||f||g||h)&&(!a||b||!c||d||!e||f||g||h)&&" \
      "(!a||b||!c||d||e||!f||g||h)&&(!a||b||!c||d||e||f||!g||h)&&(!a||b||!c||d||e||f||g||!h)&&" \
      "(!a||b||c||!d||!e||f||g||h)&&(!a||b||c||!d||e||!f||g||h)&&(!a||b||c||!d||e||f||!g||h)&&" \
      "(!a||b||c||!d||e||f||g||!h)&&(!a||b||c||d||!e||!f||g||h)&&(!a||b||c||d||!e||f||!g||h)&&" \
      "(!a||b||c||d||!e||f||g||!h)&&(!a||b||c||d||e||!f||!g||h)&&(!a||b||c||d||e||!f||g||!h)&&" \
      "(!a||b||c||d||e||f||!g||!h)&&(!a||!c||!center||d||e||f||g||h)&&(!a||c||!center||!d||e||f||g||h)&&" \
      "(!a||c||!center||d||!e||f||g||h)&&(!a||c||!center||d||e||!f||g||h)&&(!a||c||!center||d||e||f||!g||h)&&" \
      "(!a||c||!center||d||e||f||g||!h)&&(a||!b||!c||!d||e||f||g||h)&&(a||!b||!c||d||!e||f||g||h)&&" \
      "(a||!b||!c||d||e||!f||g||h)&&(a||!b||!c||d||e||f||!g||h)&&(a||!b||!c||d||e||f||g||!h)&&" \
      "(a||!b||c||!d||!e||f||g||h)&&(a||!b||c||!d||e||!f||g||h)&&(a||!b||c||!d||e||f||!g||h)&&" \
      "(a||!b||c||!d||e||f||g||!h)&&(a||!b||c||d||!e||!f||g||h)&&(a||!b||c||d||!e||f||!g||h)&&" \
      "(a||!b||c||d||!e||f||g||!h)&&(a||!b||c||d||e||!f||!g||h)&&(a||!b||c||d||e||!f||g||!h)&&" \
      "(a||!b||c||d||e||f||!g||!h)&&(a||b||!c||!d||!e||f||g||h)&&(a||b||!c||!d||e||!f||g||h)&&" \
      "(a||b||!c||!d||e||f||!g||h)&&(a||b||!c||!d||e||f||g||!h)&&(a||b||!c||d||!e||!f||g||h)&&" \
      "(a||b||!c||d||!e||f||!g||h)&&(a||b||!c||d||!e||f||g||!h)&&(a||b||!c||d||e||!f||!g||h)&&" \
      "(a||b||!c||d||e||!f||g||!h)&&(a||b||!c||d||e||f||!g||!h)&&(a||b||c||!d||!e||!f||g||h)&&" \
      "(a||b||c||!d||!e||f||!g||h)&&(a||b||c||!d||!e||f||g||!h)&&(a||b||c||!d||e||!f||!g||h)&&" \
      "(a||b||c||!d||e||!f||g||!h)&&(a||b||c||!d||e||f||!g||!h)&&(a||b||c||d||!e||!f||!g||h)&&" \
      "(a||b||c||d||!e||!f||g||!h)&&(a||b||c||d||!e||f||!g||!h)&&(a||b||c||d||e||!f||!g||!h)&&" \
      "(!b||!c||!center||d||e||f||g||h)&&(!b||c||!center||!d||e||f||g||h)&&(!b||c||!center||d||!e||f||g||h)&&" \
      "(!b||c||!center||d||e||!f||g||h)&&(!b||c||!center||d||e||f||!g||h)&&(!b||c||!center||d||e||f||g||!h)&&" \
      "(b||!c||!center||!d||e||f||g||h)&&(b||!c||!center||d||!e||f||g||h)&&(b||!c||!center||d||e||!f||g||h)&&" \
      "(b||!c||!center||d||e||f||!g||h)&&(b||!c||!center||d||e||f||g||!h)&&(b||c||!center||!d||!e||f||g||h)&&" \
      "(b||c||!center||!d||e||!f||g||h)&&(b||c||!center||!d||e||f||!g||h)&&(b||c||!center||!d||e||f||g||!h)&&" \
      "(b||c||!center||d||!e||!f||g||h)&&(b||c||!center||d||!e||f||!g||h)&&(b||c||!center||d||!e||f||g||!h)&&" \
      "(b||c||!center||d||e||!f||!g||h)&&(b||c||!center||d||e||!f||g||!h)&&(b||c||!center||d||e||f||!g||!h)"

    return mathematica_to_CNF(s, center, a)

# FIXME: slow
def SAT_solution_to_grid(solution):
    grid=[[False for c in range(WIDTH)] for r in range(HEIGHT)]
    for r in range(1,HEIGHT+1):
        for c in range(1,WIDTH+1):
            v=coords_to_var(r, c)
            if v in solution:
                grid[r-1][c-1]=True
            if "-"+v in solution:
                grid[r-1][c-1]=False
    return grid

def try_again (clauses):
    # make an empty invisible border
    # all variables are negated (because they must be False)
    for c in range(WIDTH+2):
        clauses.append ("-"+coords_to_var(0,c))
        clauses.append ("-"+coords_to_var(HEIGHT+1,c))
    for r in range(HEIGHT+2):
        clauses.append ("-"+coords_to_var(r,0))
        clauses.append ("-"+coords_to_var(r,WIDTH+1))
   
    # make an empty visible border
    # all variables are negated (because they must be False)
    for c in range(1,WIDTH+1):
        clauses.append ("-"+coords_to_var(1,c))
        clauses.append ("-"+coords_to_var(HEIGHT,c))
    for r in range(1,HEIGHT+1):
        clauses.append ("-"+coords_to_var(r,1))
        clauses.append ("-"+coords_to_var(r,WIDTH))

    for r in range(1,HEIGHT+1):
        for c in range(1,WIDTH+1):
            neighbours=[coords_to_var(r-1, c-1), coords_to_var(r-1, c), coords_to_var(r-1, c+1), coords_to_var(r, c-1),
                            coords_to_var(r, c+1), coords_to_var(r+1, c-1), coords_to_var(r+1, c), coords_to_var(r+1, c+1)]
            if final_state[r-1][c-1]=="*":
                clauses=clauses+cell_is_true(coords_to_var(r, c), neighbours)
            else:
                clauses=clauses+cell_is_false(coords_to_var(r, c), neighbours)

    write_CNF("tmp.cnf", clauses, VARS_TOTAL)

    print "%d clauses" % len(clauses)

    solution=run_minisat ("tmp.cnf")
    os.remove("tmp.cnf")
    if solution==None:
        print "unsat!"
        exit(0)
    
    grid=SAT_solution_to_grid(solution)

    print_grid(grid)
    write_RLE(grid)

    return grid

clauses=[]
while True:
    solution=try_again(clauses)
    clauses.append(negate_clause(grid_to_clause(solution)))
    clauses.append(negate_clause(grid_to_clause(reflect_vertically(solution))))
    clauses.append(negate_clause(grid_to_clause(reflect_horizontally(solution))))
    # is this square?
    if WIDTH==HEIGHT:
        clauses.append(negate_clause(grid_to_clause(rotate_square_array(solution,1))))
        clauses.append(negate_clause(grid_to_clause(rotate_square_array(solution,2))))
        clauses.append(negate_clause(grid_to_clause(rotate_square_array(solution,3))))
    print ""

