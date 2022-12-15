#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max);

my $maxx=0; my $maxy=0; my $minx=999999; my $miny=999999;
my %grid=();

my $cmin=0;
my $cmax=4000000;

my %ranges=();
my %beacons=();

my @squares=map {
    chomp;
    my ($sx,$sy,$bx,$by)= $_ =~ q/Sensor at x=([\-\d]*), y=([\-\d]*): closest beacon is at x=([\-\d]*), y=([\-\d]*)/;
    [$sx,$sy, abs($sx-$bx)+abs($sy-$by)]
} <STDIN>;

sub getIndex {
    return ($_[0].",".$_[1]);
#    return ($_[0]+5000)+($_[1]+5000)*10000;
}

sub pg {
    foreach my $iy ($miny..$maxy) {
        foreach my $ix ($minx..$maxx) {
            print $grid{getIndex($ix, $iy)} // ".";
        }
        print "\n";
    }

    print "------\n";
}

my $checks=0;
sub isOpen {
    my $cx=shift; my $cy=shift;
    my $rv=1;

#    printf("Checking %d, %d\n", $cx, $cy);
    $checks++;

    foreach my $sq (@squares) {
#        printf("   Look at square %d, %d l=%d ", $sq->[0], $sq->[1], $sq->[2]);
        my $md=abs($cx-$sq->[0])+abs($cy-$sq->[1]);
#        printf("- dist=%d\n", $md);
        if($md<=$sq->[2]) {
            $rv=0; last;    
        }
    }
    return $rv;
}

my $ex=2740279; my $ey=2625406;

#print Dumper \@squares;

printf("isOpen(%d, %d) => %d\n", $ex, $ey, isOpen($ex, $ey));
printf("isOpen(%d, %d) => %d\n", $ex+1, $ey, isOpen($ex+1, $ey));

my $rx=$cmin-1; my $ry=$cmin-1;

foreach my $sq (@squares) {
    my $sy=$sq->[1]; my $sx=$sq->[0]; my $md=$sq->[2]+1;
    printf("Looking at square %d, %d l=%d\n", $sx, $sy, $md);
    for(my $ex=max($cmin, $sx-$md); $ex<=min($cmax, $sx+$md); $ex++) {
        my $dy=($md-(abs($sx-$ex)));
        foreach my $ty ($sy+$dy, $sy-$dy) {
            next if($ty<$cmin || $ty>$cmax);
            if(isOpen($ex, $ty)) {
                $rx=$ex; $ry=$ty;
                last;
            }
        }
        last if($rx>=$cmin);
    }


    # foreach my $ex (0..$md) {
    #     foreach my $m ([1,1],[1,-1],[-1,1],[-1,-1]) {
    #         my $tx=$sx+($ex*$m->[0]); my $ty=$sy+($md-$ex)*$m->[1];
    #         next if($tx<$cmin || $tx>$cmax || $ty<$cmin || $ty>$cmax);
    #         if(isOpen($tx, $ty)) {
    #             $rx=$tx; $ry=$ty;
    #             last;
    #         }
    #     }
    #     last if($rx>=$cmin);
    # }
    last if($rx>=$cmin);
}
printf("Answer is %d, %d (%d checks)\n", $rx, $ry, $checks);

