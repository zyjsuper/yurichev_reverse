m4_include(`commons.m4')

_HEADER_HL1(`Solving pocket Rubik’s cube (2*2*2) using Z3 and SAT solver')

_COPYPASTED2()

<p><img src="190px-Pocket_cube_scrambled.jpg"></p>
<p>( The image has been taken _HTML_LINK(`https://en.wikipedia.org/wiki/Pocket_Cube',`from Wikipedia'). )</p>

<p>Solving Rubik's cube is not a problem, finding shortest solution is.</p>

_HL2(`Intro')

<p>First, a bit of terminology.
There are 6 colors we have: white, green, blue, orange, red, yellow.
We also have 6 sides: front, up, down, left, right, back.</p>

<p>This is how we will name all facelets:<p>

_PRE_BEGIN
          U00 U01
          U10 U11

          -------
L00 L01 | F00 F01 | R00 R01 | B00 B01
L10 L11 | F10 F11 | R10 R11 | B10 B11
          -------

          D00 D01
          D10 D11
_PRE_END

<p>Colors on a solved cube are:</p>

_PRE_BEGIN
    G G
    G G
    ---
R R|W W|O O|Y Y
R R|W W|O O|Y Y
    ---
    B B
    B B
_PRE_END

<p>There are 6 possible turns: front, left, right, back, up, down.
But each turn can be clockwise, counterclockwise and half-turn (equal to two CW or two CCW).
Each CW is equal to 3 CCW and vice versa.
Hence, there are 6*3=18 possible turns.</p>

<p>It is known, that 11 turns (including half-turns) are enough to solve any pocket cube (_HTML_LINK(`https://en.wikipedia.org/wiki/Optimal_solutions_for_Rubik%27s_Cube',`God’s algorithm')).
This means, _HTML_LINK(`http://mathworld.wolfram.com/GraphDiameter.html',`graph has a diameter') of 11.
For 3*3*3 cube one need 20 turns (_HTML_LINK_AS_IS(`http://www.cube20.org/')).
See also: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Rubik%27s_Cube_group').</p>

_HL2(`Z3')

<p>There are 6 sides and 4 facelets on each, hence, 6*4=24 variables we need to define a state.<p>

<p>Then we define how state is transformed after each possible turn:<p>

_PRE_BEGIN
FACE_F, FACE_U, FACE_D, FACE_R, FACE_L, FACE_B = 0,1,2,3,4,5

def rotate_FCW(s):
    return [
        [ s[FACE_F][2], s[FACE_F][0], s[FACE_F][3], s[FACE_F][1] ],   # for F
        [ s[FACE_U][0], s[FACE_U][1], s[FACE_L][3], s[FACE_L][1] ],   # for U
        [ s[FACE_R][2], s[FACE_R][0], s[FACE_D][2], s[FACE_D][3] ],   # for D
        [ s[FACE_U][2], s[FACE_R][1], s[FACE_U][3], s[FACE_R][3] ],   # for R
        [ s[FACE_L][0], s[FACE_D][0], s[FACE_L][2], s[FACE_D][1] ],   # for L
        [ s[FACE_B][0], s[FACE_B][1], s[FACE_B][2], s[FACE_B][3] ] ]  # for B

def rotate_FH(s):
    return [
        [ s[FACE_F][3], s[FACE_F][2], s[FACE_F][1], s[FACE_F][0] ],
        [ s[FACE_U][0], s[FACE_U][1], s[FACE_D][1], s[FACE_D][0] ],
        [ s[FACE_U][3], s[FACE_U][2], s[FACE_D][2], s[FACE_D][3] ],
        [ s[FACE_L][3], s[FACE_R][1], s[FACE_L][1], s[FACE_R][3] ],
        [ s[FACE_L][0], s[FACE_R][2], s[FACE_L][2], s[FACE_R][0] ],
        [ s[FACE_B][0], s[FACE_B][1], s[FACE_B][2], s[FACE_B][3] ] ]

...
_PRE_END

<p>Then we define a function, which takes turn number and transforms a state:<p>

_PRE_BEGIN
# op is turn number
def rotate(turn, state, face, facelet):
    return If(op==0,  rotate_FCW (state)[face][facelet],
           If(op==1,  rotate_FCCW(state)[face][facelet],
           If(op==2,  rotate_UCW (state)[face][facelet],
           If(op==3,  rotate_UCCW(state)[face][facelet],
           If(op==4,  rotate_DCW (state)[face][facelet],

...

           If(op==17, rotate_BH  (state)[face][facelet],
                      0))))))))))))))))))
