import sys, subprocess, os

def read_lines_from_file (fname):
    f=open(fname)
    new_ar=[item.rstrip() for item in f.readlines()]
    f.close()
    return new_ar

def mathematica_to_CNF (s, center, a):
    s=s.replace("center", center)
    s=s.replace("a", a[0]).replace("b", a[1]).replace("c", a[2]).replace("d", a[3])
    s=s.replace("e", a[4]).replace("f", a[5]).replace("g", a[6]).replace("h", a[7])
    s=s.replace("!", "-").replace("||", " ").replace("(", "").replace(")", "")
    s=s.split ("&&")
    return s

cnt=0
def write_RLE(grid):
    global cnt
    cnt=cnt+1
    fname="%d.rle" % cnt
    f=open(fname, "w")
    HEIGHT=len(grid)
    WIDTH=len(grid[0])
    f.write ("x = %d, y = %d, rule = B3/S23\n" % (WIDTH, HEIGHT))

    for r in range(HEIGHT):
        for c in range(WIDTH):
            f.write("o" if grid[r][c] else "b")
        f.write("!" if r+1==HEIGHT else "$")

    f.close()
    print fname+" written"

def reflect_vertically(a):
    rt=[]
    for row in a:
        tmp=row
        tmp.reverse()
        rt.append(tmp)
    return rt

def reflect_horizontally(a):
    rt=a
    rt.reverse()
    return rt

def rotate_square_array_90_CW(a):
    rt=[]
    square_size=len(a)
    for row in range(square_size):
        new_row=[]
        for col in range(square_size):
            new_row.append(a[square_size-1-col][row])
        rt.append(new_row)

    return rt

# angle: 1 - 90 CW; 2 - 180 CW; 3 - 270 CW
# FIXME: slow
def rotate_square_array(a, angle):
    assert (angle>=1)
    assert (angle<=3)

    for i in range(angle):
        a=rotate_square_array_90_CW(a)
    return a

def negate_clause(s):
    rt=[]
    for i in s:
        if i=="0":
            continue
        rt.append(i[1:] if i.startswith("-") else "-"+i)
    return " ".join(rt)

def print_grid(grid):
    for row in grid:
        [sys.stdout.write("*" if col else ".") for col in row]
        sys.stdout.write("\n")
    
def write_CNF(fname, clauses, VARS_TOTAL):
    f=open(fname, "w")
    f.write ("p cnf "+str(VARS_TOTAL)+" "+str(len(clauses))+"\n")
    [f.write(c+" 0\n") for c in clauses]
    f.close()
    
def run_minisat (CNF_fname):
    child = subprocess.Popen(["minisat", CNF_fname, "results.txt"], stdout=subprocess.PIPE)
    child.wait()
    # 10 is SAT, 20 is UNSAT
    if child.returncode==20:
        os.remove ("results.txt")
        return None

    if child.returncode!=10:
        print "(minisat) unknown retcode: ", child.returncode
        exit(0)
    
    solution=read_lines_from_file("results.txt")[1]
    os.remove ("results.txt")

    return solution

