#!/usr/bin/python

import os
from GoL_SAT_utils import *

WIDTH=8
HEIGHT=8
VARS_TOTAL=(WIDTH+2)*(HEIGHT+2)

def stillife (center, a):
    s="(!a||!b||!c||!center||!d)&&(!a||!b||!c||!center||!e)&&(!a||!b||!c||!center||!f)&&(!a||!b||!c||!center||!g)&&" \
      "(!a||!b||!c||!center||!h)&&(!a||!b||!c||center||d||e||f||g||h)&&(!a||!b||c||center||!d||e||f||g||h)&&" \
      "(!a||!b||c||center||d||!e||f||g||h)&&(!a||!b||c||center||d||e||!f||g||h)&&(!a||!b||c||center||d||e||f||!g||h)&&" \
      "(!a||!b||c||center||d||e||f||g||!h)&&(!a||!b||!center||!d||!e)&&(!a||!b||!center||!d||!f)&&" \
      "(!a||!b||!center||!d||!g)&&(!a||!b||!center||!d||!h)&&(!a||!b||!center||!e||!f)&&(!a||!b||!center||!e||!g)&&" \
      "(!a||!b||!center||!e||!h)&&(!a||!b||!center||!f||!g)&&(!a||!b||!center||!f||!h)&&(!a||!b||!center||!g||!h)&&" \
      "(!a||b||!c||center||!d||e||f||g||h)&&(!a||b||!c||center||d||!e||f||g||h)&&(!a||b||!c||center||d||e||!f||g||h)&&" \
      "(!a||b||!c||center||d||e||f||!g||h)&&(!a||b||!c||center||d||e||f||g||!h)&&(!a||b||c||center||!d||!e||f||g||h)&&" \
      "(!a||b||c||center||!d||e||!f||g||h)&&(!a||b||c||center||!d||e||f||!g||h)&&(!a||b||c||center||!d||e||f||g||!h)&&" \
      "(!a||b||c||center||d||!e||!f||g||h)&&(!a||b||c||center||d||!e||f||!g||h)&&(!a||b||c||center||d||!e||f||g||!h)&&" \
      "(!a||b||c||center||d||e||!f||!g||h)&&(!a||b||c||center||d||e||!f||g||!h)&&(!a||b||c||center||d||e||f||!g||!h)&&" \
      "(!a||!c||!center||!d||!e)&&(!a||!c||!center||!d||!f)&&(!a||!c||!center||!d||!g)&&(!a||!c||!center||!d||!h)&&" \
      "(!a||!c||!center||!e||!f)&&(!a||!c||!center||!e||!g)&&(!a||!c||!center||!e||!h)&&(!a||!c||!center||!f||!g)&&" \
      "(!a||!c||!center||!f||!h)&&(!a||!c||!center||!g||!h)&&(!a||!center||!d||!e||!f)&&(!a||!center||!d||!e||!g)&&" \
      "(!a||!center||!d||!e||!h)&&(!a||!center||!d||!f||!g)&&(!a||!center||!d||!f||!h)&&(!a||!center||!d||!g||!h)&&" \
      "(!a||!center||!e||!f||!g)&&(!a||!center||!e||!f||!h)&&(!a||!center||!e||!g||!h)&&(!a||!center||!f||!g||!h)&&" \
      "(a||!b||!c||center||!d||e||f||g||h)&&(a||!b||!c||center||d||!e||f||g||h)&&(a||!b||!c||center||d||e||!f||g||h)&&" \
      "(a||!b||!c||center||d||e||f||!g||h)&&(a||!b||!c||center||d||e||f||g||!h)&&(a||!b||c||center||!d||!e||f||g||h)&&" \
      "(a||!b||c||center||!d||e||!f||g||h)&&(a||!b||c||center||!d||e||f||!g||h)&&(a||!b||c||center||!d||e||f||g||!h)&&" \
      "(a||!b||c||center||d||!e||!f||g||h)&&(a||!b||c||center||d||!e||f||!g||h)&&(a||!b||c||center||d||!e||f||g||!h)&&" \
      "(a||!b||c||center||d||e||!f||!g||h)&&(a||!b||c||center||d||e||!f||g||!h)&&(a||!b||c||center||d||e||f||!g||!h)&&" \
      "(a||b||!c||center||!d||!e||f||g||h)&&(a||b||!c||center||!d||e||!f||g||h)&&(a||b||!c||center||!d||e||f||!g||h)&&" \
      "(a||b||!c||center||!d||e||f||g||!h)&&(a||b||!c||center||d||!e||!f||g||h)&&(a||b||!c||center||d||!e||f||!g||h)&&" \
      "(a||b||!c||center||d||!e||f||g||!h)&&(a||b||!c||center||d||e||!f||!g||h)&&(a||b||!c||center||d||e||!f||g||!h)&&" \
      "(a||b||!c||center||d||e||f||!g||!h)&&(a||b||c||!center||d||e||f||g)&&(a||b||c||!center||d||e||f||h)&&" \
      "(a||b||c||!center||d||e||g||h)&&(a||b||c||!center||d||f||g||h)&&(a||b||c||!center||e||f||g||h)&&" \
      "(a||b||c||center||!d||!e||!f||g||h)&&(a||b||c||center||!d||!e||f||!g||h)&&(a||b||c||center||!d||!e||f||g||!h)&&" \
      "(a||b||c||center||!d||e||!f||!g||h)&&(a||b||c||center||!d||e||!f||g||!h)&&(a||b||c||center||!d||e||f||!g||!h)&&" \
      "(a||b||c||center||d||!e||!f||!g||h)&&(a||b||c||center||d||!e||!f||g||!h)&&(a||b||c||center||d||!e||f||!g||!h)&&" \
      "(a||b||c||center||d||e||!f||!g||!h)&&(a||b||!center||d||e||f||g||h)&&(a||c||!center||d||e||f||g||h)&&" \
      "(!b||!c||!center||!d||!e)&&(!b||!c||!center||!d||!f)&&(!b||!c||!center||!d||!g)&&(!b||!c||!center||!d||!h)&&" \
      "(!b||!c||!center||!e||!f)&&(!b||!c||!center||!e||!g)&&(!b||!c||!center||!e||!h)&&(!b||!c||!center||!f||!g)&&" \
      "(!b||!c||!center||!f||!h)&&(!b||!c||!center||!g||!h)&&(!b||!center||!d||!e||!f)&&(!b||!center||!d||!e||!g)&&" \
      "(!b||!center||!d||!e||!h)&&(!b||!center||!d||!f||!g)&&(!b||!center||!d||!f||!h)&&(!b||!center||!d||!g||!h)&&" \
      "(!b||!center||!e||!f||!g)&&(!b||!center||!e||!f||!h)&&(!b||!center||!e||!g||!h)&&(!b||!center||!f||!g||!h)&&" \
      "(b||c||!center||d||e||f||g||h)&&(!c||!center||!d||!e||!f)&&(!c||!center||!d||!e||!g)&&(!c||!center||!d||!e||!h)&&" \
      "(!c||!center||!d||!f||!g)&&(!c||!center||!d||!f||!h)&&(!c||!center||!d||!g||!h)&&(!c||!center||!e||!f||!g)&&" \
      "(!c||!center||!e||!f||!h)&&(!c||!center||!e||!g||!h)&&(!c||!center||!f||!g||!h)&&(!center||!d||!e||!f||!g)&&" \
      "(!center||!d||!e||!f||!h)&&(!center||!d||!e||!g||!h)&&(!center||!d||!f||!g||!h)&&(!center||!e||!f||!g||!h)"

    return mathematica_to_CNF(s, center, a)

def coords_to_var (row, col):
    # we always use SAT variables as strings, anyway.
    # the 1st variables is 1, not 0
    return str(row*(WIDTH+2)+col+1)

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

def grid_to_clause(grid):
    rt=[]
    for r in range(HEIGHT):
        for c in range(WIDTH):
            rt.append(("-" if grid[r][c]==False else "") + str(coords_to_var(r+1, c+1)))
    return rt

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
            clauses=clauses+stillife(coords_to_var(r, c), neighbours)
   
    # each row must contain at least one cell!
    for r in range(2,HEIGHT):
        clauses.append(" ".join([coords_to_var(r, c) for c in range(2, WIDTH)]))

    # each column must contain at least one cell!
    for c in range(2,WIDTH):
        clauses.append(" ".join([coords_to_var(r, c) for r in range(2, HEIGHT)]))

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


