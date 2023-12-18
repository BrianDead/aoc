#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);

my @m = map { chomp; [split //]} <>;
my %memo;

my $w=scalar @{$m[0]};
my $h=scalar @m;
my $n=($w-1)*($h-1);

my $sofar=999999999999;

sub movefrom {
	my $y=shift;
	my $x=shift;
	my $dy=shift;
	my $dx=shift;
	my $steps=shift;
	my $score=shift;
	my $hash=shift;
	my %v=%{$hash};

	my $mem="$y, $x, $dy, $dx, $steps";
	print("$y, $x, $dy, $dx, $steps\n");
	my @paths;

	if($y<0 || $y>=$h || $x<0 ||$x>=$w) {
		return 999999999999;
	}
	$score+=$m[$y][$x];
	if($score>$sofar) {
		print("Bust!!!!! Score: $score\n");
		foreach(sort {$v{$a}<=>$v{$b}} keys %v) {
			print("--> $_ => $v{$_}\n");
		}
		return 999999999999;
	}
	if($y==($h-1) && $x==($w-1)) {
		print("End!!!!! Score: $score\n");
		foreach(sort {$v{$a}<=>$v{$b}} keys %v) {
			print("--> $_ => $v{$_}\n");
		}
		$sofar=$score<$sofar?$score:$sofar;
		return $m[$y][$x];
	}

	if(exists $v{"$y, $x, $dy, $dx, $steps"}) {
		print "Loop\n";
		return 999999999999;
		# been here before so can't be shortest path
	}
	$v{"$y, $x, $dy, $dx, $steps"}=$score;

	if(exists $memo{"$y, $x, $dy, $dx, $steps"}) {
		printf("Memo %d\n",$memo{"$y, $x, $dy, $dx, $steps"});
		return $memo{"$y, $x, $dy, $dx, $steps"};
	}


	if($steps<3) {
		push(@paths, movefrom($y+$dy, $x+$dx, $dy, $dx, $steps+1, $score, \%v));
	}
	if($dx) {
		push(@paths, movefrom($y+$dx, $x,$dx, 0,1, $score, \%v));
		push(@paths, movefrom($y-$dx, $x,0-$dx, 0,1, $score, \%v));
	}
	if($dy) {
		push(@paths, movefrom($y, $x+$dy,0, $dy,1,$score,\%v));
		push(@paths, movefrom($y, $x-$dy,0, 0-$dy,1,$score,\%v));
	}
	my $shortest=(reduce {$a<$b?$a:$b} @paths);
	print("Shortest ($y, $x) $shortest");
	print(", Add $m[$y][$x]\n");
	$memo{"$y, $x, $dy, $dx, $steps"}=$shortest+$m[$y][$x] unless $shortest>99999999;
	return $shortest+$m[$y][$x];
}

my %v;

my $p2=movefrom(0,1,0,1,1,0,\%v);
printf("*** p2=$p2\n");
my $p1=movefrom(1,0,1,0,1,0,\%v);
printf("*** p1=$p1\n");

printf("Answer is $p1, $p2 => %d\n",$p1>$p2?$p2:$p1);