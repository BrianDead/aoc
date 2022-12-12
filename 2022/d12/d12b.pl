#!/usr/bin/perl

# My implementation of Dijkstra leaves you with a grid containing all the
# path lengths from the starting point to that grid point. So, to find the
# quickest of multiple potential start points, just switch it into reverse
# and calculate the grid starting from the endpoint, then scan the grid
# for the start point with the lowest cost. Seemed to work.

use strict;
use Data::Dumper;

my @grid=map{ chomp; [split //] } <STDIN>;

my $w=@{$grid[0]};
my $h=@grid;
my @s=(-1,-1); my @e=(-1,-1);

my @nodedist=();
my @intree=();
my $huge=99999999;

foreach my $y (0..($h-1)) {
    my @ndrow=();
    my @itrow=();
    push(@nodedist,\@ndrow);
    push(@intree,\@itrow);
    foreach my $x (0..($w-1)) {
        $nodedist[$y][$x]=$huge;
        $intree[$y][$x]=0;
    }
}

my $x=0;
my $y=0;

foreach (@grid) {
    foreach (@{$_}) {
        if ($_ eq "S") {
            @s=($x, $y);
        } elsif ($_ eq "E") {
            @e=($x, $y);
        }
        $x++;
    }
    $y++;
    $x=0;
}

printf("Start at %d, %d - End at %d, %d - Grid w=%d, h=%d\n", @s, @e, $w, $h);

$nodedist[$e[1]][$e[0]]=0;

foreach my $y (0..($h-1)) {
    foreach my $x (0..($w-1)) {
        my ($nx, $ny)=minpath();
        print("Next $nx, $ny\n");

        $intree[$ny][$nx]=1;

        if($ny>0 && testH($nx, $ny-1, $grid[$ny][$nx])) { 
            my $newd=$nodedist[$ny][$nx]+1;
            $nodedist[$ny-1][$nx]=$newd if($newd<$nodedist[$ny-1][$nx]);
        }
        if($nx>0 && testH($nx-1, $ny, $grid[$ny][$nx])) { 
            my $newd=$nodedist[$ny][$nx]+1;
            $nodedist[$ny][$nx-1]=$newd if($newd<$nodedist[$ny][$nx-1]);
        }
        if($nx<($w-1) && testH($nx+1, $ny, $grid[$ny][$nx])) { 
            my $newd=$nodedist[$ny][$nx]+1;
            $nodedist[$ny][$nx+1]=$newd if($newd<$nodedist[$ny][$nx+1]);
        }
        if($ny<($h-1) && testH($nx, $ny+1, $grid[$ny][$nx])) { 
            my $newd=$nodedist[$ny][$nx]+1;
            $nodedist[$ny+1][$nx]=$newd if($newd<$nodedist[$ny+1][$nx]);
        }
    }
}

my $answer=$huge;

foreach my $y (0..($h-1)) {
    foreach my $x (0..($w-1)) {
        if($grid[$y][$x] eq "a" || $grid[$y][$x] eq "S") {
            printf("%s at %d, %d: %d\n", $grid[$y][$x], $x, $y, $nodedist[$y][$x]);
            $answer=$nodedist[$y][$x] if($nodedist[$y][$x]<$answer);
        }
    }
}

printf("Answer is %d\n", $answer);

sub minpath {
    my $xmin; my $ymin;
    my $dmin=$huge;

    foreach my $y (0..($h-1)) {
        foreach my $x (0..($w-1)) {
#            printf("min test %d,%d = %d vs %d - intree %d\n", $x, $y, $nodedist[$y][$x], $dmin, $intree[$y][$x]);
            if(!$intree[$y][$x] && $nodedist[$y][$x]<$dmin) {
                $xmin=$x; $ymin=$y;
                $dmin=$nodedist[$y][$x];
            }
        }
    }
    print("$xmin, $ymin\n");
    return ($xmin, $ymin);
}


sub testH {
    my $f=$grid[$_[1]][$_[0]];
    my $t=$_[2];

    printf("Inputs %d %d %s\n", $_[0], $_[1], $_[2]);

    $f="a" if($f eq "S");
    $t="z" if($t eq "E");

    printf("Testing %s to %s (%d to %d)\n", $f, $t, ord($f), ord($t));

    return((ord($t)-ord($f))<=1);
}

