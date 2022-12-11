#!/usr/bin/perl

use strict;

my %cycles=( "noop"=>1, "addx"=>2 );
my $answer=0;
my $pc=0;
my $x=1;

while(<STDIN>) {
    chomp;
    my ($op, $arg)=split / /, $_;

    foreach(1..$cycles{$op}) {
        if(((++$pc)-20)%40==0) {

            $answer+=$x*$pc;

        }
        if(($pc%40-1)>=$x-1 && ($pc%40-1)<=$x+1) {
            print("#");
        } else {
            print(".");
        }
        print("\n") if ($pc%40==0);
    }
    if($op eq 'addx') {
        $x+=$arg;
    }

}

printf("Answer is %d\n", $answer);