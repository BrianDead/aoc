#!/usr/bin/perl

my $answer=0;
my $total=0;
my @elves=();

while( <STDIN> ) {
    chomp;

    if($_ eq "") {
        push (@elves, $total);
        $total=0;
    } else {
        $total+=$_;
    }
}

@selves=sort { $b <=> $a } @elves;

$answer=$selves[0]+$selves[1]+$selves[2];

printf("The highest calories by any elf is %d\n", $answer);