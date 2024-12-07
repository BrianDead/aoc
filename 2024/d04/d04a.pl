#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @m=map{ chomp; [split //] } <>;

my $h=scalar @m;
my $w=scalar (@{$m[0]});
my $answer=0;
my @direction=(
	[-1,0],
	[-1,-1],
	[0,-1],
	[1,-1],
	[1,0],
	[1,1],
	[0,1],
	[-1,1]);

sub isok {
	my $ub=shift(@_);
	my $np=shift(@_) + shift(@_);
	return ($np<$ub && $np>=0);
}

for(my $i=0; $i<$h; $i++) {
	for(my $j=0; $j<$w; $j++) {
		if($m[$i][$j] eq "X") {
			foreach(@direction) {
				if(isok($h,$i,$_->[0]*3) && isok($w,$j, $_->[1]*3) ) {
					if($m[$i+$_->[0]][$j+$_->[1]] eq "M" && 
						$m[$i+$_->[0]*2][$j+$_->[1]*2] eq "A" &&
						$m[$i+$_->[0]*3][$j+$_->[1]*3] eq "S") {
						$answer++;
					}
				} 
			}
		}
	}
}

print "Answer 1: $answer\n";

my $answer2=0;

for(my $i=0; $i<$h; $i++) {
	for(my $j=0; $j<$w; $j++) {
		if($m[$i][$j] eq "A") {
#			print("A at $i,$j: ");
			if($i>0 && $j>0 && $i<($h-1) && $j<($w-1)) {
#				print("enough room ");
				if ( ( ($m[$i-1][$j-1] eq "M" && $m[$i+1][$j+1] eq "S") ||
					   ($m[$i-1][$j-1] eq "S" && $m[$i+1][$j+1] eq "M") ) &&
					( ($m[$i-1][$j+1] eq "M" && $m[$i+1][$j-1] eq "S") ||
					  ($m[$i-1][$j+1] eq "S" && $m[$i+1][$j-1] eq "M") )
					) {
#					print("match ");
					$answer2++;
				}
			}
#			print("\n");
		}
	}
}

print "Answer 2: $answer2\n"

