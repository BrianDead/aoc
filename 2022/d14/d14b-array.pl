#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max);

sub getIndex1 {
    return $_[0].",".$_[1];
}

sub getXY1 {
    return split /,/,$_[0];
}

sub getIndex {
    return $_[0]+$_[1]*10000;
}

sub getXY {
    return ($_[0]%10000, int($_[0]/10000));
}


my @grid=();
my $minx=99999999; my $miny=0;
my $maxx=0; my $maxy=0;
my $xshift=0;

while(<STDIN>) {
    chomp;
    my @path=split / -> /, $_;
    my $x1=-1; my $y1=-1;

    foreach my $l (@path) {
        my ($x,$y)=getXY1($l);
        if($x1>0) {
            if($x==$x1) {
                $maxx=$x if($x>$maxx);
                $minx=$x if($x<$minx);
                foreach my $i (min($y,$y1)..max($y,$y1)){
#                    $grid[$i]=$grid[$i] // [];
                    $grid[$i][$x+$xshift]="#";
                    $maxy=$i if($y>$maxy);
                    $miny=$i if($y<$miny);
                }
            } else {
                $maxy=$y if($y>$maxy);
                $miny=$y if($y<$miny);
#               $grid[$y]=$grid[$y] // [];
                foreach my $i (min($x, $x1)..max($x, $x1)) {
                    $grid[$y][$i+$xshift]="#";
                    $maxx=$i if($x>$maxx);
                    $minx=$i if($x<$minx);
                }
            }
        }
        $x1=$x; $y1=$y;
    }
}

printf("minx=%d maxx=%d miny=%d maxy=%d\n", $minx, $maxx, $miny, $maxy);

#pg();

my $answer=0;
my $another=1;
my $floor=$maxy+2;

do {
    my $sx=500; my $sy=0; my $stopped=0;
    $answer++;
    do {
        if(defined($grid[$sy+1][$sx+$xshift]) ) {
            if(defined($grid[$sy+1][$sx-1+$xshift]) ) {
                if(defined($grid[$sy+1][$sx+1+$xshift]) ) {
                    #Blocked
                    $stopped=1;
                    $grid[$sy][$sx+$xshift]='s';
                    $another=0 if($sy==0 && $sx==500);
                } else {
                    $sx++; $sy++;
                }

            } else {
                $sx--; $sy++;
            }
        } else {
            $sy++;
        }
        $maxy=max($sy, $maxy);
        $minx=min($sx, $minx);
        $maxx=max($sx, $maxx);

        if($sy == $floor-1) {
            #fallen out
            $stopped=1;
            $grid[$sy][$sx+$xshift]='s';
        }
    } while(!$stopped);
} while($another);

printf("Answer is %d\n", $answer);

sub pg {
    foreach my $iy ($miny..$maxy) {
    foreach my $ix ($minx..$maxx) {
        print $grid[$iy][$ix+$xshift] // '.';
    }
    print "\n";
}

print "------\n";
}

