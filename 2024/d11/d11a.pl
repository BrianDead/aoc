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

foreach(1..75) {
	my $i=0;
	while($i<(scalar @s)) {
		if($s[$i]==0) {
			$s[$i]=1;
			$i++
		} else {
			my $n="$s[$i]";
			my $l=length($n);
			if($l % 2 == 0) {
				splice(@s,$i,1,substr($n,0,$l/2)+0,substr($n,0-($l/2))+0);
				$i+=2;
			} else {
				$s[$i]=$s[$i]*2024;
				$i++;
			}	
		}
	}
	printf("%d stones\n", scalar @s);
}