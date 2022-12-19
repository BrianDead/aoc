#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max);

my %v;
my %vs=();


map { chomp; my ($e, $f, $g) = $_ =~ q/Valve (\w*) has flow rate=(\d*); tunnels? leads? to valves? ([A-Z, ]*)/; $v{$e}{"rate"} =$f; 
		$v{$e}{"cons"}= [split / ?, ?/,$g]; 
		$v{$e}{"on"}="";
		$vs{$e}=$f;
	} <STDIN>;

print Dumper \%v;
print Dumper \%vs;

my $answer=checkpath("AA", 0,"", 0, %vs);

printf("Answer is %d\n", $answer);

my %memo={};

sub checkpath {
	my $node=shift;
	my $ts=shift;
	my $path=shift;
	my %vs=@_;

	return 0 if($ts>30);

	my $key=$node.$ts;
	foreach my $v (sort keys %vs) {
		$key=$key.$v if($vs{$v}>0);
	}
	printf("memo{%s} is %s\n", $key, $memo{$key});
	return $memo{$key} if(defined($memo{$key}));

	printf("Checking %s at time %d (%d) from %s \n", $node, $ts, $vs{$node}, $path);

	my $bestpath=0;

	if($vs{$node}) {
		$vs{$node}=0;
		$bestpath=$v{$node}{"rate"}*(30-($ts+1))+checkpath($nn, $ts+1,$path."-".$node."!", %vs);
		$vs{$node}=$v{$node}{"rate"};
	}

	# Now check paths without turning on this valve
	foreach my $nn (@{$v{$node}{"cons"}}) {
		$bestpath=max(checkpath($nn,$ts+1,$path."-".$node, %vs),$bestpath);
	}

	printf("Done checking %s at time %d (%d) from %s - bestpath=%d\n", $node, $ts, $vs{$node}, $path, $bestpath);
	printf("Memoize %s as %d\n", $key, $bestpath);
	$memo{$key}=$bestpath;

	return $bestpath;
}
