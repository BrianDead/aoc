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

sub calculate {
	my $tgt=shift;
	my $rt=shift;
	my $to=shift;
	my @opd=@_;

#	print("Calculating target $tgt, rt $rt, to $to\n");
#	print Dumper \@opd;
	return 0 if($rt>$tgt);

	if(scalar @opd) {
		return calculate($tgt, ($rt<0 ? 0 : $rt) + $to, @opd )+
			calculate($tgt, ($rt<0 ? 1 : $rt) * $to, @opd)+
			calculate($tgt, ($rt<0 ? '' : $rt).$to+0, @opd);
	} else {
		return (($rt + $to) == $tgt ? 1 : 0) +
				(($rt * $to) == $tgt ? 1 : 0 ) +
				(("$rt$to"+0) == $tgt ? 1 : 0 );
	}

}

my $answer2=0;

for my $try (@list) {
	my @opds=@{$try->[1]};
	my $start=shift(@opds);
	if(calculate($try->[0], $start, @opds)) {
		printf("--- %d Success!\n", $try->[0]);
		$answer2+=$try->[0];
	}
}
print("Answer: $answer2\n");
