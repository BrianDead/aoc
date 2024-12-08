#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use bignum;

my @list=map {
	chomp;
	my ($total, $in) = split /: /;
	my @inputs=split / /,$in;
	[$total,\@inputs]
} <STDIN>;

print Dumper \@list;

my $answer1=0;

for my $try (@list) {
	my @pa=(1);
	print("Trying $try->[0] with:\n");
	print Dumper $try->[1];
	for my $op (@{$try->[1]}) {
		print("Considering $op - ");
		my @npa=map {
			my @rv=();
			print("from $_ ");
			my $nm=$_ * $op;
			my $na=$_ + $op;
			if($nm > $try->[0]) {
				if($na <= $try->[0]) {
					@rv=($na);
				}
			} else {
				if($na > $try->[0]) {
					@rv=($nm);
				} else {
					@rv=($na, $nm);
				}
			
			}
			@rv
		} @pa;
		@pa=@npa;
		print("\n");
	}
	print("--- Success!") if(grep($_==$try->[0], @pa));

	$answer1+=$try->[0] if(grep($_==$try->[0], @pa));
	print("\n");
}

print("Answer: $answer1\n")