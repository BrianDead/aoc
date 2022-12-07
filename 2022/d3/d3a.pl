#!/usr/bin/perl

use Data::Dumper;

my $answer=0;
my $total=0;
my $score=0;


while( <STDIN> ) {
    chomp;

    my $len=length($_)/2;
    my $p1=substr($_, 0, $len);
    my $p2=substr($_, $len);

    printf("Line %s split %s - %s\n", $_, $p1, $p2);

    for(my $i=0; $i<$len; $i++) {
        my $match=substr($p1, $i, 1);
        if( $p2 =~ $match ) {
            $score=ord($match)-(65-27);
            $score-=58 if($score>52);
            printf("Matched on %s, score %d\n", $match, $score);
            last;
        }
    }   

    $total+=$score;


}

$answer=$total;

printf("Total score = %d\n", $answer);