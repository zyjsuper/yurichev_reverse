#include <stdio.h>
#include <assert.h>

extern int try_row(int row, int attack_vertical, int attack_RL, int attack_LR, int queens, int mask);

int main()
{
	for (int i=1; i<=14; i++)
		printf ("%d*%d total=%d\n", i, i, try_row(0, 0, 0, 0, i, 1<<(i-1)));
/*
	assert (try_row(0, 0, 0, 0, 1, 1<<(1-1))==1);
	assert (try_row(0, 0, 0, 0, 2, 1<<(2-1))==0);
	assert (try_row(0, 0, 0, 0, 3, 1<<(3-1))==0);
	assert (try_row(0, 0, 0, 0, 4, 1<<(4-1))==2);
	assert (try_row(0, 0, 0, 0, 5, 1<<(5-1))==10);
	assert (try_row(0, 0, 0, 0, 6, 1<<(6-1))==4);
	assert (try_row(0, 0, 0, 0, 7, 1<<(7-1))==40);
	assert (try_row(0, 0, 0, 0, 8, 1<<(8-1))==92);
	assert (try_row(0, 0, 0, 0, 9, 1<<(9-1))==352);
	assert (try_row(0, 0, 0, 0, 10, 1<<(10-1))==724);
	assert (try_row(0, 0, 0, 0, 11, 1<<(11-1))==2680);
	assert (try_row(0, 0, 0, 0, 12, 1<<(12-1))==14200);
	assert (try_row(0, 0, 0, 0, 13, 1<<(13-1))==73712);
	assert (try_row(0, 0, 0, 0, 14, 1<<(14-1))==365596);
*/
};

