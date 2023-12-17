#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(reduce);

my @map=map { chomp; [split //] } <>;
my %lit;
my %memo;

my $w=scalar @{$map[0]};
my $h=scalar @map;

sub movefrom {
	my ($y, $x, $dy, $dx)=@_;
	my $ny=$y+$dy;
	my $nx=$x+$dx;
#	print("Moving from $y,$x direction $dy,$dx to $ny,$nx\n");

	if(exists $memo{"$y,$x,$dy,$dx"}) {
#		print("Loop\n\n");
		return;
	}
	$memo{"$y,$x,$dy,$dx"}=1;

	if($ny<0 || $ny>=$h ||$nx<0 ||$nx>=$w) {
#		print("End of beam\n\n");
		return;
	}
#	printf("Map square: %s\n", $map[$ny][$nx]);

	$lit{"$ny,$nx"}=1;
	if($map[$ny][$nx] eq "\\") {
		movefrom($ny,$nx,$dx,$dy);
	} elsif ($map[$ny][$nx] eq "/") {
		movefrom($ny,$nx,0-$dx,0-$dy);
	} elsif ($map[$ny][$nx] eq "|") {
		if($dx) {
			movefrom($ny, $nx, -1,0);
			movefrom($ny, $nx, 1,0);
		} else {
			movefrom($ny, $nx, $dy, $dx);
		}
	} elsif ($map[$ny][$nx] eq "-") {
		if($dy) {
			movefrom($ny, $nx, 0, 1);
			movefrom($ny, $nx, 0, -1);
		} else {
			movefrom($ny, $nx, $dy, $dx);
		}
	} else {
			movefrom($ny, $nx, $dy, $dx);
	}

}

sub beam {
	my ($y, $x, $dy, $dx)=@_;
	undef %lit;
	undef %memo;
	print("Starting from $y,$x direction $dy,$dx\n");

	movefrom($y,$x,$dy,$dx);

	my $answer;
	foreach my $y(0..$h-1) {
		foreach my $x(0..$w-1) {
			
			if($lit{"$y,$x"}) {
				$answer+=1;
			}
		}
	}

	printf("Answer is %d\n", $answer);
	return $answer;	
}

my @config;

foreach my $x(0..$w-1) {
	push(@config, beam(-1,$x,1,0));
	push(@config, beam($h,$x,-1,0));
}

foreach my $y(0..$h-1) {
	push(@config, beam($y,-1,0,1));
	push(@config, beam($y,$w,0,-1));
}

printf("Answer is %d", reduce { $a>$b?$a:$b} @config);