#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(max min);

my $maxy=0;
my @map=map{chomp;$maxy++;[split //]} <STDIN>;
my @maps=(\@map);

#print Dumper $maps[0];

my $maxx=scalar @{$map[0]}-1;
$maxy--;

my $start=0; my $finish=0;
foreach my $i (0..$maxx) {
    $start=$i if ($map[0][$i] eq ".");
    $finish=$i if ($map[$maxy][$i] eq ".");
}

my $done=0;
my $moves=0;
my @steps=([1,0],[0,1],[-1,0],[0,-1]);

my $x=$start;
my $y=0;
my $answer=999999999999;
my $answer2; my $answer3;    
my $currentmin=1500;
my %cache=();


pm($x, $y, \@map);

$answer=movefrom($start,0,1,$finish,$maxy);
printf("Answer 1: %s\n", $answer);

unshift @steps, pop @steps;
unshift @steps, pop @steps;

print Dumper \@steps;
$currentmin=300+$answer;
%cache=();

$answer2=movefrom($finish, $maxy, $answer+1, $start, 0);
printf("Answer 2: %d (%d) \n", $answer2, $answer2-$answer);

unshift @steps, pop @steps;
unshift @steps, pop @steps;
$currentmin=300+$answer2;
%cache=();

$answer3=movefrom($start,0,$answer2+1,$finish,$maxy);

printf("Answer3: %d (%d)\n", $answer3, $answer3-$answer2);
print( "Answer is $answer\n");

sub pm {
    my $px=shift;
    my $py=shift;
    my $map=shift;

    foreach my $y (0..$maxy) {
        foreach my $x (0..$maxx) {
            if($x==$px && $y==$py) {
                print "E";
            } elsif(($y==0 && $x==$start) || ($y==$maxy && $x==$finish)) {
                print"!";
            } elsif(($y==0 || $y==$maxy || $x==0 || $x==$maxx)) {
                print "#";
            } elsif(defined($map->[$y][$x])) {
                if(length($map->[$y][$x])>1) {
                    print length($map->[$y][$x]);
                } else {
                    print $map->[$y][$x];
                }
            } else {
                print '.';
            }
        }
        print "\n";
    }
    print "\n";
}

sub movefrom {
    my $x=shift;
    my $y=shift;
    my $step=shift;
    my $tox=shift;
    my $toy=shift;
    my $moves=0;

    my $minpath=999999999999;

    return $minpath if((abs($tox-$x)+abs($toy-$y))>($currentmin-$step));

    my $hash="$x.$y.$step";
    if(defined($cache{$hash})) {
        print "Cached $hash\n" if($step<1093);
        return $cache{$hash};
    }
    print("Running $hash\n");

    if($y==$toy && $x==$tox) {
        $minpath=$step-1;
        $currentmin=min($minpath, $currentmin);
        printf("Finished - %d (currentmin=%d)\n", $minpath, $currentmin);
    } else {

        if(!defined($maps[$step])) {
            printf("Making new map for step %d\n", $step);
            $maps[$step]=moveblizzards($maps[$step-1]);
        }

#        pm($x,$y,$maps[$step]);

        foreach my $s (@steps) {
            if(($x+$s->[0]<1 || $x+$s->[0]>$maxx-1 || $y+$s->[1]>$maxy-1 
                || $y+$s->[1]<1) && !($y+$s->[1]==$toy && $x+$s->[0]==$tox) ) {
                next;
            }
            if(!defined($maps[$step][$y+$s->[1]][$x+$s->[0]])) {
                $minpath=min($minpath, movefrom($x+$s->[0], $y+$s->[1], $step+1, $tox, $toy));
                $moves++;
            }
        }
        # or wait in place if a blizzard hasn't moved here
        if(!defined($maps[$step][$y][$x])) {
            $minpath=min($minpath, movefrom($x, $y, $step+1, $tox, $toy));
            $moves++;
        }
    }
    $cache{$hash}=$minpath;
    return $minpath;
}

sub moveblizzards {
    my @map=@{$_[0]};
    my @newmap=();

#    print("Moving blizzards Input map:\n");
#    pm($start,0,\@map);

    foreach my $x (1..$maxx-1) {
        my $lx=$x-1; if($lx==0) { $lx=$maxx-1; }
        my $rx=$x+1; if($rx==$maxx) {$rx=1; }
        foreach my $y (1..$maxy-1) {
            my $uy=$y-1; if($uy==0) { $uy=$maxy-1; }
            my $dy=$y+1; if($dy==$maxy) {$dy=1; }
            my $c=$map[$y][$x] // '.';
            next if($c eq '.' || $c eq '#');
            foreach my $k (0..length($c)) {
                my $l=substr($c,$k,1);
                if($l eq '^') {
                    $newmap[$uy][$x]=($newmap[$uy][$x] // '').'^';
                } elsif ($l eq '>') {
                    $newmap[$y][$rx]=($newmap[$y][$rx] // '').'>';
                } elsif ($l eq '<') {
                    $newmap[$y][$lx]=($newmap[$y][$lx] // '').'<';
                } elsif ($l eq 'v') {
                    $newmap[$dy][$x]=($newmap[$dy][$x] // '').'v';
                }
            }
        }
    }
#    print("Moving blizzards Output map:\n");
#    pm($start,0,\@newmap);

    return \@newmap;
}

