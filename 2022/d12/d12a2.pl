#!/usr/bin/perl

# Solves the puzzle using Dijkstra's algorithm, copied and adapted from
# day 15 of 2021

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

$nodedist[$s[1]][$s[0]]=0;

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

my $answer=$nodedist[$e[1]][$e[0]];

printf("Answer is %d\n", $answer);

sub minpath {
    my $xmin; my $ymin;
    my $dmin=$huge;

    foreach my $y (0..($h-1)) {
        foreach my $x (0..($w-1)) {
            if(!$intree[$y][$x] && $nodedist[$y][$x]<$dmin) {
                $xmin=$x; $ymin=$y;
                $dmin=$nodedist[$y][$x];
            }
        }
    }
    return ($xmin, $ymin);
}


sub testH {
    my $t=$grid[$_[1]][$_[0]];
    my $f=$_[2];

    printf("Inputs %d %d %s\n", $_[0], $_[1], $_[2]);

    $f="a" if($f eq "S");
    $t="z" if($t eq "E");

    printf("Testing %s to %s (%d to %d)\n", $f, $t, ord($f), ord($t));

    return((ord($t)-ord($f))<=1);
}

