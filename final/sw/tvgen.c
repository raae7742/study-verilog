#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define START 1 
#define END 99
#define ITR 4

int main(void)
{
	FILE *fp[3];
	fp[0] = fopen("./MemA.txt", "w");
	fp[1] = fopen("./tv.h", "w");
	int i, j, k;

	unsigned char number;
	unsigned char tmp_num[4] = { 0 };

	for (i = 0; i < 2; i++)
		if (fp[i] == NULL)
		{
			printf("error occurs when opening fp[%d]!\n", i);
			exit(1);
		}


	srand((long)time(NULL));

	j = 0;
	fprintf(fp[1], "unsigned char a[%d] = {\n", ITR);
	for (i = 0; i < ITR; i++) //2^15 = 256 x 128
	{
		number = rand() % (END - START + 1) + START;
		fprintf(fp[1], "0x%02x,\n", number);
		tmp_num[j] = number;
		j = j + 1;
		if (j == 4)
		{
			for (k = 3; k >= 0; k--)
				fprintf(fp[0], "%02x", tmp_num[k]);
			fprintf(fp[0], "\n");
			j = 0;
		}
	}
	fprintf(fp[1], "};\n");

	for (i = 0; i < 2; i++)
		fclose(fp[i]);

	return 0;
}