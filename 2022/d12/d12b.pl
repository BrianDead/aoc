#!/usr/bin/perl

# My implementation of Dijkstra leaves you with a grid containing all the
# path lengths from the starting point to that grid point. So, to find the
# quickest of multiple potential start points, just switch it into reverse
# and calculate the grid starting from the endpoint, then scan the grid
# for the start point with the lowest cost. Seemed to work.
# Made it more efficient by keeping hash of nodes in play instead of iterating

use strict;
use Data::Dumper;

my @grid=map{ chomp; [split //] } <STDIN>;

my $w=@{$grid[0]};
my $h=@grid;
my @s=(-1,-1); my @e=(-1,-1);

my @nodedist=();
my @intree=();
my %cl=(); # Check list
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
$cl{getIndex(@e)}=1;

foreach my $y (0..($h-1)) {
    my $nx; my $ny;
    foreach my $x (0..($w-1)) {
        ($nx, $ny)=minpath();
        last if($nx==-1);

        $intree[$ny][$nx]=1;
        delete $cl{getIndex($nx, $ny)};

        foreach my $a ([0,-1],[-1,0],[1,0],[0,1]) { 
            my $tx=$nx+$a->[0]; my $ty=$ny+$a->[1];
            if($tx>=0 && $tx<=($w-1) && $ty>=0 && $ty<=($h-1) && testH($tx, $ty, $grid[$ny][$nx])) {
                my $newd=$nodedist[$ny][$nx]+1;
                $nodedist[$ty][$tx]=$newd if($newd<$nodedist[$ty][$tx]);
                $cl{getIndex($tx, $ty)}=1 if(!$intree[$ty][$tx]);
            }
        }
    }
    last if($nx==-1);
}

printf("Part 1 Answer is %d\n", $nodedist[$s[1]][$s[0]]);

my $answer=$huge;

foreach my $y (0..($h-1)) {
    foreach my $x (0..($w-1)) {
        if($grid[$y][$x] eq "a" || $grid[$y][$x] eq "S") {
#            printf("%s at %d, %d: %d\n", $grid[$y][$x], $x, $y, $nodedist[$y][$x]);
            $answer=$nodedist[$y][$x] if($nodedist[$y][$x]<$answer);
        }
    }
}

printf("Part 2 Answer is %d\n", $answer);

sub getIndex {
    return ($_[0]+$_[1]*$w);
}

sub getXY {
    return ($_[0]%$w,int($_[0]/$w));
}

sub minpath {
    my $xmin=-1; my $ymin=-1;
    my $dmin=$huge;

    foreach (keys %cl) {
        my ($x, $y)=getXY($_);
#        printf("min test %d,%d = %d vs %d - intree %d\n", $x, $y, $nodedist[$y][$x], $dmin, $intree[$y][$x]);
        if(!$intree[$y][$x] && $nodedist[$y][$x]<$dmin) {
            $xmin=$x; $ymin=$y;
            $dmin=$nodedist[$y][$x];
        }
    }
    return ($xmin, $ymin);
}


sub testH {
    my $f=$grid[$_[1]][$_[0]];
    my $t=$_[2];

    $f="a" if($f eq "S");
    $t="z" if($t eq "E");

    return((ord($t)-ord($f))<=1);
}
