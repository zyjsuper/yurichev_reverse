m4_include(`commons.m4')

_HEADER_HL1(`Worst sorting algorithm I ever saw: proving it using KLEE')

<p>Kernighan/Pike's book "The Practice of Programming" has a nice exercise:</p>

_PRE_BEGIN()
Exercise 2-4. Design and implement an algorithm that will sort an array of n integers
as slowly as possible. You have to play fair: the algorithm must make progress and
eventually terminate, and the implementation must not cheat with tricks like timewasting
loops. What is the complexity of your algorithm as a function of n?
_PRE_END()

<p>The problem is in fact tricky, but I've seen solution once in a serious and big piece of code I've rewritten to C.</p>

<p>Here it is:</p>

_PRE_BEGIN()
void swap_ints (int *a, int *b)
{
	int tmp=*a;
	*a=*b;
	*b=tmp;
};

void weird_sort(int* array, size_t size)
{
	for (int i=0; i&lt;size; i++)
		for (int j=0; j&lt;size-1; j++)
			if (array[j]&gt;array[j+1])
				swap_ints (array+j, array+j+1);
};
_PRE_END()

<p>This is bubble sort went wrong, there are no <i>has-been-swapped</i> variable, so the author added another loop,
just to be sure everything is sorted at the end.</p>

<p>Bubble sort has worst-case performance $O(n^2)$ and best-case $O(n)$, this one always requires $n^2$ steps.</p>

<p>The moral of the story: sometimes it's easier to observe inputs/outputs, then to comprehend the code.</p>

<p>Even worse, when I googled for "bubble sort", just to be sure I'm correct, I've found quite similar implementation,
also without <i>has-been-swapped</i> variable:</p>

_PRE_BEGIN()
/* Bubble sort code */
 
#include <stdio.h>
 
int main()
{
  int array[100], n, c, d, swap;
 
  printf("Enter number of elements\n");
  scanf("%d", &n);
 
  printf("Enter %d integers\n", n);
 
  for (c = 0; c < n; c++)
    scanf("%d", &array[c]);
 
  for (c = 0 ; c < ( n - 1 ); c++)
  {
    for (d = 0 ; d < n - c - 1; d++)
    {
      if (array[d] > array[d+1]) /* For decreasing order use < */
      {
        swap       = array[d];
        array[d]   = array[d+1];
        array[d+1] = swap;
      }
    }
  }
 
  printf("Sorted list in ascending order:\n");
 
  for ( c = 0 ; c < n ; c++ )
     printf("%d\n", array[c]);
 
  return 0;
}
_PRE_END()

<p>It's somewhat faster ($O(\frac{n^2}{2})$, if I'm correct), but still weird.
I've found it on <i>programmingsimplified.com</i> website:</p>

<p>_HTML_LINK_AS_IS(`http://www.programmingsimplified.com/c/source-code/c-program-bubble-sort'),
_HTML_LINK_AS_IS(`http://archive.is/UbL3E').</p>

<p>Let's hope this is some kind of prank and they are not serious about it.</p>

_HL2(`Proving it using KLEE')

<p>Despite the fact, it's so bad, it's still correct. Or is it?
We can prove it using KLEE:</p>

_PRE_BEGIN
void swap_unsigned_chars (unsigned char *a, unsigned char *b)
{
        unsigned char tmp=*a;
        *a=*b;
        *b=tmp;
};

void weird_sort(unsigned char* array, size_t size)
{
        for (unsigned char i=0; i&lt;size; i++)
                for (unsigned char j=0; j&lt;size-1; j++)
                        if (array[j]&gt;array[j+1])
                                swap_unsigned_chars (array+j, array+j+1);
};

int main()
{
#define SIZE 6

        unsigned char buf[SIZE];
        klee_make_symbolic(buf, sizeof buf, "buf");

        weird_sort(buf, SIZE);

        // check it

        for (unsigned char i=0; i&lt;SIZE; i++)
                for (unsigned char j=i+1; j&lt;SIZE; j++)
                        if (buf[i]&gt;buf[j])
                                klee_assert(0);
};
_PRE_END

<p>We're asking KLEE to find such a 6 bytes in buf[], so that the buf[] will not be sorted after weird_sort() call.</p>

<p>It's not possible:</p>

_PRE_BEGIN
klee@774a0f6e485f:~$ time klee -libc=uclibc bad_sort.bc
KLEE: NOTE: Using klee-uclibc : /home/klee/klee_build/klee/Release+Debug+Asserts/lib/klee-uclibc.bca
KLEE: output directory is "/home/klee/klee-out-21"
Using STP solver backend
KLEE: WARNING: undefined reference to function: fcntl
KLEE: WARNING: undefined reference to function: fstat
KLEE: WARNING: undefined reference to function: ioctl
KLEE: WARNING: undefined reference to function: klee_assert
KLEE: WARNING: undefined reference to function: open
KLEE: WARNING: undefined reference to function: write
KLEE: WARNING ONCE: calling external: ioctl(0, 21505, 59516896)
KLEE: WARNING ONCE: calling __user_main with extra arguments.

KLEE: done: total instructions = 674686
KLEE: done: completed paths = 720
KLEE: done: generated tests = 720
_PRE_END

<p>KLEE can't find counterexample. Otherwise it would report (klee_assert() would be called):</p>

_PRE_BEGIN
KLEE: ERROR: /home/klee/bad_sort.c:32: failed external call: klee_assert
_PRE_END

<p>Unfortunately, I could only check it again 6-element array of bytes.
And it took 2-3 minutes on my venerable Intel Xeon E3-1220 3.10GHz.
So we can prove it's correct for all arrays of 1..6 elements of bytes.</p>

<p>Read also about proving sorting network correctness using Z3: _HTML_LINK_AS_IS(`https://yurichev.com/writings/SAT_SMT_by_example.pdf#page=82&zoom=auto,-266,268').</p>

<p>Upd: some people criticize using KLEE for verification: _HTML_LINK_AS_IS(`https://twitter.com/johnregehr/status/1022510275654606848').</p>

_BLOG_FOOTER()

