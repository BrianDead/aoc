#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my $count=0;
my $total=0;
my $minc=0;

my @reg=();

map {
	chomp; push @reg, $_;
	$count++ if($total>0 && $reg[-1] > $reg[-2]);
	$minc++ if($total>3 && sum(@reg[1..3]) > sum(@reg[0..2]));

	shift @reg if($total>3);
	$total++;
} <STDIN>;

print "$count increases out of $total\n";
print "$minc moving window increases\n";