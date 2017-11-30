m4_include(`commons.m4')

_HEADER_HL1(`Assignment method and Z3')

<p>I've found this at _HTML_LINK_AS_IS(`http://www.math.harvard.edu/archive/20_spring_05/handouts/assignment_overheads.pdf') and took screenshot:</p>

<img src="1.png">

<p>As in my previous examples, Z3 and SMT-solver may be overkill for the task.
Simpler algorithm exists for this task (<i>Hungarian algorithm/method</i>).</p>

<p>See also: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Hungarian_algorithm').</p>

<p>But again, I use it to demonstrate the problem + as SMT-solvers demonstration.</p>

<p>Here is what I do:</p>

_PRE_BEGIN
m4_include(`blog/assign_method/1.py')
_PRE_END

<p>( The source code: _HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/blob/master/blog/assign_method/1.py') )</p>

<p>Result is seems to be correct:</p>

_PRE_BEGIN
sat
[choice_0 = 1,
 choice_1 = 2,
 choice_2 = 0,
 z3name!12 = 0,
 z3name!7 = 1,
 z3name!10 = 2,
 z3name!8 = 0,
 z3name!11 = 0,
 z3name!9 = 0,
 final_sum = 950,
 row_value_2 = 200,
 row_value_1 = 350,
 row_value_0 = 400]
_PRE_END

<p>Again, as it is in the corresponding PDF presentation:</p>

<img src="2.png">

<p>(However, I've no idea what "z3name" variables mean, perhaps, some internal variables?)</p>

_BLOG_FOOTER()

