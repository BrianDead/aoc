#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# my @m=map{ chomp; [split / /] } <>;

my @l;
my @r;
my %f;

while(<STDIN>) {
	chomp;
	my @n=split / +/;
	print Dumper \@n;
	push(@l, @n[0]);
	push(@r, @n[1]);
}


print Dumper \@l, \@r;

my @ls=sort {$a <=> $b} @l;
my @rs=sort {$a <=> $b} @r;
my $dist=0;
print Dumper \@ls, \@rs;

for (0..(scalar @ls)-1) {
	$dist+=abs($ls[$_]-$rs[$_]);
	$f{$rs[$_]}+=1;
}

print Dumper \%f;

printf("Answer: %d\n", $dist);

my $s2=0;

for (0..(scalar @ls)-1) {
	if($f{$ls[$_]}) {
		$s2+=($ls[$_]*$f{$ls[$_]});
	}
}

printf("Answer2: %d\n", $s2);