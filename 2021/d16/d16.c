#include <stdio.h>
#include <stdlib.h>

typedef struct pktoutput_s {
	unsigned int result;
	unsigned int versum;
} pktoutput;

typedef struct s_pktinfo {
	unsigned int pktver;
	unsigned int pkttype;
	unsigned long value;
	unsigned int l_type;
	unsigned int l_val;
	struct s_pktinfo **subpackets;
	unsigned int n_subpackets;
	unsigned int versum;
} pktinfo;

#define BUF_START	32
#define BUF_INC		32

typedef enum e_opcode {
	OP_SUM=0,
	OP_MULT=1,
	OP_MIN=2,
	OP_MAX=3,
	OP_LITERAL=4,
	OP_GT=5,
	OP_LT=6,
	OP_EQ=7
} opcode;

static int conversions[][4]= { {0,0,0,0},{0,0,0,1},{0,0,1,0},{0,0,1,1},{0,1,0,0},{0,1,0,1},{0,1,1,0},{0,1,1,1},{1,0,0,0},{1,0,0,1},{1,0,1,0},{1,0,1,1},{1,1,0,0},{1,1,0,1},{1,1,1,0},{1,1,1,1} };

int * convert(char c) {
	if(c>='0' && c<='9') {
		return conversions[c-'0'];
	}
	if(c>='A' && c<='F') {
		return conversions[c-'A'+10];
	}
	return (int *)NULL;
}

int readdata(int **inbits) {
	/* assume data is one line */
	unsigned int buflen=BUF_START, len=0;
	char c;
	int *c2;

	int *bits=calloc(BUF_START+1,sizeof(int));

	do {
		c=fgetc(stdin);
		if(buflen-len < (4+1)) {
			buflen+=BUF_INC;
			bits=realloc((void *)bits, buflen*sizeof(int)+1);
		}
		if(!bits) { exit(-1);}
		if((c2=convert(c))) {
//			printf ("Read: %c, converted to: %d %d %d %d\n", c, c2[0], c2[1], c2[2], c2[3]);
			for(int i=0; i<4; i++) {

				bits[i+len]=c2[i];
			}
		}
		len+=4;
	 } while(c!='\n');

	 *inbits=bits;
	 return len;
}

unsigned long getbits(int * data, int *pc, int num) {
	int base=1;
	unsigned long ret=0;

	for(int i=num-1; i>=0; i--) {
		ret+=data[*pc+i]*base;
//		printf("i=%d pc=%d val=%d base=%d ret=%d\n", i, *pc+i, data[*pc+i], base, ret);
		base*=2;
	}
	*pc+=num;
//	printf("%d: Got %d bits - %d\n\n", *pc, num, ret);
	return ret;
}

unsigned long sumpackets(pktinfo *pkt) {
	unsigned long ret=0;
	for(int i=0; i<pkt->n_subpackets; i++){
		ret+=pkt->subpackets[i]->value;
	}
	return ret;
}

unsigned long multpackets(pktinfo *pkt) {
	unsigned long ret=1;
	for(int i=0; i<pkt->n_subpackets; i++){
		ret=ret * pkt->subpackets[i]->value;
	}
	return ret;
}

unsigned long minpackets(pktinfo *pkt) {
	unsigned long ret=pkt->subpackets[0]->value;
	for(int i=1; i<pkt->n_subpackets; i++){
		if(pkt->subpackets[i]->value<ret) {
			ret=pkt->subpackets[i]->value;
		}
	}
	return ret;
}

unsigned long maxpackets(pktinfo *pkt) {
	unsigned long ret=0;
	for(int i=0; i<pkt->n_subpackets; i++){
		if(pkt->subpackets[i]->value>ret) {
			ret=pkt->subpackets[i]->value;
		}
	}
	return ret;
}

unsigned long cmpgt(pktinfo *pkt) {
	unsigned long ret=0;
	if(pkt->subpackets[0]->value > pkt->subpackets[1]->value) {
		ret=1;
	}
	return ret;
}

unsigned long cmplt(pktinfo *pkt) {
	unsigned long ret=0;

	if(pkt->subpackets[0]->value < pkt->subpackets[1]->value) {
		ret=1;
	}
	return ret;
}

unsigned long cmpeq(pktinfo *pkt) {
	unsigned long ret=0;
	if(pkt->subpackets[0]->value == pkt->subpackets[1]->value) {
		ret=1;
	}
	return ret;
}

unsigned long noop(pktinfo *pkt) {
	printf("This shouldn't happen\n");
	return 0;
}

unsigned long (*operations[])(pktinfo *) = {
	&sumpackets,
	&multpackets,
	&minpackets,
	&maxpackets,
	&noop,
	&cmpgt,
	&cmplt,
	&cmpeq
};

pktinfo *parsepacket(int *data, int *pc) {
	pktinfo *thispkt=calloc(1, sizeof(pktinfo));

	thispkt->l_val=0;

	thispkt->pktver=getbits(data, pc, 3);
	thispkt->versum=thispkt->pktver;

	if((thispkt->pkttype=getbits(data, pc, 3))==4) {
		int ltype=0, val=0;
		do {
			ltype=getbits(data,pc,1);
			thispkt->value=thispkt->value*16+getbits(data,pc,4);
		} while (ltype);
	} else {
		int done=0;
		thispkt->l_type=getbits(data,pc,1);
		thispkt->l_val=getbits(data,pc,thispkt->l_type?11:15);

		while(done<thispkt->l_val) {
			int start_pc=*pc;
			thispkt->n_subpackets++;
			if(thispkt->n_subpackets==1) {
				thispkt->subpackets=calloc(thispkt->n_subpackets, sizeof(pktinfo *));
			} else {
				thispkt->subpackets=realloc(thispkt->subpackets, thispkt->n_subpackets*sizeof(pktinfo *));
			}
			thispkt->subpackets[thispkt->n_subpackets-1]=parsepacket(data, pc);
			if(thispkt->l_type) {
				done++;
			} else {
				done+=(*pc-start_pc);
			}
		}

		thispkt->value=(*operations[thispkt->pkttype])(thispkt);

	}
	printf("Op %d: (%d) ", thispkt->pkttype, thispkt->n_subpackets);
	if(thispkt->pkttype!=4) {
		for(int i=0; i<(thispkt->n_subpackets); i++) {
			printf("%ld ", thispkt->subpackets[i]->value);
		}
	}
	printf(" === %ld\n", thispkt->value);


	for(int i=0; i<thispkt->n_subpackets; i++) {
		thispkt->versum+=(*(thispkt->subpackets)[i]).versum;
	}

	return thispkt;
}

int main (int argc, char * argv[]) {
	int *data;
	int pc=0, len=0;
	pktinfo *output;

	len=readdata(&data);
/*	for(int i=0; i<len; i++) {
		printf("%d",data[i]);
	}
	printf("\n");
*/
	output=parsepacket(data, &pc);

	printf("Answer 1: %d\nAnswer 2: %ld\n", output->versum, output->value);

}

