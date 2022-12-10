#!/usr/bin/perl

use strict;

my %moves=( 'Wx'=>-1, 'Ex'=>1,'Ny'=>1,'Sy'=>-1, 'Lt'=>1, 'Rt'=>-1);
#my %turns=( 'Ex');
my @faces=('E','N','W','S');
my %tr=(
    '0xx'=>'1', '0yy'=>'1',
    '90yx'=>'-1', '90xy'=>'1',
    '180xx'=>'-1', '180yy'=>'-1',
    '270yx'=>'1', '270xy'=>'-1'
);

my @pos=(0,0);
my @wp=(10,1); #Waypoint starting pos
my $face=0;

while(<STDIN>) {
    chomp;
    my ($m, $n)= $_ =~ q/(\w)(.*)/;

    printf("Moving %d %s\n", $n, $m);

    if($m eq 'F') {
        $pos[0]+=$wp[0]*$n;
        $pos[1]+=$wp[1]*$n;
    } elsif($m eq 'R' || $m eq 'L') {
        $n=(360-$n)%360 if($m eq 'R');  # Convert right turns to left turns
        my $x=$wp[0];
        my $y=$wp[1];

        $wp[0]=($x*$tr{$n.'xx'}+$y*$tr{$n.'yx'}); # Pivot waypoint
        $wp[1]=($x*$tr{$n.'xy'}+$y*$tr{$n.'yy'});
    } else {
        $wp[0]+=$n*$moves{$m.'x'};
        $wp[1]+=$n*$moves{$m.'y'};
    }

    printf("Now at %d, %d ", @pos);
    printf("Waypoint now %d, %d\n", @wp);

}

printf("Answer is %d\n", abs($pos[0])+abs($pos[1]));
