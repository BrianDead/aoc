#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw/sum/;

use Data::Dumper;

my @clumps;

my @plan = map {
	chomp;
	my ($p, $c)=split / +/;
	push(@clumps, [split /,/,$c]);
	[split //, $p]
#	$p
} <>;

print Dumper \@plan;
print "\n";
print Dumper \@clumps;

my $answer;

foreach my $i (0..$#plan) {
	my $done=0;
	my $h=sum(@{$clumps[$i]});
	my $regex="^[.]*";
	my $first=1;
	foreach (@{$clumps[$i]}) {
		if(!$first) {
			$regex=$regex . "[.]+"
		}
		$regex=$regex . ( "#" x $_ ) ;
		$first=0;
	}
	$regex=$regex . "[.]*\$";

	printf("Next one - regex $regex hashes $h\n");
	foreach (@{$plan[$i]}) {
		print $_;
	}
	print "\n";

	my $try=0;
	my $succ=0;
	my $wilds=0;
	my $wild;
	do {
		$wild=0;
		my $string="";
		my $hashes=0;
		foreach (@{$plan[$i]}) {
			if ($_ eq "?") {
				if($try & 2**$wild) {
					$string=$string.".";
				} else {
					$string=$string."#";
					$hashes++;
				}
				$wild++;
			} elsif($_ eq "#") {
				$string=$string."#";
				$hashes++;
			} else {
				$string=$string.".";
			}
			$wilds=$wild>$wilds?$wild:$wilds;
			if($hashes > $h) {
				$string="";
				last;
			};
		}
		if($string ne "") {
		if($string =~ m/$regex/) {
			$succ++;
#			print("$succ: $string matches $regex\n");
		} else {
#			print(" fail: $string doesn't match $regex\n");
		}
	}
		$try++;
	} until ($try >= (2**$wilds) ) ;	

	printf("result: %d\n", $succ);
	$answer+=$succ;
}
print("Answer is $answer\n");