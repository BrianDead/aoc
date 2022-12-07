#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_STACKS 15
#define MAX_STACK_SIZE 2000000
#define MAX_LINE 80

int main(int argc, char * argv[]) {
	char *stacks[MAX_STACKS];
	int stackl[MAX_STACKS];
	int max_cols, cols;
	char cin[MAX_LINE+1];
	char *c;

	memset(stackl,0,MAX_STACKS*sizeof(int));

	printf("2\n");

	do {
		c=fgets(cin, MAX_LINE, stdin);
//		printf("%s\n", c);
		if(c[1]!='1') {
			cols=strlen(c)/4;
			max_cols=(cols>max_cols?cols:max_cols);

			for(int i=0; i<cols; i++) {
				if(c[i*4+1]!=' ') {
					if(stackl[i]==0) {
						stacks[i]=calloc(MAX_STACK_SIZE+1, sizeof(char));
					}
					stacks[i][MAX_STACK_SIZE-(stackl[i]++)-1]=c[i*4+1];
				}
			}
		}

	} while (c[1]!='1');

		for(int j=0; j<max_cols; j++) {
			printf("%d \n",stackl[j]);
		}
	printf("\n");
	for(int i=0; i<max_cols; i++) {
		memcpy(stacks[i],stacks[i]+(MAX_STACK_SIZE-stackl[i]),stackl[i]);
	}

	do {
		int q, f, t;
		if(!(c=fgets(cin, MAX_LINE, stdin))) break;
		if(sscanf(c,"move %d from %d to %d",&q,&f,&t)!=3) continue;
/*		printf("Moving %d from %d to %d\n", q, f, t);
*/
		f-=1; t-=1;

		memcpy(stacks[t]+stackl[t], stacks[f]+stackl[f]-q, q);
		stackl[t]+=q; stackl[f]-=q;

/*		for(int j=0; j<max_cols; j++) {
			printf("%d ",stackl[j]);
		}
		printf("\n");
*/

		stacks[t][stackl[t]]='\0';
		stacks[f][stackl[f]]='\0';
/*		for(int j=0; j<max_cols; j++) {
			printf("%s\n",stacks[j]);
		}
*/
	} while(c);

	for(int i=0; i<max_cols; i++) {
		printf("%c", stacks[i][stackl[i]-1]);
	}
	printf("\n");

}