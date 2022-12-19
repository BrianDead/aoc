#!/usr/bin/perl

# Note to future self: Don't do this again. Dijkstra doesn't work this way.

use strict;
use Data::Dumper;
use List::Util qw(min max);

my %v;
my %inplay;
my %intree;

map { chomp; my ($e, $f, $g) = $_ =~ q/Valve (\w*) has flow rate=(\d*); tunnels? leads? to valves? ([A-Z, ]*)/; $v{$e}{"rate"} =$f; 
	foreach my $o ($e, $e."!") {
		$v{$o}{"cons"}= [split / ?, ?/,$g]; 
		$v{$o}{"nd"}=0; 
		$v{$o}{"cl"}=0;
		$v{$o}{"mv"}=-1;
		$v{$o}{"on"}="";
	}
	push @{$v{$e}{"cons"}}, $e."!";
} <STDIN>;

print Dumper \%v;

$inplay{"AA"}=1;
$v{"AA"}{"mv"}=30;
my $tr=30;

foreach my $i (1..30) {
	printf("Turn %d\n", $i);	
	my $nn=maxpath();

	$intree{$nn}=1;
	delete $inplay{$nn} if(length($inplay{$nn})>2);

	printf("Distance to %s is %d\n", $nn, $v{$nn}{"nd"});
	if(length($nn)==2 && !$intree{$nn."!"}) {
		my $newd=$v{$nn}{"nd"}+$v{$nn}{"rate"}*($v{$nn}{"mv"}-1);
		printf("Check %s!, rate %d, minutes %d, newd is %d\n", $nn, $v{$nn}{"rate"}, $v{$nn}{"mv"}, $newd);
		if($newd>$v{$nn."!"}{"nd"} || ($newd=$v{$nn."!"}{"nd"} && $v{$nn."!"}{"mv"}<($v{$nn}{"mv"}-1) ) ) {
			$v{$nn."!"}{"nd"}=$newd;
			$v{$nn."!"}{"mv"}=$v{$nn}{"mv"}-1;
			$inplay{$nn."!"}=1 if(!$intree{$nn."!"});
			printf("%s! is now in play\n", $nn);
		}
	}

	foreach my $nh (@{$v{$nn}{"cons"}}) {
		next if(length($nh)>2);
		printf("Check %s to %s - Dist %d vs %d, min %d vs %d\n", $nn, $nh, $v{$nn}{"nd"}, $v{$nh}{"nd"}, $v{$nn}{"mv"}, $v{$nh}{"mv"});
		if($v{$nn}{"nd"}>$v{$nh}{"nd"} || ($v{$nn}{"nd"}==$v{$nh}{"nd"} && $v{$nh}{"mv"}<($v{$nn}{"mv"}-1))) {
			$v{$nh}{"nd"}=$v{$nn}{"nd"};
			$v{$nh}{"mv"}=$v{$nn}{"mv"}-1;
			$inplay{$nh}=1 if(!$intree{$nh});
			printf("%s is now in play\n", $nh);
		}
	}
}

#print Dumper \%v;

sub maxpath {
	my $minnode;
	my $dmin=-1; my $mvmin=-1;

	foreach(keys %inplay) {
		printf("Check %s with nd of %d\n", $_, $v{$_}{"nd"});
#		if(!$intree{$_} && $v{$_}{"nd"}>$dmax) {
		if((length($_)==2 || !$intree{$_}) && ($v{$_}{"nd"}<$dmin)) {
			$dmin=$v{$_}{"nd"}; $mvmin=$v{$_}{"mv"};
			$minnode=$_;
		}
	}
	print("Next node is ".$maxnode."\n");
	return $maxnode;
}

