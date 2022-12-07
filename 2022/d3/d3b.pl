#!/usr/bin/perl

use Data::Dumper;

my $answer=0;
my $total=0;
my $score=0;

my $gcount=0;
my @mem=();

while( <STDIN> ) {
    chomp;
    $mem[$gcount++]=$_;
    if($gcount >= 3) {
        $gcount=0;

        my $len=length($mem[0]);

        printf("Line 1 %s\nLine 2 %s\nLine 3 %s\n", $mem[0], $mem[1], $mem[2]);

        for(my $i=0; $i<$len; $i++) {
            my $match=substr($mem[0], $i, 1);
            if( $mem[1] =~ $match ) {
                if( $mem[2] =~ $match) {
                    $score=ord($match)-(65-27);
                    $score-=58 if($score>52);
                    printf("Matched on %s, score %d\n", $match, $score);
                    last;
                }
            }
        }   
        $total+=$score;
    }

}

$answer=$total;

printf("Total score = %d\n", $answer);