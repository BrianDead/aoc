#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @map;
my @galaxy;
my %pairs;
my $answer=0;

sub getpath {
	my ($f, $t)=@_;
	abs($galaxy[$f][0]-$galaxy[$t][0])+abs($galaxy[$f][1]-$galaxy[$t][1])
}

while(<>){
	chomp;
	push (@map, [split //]);
	if(index($_, '#')<0) {
		push (@map, [split //])
	}
}

my $h=scalar @map;
my $w=scalar @{$map[0]};

my $x=0;

while($x<$w) {
	my $gc=0;
	foreach my $y(0..$h-1) {
		$gc++ if($map[$y][$x] eq '#');
	}
	if($gc eq 0) {
		foreach my $y(0..$h-1) {
			splice(@{$map[$y]},$x,0,'.');
		}
		$w++;
		$x++;
	}
	$x++
}

foreach my $r(@map) {
	foreach my $c(@{$r}) {
		print $c;
	}
	print "\n";
}

foreach my $y(0..$h-1) {
	foreach my $x(0..$w-1) {
		push(@galaxy, [$y,$x]) if($map[$y][$x] eq "#"); 
	}
}

foreach my $i (0..($#galaxy-1)) {
	foreach my $j(($i+1)..$#galaxy) {
		my $p=getpath($i, $j);
		$answer+=$p;
		print("Pair $i,$j = $p\n");
	}
}

print("Answer is $answer\n");