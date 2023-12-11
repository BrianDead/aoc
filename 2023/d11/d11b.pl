#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @map;
my @galaxy;
my $answer=0;
my @ri;
my @ci;


# For part 1
#my $insert=1;
# For part 2
my $insert=999999;

sub getpath {
	my ($f, $t)=@_;
	abs($ri[$galaxy[$f][0]]-$ri[$galaxy[$t][0]])+abs($ci[$galaxy[$f][1]]-$ci[$galaxy[$t][1]])
}

my $rr=0;

while(<>){
	chomp;
	push (@map, [split //]);
	push (@ri,$rr);
	if(index($_, '#')<0) {
		$rr+=$insert;
	}
	$rr++;
}

my $h=scalar @map;
my $w=scalar @{$map[0]};

my $x=0;
my $rc=0;

foreach my $x(0..$w-1) {
	my $gc=0;
	push(@ci,$rc);
	foreach my $y(0..$h-1) {
		$gc++ if($map[$y][$x] eq '#');
	}
	if($gc eq 0) {
		$rc+=$insert;
	}
	$rc++;
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