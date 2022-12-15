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
    foreach my $iy ($miny..$maxy) {
        foreach my $ix ($minx..$maxx) {
            print $grid{getIndex($ix, $iy)} // ".";
        }
        print "\n";
    }

    print "------\n";
}

my $target=2000000;
my @ranges=();
my %beacons=();


while (<STDIN>) {
    chomp;
    my ($sx,$sy,$bx,$by)= $_ =~ q/Sensor at x=([\-\d]*), y=([\-\d]*): closest beacon is at x=([\-\d]*), y=([\-\d]*)/;

    printf("%d,%d - %d,%d\n", $sx, $sy, $bx, $by);

    my $md=abs($sx-$bx)+abs($sy-$by);
    print("Manhattan distance = ".$md."\n");

    if(($sy-$md)<=$target || ($sy+$md)>=$target) {
        my $dx=$md-abs($sy-$target);
        push @ranges, [$sx-$dx, $sx+$dx];
    }

    if($by==$target) {
        $beacons{$bx}=1;
    }
    $maxx=max($maxx, $sx+$md);
    $maxy=max($maxy, $sy+$md);
    $miny=min($miny, $sy-$md);
    $minx=min($minx, $sx-$md);
}

my $answer=0;

my %row=();
my $rmaxx=-9999999999;
my $rminx=9999999999;


foreach my $r (@ranges) {
    $rmaxx=max($rmaxx, $r->[0]);
    $rminx=min($rminx, $r->[1]);

 #   printf("Range %d-%d\n", $r->[0], $r->[1])

    for my $i ($r->[0]..$r->[1]) {
        $answer++ unless (defined($row{$i}) || defined($beacons{$i}));
        $row{$i}=$beacons{$i} // 2;
    }
}
# foreach my $k ($minx..$maxx) {
#     print $row{$k} // '.';
# }
# print "\n";

print("Answer is ".$answer."\n");