#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
my %direction=(
	'n'=>[-1,0],
	'w'=>[0,-1],
	's'=>[1,0],
	'e'=>[0,1]
	);

my @m=map { chomp ; [ split // ] } <STDIN>;

my $sx; my $sy;
my $ex; my $ey;



for my $y (0..(scalar @m)-1) {
	for my $x (0..(scalar @{$m[0]})-1) {
		if ($m[$y][$x] eq 'S') {
			$sx=$x; $sy=$y;
		} elsif ($m[$y][$x] eq 'E') {
			$ex=$x; $ey=$y;
		}
	}
}

my @candidates=();
my %visited=();

push(@candidates, [0, $sy, $sx, 'e']);

sub getcost {
	my $facing=shift;
	my $newdir=shift;

	return 1 if($facing eq $newdir);

	if($facing eq 'n' || $facing eq 's') {
		if($newdir eq 'e' || $newdir eq 'w') {
			return 1001;
		} else {
			return 2001;
		}
	} else {
		if($newdir eq 'n' || $newdir eq 's') {
			return 1001;
		} else {
			return 2001;
		}

	}

}

my $answer;
my $ed;

while(@candidates) {
	my $cm=shift(@candidates);
	my $cc=$cm->[0];
	my $cy=$cm->[1];
	my $cx=$cm->[2];
	my $cd=$cm->[3];


	if($cy==$ey && $cx==$ex) {
		printf("Answer is: %d\n", $cm->[0]);
		$answer=$cm->[0];
		$ed=$cd;
		last;
	}

	foreach my $d(keys %direction) {
		my $ny=$cy+$direction{$d}->[0];
		my $nx=$cx+$direction{$d}->[1];

		next if( ($m[$ny][$nx] eq '#') || ($visited{"$ny,$nx,$d"}) );

		my $nc=$cm->[0]+getcost($cd, $d);
		push(@candidates, [$nc, $ny, $nx, $d]);
	}

	if(!defined $visited{"$cy,$cx,$cd"}) {
		$visited{"$cy,$cx,$cd"}=$cc;
	} elsif($visited{"$cy,$cx,$cd"}>$cc) {
		$visited{"$cy,$cx,$cd"}=$cc;
	}
	@candidates=sort {$a->[0]<=>$b->[0]} @candidates;
}

my $done=0;

my $by=$ey;
my $bx=$ex;

my @ps=([$answer, $ey, $ex, $ed]);

my $pathsquares=0;
my %onpath=();

while(@ps) {
	my $cm=shift(@ps);
	my $cc=$cm->[0];
	my $cy=$cm->[1];
	my $cx=$cm->[2];
	my $cd=$cm->[3];

	print("At $cy,$cx facing $cd - cost $cc\n");

	foreach my $d(keys %direction) {
		my $ny=$cy-$direction{$d}->[0];
		my $nx=$cx-$direction{$d}->[1];
		print("Considering $d - $ny, $nx ");

		if( ($m[$ny][$nx] eq '#' || $m[$ny][$nx] eq 'O') ) {
			printf("skip %s\n", $m[$ny][$nx]);
			next;
		}

		foreach my $di(keys %direction) {
			print("inbound $di:");
			if( !defined($visited{"$ny,$nx,$di"})) {
				print("Not visited -");
				next;
			};
			printf("visited - cost %d", $visited{"$ny,$nx,$di"});
			if($visited{"$ny,$nx,$di"} == ($cc-getcost($d, $di))) {
				print("match - ");
				push(@ps, [$cc-getcost($d, $di), $ny, $nx, $d]);
			}
		}
		print("\n");
	}
	$onpath{"$cy, $cx"}++;
	$m[$cy][$cx]='O';
}

for my $py (0..(scalar @m)-1) {
	for my $px (0..(scalar @{$m[0]})-1) {
		print($m[$py][$px]);
	}
	print("\n");
}

printf("Answer 2: %d\n", scalar keys %onpath);

