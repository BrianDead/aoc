#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my $ra=0;
my $rb=0;
my $rc=0;
my $ip=0;

my @prog=();

sub comboval {
	my $op=shift;
	if($op<=3) {
		return $op;
	} elsif($op==4) {
		return $ra;
	} elsif($op==5) {
		return $rb;
	} elsif($op==6) {
		return $rc;
	}
	print("Invalid combo - $op\n");
	die;
}

while(<STDIN>) {
	chomp;
	my $v;
	if(($v)= $_ =~ /Register A: ([0-9]+)/) {
		$ra=$v;
	} elsif(($v)= $_ =~ /Register B: ([0-9]+)/) {
		$rb=$v;
	} elsif(($v)= $_ =~ /Register C: ([0-9]+)/) {
		$rc=$v;
	} elsif(($v)= $_ =~ /Program: ([0-9\,]+)/) {
		@prog=split(/\,/, $v);
	}

}

print("A=$ra B=$rb C=$rc\n");
printf("%s\n",join ';', @prog);
my @out=();

while($ip < (@prog-1)) {
	if($prog[$ip]==0) {
		#adv
		$ra=int($ra/(2**comboval($prog[$ip+1])));
	} elsif($prog[$ip]==1) {
		#bxl
		$rb=$rb^$prog[$ip+1];
	} elsif($prog[$ip]==2) {
		#bst
		$rb=comboval($prog[$ip+1]) % 8;
	} elsif($prog[$ip]==3) {
		#jnz
		if($ra!=0) {
			$ip=$prog[$ip+1];
			next;
		}
	} elsif($prog[$ip]==4) {
		#bxc
		$rb=$rb^$rc;
	} elsif($prog[$ip]==5) {
		#out
		push(@out, comboval($prog[$ip+1]) % 8);
	} elsif($prog[$ip]==6) {
		#bdv
		$rb=int($ra/(2**comboval($prog[$ip+1])));
	} elsif($prog[$ip]==7) {
		#cdv
		$rc=int($ra/(2**comboval($prog[$ip+1])));
	} else {
		die("Bad instruction at ip=$ip\n");
	}
	$ip+=2;
}

printf("Answer: %s\n", join(',', @out));