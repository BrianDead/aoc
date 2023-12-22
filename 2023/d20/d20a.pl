#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);


my %nodes;
my @pulses;
my @stack;

sub makepulse {
	push(@stack, \@_);
}

sub pulse {
	my $node=shift;
	my $pulse=shift;
	my $from=shift;

	print("Node $node, Pulse $pulse, From $from\n");
	$pulses[$pulse]++;

	if($node eq "output") {
		return;
	}

	if($node eq "broadcaster") {
		foreach(@{$nodes{$node}->{links}}) {
			makepulse($_, $pulse, $node);
		}
	}

	if(exists $nodes{$node}->{type}) {
		if($nodes{$node}->{type} eq '%') {
			printf("Node %s is at state %d\n", $node, $nodes{$node}->{state});
			if($pulse==0) {
				if($nodes{$node}->{state}==0) {
					$nodes{$node}->{state}=1;
				} else {
					$nodes{$node}->{state}=0;
				}
				foreach(@{$nodes{$node}->{links}}) {
					makepulse($_, $nodes{$node}->{state}, $node);
				}
			}
		} elsif($nodes{$node}->{type} eq '&') {
			$nodes{$node}->{"in-$from"}=$pulse;
			my $h=0;
			foreach(keys %{$nodes{$node}}) {
				print"key $_\n";
				if(my $n= $_ =~q/^in-([a-z*])/) {
					printf("remembering %d\n",$nodes{$node}->{$_});
					if($nodes{$node}->{$_} == 0) {
						$h=1;
					}
				}
			}
			foreach(@{$nodes{$node}->{links}}) {
				makepulse($_, $h, $node);
			}
		}
	}
}

while(<>) {
	chomp;
	my ($type,$name,$links) = $_ =~ q/([%&]?)([a-z]+) -> ([a-z, ]+)/;
	my %node=(type => $type, links => [split /[, ]+/, $links] );
	if($type eq '%') {$node{state}=0;}
	$nodes{$name}=\%node;
}

foreach(keys %nodes) {
	my $o=$_;
	foreach(@{$nodes{$o}->{links}}) {
		$nodes{$_}->{"in-$o"}=0;
	}
}
print Dumper \%nodes;


foreach (1..1000) {
	makepulse("broadcaster",0, "button");
	do {
		pulse(@{shift(@stack)});
	} until (@stack == 0);
}

printf("Low: %d, High: %d. Answer is %d\n", $pulses[0], $pulses[1], $pulses[0]*$pulses[1]);
