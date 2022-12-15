#!/usr/bin/perl

use strict;
use Data::Dumper;
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

my $cmin=0;
my $cmax=4000000;

my %ranges=();
my %beacons=();

my @squares=map {
    chomp;
    my ($sx,$sy,$bx,$by)= $_ =~ q/Sensor at x=([\-\d]*), y=([\-\d]*): closest beacon is at x=([\-\d]*), y=([\-\d]*)/;
    [$sx,$sy, abs($sx-$bx)+abs($sy-$by)]
} <STDIN>;

print Dumper \@squares;

foreach my $ty ($cmin..$cmax) {
    foreach my $sq (@squares) {
        my $sy=$sq->[1]; my $sx=$sq->[0]; my $md=$sq->[2];
        my $dx=$md-abs($sy-$ty);

#        printf("Row %d, Sq(%d, %d, %d), dx=%d now %d lines ", $ty, $sx, $sy, $md, $dx, scalar @{$ranges{$ty}});

        if($dx>=0) {
            my @tr=(max($cmin, $sx-$dx), min($cmax, $sx+$dx));
#            printf("- line from %d to %d ", $tr[0], $tr[1]);
            if(defined($ranges{$ty})) {
                my $overlap=0;
                foreach my $r (@{$ranges{$ty}}) {
                    if($tr[0]<$r->[0] && $tr[1]>=($r->[0]-1)) { #overlap or abut left
                        $r->[0]=$tr[0];
                        $overlap=1;
#                        print "-oll-";
                    }
                    if($tr[1]>$r->[1] && $tr[0]<=($r->[1]+1)) { #overlap or abut right
                        $r->[1]=$tr[1];
                        $overlap=1;
#                        print "-olr-";
                    }
                    if($tr[0]>=$r->[0] && $tr[0]<=$r->[1] && $tr[1]<=$r->[1] && $tr[1]>=$r->[0]) { # fits inside existing
                        $overlap=1;
                    }
                    last if($overlap);
                }
                if(!$overlap) {
                    push @{$ranges{$ty}}, \@tr;
                } else {
                    my $ol=0;
                    do {
                        $ol=0;
                        if(@{$ranges{$ty}} > 1) {
                            my @sr=sort { $a->[0] <=> $b->[0] } @{$ranges{$ty} };
                            foreach my $j (0..@sr-2) {
                                if($sr[$j][0]<$sr[$j+1][0] && $sr[$j][1]>=($sr[$j+1][0]-1)) { #overlap left
                                    $sr[$j+1][0]=$sr[$j][0];
                                    $ol=1;
                                }
                                if($sr[$j][1]>$sr[$j+1][1] && $sr[$j][0]<=($sr[$j+1][1]+1)) { #overlap right
                                    $sr[$j+1][1]=$sr[$j][1];
                                    $ol=1;
                                }
                                if($sr[$j][0]>=$sr[$j+1][0] && $sr[$j][0]<=$sr[$j+1][1] &&
                                    $sr[$j][1]<=$sr[$j+1][1] && $sr[$j][1]>=$sr[$j][0]) {
                                    $ol=1;
                                }
                                if($ol) {
                                    splice @sr, $j, 1;
                                    last;
                                }
                            }
                            $ranges{$ty}=\@sr;
                        } 
                    } while ($ol); 
                }
            } else {
                $ranges{$ty}=[\@tr];
            }


        }
#        printf("\nRow %d, Sq(%d, %d, %d) now %d lines\n", $ty, $sx, $sy, $md, scalar @{$ranges{$ty}});
    }
}

my $answer=0;

foreach my $i ($cmin..$cmax) {

#    printf("Row %d - %d\n", $i, scalar @{$ranges{$i}});
    if(scalar @{$ranges{$i}} > 1) {
        printf("row %d - %d\n", $i, @{$ranges{$i}});
        printf("column %d - %d ==> %d\n", $ranges{$i}->[0][1], $ranges{$i}->[1][0], $ranges{$i}->[0][1]+1);
        $answer=$i+($ranges{$i}->[0][1]+1)*4000000;
        printf("Answer: %d\n", $answer);
        print Dumper $ranges{$i};
    }
}

printf("Answer")