_PRE_END

<p>Now set "solved" state, initial state and connect everything:<p>

_PRE_BEGIN
move_names=["FCW", "FCCW", "UCW", "UCCW", "DCW", "DCCW", "RCW", "RCCW", "LCW", "LCCW", "BCW", "BCCW", "FH", "UH", "DH", "RH", "LH", "BH"]

def colors_to_array_of_ints(s):
    return [{"W":0, "G":1, "B":2, "O":3, "R":4, "Y":5}[c] for c in s]

def set_current_state (d):
    F=colors_to_array_of_ints(d["FACE_F"])
    U=colors_to_array_of_ints(d["FACE_U"])
    D=colors_to_array_of_ints(d["FACE_D"])
    R=colors_to_array_of_ints(d["FACE_R"])
    L=colors_to_array_of_ints(d["FACE_L"])
    B=colors_to_array_of_ints(d["FACE_B"])
    return F,U,D,R,L,B # return tuple

# 4
init_F, init_U, init_D, init_R, init_L, init_B=set_current_state({"FACE_F":"RYOG", "FACE_U":"YRGO", "FACE_D":"WRBO", "FACE_R":"GYWB", "FACE_L":"BYWG", "FACE_B":"BOWR"})

...

for TURNS in range(1,12): # 1..11
    print "turns=", TURNS

    s=Solver()

    state=[[[Int('state%d_%d_%d' % (n, side, i)) for i in range(FACELETS)] for side in range(FACES)] for n in range(TURNS+1)]
    op=[Int('op%d' % n) for n in range(TURNS+1)]

    for i in range(FACELETS):
        s.add(state[0][FACE_F][i]==init_F[i])
        s.add(state[0][FACE_U][i]==init_U[i])
        s.add(state[0][FACE_D][i]==init_D[i])
        s.add(state[0][FACE_R][i]==init_R[i])
        s.add(state[0][FACE_L][i]==init_L[i])
        s.add(state[0][FACE_B][i]==init_B[i])

    # solved state
    for face in range(FACES):
        for facelet in range(FACELETS):
            s.add(state[TURNS][face][facelet]==face)

    # turns:
    for turn in range(TURNS):
        for face in range(FACES):
            for facelet in range(FACELETS):
                s.add(state[turn+1][face][facelet]==rotate(op[turn], state[turn], face, facelet))

    if s.check()==sat:
        print "sat"
        m=s.model()
        for turn in range(TURNS):
            print move_names[int(str(m[op[turn]]))]
        exit(0)
_PRE_END

