// ***********************************************************************
// TITLE       : sad.c    
// AUTHOR      : Yoonjin Kim 
// AFFILIATION : Dept. of CS, Sookmyung Women's University 
// DESCRIPTION : Sum of Absolute Difference Algoritm Description in C                     
// **********************************************************************


#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "tv.h"

#define ITR 256

int main(void)
{
	FILE *fp;
	int i, j, k;
	unsigned int sum[128] = {0};
	i=0;
        j=0;
        k=0;
	fp = fopen("./sw_result.txt", "w");
	
	if(fp==NULL)
	{
		printf("error occurs when opening sw_result.txt!\n", i);
		exit(1);
	}
	
	while(i<ITR)
	{
		while(j<256)
		{
			sum[k]=sum[k]+abs(a[i]-b[i]);
		        j=j+1;
			i=i+1;
		}
		fprintf(fp, "%08x\n", sum[k]);
		j=0;
		k=k+1;
	}
		
	fclose(fp);
	
	return 0;
}
