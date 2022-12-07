#!/usr/bin/perl

my $t1=0;
my $t2=0;

map {
    chomp;
    my @e=split /,/;
    my @e1=split /-/,$e[0];
    my @e2=split /-/,$e[1];

    printf("%s : %d-%d,%d-%d\n", $_, $e1[0],$e1[1],$e2[0],$e2[1]);

    if($e1[0]==$e2[0]) {
        $t1++;
        $t2++;
    } elsif($e1[0]<$e2[0]) {
        $t1++ if($e2[1]<=$e1[1]);
        $t2++ if($e1[1]>=$e2[0]); 
    } else {
        $t1++ if($e1[1]<=$e2[1]);
        $t2++ if($e2[1]>=$e1[0]);
    }
} <STDIN>;

printf("Complete overlap=%d PArtial overlap=%d\n", $t1, $t2)