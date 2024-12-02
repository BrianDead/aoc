#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);


my %nodes;
my @pulses;
my @stack;
my $done=0;
my $pushes=0;
my %last;

sub makepulse {
	my @pulse=@_;
	push(@stack, \@pulse);
}

sub pulse {
	my $node=shift;
	my $pulse=shift;
	my $from=shift;

#	if($node =~ q/(xn)|(fz)|(xf)|(hn)|(mp)/ ){
	if($node eq 'xn' || $node eq 'mp' || $node eq 'jl') {
		print("$node received pulse $pulse from $from, push $pushes\n");
		if($pulse==1) {
			if(exists $last{$from}) {
				printf("Last was %d, cycle %d\n", $last{$from}, $pushes-$last{$from});
			}
			$last{$from}=$pushes;
			foreach(keys %{$nodes{$node}}) {
				if(my $n= $_ =~q/^in-([a-z*])/) {
					printf("$_ -> %d\n", $nodes{$node}->{$_} )
				}
			}
		}
	}

	$pulses[$pulse]++;

	if($node eq "rx") {
		if($pulse==0) {
			$done=1;
		}
		return;
	}

	if($node eq "broadcaster") {
		foreach(@{$nodes{$node}->{links}}) {
			makepulse($_, $pulse, $node);
		}
	}


	if(exists $nodes{$node}->{type}) {
		if($nodes{$node}->{type} eq '%') {
			if($pulse==0) {
				if($nodes{$node}->{state}==0) {
					$nodes{$node}->{state}=1;
				} else {
					$nodes{$node}->{state}=0;
				}
				foreach my $i (0..(scalar @{$nodes{$node}->{links}}-1)) {
					makepulse($nodes{$node}->{links}->[$i], $nodes{$node}->{state}, $node);
				}


				# foreach(@{$nodes{$node}->{links}}) {
				# 	makepulse($_, $nodes{$node}->{state}, $node);
				# }
			}
		} elsif($nodes{$node}->{type} eq '&') {
			$nodes{$node}->{"in-$from"}=$pulse;
			my $h=0;
			foreach(keys %{$nodes{$node}}) {
				if(my $n= $_ =~q/^in-([a-z*])/) {
					if($nodes{$node}->{$_} == 0) {
						$h=1;
					}
				}
			}
			foreach my $i (0..(scalar @{$nodes{$node}->{links}}-1)) {
				makepulse($nodes{$node}->{links}->[$i], $h, $node);
			}
			# foreach(@{$nodes{$node}->{links}}) {
			# 	makepulse($_, $h, $node);
			# }
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


do {
	$pushes++;
	makepulse("broadcaster",0, "button");
	do {
		pulse(@{shift(@stack)});
	} until (@stack == 0);
	print("$pushes pushes\n") if($pushes % 1000000 == 0);
} while (!$done && $pushes<30000);

printf("Low: %d, High: %d. Answer is %d\n", $pulses[0], $pulses[1], $pushes);
