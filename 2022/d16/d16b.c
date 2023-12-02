#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// Compiled with gcc -O3 -lm: ( cat in.d16r | ./a.out; )  610.67s user 5.69s system 99% cpu 10:17.04 total
// Compiled with gcc -lm : ( cat in.d16r | ./a.out; )  986.17s user 6.40s system 99% cpu 16:34.20 total


#define MAX_LINE    128
#define MAX_NODES   64
#define MAX_CONNS   6
#define TIMELIMIT 26
#define MAX_CACHE 5000


typedef struct centry_s {
    unsigned long int hash;
    int score;
} centry;

typedef struct node_s {
    char name[2+1];
    int rate;
    int nc;
    char conns[MAX_CONNS][2+1];
} node;
  
static node nodes[MAX_NODES];
static int nn[26*26];
static int nc=0;

static int ce_max[TIMELIMIT*MAX_NODES*MAX_NODES];
static centry *cache;

int max_sofar=0;


static inline int get_vi(int *vs, char *valve) {
    int r=vs[((valve[0]-'A')*26)+(valve[1]-'A')];
    return r;
}

static inline void set_vi(int *vs, char *valve, int s) {
    vs[((valve[0]-'A')*26)+(valve[1]-'A')]=s;
}

void printnodes(int nc) {
    for(int i=0; i<nc; i++) {
        printf("Node %s flow %d - %d conns to ", nodes[i].name, nodes[i].rate, nodes[i].nc);
        for(int j=0; j<nodes[i].nc; j++) {
            printf("%s - ", nodes[i].conns[j]);
        }
        printf("\n");
    }
}

static inline unsigned long int get_phash(int ts, char *hnode, char *enode) {
    unsigned long int hash=0l;
    int hn=get_vi(nn, hnode);
    int en=get_vi(nn, enode);
    int gn=hn>en?hn:en;
    int ln=hn>en?en:hn;

    return ((ts*MAX_NODES+gn)*MAX_NODES+ln);
}
 
static inline unsigned long int get_vhash(int *svs) {
    unsigned long int hash=0l;
    
    for(int i=0; i<nc; i++) {
        hash=hash|(unsigned long int)((svs[i]?1:0)*pow(2,(i)));
    }

    return hash;
}

static inline int check_vs(unsigned long int vhash, int valve) {
    return (vhash & (unsigned long int)pow(2,valve)) != 0l;
}

static inline unsigned long int set_vs(unsigned long int vhash, int valve) {
    return(vhash | (unsigned long int)pow(2, valve));
}

static inline unsigned long int unset_vs(unsigned long int vhash, int valve) {
    return(vhash & ~(unsigned long int)pow(2, valve));
}

static inline int cache_g(unsigned long int phash, unsigned long int vhash) {
    int ret=-1;

    for(int i=0; i<ce_max[phash]; i++) {
        if(cache[phash*i].hash==vhash) {
            ret=cache[phash*i].score;
            break;
        }
    }
    return ret;
}


int cache_get(int ts,int *svs, char *hnode, char *enode) {
    return cache_g(get_phash(ts, hnode, enode),get_vhash(svs));
}

static int max_cache=0;

static inline void cache_s(unsigned long int phash, unsigned long int vhash, int score) {
    if(ce_max[phash]<MAX_CACHE-1) {
//        cache[phash][ce_max[phash]].hash=vhash;
//        cache[phash][ce_max[phash]].score=score;
        cache[phash*ce_max[phash]].hash=vhash;
        cache[phash*ce_max[phash]].score=score;
        ce_max[phash]++;
		max_cache=(ce_max[phash]>max_cache)?ce_max[phash]:max_cache;
    } else {
        printf("No cache room\n");
        exit(1);
    }
}

void cache_set(int ts,int *svs,char *hnode, char *enode, int score) {
    cache_s(get_phash(ts, hnode, enode), get_vhash(svs), score);
}

int cmpfnc(const void * a, const void * b) {
    return( *(int *)b - *(int *)a);
}

int countoff(unsigned long int vhash, int ts, int *rem) {
    int r=0; int rm=0;
    int sn[MAX_NODES];
    *rem=0;

    for(int i=0; i<(nc?nc:MAX_NODES); i++) {
        if(check_vs(vhash, i)) {
            sn[r]=nodes[i].rate;
            r++;
        }
    }
    qsort((void *)sn, r, sizeof(int), cmpfnc);
    int tr=TIMELIMIT-(ts+1);
    for(int i=0; i<r && i<(tr*2); i++) {
        *rem+=sn[i]*(int)(tr-(i/2));
    }
    return r;
}

