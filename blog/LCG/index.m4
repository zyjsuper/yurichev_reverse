m4_include(`commons.m4')

_HEADER_HL1(`2-Mar-2017: Cracking simple LCG PRNG')

<p>LCG (Linear congruential generator) is a simplest PRNG (Pseudorandom number generator) and can be cracked easily.</p>

<p>Here is a clone of a very popular "color lines" game (_HTML_LINK_AS_IS(`https://archive.org/download/BallTriX_1020')).</p>

<p>In its internals we can find that it uses standard MSVC rand() function, like that:</p>

_PRE_BEGIN
uint32_t MSVC_rand()
{
        g_seed = 214013 * g_seed + 2531011;
	return (g_seed & 0x7FFF0000) >> 16;
};
_PRE_END

<p>The game places 3 balls at each step.
Each ball has the following characteristics: row, column and color.
It's easy to see in debugger, that rand() function is called 3 times for each step.
Row and column are computed like that:</p>

_PRE_BEGIN
	rand() % 10
_PRE_END

<p>... while color:</p>

_PRE_BEGIN
	rand() % 5
_PRE_END

<p>At each step, rand() is called twice to get row and column, and then 3rd time to get color.</p>

<p>PRNG facility is initialized like that: srand(time(NULL)).</p>

<p>Let's see, if we can find a way to predict next balls' placement.</p>

<p>For this task, we are going to recover PRNG state.
And I've found that 6 steps are enough to recover it.
This problem can be solved using SMT-solver, but this is overkill; state is 32-bit variable, so it can be found
using simple brute-force.</p>

<p>First, we run it, and in debugger, we can see that 6 triplets is generated using rand():</p>

<p><img src="https://yurichev.com/blog/LCG/1.png"></p>

<p>3 balls are placed and the game is also prepared other 3 balls.
Now we see that at this step, the game is already know where the next 3 balls will be placed.</p>

<p>Now I'm moving topmost ball one step aside:</p>

<p><img src="https://yurichev.com/blog/LCG/2.png"></p>

<p>Now we got 6 pair of coordinates, and we can brute-force PRNG state. I didn't map colors to its numbers, so we ignore them completely.</p>

_PRE_BEGIN
m4_include(`blog/LCG/src.c')
_PRE_END

<p>It took ~80 seconds on my somewhat outdated Xeon E3-1220.
This is enough to get one single candidate:</p>

_PRE_BEGIN
m4_include(`blog/LCG/results.txt')
_PRE_END

<p>Is it correct?
Let's move topmost ball again couple of times:</p>

<p><img src="https://yurichev.com/blog/LCG/3.png"></p>

<p><img src="https://yurichev.com/blog/LCG/4.png"></p>

<p>It seems so.</p>

<p>This is the way we can predict all further balls placements without touching debugger.</p>

_HL2(`Further work')

<p>Since PRNG is initialized using current UNIX time, this can narrow brute-force process, if the current time (or day)
is known.</p>

_HL2(`Exercise')

<p>What happens if the ball is to be placed to the occupied cell?
Will rand() be called again?</p>

_HL2(`Conclusion')

<p>LCG shouldn't be used at all, maybe except of embedded environments where code size is critical.
Mersenne twister is much better, it has bigger internal state.</p>

<p>Even more, you can use block cipher as PRNG, or your favorite hash function: just hash your initial seed at the first step,
then hash results of hashing in infinite loop, this can produce enough entropy to have the same features as PRNG,
but it will not be crackable as easily as LCG.</p>

<p>More ideas and insights: _HTML_LINK(`https://tools.ietf.org/html/rfc4086',`RFC4086'): "Randomness Requirements for Security".</p>

_BLOG_FOOTER()

