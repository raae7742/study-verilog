#include <stdio.h>
#include "tv.h"

#define ITR 64

int main(void)
{
	FILE *fp;
	int i = 0;
	int j = 0;
	int val;
	int cnt;
	fp = fopen("./sw_result.txt", "w");

	if (fp == NULL)
	{
		printf("error occurs when opening sw_result.txt!\n", i);
		exit(1);
	}

	while (i < ITR)
	{
		val = 1;
		while (val <= 970200)
		{
			cnt = 0;
			j = 0;

			while (j < 4)
			{
				if (val % a[(4 * i) + j] == 0) cnt++;
				j = j + 1;
			}

			if (cnt >= 3)
			{
				printf("%d %d %d %d : %d\n", a[4 * i + 0], a[4 * i + 1], a[4 * i + 2], a[4 * i + 3], val);
				break;
			}

			val = val + 1;
		}

		fprintf(fp, "%04x\n", val);

		i = i + 1;
	}

	fclose(fp);
	return 0;
}