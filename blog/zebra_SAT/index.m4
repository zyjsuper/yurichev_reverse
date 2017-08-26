m4_include(`commons.m4')

_HEADER_HL1(`Zebra puzzle as a SAT problem')

<p>(The following text has been moved to the article at _HTML_LINK_AS_IS(`https://yurichev.com/tmp/SAT_SMT_DRAFT.pdf').)</p>

<p>Zebra puzzle (AKA Einstein puzzle) defined as follows:

_PRE_BEGIN
1.There are five houses.
2.The Englishman lives in the red house.
3.The Spaniard owns the dog.
4.Coffee is drunk in the green house.
5.The Ukrainian drinks tea.
6.The green house is immediately to the right of the ivory house.
7.The Old Gold smoker owns snails.
8.Kools are smoked in the yellow house.
9.Milk is drunk in the middle house.
10.The Norwegian lives in the first house.
11.The man who smokes Chesterfields lives in the house next to the man with the fox.
12.Kools are smoked in the house next to the house where the horse is kept.
13.The Lucky Strike smoker drinks orange juice.
14.The Japanese smokes Parliaments.
15.The Norwegian lives next to the blue house.

Now, who drinks water? Who owns the zebra?

In the interest of clarity, it must be added that each of the five houses is painted a dif-
ferent color, and their inhabitants are of different national extractions, own different pets,
drink different beverages and smoke different brands of American cigarets [sic]. One other
thing: in statement 6, right means your right.
_PRE_END

<p>( _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Zebra_Puzzle'). )</p>

<p>In past, I've solved it
_HTML_LINK(`https://yurichev.com/writings/30-Jun-2017/SAT_SMT_draft-EN.pdf#page=5&zoom=auto,-13,192',`using Z3')
and
_HTML_LINK(`https://yurichev.com/writings/30-Jun-2017/SAT_SMT_draft-EN.pdf#page=77&zoom=auto,-13,603',`KLEE').
Let's try to solve it using SAT.</p>

<p>How each variable can be defined?
Since each variable is in 1..5 range, each can be encoded usign 3 bits.
I've chosen simpler way: let's allocate 5 booleans to each variable, a single bit at specific position will indicate its
value: "1 0 0 0 0" for 1, "0 1 0 0 0" for 2, etc.
Now we are going to define the fact that only 1 bit among 5 can be present.
We can use "population function", as I did so in my previous "Cracking Minesweeper with SAT solver"
_HTML_LINK(`https://yurichev.com/blog/minesweeper_SAT/',`example').</p>

<p>I've used Wolfram Mathematica for that:</p>

_PRE_BEGIN
In[]:= tbl1=Table[PadLeft[IntegerDigits[i,2],5] ->If[Equal[DigitCount[i,2][[1]],1],1,0],{i,0,63}]
Out[]= {{0,0,0,0,0}->0,
{0,0,0,0,1}->1,
{0,0,0,1,0}->1,
{0,0,0,1,1}->0,
{0,0,1,0,0}->1,
{0,0,1,0,1}->0,

...

{1,1,1,1,0}->0,
{1,1,1,1,1}->0}

In[]:= BooleanConvert[BooleanFunction[tbl1,{a,b,c,d,e}],"CNF"]
Out[]= (!a||!b)&&(!a||!c)&&(!a||!d)&&(!a||!e)&&(a||b||c||d||e)&&(!b||!c)&&(!b||!d)&&(!b||!e)&&(!c||!d)&&(!c||!e)&&(!d||!e)
_PRE_END

<p>... but in fact, the expression is simple enough to write it by hand.
We just enumerate all possible pairs among 4 SAT variables and tell that no pair can have both bits:</p>

_PRE_BEGIN    
(!a||!b)&&
(!a||!c)&&
(!a||!d)&&
(!a||!e)&&
(!b||!c)&&
(!b||!d)&&
(!b||!e)&&
(!c||!d)&&
(!c||!e)&&
(!d||!e)&&
(a||b||c||d||e)
_PRE_END

<p>The last clause means "at least one bit must exist".</p>

<p>Now the following problem: we have 5 houses, colored as "Yellow", "Blue", "Red", "Ivory" and "Green".
All these 5 houses must have distinct values/number.
No two houses can share same value/number.
Here is how can we solve it.</p>

<p>Let the first house be 0 0 0 0 1. The second can be 0 0 0 1 0.
Now we can see that all values, if OR'ed, must have result of 1 1 1 1 1.
For example:</p>

_PRE_BEGIN
Yellow: 0 0 1 0 0
Blue:   0 1 0 0 0
Red:    0 0 0 1 0
Ivory:  1 0 0 0 0
Green:  0 0 0 0 1
-----------------
OR all: 1 1 1 1 1
_PRE_END

<p>Hence, we can define the following condition: all 5 booleans from each column, if OR'ed, must result in 1.</p>

_PRE_BEGIN
def mathematica_to_CNF (s, d):
    for k in d.keys():
        s=s.replace(k, d[k])
    s=s.replace("!", "-").replace("||", " ").replace("(", "").replace(")", "")
    s=s.split ("&&")
    return s

def add_popcnt1(v1, v2, v3, v4, v5):
    global clauses
    s="(!a||!b)&&" \
      "(!a||!c)&&" \
      "(!a||!d)&&" \
      "(!a||!e)&&" \
      "(!b||!c)&&" \
      "(!b||!d)&&" \
      "(!b||!e)&&" \
      "(!c||!d)&&" \
      "(!c||!e)&&" \
      "(!d||!e)&&" \
      "(a||b||c||d||e)"

    clauses=clauses+mathematica_to_CNF(s, {"a":v1, "b":v2, "c":v3, "d":v4, "e":v5})

...

# k=tuple: ("high-level" variable name, number of bit (0..4))
# v=variable number in CNF
vars={}
vars_last=1

...

def alloc_distinct_variables(names):
    global vars
    global vars_last
    for name in names:
        for i in range(5):
            vars[(name,i)]=str(vars_last)
            vars_last=vars_last+1

        add_popcnt1(vars[(name,0)], vars[(name,1)], vars[(name,2)], vars[(name,3)], vars[(name,4)])

    # make them distinct:
    for i in range(5):
        clauses.append(vars[(names[0],i)] + " " + vars[(names[1],i)] + " " + vars[(names[2],i)] + " " + vars[(names[3],i)] + " " + vars[(names[4],i)])

...

alloc_distinct_variables(["Yellow", "Blue", "Red", "Ivory", "Green"])
alloc_distinct_variables(["Norwegian", "Ukrainian", "Englishman", "Spaniard", "Japanese"])
alloc_distinct_variables(["Water", "Tea", "Milk", "OrangeJuice", "Coffee"])
alloc_distinct_variables(["Kools", "Chesterfield", "OldGold", "LuckyStrike", "Parliament"])
alloc_distinct_variables(["Fox", "Horse", "Snails", "Dog", "Zebra"])
_PRE_END

<p>Now we have 5 boolean variables for each "high-level" variable, and each group of variables will always have distinct values.</p>

<p>Now let's reread puzzle description: "2.The Englishman lives in the red house.".
That's easy.
In my Z3 and KLEE examples I just wrote "Englishman==Red".
Same story here: we just add a clauses showing that 5 booleans for "Englishman" must be the same as 5 booleans for "Red".</p>

<p>On a lowest CNF level, if we want to say that two CNF variables must be equal to each other, we add two clauses:</p>

_PRE_BEGIN
(var1 OR ~var2) AND (~var1 OR var2)
_PRE_END

<p>That means, both var1 and var2 must be False or True, they cannot be different.</p>

_PRE_BEGIN
def add_eq_clauses(var1, var2):
    global clauses
    clauses.append(var1 + " -" + var2)
    clauses.append("-"+var1 + " " + var2)

def add_eq (n1, n2):
    for i in range(5):
        add_eq_clauses(vars[(n1,i)], vars[(n2, i)])

...

# 2.The Englishman lives in the red house.
add_eq("Englishman","Red")

# 3.The Spaniard owns the dog.
add_eq("Spaniard","Dog")

# 4.Coffee is drunk in the green house.
add_eq("Coffee","Green")

...

_PRE_END

<p>Now the next conditions:
"9.Milk is drunk in the middle house." (i.e., 3rd house), "10.The Norwegian lives in the first house."
We can just assign boolean values directly:</p>

_PRE_BEGIN
# n=1..5
def add_eq_var_n (name, n):
    global clauses
    global vars
    for i in range(5):
        if i==n-1:
            clauses.append(vars[(name,i)]) # always True
        else:
            clauses.append("-"+vars[(name,i)]) # always False

...

# 9.Milk is drunk in the middle house.
add_eq_var_n("Milk",3) # i.e., 3rd house

# 10.The Norwegian lives in the first house.
add_eq_var_n("Norwegian",1)
_PRE_END

<p>For "Milk" we will have "0 0 1 0 0" value, for "Norwegian": "1 0 0 0 0".</p>

<p>What to do with this?
"6.The green house is immediately to the right of the ivory house."
I can construct the following condition:</p>

_PRE_BEGIN
    Ivory      Green
AND(1 0 0 0 0  0 1 0 0 0)
.. OR ..
AND(0 1 0 0 0  0 0 1 0 0)
.. OR ..
AND(0 0 1 0 0  0 0 0 1 0)
.. OR ..
AND(0 0 0 1 0  0 0 0 0 1)
_PRE_END

<p>There is no "0 0 0 0 1" for Ivory, because it cannot be the last one.
Now I can convert these conditions to CNF using Wolfram Mathematica:</p>

_PRE_BEGIN
In[]:= BooleanConvert[(a1&& !b1&&!c1&&!d1&&!e1&&!a2&& b2&&!c2&&!d2&&!e2) ||
(!a1&& b1&&!c1&&!d1&&!e1&&!a2&& !b2&&c2&&!d2&&!e2) ||
(!a1&& !b1&&c1&&!d1&&!e1&&!a2&& !b2&&!c2&&d2&&!e2) ||
(!a1&& !b1&&!c1&&d1&&!e1&&!a2&& !b2&&!c2&&!d2&&e2) ,"CNF"]

Out[]= (!a1||!b1)&&(!a1||!c1)&&(!a1||!d1)&&(a1||b1||c1||d1)&&!a2&&(!b1||!b2)&&(!b1||!c1)&&
(!b1||!d1)&&(b1||b2||c1||d1)&&(!b2||!c1)&&(!b2||!c2)&&(!b2||!d1)&&(!b2||!d2)&&(!b2||!e2)&&
(b2||c1||c2||d1)&&(b2||c2||d1||d2)&&(b2||c2||d2||e2)&&(!c1||!c2)&&(!c1||!d1)&&(!c2||!d1)&&
(!c2||!d2)&&(!c2||!e2)&&(!d1||!d2)&&(!d2||!e2)&&!e1
_PRE_END

<p>And here is a piece of my Python code:</p>

_PRE_BEGIN
def add_right (n1, n2):
    global clauses
    s="(!a1||!b1)&&(!a1||!c1)&&(!a1||!d1)&&(a1||b1||c1||d1)&&!a2&&(!b1||!b2)&&(!b1||!c1)&&(!b1||!d1)&&" \
      "(b1||b2||c1||d1)&&(!b2||!c1)&&(!b2||!c2)&&(!b2||!d1)&&(!b2||!d2)&&(!b2||!e2)&&(b2||c1||c2||d1)&&" \
      "(b2||c2||d1||d2)&&(b2||c2||d2||e2)&&(!c1||!c2)&&(!c1||!d1)&&(!c2||!d1)&&(!c2||!d2)&&(!c2||!e2)&&" \
      "(!d1||!d2)&&(!d2||!e2)&&!e1"

    clauses=clauses+mathematica_to_CNF(s, {
	"a1": vars[(n1,0)], "b1": vars[(n1,1)], "c1": vars[(n1,2)], "d1": vars[(n1,3)], "e1": vars[(n1,4)],
	"a2": vars[(n2,0)], "b2": vars[(n2,1)], "c2": vars[(n2,2)], "d2": vars[(n2,3)], "e2": vars[(n2,4)]})

...

# 6.The green house is immediately to the right of the ivory house.
add_right("Ivory", "Green")
_PRE_END

<p>What we will do with that?
"11.The man who smokes Chesterfields lives in the house next to the man with the fox."
"12.Kools are smoked in the house next to the house where the horse is kept."</p>

<p>We don't know side, left or right, but we know that they are differ in one.
Here is a clauses I would add:</p>

_PRE_BEGIN
    Chesterfield  Fox
AND(0 0 0 0 1     0 0 0 1 0)
.. OR ..
AND(0 0 0 1 0     0 0 0 0 1)
AND(0 0 0 1 0     0 0 1 0 0)
.. OR ..
AND(0 0 1 0 0     0 1 0 0 0)
AND(0 0 1 0 0     0 0 0 1 0)
.. OR ..
AND(0 1 0 0 0     1 0 0 0 0)
AND(0 1 0 0 0     0 0 1 0 0)
.. OR ..
AND(1 0 0 0 0     0 1 0 0 0)
_PRE_END

<p>I can convert this into CNF using Mathematica again:</p>

_PRE_BEGIN
In[]:= BooleanConvert[(a1&& !b1&&!c1&&!d1&&!e1&&!a2&& b2&&!c2&&!d2&&!e2) ||

(!a1&& b1&&!c1&&!d1&&!e1&&a2&& !b2&&!c2&&!d2&&!e2) ||
(!a1&& b1&&!c1&&!d1&&!e1&&!a2&& !b2&&c2&&!d2&&!e2) ||

(!a1&& !b1&&c1&&!d1&&!e1&&!a2&& b2&&!c2&&!d2&&!e2) ||
(!a1&& !b1&&c1&&!d1&&!e1&&!a2&& !b2&&!c2&&d2&&!e2) ||

(!a1&& !b1&&!c1&&d1&&!e1&&!a2&& !b2&&c2&&!d2&&!e2) ||
(!a1&& !b1&&!c1&&d1&&!e1&&!a2&& !b2&&!c2&&!d2&&e2) ||

(!a1&& !b1&&!c1&&!d1&&e1&&!a2&& !b2&&!c2&&d2&&!e2) ,"CNF"]

Out[]= (!a1||!b1)&&(!a1||!c1)&&(!a1||!d1)&&(!a1||!e1)&&(a1||b1||c1||d1||e1)&&(!a2||b1)&&(!a2||!b2)&&
(!a2||!c2)&&(!a2||!d2)&&(!a2||!e2)&&(a2||b2||c1||c2||d1||e1)&&(a2||b2||c2||d1||d2)&&(a2||b2||c2||d2||e2)&&
(!b1||!b2)&&(!b1||!c1)&&(!b1||!d1)&&(!b1||!e1)&&(b1||b2||c1||d1||e1)&&(!b2||!c2)&&(!b2||!d1)&&(!b2||!d2)&&
(!b2||!e1)&&(!b2||!e2)&&(!c1||!c2)&&(!c1||!d1)&&(!c1||!e1)&&(!c2||!d2)&&(!c2||!e1)&&(!c2||!e2)&&
(!d1||!d2)&&(!d1||!e1)&&(!d2||!e2)
_PRE_END

<p>And here is my code:</p>

_PRE_BEGIN
def add_right_or_left (n1, n2):
    global clauses
    s="(!a1||!b1)&&(!a1||!c1)&&(!a1||!d1)&&(!a1||!e1)&&(a1||b1||c1||d1||e1)&&(!a2||b1)&&" \
      "(!a2||!b2)&&(!a2||!c2)&&(!a2||!d2)&&(!a2||!e2)&&(a2||b2||c1||c2||d1||e1)&&(a2||b2||c2||d1||d2)&&" \
       "(a2||b2||c2||d2||e2)&&(!b1||!b2)&&(!b1||!c1)&&(!b1||!d1)&&(!b1||!e1)&&(b1||b2||c1||d1||e1)&&" \
       "(!b2||!c2)&&(!b2||!d1)&&(!b2||!d2)&&(!b2||!e1)&&(!b2||!e2)&&(!c1||!c2)&&(!c1||!d1)&&(!c1||!e1)&&" \
       "(!c2||!d2)&&(!c2||!e1)&&(!c2||!e2)&&(!d1||!d2)&&(!d1||!e1)&&(!d2||!e2)"
    
    clauses=clauses+mathematica_to_CNF(s, {
	"a1": vars[(n1,0)], "b1": vars[(n1,1)], "c1": vars[(n1,2)], "d1": vars[(n1,3)], "e1": vars[(n1,4)],
	"a2": vars[(n2,0)], "b2": vars[(n2,1)], "c2": vars[(n2,2)], "d2": vars[(n2,3)], "e2": vars[(n2,4)]})

...

# 11.The man who smokes Chesterfields lives in the house next to the man with the fox.
add_right_or_left("Chesterfield","Fox") # left or right

# 12.Kools are smoked in the house next to the house where the horse is kept.
add_right_or_left("Kools","Horse") # left or right
_PRE_END

<p>This is it!
Full source code: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/zebra_SAT/zebra_SAT.py')</p>

<p>Resulting CNF instance has 125 boolean variables and 511 clauses: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/zebra_SAT/1.cnf').
It is a piece of cake for any SAT solver.
Even _HTML_LINK(`https://yurichev.com/blog/SAT_backtrack/',`my toy-level SAT')
solver can solve it in ~1 second on my ancient Intel Atom netbook.</p>

_PRE_BEGIN
% python zebra_SAT.py
Yellow 1
Blue 2
Red 3
Ivory 4
Green 5
Norwegian 1
Ukrainian 2
Englishman 3
Spaniard 4
Japanese 5
Water 1
Tea 2
Milk 3
OrangeJuice 4
Coffee 5
Kools 1
Chesterfield 2
OldGold 3
LuckyStrike 4
Parliament 5
Fox 1
Horse 2
Snails 3
Dog 4
Zebra 5
_PRE_END

<p>My other notes about SAT/SMT: _HTML_LINK_AS_IS(`https://yurichev.com/writings/SAT_SMT_draft-EN.pdf').</p>

_BLOG_FOOTER()

