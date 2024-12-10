#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my %xmers=();
my $y=0;

my $h=0;
my $w=0;

while(<STDIN>) {
	chomp;
	my $x=0;
	foreach(split //) {
#		print $_;
		if($_ ne '.') {
			if(!defined($xmers{$_})) {
				$xmers{$_}=[];
			}
			push(@{$xmers{$_}},[$x,$y]);
		}
		$x++;
	}
	$w=$x if($x>$w);
	$y++;
#	print"\n";
}

$h=$y;

my %anodes=();

for my $xm (keys %xmers) {
	my @tt=@{$xmers{$xm}};
	while((scalar @tt ) > 1) {
		my $n1=shift(@tt);
		for my $n2 (@tt) {
			my $dx=$n2->[0]-$n1->[0];
			my $dy=$n2->[1]-$n1->[1];

			my $p1x=$n2->[0]+$dx;
			my $p1y=$n2->[1]+$dy;

			my $p2x=$n1->[0]-$dx;
			my $p2y=$n1->[1]-$dy;

#			printf("Pair %d,%d and %d, %d\n", $n2->[0], $n2->[1], $n1->[0], $n1->[1]);

#			print("Diff $dx, $dy Antinodes $p1x, $p1y and $p2x, $p2y\n");

			$anodes{"$p1x,$p1y"}++ if($p1x>=0 && $p1y>=0 && $p1x<$w && $p1y<$h);
			$anodes{"$p2x,$p2y"}++ if($p2x>=0 && $p2y>=0 && $p2x<$w && $p2y<$h);
		}
	}
}

printf("Answer: %d\n", scalar keys %anodes);

#print Dumper \%anodes;

my %anodes2=();

for my $xm (keys %xmers) {
	my @tt=@{$xmers{$xm}};
	while((scalar @tt ) > 1) {
		my $n1=shift(@tt);
		for my $n2 (@tt) {
			my $dx=$n2->[0]-$n1->[0];
			my $dy=$n2->[1]-$n1->[1];

			my $p1x=$n2->[0];
			my $p1y=$n2->[1];

			while ($p1x>=0 && $p1y>=0 && $p1x<$w && $p1y<$h) {
				$anodes2{"$p1x,$p1y"}++;
				$p1x+=$dx;
				$p1y+=$dy;
			}


			my $p2x=$n1->[0];
			my $p2y=$n1->[1];

			while ($p2x>=0 && $p2y>=0 && $p2x<$w && $p2y<$h) {
				$anodes2{"$p2x,$p2y"}++;
				$p2x-=$dx;
				$p2y-=$dy;
			}

		}
	}
}

for my $i (0..$h-1) {
	for my $j (0..$w-1) {
		if($anodes2{"$j,$i"}) {
			print '#';
		} else {
			print '.';
		}
	}
	print "\n";
}

printf("Answer2: %d\n", scalar keys %anodes2);
