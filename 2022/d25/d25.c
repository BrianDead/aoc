#include <stdio.h>
#include <string.h>

static char digits[]={'0','1','2','=','-'};
static char digits2[]={'=','-','0','1','2'};

static inline int digval(char dig) {
    int i;

    for(i=0; i<sizeof(digits2); i++) {
        if (digits2[i]==dig) {
            break;
        }
    }
    i-=2;
    return i;
}

static inline char *zapnl(char *in, size_t size) {
    int r=0;
    while(r<size) {
        if(in[r]=='\n') { in[r]='\0'; break;}
        r++;
    }
    return in;
}

long int fromsnafu(char *snafu) {
    long int p=1;
    long int r=0;
    int i;
    int l=strlen(snafu);

    for(i=l-1; i>=0; i--) {
        r+=digval(snafu[i])*p;
        p*=5;
    }
    return r;
}

char *tosnafu(char *snafu, int buflen, long int n) {
    int d=0;

    while(n>0 && d<(buflen-1)) {
        int v=n%5;
        n=n/5;

        if(v>2) { n++;}

        for(int i=d; i>0; i--) {
            if(i<buflen-1) {
                snafu[i]=snafu[i-1];
            }
        }
        snafu[0]=digits[v];
        snafu[++d]='\0';
    }
    return snafu;
}

long int a=0;
#define MAX_LINE 128

int main(int argc, char *argv[]) {
    char line[MAX_LINE];
    char snafu[MAX_LINE];
    long int a;

    size_t end;

    while(fgets(line, MAX_LINE, stdin)) {
        a+=fromsnafu(zapnl(line, MAX_LINE));
    }
    printf("Answer is %s (%ld)\n", tosnafu(snafu,MAX_LINE,a), a);

}