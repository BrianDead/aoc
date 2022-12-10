#!/usr/bin/perl

use strict;

my %moves=( 'Wx'=>-1, 'Ex'=>1,'Ny'=>1,'Sy'=>-1, 'Lt'=>1, 'Rt'=>-1);
my %turns=( 'Ex');
my @faces=('E','N','W','S');
my @pos=(0,0);
my $face=0;


while(<STDIN>) {
    chomp;
    my ($m, $n)= $_ =~ q/(\w)(.*)/;

    printf("Moving %d %s\n", $n, $m);

    if($m eq 'F') {
        $m=$faces[$face];
    }
    $pos[0]+=$n*$moves{$m.'x'};
    $pos[1]+=$n*$moves{$m.'y'};
    $face=($face+$moves{$m.'t'}*$n/90+4)%4;

    printf("Now at %d, %d facing %s\n", @pos, $faces[$face]);

}

printf("Answer is %d\n", abs($pos[0])+abs($pos[1]));
