#!/usr/bin/perl

use POSIX;
use Data::Dumper;

my @in=map { chomp; [ split / +/ ]}<>;
shift @{$in[0]};
shift @{$in[1]};

my $t2="";
my $d2="";

foreach my $n (@{$in[0]}) {
	print $n;
	$t2="$t2$n";
}
foreach my $n (@{$in[1]}) {
	$d2="$d2$n";
}

print Dumper @in;

my $answer=1;

for my $i (0..@{$in[0]}-1) {
	my $x=int((-$in[0][$i]+sqrt($in[0][$i]**2 - (4*$in[1][$i])))/-2)+1;
	my $sol=$in[0][$i]-$x-($x-1);
	printf("Time %d, distance %d, x=%d, solutions %d\n", $in[0][$i], $in[1][$i], $x, $sol);
	$answer*=$sol;
}

printf("Answer=%d\n",$answer);

my $x=int((-$t2+sqrt($t2**2 - (4*$d2)))/-2)+1;
my $sol=$t2-$x-($x-1);
printf("Time %d, distance %d, x=%d, solutions %d\n", $t2, $d2, $x, $sol);
