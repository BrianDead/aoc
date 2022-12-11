#!/usr/bin/perl

use strict;

my %cycles=( "noop"=>1, "addx"=>2 );
my $answer=0;
my $pc=0;
my $x=1;

while(<STDIN>) {
    chomp;
    my ($op, $arg)=split / /, $_;
    printf("OP:%s ARG:%s CYCLES:%d\n", $op, $arg, $cycles{$op});

    foreach(1..$cycles{$op}) {
        printf("Cycle %d x=%d %s %d\n", $pc+1, $x, $op, $arg);
        if(((++$pc)-20)%40==0) {

            $answer+=$x*$pc;
            printf("**** Signal %d Answer now %d\n", $x*$pc, $answer);

        }
    }
    if($op eq 'addx') {
        $x+=$arg;
    }

}

printf("Answer is %d\n", $answer);