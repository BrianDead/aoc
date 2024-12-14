#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);
use Time::HiRes qw(sleep);

my $w=101;
my $h=103;

my @r=map {[ $_ =~ m/p=([0-9]+),([0-9]+) v=([-]?[0-9]+),([-]?[0-9]+)/ ] } <STDIN>;


my $sec=100;

my @res=map { [ ($_->[0]+$_->[2] * $sec) % $w, ($_->[1]+$_->[3] * $sec) % $h ]} @r;

print Dumper \@res;


my @q=(0,0,0,0);


foreach(@res) {
	if($_->[0]<($w-1)/2) {
		if($_->[1]<($h-1)/2) {
			$q[0]++;
		} elsif($_->[1]>($h-1)/2) {
			$q[1]++;
		}
	} elsif($_->[0]>($w-1)/2) {
		if($_->[1]<($h-1)/2) {
			$q[2]++;
		} elsif($_->[1]>($h-1)/2) {
			$q[3]++;
		}
	}
}

print Dumper \@q;

printf("Answer: %d\n", reduce {$a*$b} @q);

# part 2

my $s=98;
while(1) {
	print("Turn $s\n");
	my @res=map { [ ($_->[0]+$_->[2] * $s) % $w, ($_->[1]+$_->[3] * $s) % $h ]} @r;
	my @m=map { [ map {0} (0..$w-1) ] } (0..$h-1);

	foreach(@res) {
		if($_->[0]>=$w || $_->[1]>=$h) {
			print Dumper $_;
			die;
		}
		$m[$_->[1]][$_->[0]]++;
	}
	foreach(@m) {
		foreach(@{$_}) {
			die if(!defined $_);
			print($_ > 0 ? '#' : '.');
		}
		print("\n");
	}
	print("\n");
	sleep(0.3);
	$s+=101;
}