m4_include(`commons.m4')

_HEADER_HL1(`Enumerating all possible inputs for a specific regexp using Z3 SMT-solver')

<p>Regular expression if first converted to FSM (finite state machine) before matching.
Hence, many RE libraries has two functions: "compile" and "execute" (when you match many strings against single RE, no need to recompile it to FSM each time).</p>

<p>And I've found this website, which can visualize FSM (finite state machine) for a regular expression.
_HTML_LINK_AS_IS(`http://hokein.github.io/Automata.js/').
This is fun!</p>

<p>This FSM (DFA) is for the expression <b>(dark|light)?(red|blue|green)(ish)?</b></p>

<p><img src="FSM.png"></p>

<p>Accepting states are in double circles, these are the states where matching process stops.</p>

<p>How can we generate an input string which regular expression would match?
In other words, which inputs FSM would accept?
This task is surprisingly simple for SMT-solver.</p>

<p>We just define a transition function.
For each pair (state, input) it defines new state.</p>

<p>FSM has been visualized by the website mentioned above, and I used this information to write transition() function.</p>

<p>Then we chain transition functions... then we try a chain for all lengths in range of 2..14.</p>

_PRE_BEGIN
m4_include(`blog/regexp/re.py')
_PRE_END

<p>Results:</p>

_PRE_BEGIN
m4_include(`blog/regexp/res')
_PRE_END

<p>As simple as this.</p>

<p>It can be said, what we did is enumeration of all paths between two vertices of a directed graph (representing FSM).</p>

<p>Also, the transition() function itself can act as a RE matcher, with no relevance to SMT solver(s).
Just feed input characters to it and track state.
Whenever you hit one of accepting states, return "match", whenever you hit INVALID_STATE, return "no match".</p>

_FOOTER()

