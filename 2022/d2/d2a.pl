#!/usr/bin/perl

use Data::Dumper;

my $answer=0;
my $total=0;

my %scores=( 'Y' => 2, 'Z' => 3, 'X' => 1 );
my %plays=( 'A' => { 'X' =>3, 'Y' => 6, 'Z' => 0 },
            'B' => { 'X' =>0, 'Y' => 3, 'Z' => 6 },
            'C' => { 'X' =>6, 'Y' => 0, 'Z' => 3 }
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