unsigned long int read() {
    int v=0;
    int vs[MAX_NODES];
    char line[MAX_LINE+1];
    char *conns[MAX_LINE+1];

    while(fgets(line, MAX_LINE, stdin)) {
        int c=1;
        int cs=0;

        if(sscanf(line, "Valve %s has flow rate=%d;", 
            nodes[v].name, &nodes[v].rate)<2) {
                printf("Read error\n");
                exit(1);
            }
        for(int i=strlen(line); i>=0; i--) {
            if(line[i]==',') {
                c++;
            }
            if(line[i]=='s' || line[i]=='e') {
                cs=i+2;
                break;
            }
        }
        if(!cs) {
            printf("Scan error\n");
            exit(2);
        }

        for(int ic=0; ic<c; ic++) {
            nodes[v].conns[ic][0]=*(line+cs+(ic*4));
            nodes[v].conns[ic][1]=*(line+cs+(ic*4)+1);
            nodes[v].conns[ic][2]='\0';
        }
        set_vi(nn, nodes[v].name, v);
        vs[v]=nodes[v].rate;
        nodes[v++].nc=c;
        nc++;
    }
    return get_vhash(vs);
}

static int depth=0;

int checkpath(char *hnode, char *enode, int ts, unsigned long int vhash, int pathscore) {
    int bestpath=0;
    depth++;

#ifdef PROGRESS_PRINT
    printf("depth: %d, hnode: %s, enode: %s, ts: %d - ", depth, hnode, enode, ts);
#endif
    if(ts>=TIMELIMIT) {
#ifdef PROGRESS_PRINT
        printf("timelimit exceeded\n");
#endif
        goto bail;
    }

    int hn=get_vi(nn, hnode);
    int en=get_vi(nn, enode);

    unsigned long int phash=get_phash(ts, hnode, enode);
    int rr=0;

    if (vhash==0l) {
#ifdef PROGRESS_PRINT
        printf("vhash==0l\n");
#endif
        goto bail;
    }

    bestpath=cache_g(phash, vhash);
    if(bestpath>=0) return bestpath;
    bestpath=0;
#ifdef PROGRESS_PRINT
    printf("not cached\n");
#endif

    int vc=countoff(vhash, ts, &rr);

    if(rr+pathscore > max_sofar) {
        if(check_vs(vhash,en) && check_vs(vhash, hn) && !(en==hn)) {
            int thisflow=(nodes[en].rate+nodes[hn].rate)*(TIMELIMIT-(ts+1));
            int tp=thisflow+checkpath(hnode, enode, ts+1, unset_vs(unset_vs(vhash,en),hn), pathscore+thisflow);
            bestpath=tp;
        }

        if(check_vs(vhash, hn)) {
            int thisflow=nodes[hn].rate*(TIMELIMIT-(ts+1));
            for(int iv=0; iv<nodes[en].nc; iv++) {
                int tp;
                tp=thisflow+checkpath(hnode, nodes[en].conns[iv], ts+1, unset_vs(vhash,hn), pathscore+thisflow);
                if(tp>bestpath) {
                    bestpath=tp;  
                }
            }
        }

        if(check_vs(vhash,en)) {
            int thisflow=nodes[en].rate*(TIMELIMIT-(ts+1));
            for(int iv=0; iv<nodes[hn].nc; iv++) {
                int tp;
                tp=thisflow+checkpath(nodes[hn].conns[iv], enode, ts+1, unset_vs(vhash,en),pathscore+thisflow);
                if(tp>bestpath) {
                    bestpath=tp;
                }
            }
        }

        for(int ihv=0; ihv<nodes[hn].nc;ihv++) {
            for(int iev=0; iev<nodes[en].nc; iev++) {
                int tp=checkpath(nodes[hn].conns[ihv],nodes[en].conns[iev],ts+1,vhash,pathscore);
                if(tp>bestpath) {
                    bestpath=tp;
                }
            }
        }
    }
#ifdef PROGRESS_PRINT
    printf("depth %d - cacheing result %lu, %lu, %d\n", depth, phash, vhash, bestpath);
#endif
    cache_s(phash, vhash, bestpath);
    max_sofar=bestpath>max_sofar?bestpath:max_sofar;
#ifdef PROGRESS_PRINT
    printf(" - leaving\n");
#endif

bail:
    depth--;
    return bestpath;

}

int main(int argc, char * argv) {
    unsigned long int vhash;
    int vs[MAX_NODES];

    cache=(centry *)calloc(MAX_CACHE, TIMELIMIT*MAX_NODES*MAX_NODES*sizeof(centry));
    if(! cache) { 
        printf("Couldn't allocate memeory for cache\n");
            exit(1);
    }

    printf("zeroing ce_max\n");
    for(int i=0; i<TIMELIMIT; i++) {
        ce_max[i]=0;
    }

    printf("zeroing vs\n");
    for(int i=0; i<MAX_NODES; i++) {
        vs[i]=0;
    }

    printf("reading input\n");
    vhash=read();
//    printnodes(nc);

    printf("Calculating...\n");
    printf("Answer is %d\n", checkpath("AA", "AA", 0, vhash,0));
	printf("Largest cache: %d\n", max_cache);
	free(cache);
}
