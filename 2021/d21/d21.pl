#!/usr/bin/perl

use List::Util qw(min);

my $start1=7;
my $start2=3;

#my $start1=4;
#my $start2=8;

my $nextroll=0;

my $done=0;

my @pos=($start1-1, $start2-1);
my @score=(0,0);

my $turn=0;
my $rolls=0;

sub roll {
    my $ret;
    foreach $r (0..2) {
        $ret+=(($_[0]+$r) % 100)+1;
    }
    return $ret;
}

while(!$done) {
    $turn++;
    foreach(0..1) {
        my $npos=(roll($nextroll)+$pos[$_]) % 10; 
        $rolls+=3;
        $score[$_]+=($npos+1);
        print"Player $_: turn $turn : nextroll $nextroll : from $pos[$_] to pos $npos : new score $score[$_]\n";
        $pos[$_]=$npos;
        $nextroll=($nextroll+3)% 100; $npos;
        if($score[$_]>=1000) {
            $done=$_+1;
            last;
        }
    }
    last if ($done);
}

print "Pos 0: $pos[0] Pos1: $pos[1]\n";
print "Score -: $score[0] Score 1: $score[1]\n";
print "Nextroll=$nextroll Die rolls=$rolls\n";

my $answer=min($score[0], $score[1])*$rolls;
print "Answer: $answer\n";