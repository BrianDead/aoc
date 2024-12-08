#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

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
			if($_<=$try->[0]) {
				print("from $_ ");
				@rv=($_ * $op, $_ + $op);
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

print("Answer: $answer1\n");

sub calculate {
	my $tgt=shift;
	my $rt=shift;
	my $to=shift;
	my @opd=@_;

#	print("Calculating target $tgt, rt $rt, to $to\n");
#	print Dumper \@opd;

	if(scalar @opd) {
		return (
			calculate($tgt, ($rt<0 ? 0 : $rt) + $to, @opd ),
			calculate($tgt, ($rt<0 ? 1 : $rt) * $to, @opd),
			calculate($tgt, ($rt<0 ? '' : $rt).$to+0, @opd)
			);
	} else {
		return ( 
			$rt + $to,
			$rt * $to,
			"$rt$to"+0
		)
	}

}

my $answer2=0;

for my $try (@list) {
	my @opds=@{$try->[1]};
	my $start=shift(@opds);
	my @results=calculate($try->[0], $start, @opds);

#	print Dumper \@results;

	print("--- Success!") if(grep($_==$try->[0] , @results));

	$answer2+=$try->[0] if(grep($_==$try->[0], @results));
	print("\n");
}
print("Answer: $answer2\n");
