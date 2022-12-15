#!/usr/bin/perl

use strict;
use List::Util qw(min max);

my $maxx=0; my $maxy=0; my $minx=999999; my $miny=999999;
my %grid=();


sub getIndex {
    return ($_[0].",".$_[1]);
#    return ($_[0]+5000)+($_[1]+5000)*10000;
}

sub pg {
    foreach my $iy (0..20) {
        foreach my $ix (0..20) {
            print $grid{getIndex($ix, $iy)} // ".";
        }
        print "\n";
    }

    print "------\n";
}


while (<STDIN>) {
    chomp;
    my ($sx,$sy,$bx,$by)= $_ =~ q/Sensor at x=([\-\d]*), y=([\-\d]*): closest beacon is at x=([\-\d]*), y=([\-\d]*)/;

    printf("%d,%d - %d,%d\n", $sx, $sy, $bx, $by);

    $grid{getIndex($sx,$sy)}="S";
    printf("%s\n", $grid{getIndex($sx, $sy)});
    $grid{getIndex($bx,$by)}="B";

    my $md=abs($sx-$bx)+abs($sy-$by);
    print("Manhattan distance = ".$md."\n");

    foreach my $mx (0..$md) {
        foreach my $my (0..($md-$mx)) {
            $grid{getIndex($sx+$mx, $sy+$my)}=$grid{getIndex($sx+$mx, $sy+$my)} // "#";
            $grid{getIndex($sx-$mx, $sy-$my)}=$grid{getIndex($sx-$mx, $sy-$my)} // "#";
            $grid{getIndex($sx+$mx, $sy-$my)}=$grid{getIndex($sx+$mx, $sy-$my)} // "#";
            $grid{getIndex($sx-$mx, $sy+$my)}=$grid{getIndex($sx-$mx, $sy+$my)} // "#";

        } 
    }
    $maxx=max($maxx, $sx+$md);
    $maxy=max($maxy, $sy+$md);
    $miny=min($miny, $sy-$md);
    $minx=min($minx, $sx-$md);
}

pg();

my $answer=0;

foreach my $ix ($minx..$maxx) {
    $answer++ if($grid{$ix.",10"} =~ q/[S#]/);
}

print("Answer is ".$answer."\n");