#!/usr/bin/perl

use Data::Dumper;

my $answer=0;
my $total=0;

my %scores=( 'X' => 0 ,'Y' => 3, 'Z' => 6);
my %plays=( 'A' => { 'X' => 3, 'Y' => 1, 'Z' => 2 },
            'B' => { 'X' => 1, 'Y' => 2, 'Z' => 3 },
            'C' => { 'X' => 2, 'Y' => 3, 'Z' => 1 }
        );

print Dumper \%plays;

printf("Score Y=%d\n", $scores{'Y'});
printf("Score A X=%d\n", $plays{'A'}{'X'});

while( <STDIN> ) {
    chomp;
    my ($p1,$p2)=split / /, $_;

    printf("%s plays %s - result %d play %d total %d\n", $p1, $p2, $plays{$p1}{$p2}, $scores{$p2}, $plays{$p1}{$p2} + $scores{$p2});

    $total+=($plays{$p1}{$p2}+$scores{$p2});


}

$answer=$total;

printf("Total score = %d\n", $answer);