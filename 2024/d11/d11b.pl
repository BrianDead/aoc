#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my @s;

while(<STDIN>) {
	chomp;
	push(@s, split / /)
}

printf("%d stones\n", scalar @s);

my %analysis=();

foreach(@s) {
	$analysis{$_}++;
}

my $ana=\%analysis;

foreach(1..75) {
	my %nana=();

	for my $n (keys %{$ana}) {
		if($n==0) {
			$nana{1}+=$ana->{0}
		} else {
			my $sn="$n";
			my $l=length($sn);
			if($l % 2 == 0) {
				$nana{substr($sn,0,$l/2)+0}+=$ana->{$n};
				$nana{substr($sn,0-($l/2))+0}+=$ana->{$n};
			} else {
				$nana{$n*2024}+=$ana->{$n};
			}	
		}
	}
	$ana=\%nana;

}

my $answer=0;
for my $n (keys %{$ana}) {
	$answer+=$ana->{$n};
}

printf("Answer: %d\n", $answer);



