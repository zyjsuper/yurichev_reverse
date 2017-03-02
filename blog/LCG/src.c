#include &lt;stdio.h>
#include &lt;stdlib.h>
#include &lt;stdint.h>

#define GROUP1_TRIPLET1_COL 2
#define GROUP1_TRIPLET1_ROW 0

#define GROUP1_TRIPLET2_COL 6
#define GROUP1_TRIPLET2_ROW 3

#define GROUP1_TRIPLET3_COL 8
#define GROUP1_TRIPLET3_ROW 5

#define GROUP2_TRIPLET1_COL 9
#define GROUP2_TRIPLET1_ROW 1

#define GROUP2_TRIPLET2_COL 7
#define GROUP2_TRIPLET2_ROW 6

#define GROUP2_TRIPLET3_COL 7
#define GROUP2_TRIPLET3_ROW 4

uint32_t g_seed;

uint32_t MSVC_rand()
{
	g_seed = 214013 * g_seed + 2531011;
	return (g_seed & 0x7FFF0000) >> 16;
};

void chk_seed(uint32_t seed)
{
	int col[6];
	int row[6];
	int color[6];

	g_seed=seed;

	// generate 6 triplets:
	for (int i=0; i<6; i++)
	{
		col[i]=MSVC_rand() % 10;
		row[i]=MSVC_rand() % 10;
		color[i]=MSVC_rand() % 5;
	};

	int group1=0, group2=0;

	// we know coordinates, but we don't know order in which they appeared
	// so we suppose that each triple could be generated at any point...
	for (int i=0; i<3; i++)
	{
		if (col[i]==GROUP1_TRIPLET1_COL && row[i]==GROUP1_TRIPLET1_ROW)
			group1|=1;
		if (col[i]==GROUP1_TRIPLET2_COL && row[i]==GROUP1_TRIPLET2_ROW)
			group1|=2;
		if (col[i]==GROUP1_TRIPLET3_COL && row[i]==GROUP1_TRIPLET3_ROW)
			group1|=4;

		if (col[3+i]==GROUP2_TRIPLET1_COL && row[3+i]==GROUP2_TRIPLET1_ROW)
			group2|=1;
		if (col[3+i]==GROUP2_TRIPLET2_COL && row[3+i]==GROUP2_TRIPLET2_ROW)
			group2|=2;
		if (col[3+i]==GROUP2_TRIPLET3_COL && row[3+i]==GROUP2_TRIPLET3_ROW)
			group2|=4;
	};

	if (group1==7 && group2==7)
	{
		printf ("seed 0x%x is OK\n", seed);
		printf ("next points are probably these:\n");
		for (int group=0; group<4; group++)
		{
			int new_col[3];
			int new_row[3];
			int new_color[3];
			for (int i=0; i<3; i++)
			{
				new_col[i]=MSVC_rand() % 10;
				new_row[i]=MSVC_rand() % 10;
				new_color[i]=MSVC_rand() % 5;

				printf ("col=%d row=%d color=%d\n", new_col[i], new_row[i], new_color[i]);
			};

			for (int r=0; r<10; r++)
			{
				for (int c=0; c<10; c++)
				{
					int put_it=0;

					for (int i=0; i<3; i++)
						if (new_col[i]==c && new_row[i]==r)
							put_it=1;

					printf (put_it ? "*" : ".");
				};
				printf ("\n");
			};

			printf ("\n");
		};
	};
};

int main()
{
	// MSB of state isn't used at all, so we don't touch it
	for (uint32_t seed=0; seed<0x80000000; seed++)
		chk_seed(seed);
};