<p>( The full source code: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/rubik/rubik2_z3.py') )<p>

<p>That works:<p>

_PRE_BEGIN
turns= 1
turns= 2
turns= 3
turns= 4
sat
RCW
UCW
DCW
RCW
_PRE_END

<p>...but very slow. It takes up to 1 hours to find a path of 8 turns, which is not enough, we need 11.<p>

<p>Nevetheless, I decided to include Z3 solver as a demonstration.<p>

_HL2(`SAT')

<p>I had success with my SAT-based solver, which can find an 11-turn path for a matter of 10-20 minutes on my old
Intel Xeon E3-1220 3.10GHz.<p>

<p>First, we will encode each color as 3-bit bit vector.
Then we can build electronic circuit, which will take initial state of cube and output final state.
It can have switches for each turn on each state.<p>

_PRE_BEGIN
                 +-----+    +-----+     +-----+
initial state -> | blk | -> | blk | ... | blk | -> final state
                 +-----+    +-----+     +-----+
                    ^          ^           ^
                    |          |           |
                  turn 1     turn 2    last turn
_PRE_END

<p>You set all turns and the device "calculates" final state.<p>

<p>Each "blk" can be constisted of 24 multiplexers (MUX), each for each facelet.
Each MUX is controlled by 5-bit command (turn number).
Depending on command, MUX takes 3-bit color from a facelet from a previous state.</p>

<p>Here is a table: the first column is a "destination" facelet, then a list of "source" facelets for each turn:</p>

_PRE_BEGIN
    #       dst,  FCW   FH    FCCW  UCW   UH    ...  BCW   BH    BCCW
    add_r("F00",["F10","F11","F01","R00","B00", ... "F00","F00","F00"])
    add_r("F01",["F00","F10","F11","R01","B01", ... "F01","F01","F01"])
    add_r("F10",["F11","F01","F00","F10","F10", ... "F10","F10","F10"])
    add_r("F11",["F01","F00","F10","F11","F11", ... "F11","F11","F11"])
    add_r("U00",["U00","U00","U00","U10","U11", ... "R01","D11","L10"])
    add_r("U01",["U01","U01","U01","U00","U10", ... "R11","D10","L00"])
    add_r("U10",["L11","D01","R00","U11","U01", ... "U10","U10","U10"])
    add_r("U11",["L01","D00","R10","U01","U00", ... "U11","U11","U11"])
    add_r("D00",["R10","U11","L01","D00","D00", ... "D00","D00","D00"])
    add_r("D01",["R00","U10","L11","D01","D01", ... "D01","D01","D01"])
    add_r("D10",["D10","D10","D10","D10","D10", ... "L00","U01","R11"])
    add_r("D11",["D11","D11","D11","D11","D11", ... "L10","U00","R01"])
    add_r("R00",["U10","L11","D01","B00","L00", ... "R00","R00","R00"])
    add_r("R01",["R01","R01","R01","B01","L01", ... "D11","L10","U00"])
    add_r("R10",["U11","L01","D00","R10","R10", ... "R10","R10","R10"])
    add_r("R11",["R11","R11","R11","R11","R11", ... "D10","L00","U01"])
    add_r("L00",["L00","L00","L00","F00","R00", ... "U01","R11","D10"])
    add_r("L01",["D00","R10","U11","F01","R01", ... "L01","L01","L01"])
    add_r("L10",["L10","L10","L10","L10","L10", ... "U00","R01","D11"])
    add_r("L11",["D01","R00","U10","L11","L11", ... "L11","L11","L11"])
    add_r("B00",["B00","B00","B00","L00","F00", ... "B10","B11","B01"])
    add_r("B01",["B01","B01","B01","L01","F01", ... "B00","B10","B11"])
    add_r("B10",["B10","B10","B10","B10","B10", ... "B11","B01","B00"])
    add_r("B11",["B11","B11","B11","B11","B11", ... "B01","B00","B10"])
_PRE_END

<p>Each MUX has 32 inputs, each has width of 3 bits: colors from "source" facelets.
It has 3-bit output (color for "destination" facelet).
It has 5-bit selector, for 18 turns. Other selector values (32-18=14 values) are not used at all.</p>

<p>The whole problem is to build a circuit and then ask SAT solver to set "switches" to such a state,
when input and output are determined (by us).</p>

<p>Now the problem is to represent MUX in CNF terms.</p>

<p>From EE courses we can remember about a simple if-then-else (ITE) gate, it takes 3 inputs
("selector", "true" and "false") and it has 1 output.
Depending on "selector" input it "connects" output with "true" or "false" input.
Using tree of ITE gates we first can build 32-to-1 MUX, then wide 32*3-to-3 MUX.</p>

<p>I once have written small utility to search for shortest possible CNF formula for a specific function,
in a bruteforce manner (_HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/rubik/XOR_CNF_bf.c')).
It was inspired by "aha! hacker assistant" by Henry Warren.
So here is a function:</p>

_PRE_BEGIN
bool func(bool v[VARIABLES])
{

	// ITE:

	bool tmp;
	if (v[0]==0)
		tmp=v[1];
	else
		tmp=v[2];

	return tmp==v[3];
}
_PRE_END

<p>A shortest CNF for it:</p>

_PRE_BEGIN
try_all_CNFs_of_len(1)
try_all_CNFs_of_len(2)
try_all_CNFs_of_len(3)
try_all_CNFs_of_len(4)
found a CNF:
p cnf 4 4
-1 3 -4 0
1 2 -4 0
-1 -3 4 0
1 -2 4 0
_PRE_END

<p>1st variable is "select", 2nd is "false", 3rd is "true", 4th is "output".
"output" is an additional variable, added just like in Tseitin transformations.</p>

<p>Hence, CNF formula is:</p>

_PRE_BEGIN
(!select OR true OR !output) AND (select OR false OR !output) AND (!select OR !true OR output) AND (select OR !false OR output)
_PRE_END

<p>It assures that the "output" will always be equal to one of inputs depending on "select".</p>

<p>Now we can build a tree of ITE gates:</p>

_PRE_BEGIN
def create_ITE(s,f,t):
    x=create_var()

    clauses.append([neg(s),t,neg(x)])
    clauses.append([s,f,neg(x)])
    clauses.append([neg(s),neg(t),x])
    clauses.append([s,neg(f),x])

    return x

# ins=16 bits
# sel=4 bits
def create_MUX(ins, sel):
    t0=create_ITE(sel[0],ins[0],ins[1])
    t1=create_ITE(sel[0],ins[2],ins[3])
    t2=create_ITE(sel[0],ins[4],ins[5])
    t3=create_ITE(sel[0],ins[6],ins[7])
    t4=create_ITE(sel[0],ins[8],ins[9])
    t5=create_ITE(sel[0],ins[10],ins[11])
    t6=create_ITE(sel[0],ins[12],ins[13])
    t7=create_ITE(sel[0],ins[14],ins[15])

    y0=create_ITE(sel[1],t0,t1)
    y1=create_ITE(sel[1],t2,t3)
    y2=create_ITE(sel[1],t4,t5)
    y3=create_ITE(sel[1],t6,t7)

    z0=create_ITE(sel[2],y0,y1)
    z1=create_ITE(sel[2],y2,y3)

    return create_ITE(sel[3], z0, z1)
_PRE_END

<p>This is my old MUX I wrote for 16 inputs and 4-bit selector, but you've got the idea: this is 4-tier tree.
It has 15 ITE gates or 15*4=60 clauses.</p>

<p>Now the question, is it possible to make it smaller?
I've tried to use Mathematica.
First I've built truth table for 4-bit selector:</p>

_PRE_BEGIN
...
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 0 1 1    0    0
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 0 1 1    1    1
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 1 0 0    0    0
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 1 0 0    1    1
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 1 0 1    0    0
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 1 0 1    1    1
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 1 1 0    0    0
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 1 1 0    1    1
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 1 1 1    0    0
1 1 1 1     1 1 1 1 1 1 0 1 0 1 0 1 1 1 1 1    1    1
1 1 1 1     1 1 1 1 1 1 0 1 0 1 1 0 0 0 0 0    0    0
1 1 1 1     1 1 1 1 1 1 0 1 0 1 1 0 0 0 0 0    1    1
1 1 1 1     1 1 1 1 1 1 0 1 0 1 1 0 0 0 0 1    0    0
1 1 1 1     1 1 1 1 1 1 0 1 0 1 1 0 0 0 0 1    1    1
1 1 1 1     1 1 1 1 1 1 0 1 0 1 1 0 0 0 1 0    0    0
1 1 1 1     1 1 1 1 1 1 0 1 0 1 1 0 0 0 1 0    1    1
1 1 1 1     1 1 1 1 1 1 0 1 0 1 1 0 0 0 1 1    0    0
...
_PRE_END

<p>First 4 bits is selector, then 16 bits of input.
Then the possible output and the bit, indicating, if the output bit equals to one of the inputs.</p>

<p>Then I load this table to Mathematica and make CNF expression out of truth table:</p>

_PRE_BEGIN
arr=Import["/home/dennis/P/Rubik/TT","Table"]
{{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1}, ⋯2097135⋯ ,
{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0},{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1},{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0},
{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0},{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1},
{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0},{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}}


TT=(Most[#]->Last[#])&/@arr
{{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}->1,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}->0,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0}->0,
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1}->1,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0}->1,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1}->0,
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0}->0,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1}->1,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0}->1, ⋯2097135⋯ ,
{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0}->0,{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1}->1,{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0}->0,
{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1}->1,{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0}->0,{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1}->1,
{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}->0,{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}->1}


BooleanConvert[BooleanFunction[TT,{s3,s2,s1,s0, i15,i14,i13,i12,i11,i10,i9,i8,i7,i6,i5,i4,i3, i2, i1, i0,x}],"CNF"]
(!i0||s0||s1||s2||s3||x)&&(i0||s0||s1||s2||s3||!x)&&(!i1||!s0||s1||s2||s3||x)&&(i1||!s0||s1||s2||s3||!x)&&(!i10||s0||!s1||s2||!s3||x)&&
(i10||s0||!s1||s2||!s3||!x)&&(!i11||!s0||!s1||s2||!s3||x)&&(i11||!s0||!s1||s2||!s3||!x)&&(!i12||s0||s1||!s2||!s3||x)&&(i12||s0||s1||!s2||!s3||!x)&&
(!i13||!s0||s1||!s2||!s3||x)&&(i13||!s0||s1||!s2||!s3||!x)&&(!i14||s0||!s1||!s2||!s3||x)&&(i14||s0||!s1||!s2||!s3||!x)&&
(!i15||!s0||!s1||!s2||!s3||x)&&(i15||!s0||!s1||!s2||!s3||!x)&&(!i2||s0||!s1||s2||s3||x)&&(i2||s0||!s1||s2||s3||!x)&&(!i3||!s0||!s1||s2||s3||x)&&
(i3||!s0||!s1||s2||s3||!x)&&(!i4||s0||s1||!s2||s3||x)&&(i4||s0||s1||!s2||s3||!x)&&(!i5||!s0||s1||!s2||s3||x)&&(i5||!s0||s1||!s2||s3||!x)&&
(!i6||s0||!s1||!s2||s3||x)&&(i6||s0||!s1||!s2||s3||!x)&&(!i7||!s0||!s1||!s2||s3||x)&&(i7||!s0||!s1||!s2||s3||!x)&&(!i8||s0||s1||s2||!s3||x)&&
(i8||s0||s1||s2||!s3||!x)&&(!i9||!s0||s1||s2||!s3||x)&&(i9||!s0||s1||s2||!s3||!x)
_PRE_END

Look closer to CNF expression:

_PRE_BEGIN
(!i0|   |s0||s1||s2|| s3|| x)&&
( i0||  s0|| s1||s2|| s3||!x)&&
(!i1||! s0|| s1||s2|| s3|| x)&&
( i1||! s0|| s1||s2|| s3||!x)&&
(!i10|| s0||!s1||s2||!s3|| x)&&
( i10|| s0||!s1||s2||!s3||!x)&&
(!i11||!s0||!s1||s2||!s3|| x)&&
( i11||!s0||!s1||s2||!s3||!x)&&

...

(!i8|| s0||s1||s2||!s3|| x)&&
( i8|| s0||s1||s2||!s3||!x)&&
(!i9||!s0||s1||s2||!s3|| x)&&
( i9||!s0||s1||s2||!s3||!x)
_PRE_END

<p>It has simple structure and there are 32 clauses, against 60 in my previous attempt.
Will it work faster?
No, as my experience shows, it doesn't speed up anything.
Anyway, I used the latter idea to make MUX.</p>

<p>The following function makes pack of MUXes for each state, based on what I've got from Mathematica:</p>

_PRE_BEGIN
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
_PRE_END

<p>Now the function that glues all together:</p>

_PRE_BEGIN
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

...

    #       dst,  FCW   FH    FCCW  UCW   UH    ...  BCW   BH    BCCW
    add_r("F00",["F10","F11","F01","R00","B00", ... "F00","F00","F00"])
    add_r("F01",["F00","F10","F11","R01","B01", ... "F01","F01","F01"])
    add_r("F10",["F11","F01","F00","F10","F10", ... "F10","F10","F10"])
    add_r("F11",["F01","F00","F10","F11","F11", ... "F11","F11","F11"])
...
_PRE_END

<p>Now the full source code: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/rubik/SAT.py').
I tried to make it as concise as possible.
It requires minisat to be installed.</p>

<p>And it works up to 11 turns, starting at 11, then decreasing number of turns.
Here is an output for a state which can be solved with 4 turns:</p>

_PRE_BEGIN
set_state(0, {"F":"RYOG", "U":"YRGO", "D":"WRBO", "R":"GYWB", "L":"BYWG", "B":"BOWR"})
_PRE_END

_PRE_BEGIN
m4_include(`blog/rubik/post_RDUR.txt')
_PRE_END

<p>Even on my relic Intel Atom 1.5GHz netbook it takes just 20s.</p>

<p>You can find redundant turns in 11-turn solution, like double UH turns.
Of course, two UH turns returns the cube to the previous state.
So these "annihilating turns" are added if the final solution can be shorter.
Why the solver added it? There is no "no operation" turn. And the solver is forced to fit into 11 turns.
Hence, it do what it can to produce correct solution.</p>

<p>Now a hard example:</p>

_PRE_BEGIN
set_state(0, {"F":"RORW", "U":"BRBB", "D":"GOOR", "R":"WYGY", "L":"OWYW", "B":"BYGG"})
_PRE_END

_PRE_BEGIN
TURNS= 11
len(clauses)= 52440
sat!
UCW
BCW
LCCW
BH
DCW
RH
DCCW
FCW
UH
LCW
RCW

TURNS= 10
len(clauses)= 47688
sat!
RH
BCCW
LCCW
RH
BCCW
LH
BCW
DH
BCW
LCCW

...
_PRE_END

<p>( ~5m on my old Intel Xeon E3-1220 3.10GHz. )<p>

<p>I couldn't find a pure "11-turn state" which is "unsat" for 10-turn, it seems, these are rare.
According to _HTML_LINK(`https://en.wikipedia.org/wiki/Pocket_Cube',`wikipedia'), there are just 0.072% of these states.
Like "20-turn states" for 3*3*3 cube, which are also rare.</p>

_HL2(`Several solutions')

<p>According to picosat (--all option to get all possible solutions), the 4-turn example we just saw has 2 solutions.
Indeed, two consequent turns UCW and DCW can be interchanged, they do not conflict with each other.</p>

_HL2(`Other (failed) ideas')

<p>Pocket cube (2*2*2) has no central facelets, so to solve it, you don't need to stick each color to each face.
Rather, you can define a constraint so that a colors on each face must be equal to each other.
Somehow, this slows down drastically my both Z3 and SAT-based solvers.</p>

<p>Also, to prevent "annihilating" turns, we can set a constraint so that each state cannot be equal to any of previous
states, i.e., states cannot repeat.
This also slows down my both solvers.</p>

_HL2(`3*3*3 cube')

<p>3*3*3 cube requires much more turns (20), so I couldn't solve it with my methods.
I have success to solve maybe 10 or 11 turns.
But some people do all 20 turns: _HTML_LINK(`https://arxiv.org/pdf/1105.1436.pdf',`Jingchao Chen').</p>

<p>However, you can use 3*3*3 cube to play, because it can act as 2*2*2 cube: just use corners and ignore
edge and center cubes.
Here is mine I used, you can see that corners are correctly solved:</p>

<img src="3solved.jpg">

_HL2(`My other notes about SAT/SMT')

<p>_HTML_LINK_AS_IS(`https://yurichev.com/writings/SAT_SMT_draft-EN.pdf')</p>

<p>Some discussion: _HTML_LINK_AS_IS(`https://news.ycombinator.com/item?id=15214439'), 
_HTML_LINK_AS_IS(`https://www.reddit.com/r/compsci/comments/6zb34i/solving_pocket_rubiks_cube_222_using_z3_and_sat/'),
_HTML_LINK_AS_IS(`https://www.reddit.com/r/Cubers/comments/6ze3ua/theory_dennis_yurichev_solving_pocket_rubiks_cube/').</p>

<p>Next part: _HTML_LINK_AS_IS(`https://yurichev.com/blog/rubik2/').</p>

_BLOG_FOOTER()

