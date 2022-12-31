#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define MAX_LINE    128
#define MAX_NODES   64
#define MAX_CONNS   6

typedef struct node_s {
    char name[2+1];
    int rate;
    int nc;
    char conns[MAX_CONNS][2+1];
} node;
  
static node nodes[MAX_NODES];
static int nn[26*26];
static int nc=0;


static inline int get_vi(int *vs, char *valve) {
    int r=vs[((valve[0]-'A')*26)+(valve[1]-'A')];
//    printf("Get Valve %s - %d\n", valve, r);
    return r;
}

static inline void set_vi(int *vs, char *valve, int s) {
    vs[((valve[0]-'A')*26)+(valve[1]-'A')]=s;
    printf("Set Valve %s [%d] - %d (%d)\n", valve, ((valve[0]-'A')*26)+(valve[1]-'A'), s, vs[((valve[0]-'A')*26)+(valve[1]-'A')]);
}

int read(int *vs) {
    int v=0;
    char line[MAX_LINE+1];
    char *conns[MAX_LINE+1];

    while(fgets(line, MAX_LINE, stdin)) {
        int c=1;
        int cs=0;
        printf("Reading line %d ", v);

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
        printf("\n");
    }
    return v;
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

#define TIMELIMIT 26


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


static inline unsigned long int get_ovhash(int *svs) {
    unsigned long int hash=0l;
    
    unsigned char hb[MAX_NODES/8+1];
    for(int i=0; i<MAX_NODES/8+1; i++) {
        hb[i]='\0';
    }

    for(int i=0; i<nc; i++) {
        printf("%d - hb[%d] - %d - %02x - %02x",i, (int)i/8, svs[i], (unsigned char)((svs[i]?1:0)*pow(2,(i%8))), hb[i/8]);
        hb[i/8]=hb[i/8]|((unsigned char)((svs[i]?1:0)*pow(2,(i%8))));
        printf("%02x\n",hb[i/8]);
    }

    hash=((((((hb[7]*256+hb[6]*256+hb[5])*256+hb[4])*256+hb[3])*256+hb[2])*256+hb[1])*256+hb[0]);
 
    printf("Hash %16lx: %02x%02x%02x%02x%02x%02x%02x%02x\n",
        hash, hb[7],hb[6],hb[5],hb[4],hb[3],hb[2],hb[1],hb[0]);
    return hash;
}

typedef struct centry_s {
    unsigned long int hash;
    int score;
} centry;

#define MAX_CACHE 10000

static int ce_max[TIMELIMIT*MAX_NODES*MAX_NODES];
static centry cache[TIMELIMIT*MAX_NODES*MAX_NODES][MAX_CACHE];

static inline int cache_g(unsigned long int phash, unsigned long int vhash) {
    int ret=-1;

    for(int i=0; i<ce_max[phash]; i++) {
        if(cache[phash][i].hash==vhash) {
            ret=cache[phash][i].score;
            break;
        }
    }
    return ret;
}


int cache_get(int ts,int *svs, char *hnode, char *enode) {
    return cache_g(get_phash(ts, hnode, enode),get_vhash(svs));
}

static inline void cache_s(unsigned long int phash, unsigned long int vhash, int score) {
    if(ce_max[phash]<MAX_CACHE-1) {
        cache[phash][ce_max[phash]].hash=vhash;
        cache[phash][ce_max[phash]].score=score;
        ce_max[phash]++;
    } else {
        printf("No cache room");
    }
}

void cache_set(int ts,int *svs,char *hnode, char *enode, int score) {
    cache_s(get_phash(ts, hnode, enode), get_vhash(svs), score);
}

int countoff(int *svs) {
    int r=0;
    for(int i=0; i<(nc?nc:MAX_NODES); i++) {
        if(svs[i]) r++;
    }
    return r;
}

int checkpath(char *hnode, char *enode, int ts, int *svs) {
    int vs[MAX_NODES];
    int bestpath=0;
    int cv=0;

    if(ts>=TIMELIMIT) {
        return 0;
    }

    int hn=get_vi(nn, hnode);
    int en=get_vi(nn, enode);
    unsigned long int phash=get_phash(ts, hnode, enode);
    unsigned long int vhash=get_vhash(svs);

    printf("%016lx-%016lx Time %d: Human %s Elephant %s Off:%d\n",phash,vhash,ts,hnode,enode, countoff(svs));

    bestpath=cache_g(phash, vhash);
    printf("%016lx-%016lx Seen before %d\n", phash, vhash, bestpath);
    if(bestpath>=0) return bestpath;
    bestpath=0;

    for(int i=0; i<nc; i++) {
        vs[i]=svs[i];
        if(vs[i]) cv++;
    }

    if (cv==0) {
        return 0;
    }

    if(vs[en] && vs[hn] && !(en==hn)) {
        vs[en]=0; vs[hn]=0;
        int thisflow=(nodes[en].rate+nodes[hn].rate)*(TIMELIMIT-(ts+1));
//        printf("BRate %d for %d  and %d for %d at ts=%d (%d) yields %d\n", nodes[hn].rate, hn, nodes[en].rate, en, ts, TIMELIMIT-(ts+1), thisflow);
        if(cv>2) {
            int tp=thisflow+checkpath(hnode, enode, ts+1, vs);
            bestpath=tp;
        } else {
            bestpath=thisflow;
        }
        vs[en]=nodes[en].rate; vs[hn]=nodes[hn].rate;
    }

    if(vs[hn]) {
        vs[hn]=0;
        int thisflow=nodes[hn].rate*(TIMELIMIT-(ts+1));
//        printf("HRate %d for %d at ts=%d (%d) yields %d\n",  nodes[hn].rate, hn, ts, TIMELIMIT-(ts+1), thisflow);
        if(cv>1) {
            for(int iv=0; iv<nodes[en].nc; iv++) {
                int tp;
                tp=thisflow+checkpath(hnode, nodes[en].conns[iv], ts+1, vs);
                if(tp>bestpath) {
                    bestpath=tp;
                }
            }
        } else {
            if(thisflow>bestpath) {
                bestpath=thisflow;
            }
        }

        vs[hn]=nodes[hn].rate;
    }

    if(vs[en]) {
        vs[en]=0; 
        int thisflow=nodes[en].rate*(TIMELIMIT-(ts+1));
//        printf("ERate %d for %d at ts=%d (%d) yields %d\n",  nodes[en].rate, en, ts, TIMELIMIT-(ts+1), thisflow);
        if(cv>1) {
            for(int iv=0; iv<nodes[hn].nc; iv++) {
                int tp;
                tp=thisflow+checkpath(nodes[hn].conns[iv], enode, ts+1, vs);
                if(tp>bestpath) {
                    bestpath=tp;
                }
            }
        } else {
            if(thisflow>bestpath) {
                bestpath=thisflow;
            }
        }
        vs[en]=nodes[en].rate;
    }

    for(int ihv=0; ihv<nodes[hn].nc;ihv++) {
        for(int iev=0; iev<nodes[en].nc; iev++) {
            int tp=checkpath(nodes[hn].conns[ihv],nodes[en].conns[iev],ts+1,vs);
            if(tp>bestpath) {
                bestpath=tp;
            }
        }
    }
    printf("%16lx-%16lx Time %d: Best %d - %d (%d to go) yields %d\n", phash, vhash, ts, hn, en, TIMELIMIT-(ts+1), bestpath);
    cache_s(phash, vhash, bestpath);
    return bestpath;

}

int main(int argc, char * argv) {
    int vs[MAX_NODES];

    printf("long=%ld double=%ld\n", sizeof(long), sizeof(double));

    for(int i=0; i<TIMELIMIT; i++) {
        ce_max[i]=0;
    }

    for(int i=0; i<MAX_NODES; i++) {
        vs[i]=0;
    }

    nc=read(vs);
    printf("nc=%d\n", nc);
    printnodes(nc);
    for(int i=0; i<MAX_NODES; i++) {
        if(vs[i]) {
            printf("%d: %s - %d (%d)\n", i, nodes[i].name, vs[i], nodes[i].rate);
        }
    }

    printf("Answer is %d\n", checkpath("AA", "AA", 0, vs));
}