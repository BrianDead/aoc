#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my @m=map { chomp; [ split // ]} <STDIN>;

my $h=scalar @m;
my $w=scalar @{$m[0]};

my @dir=(
	[-1,0],
	[0,1],
	[1,0],
	[0,-1]
	);

my $answer=0;

sub trail {
	my $r=shift;
	my $c=shift;
	my $rec=shift;
	my $hash="$r,$c";
#	return 0 if($rec->{$hash}++);

	printf("($r,$c) %d - ", $m[$r][$c]);

	if($m[$r][$c]==9) {
		printf("\n");
		return 1;
	}

	
	my $count=0;

	for my $d (@dir) {
		my $nr=$r+$d->[0];
		my $nc=$c+$d->[1];

		if($nr>=0 && $nr<$h && $nc>=0 && $nc<$w) {
			if($m[$nr][$nc]==$m[$r][$c]+1) {
				$count+=trail($nr, $nc, $rec);
			}
		}
	}

	print("\n") if($count==0);
	return $count;
}

for my $r (0..(scalar @m)-1) {
	for my $c (0..(scalar@{$m[$r]})-1) {
		my %rec=();
		if ($m[$r][$c]==0) {
			print("Starting a trail at $r, $c\n");
			$answer+=trail($r, $c, \%rec);
			print("answer now $answer\n");
		}
	}
}

print("Answer: $answer\n");
