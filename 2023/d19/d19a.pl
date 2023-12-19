#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);

my %flows;
my $rf=1;
my $answer=0;

sub runflow {
	my %val;
	my $flow;
	my $ret="";
	($flow, $val{'x'}, $val{'m'} , $val{'a'} ,$val{'s'})=@_;

	foreach my $step(@{$flows{$flow}}) {
		if(scalar @{$step}>1) {
			my ($pr, $co, $v)= $step->[0] =~ /(\w)([<=>])([\w]+)/;
			if($co eq '=') {
				if($val{$pr}==$v) {
					$ret=$step->[1];
				}
			} elsif($co eq '>') {
				if($val{$pr}>$v) {
					$ret=$step->[1];
				}
			} elsif($co eq '<') {
				if($val{$pr}<$v) {
					$ret=$step->[1];
				}
			}
		} else {
			$ret=$step->[0];
		}
		last if($ret ne '');
	}
	return $ret;
}


while (<>) {
	chomp;
	if($_ eq '') {
		$rf=0;
		next;
	}
	if($rf) {
		my ($label, $flow)= $_ =~ /^(\w+){(.*)}$/;
		print("$label ---- $flow\n");
		$flows{$label}=[ map{ [split /:/, $_] } split /,/, $flow ];
	} else {
		my ($x, $m, $a, $s)= $_=~ /x=(\d+),m=(\d+),a=(\d+),s=(\d+)/;

		my $flow='in';
		my $result='';
		do {
			$flow=runflow($flow, $x, $m, $a, $s);
		} until ($flow eq 'A' || $flow eq 'R');
		print("Part $_ Status $flow\n");
		$answer+=($x+$m+$a+$s) if($flow eq 'A');
	}

}

print "Answer is $answer\n";