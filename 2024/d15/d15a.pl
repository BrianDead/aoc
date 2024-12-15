#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use 5.010;

my @m=();
my @ml={};
my $stage=0;
my %dir=(
	'^'=>[-1,0],
	'>'=>[0,1],
	'v'=>[1,0],
	'<'=>[0,-1]
	);
while(<STDIN>) {
	chomp;
	if($_ eq '') {
		$stage=1;
		next;
	}

	if($stage==0) {
		push(@m, [split //]);
	} else {
		push(@ml, split //);
	}
}

my $h=scalar @m;
my $w=scalar @{$m[0]};

my $rx=-1;
my $ry=-1;

for my $y(0..$h-1) {
	for my $x(0..$w-1) {
		if($m[$y][$x] eq '@') {
			$rx=$x; $ry=$y;
			$m[$y][$x]='.';
			last;
		}
	}
	last if($rx>=0);
}

foreach(@ml) {
	my $dx=$dir{$_}->[1];
	my $dy=$dir{$_}->[0];
	my $nx=$rx+$dx;
	my $ny=$ry+$dy;

	given($m[$ny][$nx]) {
		when('#') {
			# Up against the wall - no move
			next;
		}
		when('O') {
			my $ty=$ny+$dy;
			my $tx=$nx+$dx;

			while($m[$ty][$tx] eq 'O') {cp 
				$ty+=$dy;
				$tx+=$dx;
			}
			if($m[$ty][$tx] eq '.') {
				$m[$ty][$tx]='O';
				$m[$ny][$nx]='.';
				$rx=$nx; $ry=$ny;				
			} # else it must be a wall - no move
		}
		default {
			$rx=$nx; $ry=$ny;
		}
	}
}

my $answer=0;

for my $y(0..$h-1) {
	for my $x(0..$w-1) {
		print $m[$y][$x];
		if($m[$y][$x] eq 'O') {
			$answer+=$y*100+$x;
		}
	}
	print("\n");
}

print("Answer: $answer\n");