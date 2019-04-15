m4_include(`commons.m4')

_HEADER_HL1(`[Python][SAT] Optimizing production of a cardboard toy using SAT-solver')

<p>This is a do-it-yourself toy horse I once bought, made of cardboard parts:</p>

<p><img src="assembled.jpg"></p>

<p>All parts came in 3 plates (pardon my cheap smartphone):</p>

<p><img src="plate1.jpg"></p>

<p><img src="plate2.jpg"></p>

<p><img src="plate3.jpg"></p>

<p>And the assembly manual:</p>

<p><img src="ins1.jpg"></p>

<p><img src="ins2.jpg"></p>

<p>Now the question: can we put all the parts needed on smaller plates?
To save some cardboard material?</p>

<p>I "digitized" all parts using usual notebook:</p>

<p><img src="digit1.jpg"></p>

<p><img src="digit2.jpg"></p>

<p><img src="digit3.jpg"></p>

<p>I don't know a real size of a square in notebook, probably, ~5mm.
I would call it "one [square] unit".</p>

<p>Then I took the same piece of Python code I used before 
(click _HTML_LINK(`https://yurichev.com/writings/SAT_SMT_by_example.pdf',`here')
and Ctrl-F for "tiling puzzle").
That code used Z3, and I rewrote it for generic SAT.
(_HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/tiling_horse/tiling_pento.py',`The source code').)</p>

<p>It was easy: there are just (a big) pack of boolean variables and AMO1/ALO1 constraints,
or, as I called them before, POPCNT1.</p>

<p>Also, my idea is based on Donald Knuth's 
_HTML_LINK(`https://arxiv.org/pdf/cs/0011047.pdf',`Dancing Links paper')
(I translated it to SAT).</p>

<p>Thanks to parallelized _HTML_LINK(`http://fmv.jku.at/lingeling/',`Plingeling'), I could
find a solution for a 40*30 [units] plate:</p>

<p><img src="1_plate.png"></p>

<p>(_HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/tiling_horse/tiling_horse.py',`The source code'),
it uses _HTML_LINK(`https://github.com/DennisYurichev/SAT_SMT_by_example/blob/master/libs/SAT_lib.py',`SAT_lib library') and Plingeling).</p>

<p>Probably this is smallest plate possible, however, I didn't checked even smaller.</p>

<p>Now the question: the toy factory wants to ship all parts in several (smaller) plates.
Like, 3 of them.
Because one plate is impractical for shipping, handling, etc.</p>

<p>To put all parts on 3 plates, I can just add 2 borders between them:</p>

_PRE_BEGIN
board=["*"*BOARD_SMALL_WIDTH + " " + "*"*BOARD_SMALL_WIDTH + " " + "*"*BOARD_SMALL_WIDTH]*BOARD_SMALL_HEIGHT
_PRE_END

<p>Smallest (3) plates I found: 16*27 [units]:</p>

<p><img src="3_plates.png"></p>

<p>This is slightly better than what was produced by the toy factory (20*30 [units]).</p>

<p>But keep in mind, how coarse my "units" are (~5mm).
You can "digitize" better if you use
_HTML_LINK(`https://en.wikipedia.org/wiki/Graph_paper',`millimeter paper'), but such a problem
would be more hard for SAT solver, of course.</p>

<p>What I also did: this problem required huge AMO1/ALO1 constraints (several thousands
boolean variables).
Naive quadratic encoding can't manage this, also, CNF instances growing greatly.</p>

<p>I used "commander" encoding this time.
For example, you need to add AMO1/ALO1 constraint to 100 variables.
Divide them by 10 parts.
Add naive/quadratic AMO1/ALO1 for each of these 10 parts.
Add OR for each parts.
Then you get 10 OR result.
Each OR result is "commander", like, commander of a squad.
Join them together with quadratic AMO1/ALO1 constraint again.</p>

<p>I do this recursively, so it looks like a tree.
Changing these 5 and 10 constants influences SAT solver's perfomance significantly, probably, tuning is required for each type of task...</p>

_PRE_BEGIN
    # naive/pairwise/quadratic encoding
    def AtMost1_pairwise(self, lst):
        for pair in itertools.combinations(lst, r=2):
            self.add_clause([self.neg(pair[0]), self.neg(pair[1])])

    # "commander" (?) encoding
    def AtMost1_commander(self, lst):
        parts=my_utils.partition(lst, 5)
        c=[]
        for part in parts:
            if len(part)<10:
                self.AtMost1_pairwise(part)
                c.append(self.OR_list(part))
            else:
                c.append(self.AtMost1_commander(part))
        self.AtMost1_pairwise(c)
        return self.OR_list(c)

    def AtMost1(self, lst):
        if len(lst)<=10:
            self.AtMost1_pairwise(lst)
        else:
            self.AtMost1_commander(lst)

    # previously named POPCNT1
    # make one-hot (AKA unitary) variable
    def make_one_hot(self, lst):
        self.AtMost1(lst)
        self.OR_always(lst)
_PRE_END
<p>( _HTML_LINK(`https://github.com/DennisYurichev/SAT_SMT_by_example/blob/master/libs/SAT_lib.py',`src') )</p>

_BLOG_FOOTER()

