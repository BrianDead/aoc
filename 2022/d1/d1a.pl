#!/usr/bin/perl

my $answer=0;
my $total=0;

while( <STDIN> ) {
    chomp;

    if($_ eq "") {
        $answer=$total if($total>$answer);
        $total=0;
    } else {
        $total+=$_;
    }
}

printf("The highest calories by any elf is %d\n", $answer);