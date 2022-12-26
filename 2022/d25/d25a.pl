#!/usr/bin/perl

use strict;
use warnings;

my %digits=( '1'=>1, '2'=>2, '0'=>0, '-'=>-1,'='=>-2);
my %mkdig=( 1=>'1',2=>'2',3=>'=',4=>'-',0=>'0');

sub fromsnafu {
    my $snafu=shift;
    my $place=1;
    my $r=0;

    printf("Decoding %s (%d) to ", $snafu, length($snafu));

    for my $i (1..(length($snafu))) {
        my $p=length($snafu)-$i;
#        printf("Place %d Digit %d is %s\n", $place,$i, substr($snafu, $p, 1));
        $r+=$digits{substr($snafu, $p, 1)}*$place;
        $place=$place*5;
    }
    print("$r\n");
    return $r;
}

sub tosnafu {
    my $n=shift;
    my $snafu="";
    my $place=5;
    my $carry=0;

    print("Encoding $n to ");

    while($n>0) {
        my $val=$n%5; $n=int($n/5);

        if($val>2) {
            $n+=1;
        }
        $snafu=$mkdig{$val}.$snafu;
    }

    print($snafu."\n");
    return $snafu;
}

#for my $i (1,2,3,4,5,6,7,8,9,10,15,20) {
#    tosnafu($i);
#}



my $answer=0;

while(<STDIN>) {
    chomp;
    $answer+=fromsnafu($_);
#    tosnafu($answer);
#    print("--------------------\n");
}

printf("Answer is %s (%d)\n", tosnafu($answer), $answer);
