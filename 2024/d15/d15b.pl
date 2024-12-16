#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use 5.010;

my @m=();
my @ml=();
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
		push(@m, [map { ($_ eq 'O' ? '[' : $_, $_ eq '@' ? '.' : ($_ eq 'O' ? ']' :$_ ) ) } split //]);
	} else {
		push(@ml, split //);
	}
}

my $h=scalar @m;
my $w=scalar @{$m[0]};

sub trymove {
	my $fy=shift;
	my $fx=shift;
	my $dy=shift;

#	print("Trymove $fy, $fx, $dy\n");

	my $stuck=0;

	my @tm=([$fy,$fx]);
	my @moves=();
	my %moveout=();

	while(scalar @tm && !$stuck) {
		my $this=shift @tm;
		my $thisy=$this->[0];
		my $thisx=$this->[1];
		my $nexty=$thisy+$dy;
		my $nextx=$thisx;
		
		if($m[$nexty][$nextx] eq '[') {
			$moveout{$thisy*$w+$thisx}++;
			push(@moves, [$nexty, $nextx, $m[$this->[0]][$this->[1]] ]);
			push(@moves, [$nexty, $nextx+1, '.' ]) if(($m[$thisy][$thisx] eq '@' || $m[$thisy][$thisx] eq ']') && !defined $moveout{($nexty-$dy)*$w+$nextx+1} );
			push(@tm, [$nexty, $nextx] );
			push(@tm, [$nexty, $nextx+1 ]);
		} elsif($m[$nexty][$nextx] eq ']') {
			$moveout{$thisy*$w+$thisx}++;
			push(@moves, [$nexty, $nextx, $m[$this->[0]][$this->[1]] ]);
			push(@moves, [$nexty, $nextx-1, '.' ]) if(($m[$thisy][$thisx] eq '@' || $m[$thisy][$thisx] eq '[') && !defined $moveout{($nexty-$dy)*$w+$nextx-1} );
			push(@tm, [$nexty, $nextx]);
			push(@tm, [$nexty, $nextx-1]);
		} elsif($m[$nexty][$nextx] eq '.') {
			$moveout{$thisy*$w+$thisx}++;
			push(@moves, [$nexty, $nextx, $m[$this->[0]][$this->[1]] ]);
		} elsif($m[$nexty][$nextx] eq '#') {
			$stuck=1;
			last;
		}			

	}

	if(!$stuck) {
		return @moves;
	} else {
		return ();
	}
}

my $rx=-1;
my $ry=-1;

for my $y(0..$h-1) {
	for my $x(0..$w-1) {
#		print($m[$y][$x]);
		if($m[$y][$x] eq '@') {
			$rx=$x; $ry=$y;
			$m[$y][$x]='.';
#			last;
		}
	}
#	print("\n");
#	last if($rx>=0);
}

my $count=0;

foreach(@ml) {
	my $dx=$dir{$_}->[1];
	my $dy=$dir{$_}->[0];
	my $nx=$rx+$dx;
	my $ny=$ry+$dy;

#	printf("Move $_ ($dy,$dx) from $ry,$rx to $ny,$nx %s\n", $m[$ny][$nx]);

	if($m[$ny][$nx] eq '#') {
		# Up against the wall - no move
		next;
	} elsif($m[$ny][$nx] eq '[' || $m[$ny][$nx] eq ']') {
		my $ty=$ny;
		my $tx=$nx;

		if($dy) {
			my @moves=trymove($ry, $rx, $dy);
#			print Dumper \@moves;
			if(@moves) {
				foreach(@moves) {
					$m[$_->[0]][$_->[1]]=$_->[2];
				}
				$m[$ny][$nx]='@';
#					$m[$ny][$nx+($m[$ny][$nx] eq '[' ? 1 : -1)]='.';
				$m[$ry][$rx]='.';
				$rx=$nx; $ry=$ny;
			}
		} else {
			while($m[$ty][$tx] eq '[' || $m[$ty][$tx] eq ']') { 
				$tx+=$dx;
			}
			if($m[$ty][$tx] eq '.') {
				for(my $mx=$tx; $mx!=$nx; $mx-=$dx) {
					$m[$ny][$mx]=$m[$ny][$mx-$dx];
				}
				$m[$ny][$nx]='@';
				$m[$ry][$rx]='.';
				$rx=$nx; $ry=$ny;				
			} # else it must be a wall - no move
		}
	} else {
		$m[$ny][$nx]='@';
		$m[$ry][$rx]='.';
		$rx=$nx; $ry=$ny;
	}

#	for my $y(0..$h-1) {
#		for my $x(0..$w-1) {
#			print $m[$y][$x];
#		}
#		print("\n");
#	}

#	last if(($count++) >=4000);
}

my $answer=0;

for my $y(0..$h-1) {
	for my $x(0..$w-1) {
		print $m[$y][$x];
		if($m[$y][$x] eq '[') {
			$answer+=$y*100+$x;
		}
	}
	print("\n");
}

print("Answer: $answer\n");