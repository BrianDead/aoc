#!/usr/bin/perl

use strict;
use List::Util qw(min max);

sub getIndex {
    return $_[0].",".$_[1];
}

sub getXY {
    printf("GetXY - %s\n", $_[0]);
    return split /,/,$_[0];
}


my %grid=();
my $minx=99999999; my $miny=0;
my $maxx=0; my $maxy=0;

while(<STDIN>) {
    chomp;
    my @path=split / -> /, $_;
    my $x1=-1; my $y1=-1;

    foreach my $l (@path) {
        print($l."\n");
        my ($x,$y)=getXY($l);
        printf("%d, %d -> %d, %d\n", $x1, $y1, $x, $y);
        if($x1>0) {
            if($x==$x1) {
                $maxx=$x if($x>$maxx);
                $minx=$x if($x<$minx);
                foreach my $i (min($y,$y1)..max($y,$y1)){
                    printf("hline %d, %d\n",$i,$y);
                    $grid{getIndex($x,$i)}="#";
                    $maxy=$i if($y>$maxy);
                    $miny=$i if($y<$miny);
                }
            } else {
                $maxy=$y if($y>$maxy);
                $miny=$y if($y<$miny);
                foreach my $i (min($x, $x1)..max($x, $x1)) {
                    printf("vline %d, %d\n",$i,$y);
                    $grid{getIndex($i, $y)}="#";
                    $maxx=$i if($x>$maxx);
                    $minx=$i if($x<$minx);
                }
            }
        }
        $x1=$x; $y1=$y;
    }
}

printf("minx=%d maxx=%d miny=%d maxy=%d\n", $minx, $maxx, $miny, $maxy);

my $answer=0;
my $another=1;

do {
    my $sx=500; my $sy=0; my $stopped=0;
    $answer++;
    do {
        if($grid{getIndex($sx,$sy+1)} =~ q/[#s]/) {
            if($grid{getIndex($sx-1,$sy+1)} =~ q/[#s]/) {
                if($grid{getIndex($sx+1,$sy+1)} =~ q/[#s]/) {
                    #Blocked
                    $stopped=1;
                    $grid{getIndex($sx,$sy)}='s';
                } else {
                    $sx++; $sy++;
                }

            } else {
                $sx--; $sy++;
            }
        } else {
            $sy++;
        }
        if($sy >= $maxy) {
            #fallen out
            $stopped=1;
            $answer--;
            $another=0;
        }
    } while(!$stopped);
    pg();
} while($another);

printf("Answer is %d", $answer);

sub pg {
    foreach my $iy ($miny..$maxy) {
    foreach my $ix ($minx..$maxx) {
        if($grid{getIndex($ix, $iy)} =~ q/[#s]/) {
            print $grid{getIndex($ix, $iy)};
        } else {
            print ".";
        }
    }
    print "\n";
}

print "------\n";
}
