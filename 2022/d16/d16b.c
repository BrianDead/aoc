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
    printf("Set Valve %s - %d (%d)\n", valve, s, vs[((valve[0]-'A')*26)+(valve[1]-'A')]);
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


static inline long int get_hash(int ts, int *svs, char *hnode,char *enode) {
    long int hash=0l;
    int hn=get_vi(nn, hnode);
    int en=get_vi(nn, enode);
    int gn=hn>en?hn:en;
    int ln=hn>en?en:hn;

    hash=((ts*MAX_NODES+gn)*MAX_NODES+ln);
    
    unsigned char hb[MAX_NODES/8+1];
    for(int i=0; i<MAX_NODES/8+1; i++) {
        hb[i]='\0';
    }

    for(int i=0; i<nc; i++) {
        hb[i/8]=hb[i/8]|((unsigned char)((svs[i]?1:0)*pow(2,(i%8))));
    }

    hash=((((hash*256+hb[3])*256+hb[2])*256+hb[1])*256+hb[0]);

//    printf("Hash %ld: ts=%d %02x%02x%02x%02x h=%s e=%s g=%d l=%d\n",
//        hash, ts, hb[3],hb[2],hb[1],hb[0],hnode, enode, gn, ln);
    return hash;
}

typedef struct centry_s {
    long int hash;
    int score;
} centry;

#define MAX_CACHE 100000

static int ce_max=0;
static centry cache[MAX_CACHE];

static inline int cache_g(long int hash) {
    int ret=-1;

    for(int i=0; i<ce_max; i++) {
        if(cache[i].hash==hash) {
            ret=cache[i].score;
            break;
        }
    }
    return ret;
}


int cache_get(int ts,int *svs, char *hnode, char *enode) {
    return cache_g(get_hash(ts,svs,hnode,enode));
}

static inline void cache_s(long int hash, int score) {
    if(ce_max<MAX_CACHE-1) {
        cache[ce_max].hash=hash;
        cache[ce_max].score=score;
        ce_max++;
    } else {
        printf("No cache room");
    }
}

void cache_set(int ts,int *svs,char *hnode, char *enode, int score) {
    cache_s(get_hash(ts,svs,hnode,enode), score);
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
    long int hash=get_hash(ts, svs, hnode, enode);

//    printf("Time %d: Human %s Elephant %s Off:%d\n",ts,hnode,enode, countoff(svs));

    bestpath=cache_g(hash);
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
//        printf("HRate %d for %d at ts=%d (%d) yields %d\n", nodes[hn].rate, hn, ts, TIMELIMIT-(ts+1), thisflow);
        if(cv>1) {
            for(int iv=0; iv<nodes[en].nc; iv++) {
                int tp;
                tp=thisflow+checkpath(hnode, nodes[en].conns[iv], ts+1, vs);
                bestpath=(tp>bestpath) ? tp : bestpath;
            }
        } else {
            bestpath=(thisflow>bestpath) ? thisflow : bestpath;
        }

        vs[hn]=nodes[hn].rate;
    }

    if(vs[en]) {
        vs[en]=0; 
        int thisflow=nodes[en].rate*(TIMELIMIT-(ts+1));
//        printf("ERate %d for %d at ts=%d (%d) yields %d\n", nodes[en].rate, en, ts, TIMELIMIT-(ts+1), thisflow);
        if(cv>1) {
            for(int iv=0; iv<nodes[hn].nc; iv++) {
                int tp;
                tp=thisflow+checkpath(nodes[hn].conns[iv], enode, ts+1, vs);
                bestpath=(tp>bestpath) ? tp : bestpath;
            }
        } else {
            bestpath=(thisflow>bestpath) ? thisflow : bestpath;
        }
        vs[en]=nodes[en].rate;
    }

    for(int ihv=0; ihv<nodes[hn].nc;ihv++) {
        for(int iev=0; iev<nodes[en].nc; iev++) {
            int tp=checkpath(nodes[hn].conns[ihv],nodes[en].conns[iev],ts+1,vs);
            bestpath=(tp>bestpath) ? tp : bestpath;
        }
    }
//    printf("Time %d: Best %d - %d (%d to go) yields %d\n", ts, hn, en, TIMELIMIT-(ts+1), bestpath);
    cache_s(hash, bestpath);
    return bestpath;

}

int main(int argc, char * argv) {
    int vs[MAX_NODES];

    printf("long=%ld\n", sizeof(long));

    for(int i=0; i<MAX_NODES; i++) {
        vs[i]=0;
    }

    nc=read(vs);
    printnodes(nc);
    for(int i=0; i<MAX_NODES; i++) {
        if(vs[i]) {
            printf("%d: %s - %d (%d)\n", i, nodes[i].name, vs[i], nodes[i].rate);
        }
    }

    printf("Answer is %d\n", checkpath("AA", "AA", 0, vs));

}
