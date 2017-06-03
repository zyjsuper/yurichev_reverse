m4_include(`commons.m4')

_HEADER_HL1(`3-Jun-2017: Worst sorting algorithm I ever saw')

<p>Kernighan/Pike's book "The Practice of Programming" has a nice exercise:</p>

_PRE_BEGIN()
Exercise 2-4. Design and implement an algorithm that will sort an array of n integers
as slowly as possible. You have to play fair: the algorithm must make progress and
eventually terminate, and the implementation must not cheat with tricks like timewasting
loops. What is the complexity of your algorithm as a function of n?
_PRE_END()

<p>The problem is in fact tricky, but I've seen solution once in a serious a big software I've rewritten to C.</p>

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

<p>This is bubble sort gone wrong, there are no <i>has-been-swapped</i> variable, so the author added another loop,
just to be sure everything is sorted at the end.</p>

<p>Bubble sort has worst-case performance $O(n^2)$ and best-case $O(n)$, this one always requires $n^2$ steps.</p>

<p>The moral of the story: sometimes it's easier to observe inputs/outputs, then to comprehend the code.</p>

<p>Even worse, when I googled for "bubble sort", just to be sure I'm correct, I've found quite similar implementation,
also without temporary variable:</p>

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

<p>It's somewhat faster, but still weird.
I've found it on <i>programmingsimplified.com</i> website:</p>

<p>_HTML_LINK_AS_IS(`http://www.programmingsimplified.com/c/source-code/c-program-bubble-sort'),
_HTML_LINK_AS_IS(`http://archive.is/UbL3E').</p>

<p>Let's hope this is some kind of prank and they are not serious about it.</p>

_BLOG_FOOTER()

