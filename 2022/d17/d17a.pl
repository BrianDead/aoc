#!/usr/bin/perl

#perl d17a.pl > /dev/null  0.05s user 0.01s system 52% cpu 0.124 total

use strict;
use warnings;
use List::Util qw(max);
use Data::Dumper;

my @rocks=(
	[0,1,2,3],
	[1,7,8,9,15],
	[0,1,2,9,16],
	[0,7,14,21],
	[0,1,7,8]
	);

#my $inp=">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>";
my $inp=">>><<<>>>><<<<>><<<<>><>>><>>>><><<<<>>>><<>>><<<>><>>><<>><>>><<>>><<>><>>><>>><<<<><<<>><<<>>><<>>>><>>>><<<<>>>><<<>>>><<<>>>><<<>>>><<<<><<<<><<<>>>><<<>>><<<><<<>>>><<>><<<>><<<><<<><<>><<>>>><<>>><<><<>><<><<>>><<>>>><<<><>>><<<<>>><<<<><><<<><<>>><<>><>>>><<<<><<>>><<<>>><<<<>>>><<<<>><<<>>><<<<>>><<<>>>><<<>>>><<<>>>><<<<>>><<<>>>><<<><><<<><<<><>>>><>><>>><<><<<>>><><<<>><<<<>><<>><>><>>>><<<<>>><<>>>><<><<>><<<<>><><<>>>><<<>>>><<<>><<<<>>><<<<>>>><>>>><<>><<<><<<>><<<<>>><<<<>><<>><><<<<>>><<><<<>>>><<>>>><<<<>>>><<<>>>><<<>>><<>>>><>>>><<>>><<<>>>><>>>><<<<>>>><>>>><<<><<<>>>><>><>>><>>>><<<><>><<<<><<><>>>><<><<<<><<<>>><><>>>><<><>>>><<<>>><<<<>>><>>>><<<>>><<<<>>>><<>><<<>>><<>>>><<><<<<><><<<<>>><<<<>>><<<<>>><<>>><<<>><<>>><<<<>>>><<<<>>>><<<>>><>>>><<<<>>><>><<>>><<><<<<>><<>>><<<><><<<<>>>><<<>><><<>>><<>><<><>>><<<>>>><<<<>>><<<><<>><<>>><>><<>>>><<>>>><<>>>><<>>>><<>><>>>><<><>>>><<<>>>><<<>>><<><<<<><>><<<>><<<<>><<<<>><<>>>><<<>><<>><>>>><<<>>>><<<>>>><<<<>>><<<<>><<><<<>>>><<<>>>><<>>><<><><<<<>><<<<><<<><<>><<><<<<>><<<<>><<<<><<<<>>>><<<>><<<><<<<>>><>><>>><>>><<><<<<>>><<<<>>>><<<><<<>><<<>><<<>>><<>>><<<>>><>>><<><>>>><<<<>>><<<<>>>><<<>>>><>>><>><<>><<<>><><<<>>>><<<>>><><<><<><<<<><<<<>>><<<<><>>>><<<>>>><<>>><<<<>>>><<<<>>><<>>><>>>><>><<<>>><<<<>>>><>><<>>><<<><<<>>><<<<><<<<><>>>><<><>><<<<>><<<<>>>><>>>><<>>><<<<><<<><<>>>><<><<<>>><<<><<<<>><<>>><<<<>><>>>><><<<<>>><<<>>>><><<>>>><<<<>>>><<<<>><<<>>><<<<>>><<<>>><>>>><<>><>><<<<><<<>><<>>>><>><>>>><<<>>><<><<<>><<>><<<>><<>>><<<<>><><<<>>><<<<>>><<<>>><<<<>>><<<<>>><<>>><>>><<>>><<<>><>><<<>>><<<<>><>>>><<<>>><>><>><<<>>><>>><<>>><<>><<<<>>>><<>>>><<<<>><>>><<<<>>><<<<>>>><<<>>>><>><<<>>>><<<><<>>><<><>><<<>>><<<>>><<><>>><<>>>><<<><<<<><><>>><<<<>>>><<<<><<<>><<<>><<<>>><<<>>>><>>><<<>>><<<<>><<>><<<>>>><<<><<>>><<<>><<<<>>>><<<<>><<<><<<>>><<<<><>><<<><<<<>>>><<><>><<<>>><<>>>><>>>><<<><<<<>>>><<>>>><<>><<<>>>><><<<>><<>>><<><<<<>>><<>><<<>><<<<>>>><<>>><<>>><<<<>>>><<>>><<<>><<>>>><<>><<<>>><<<>>><<>>>><<<<><>><>>><<<<>>><<<><<>><<<><<<>>><>><<<><<><<<>>><<><<>>><>><<<>>>><<><>><<<>>><<<>>>><<>><><>>><<<<>>><<>><<<><<<<>>>><>>><<<<>>><><><<<<><><<>><<>><>>>><<<<>>><<<>>>><><<<<>><<<<>><<><<<<>>><>>><<<><<<>>><<<>>><<<<>>><<>><<<<><<<<>>>><<>><<<<>>><<<>><<>>><<<><<<>>>><<>><<<<>>><<<<>>>><<<>>>><<>>><>>><<<<><<<<><><<>>>><<<>><>>>><<<>>><>><>><><<>>><<<>>>><<<>><<><<><<>><<<<><<<><>>>><>>><>><>>><<<<>>><<<><>><<<<>>><<<<><><>>>><<>>>><<>>>><<>>>><<<<>>><>><<<<>>>><<<>><<><<<<>>>><>><<>><>><>>>><<>>><>>>><<<<>><<<>>><<<>>>><<<<>><<><<<<>><>>><<>>>><<<<>><<<<>><>>>><><<<<>>>><<><<<><<>><<<<>>>><<><<<<><<<<>>>><>><<>><<><<<<>><<<><<<<>>><><<>>><>>>><<<<>><>>><<<><<>>><>>>><>><<<>>>><>>><>><<<<>>><<<><<<<>>>><<<>>><<<>><<<>>>><<<>>><<<<>>><<<<><>>><<<<>>>><>><>>><>>><<>><<<>>>><<<>><<<>>><<<>>><<>>>><<<<><<<<><<<<>>>><<<>>><<<>>>><<<><<<<>>><<<<><<<<>><<<<>><>><<<<><<<<>>><<>><><<<<><><<<<>><<>>>><<>><>><<<<><<<<>>>><<>>>><<<>>><<<<>>>><<<<>>>><<<<>><<><>>>><>>>><<><<<<><<>><<>>>><<>><<<>>><>><><<<<><<><<>><<<>>><<>>><<>>>><<<><>>>><<<<>>>><<<>><<<><<<<><<><<<><<<>>>><<<<>>>><<<<><<<<><>>><><<<<>>>><<<<><<>><<<>>>><<<<>>><>><<<<>>><<<<>>>><<<<>>><>>><<>>><<<><>>><><<<<>>><>>><>><><<<>><>>>><><<<>><<><<<>>><<><<<<>>>><<<<>>>><<<<>><<<><<<><><>>><<<><>><<>>><>>>><<<<>>><<>>><<<<>>>><<<<>>><<<>><<<<><>><<<<>>><>><<<>>><<<<>><<<<>><<>>><<<<>>>><<<>>><<>>>><<>>>><<><<<<><<>>><<<<>><<>><<<><<<<>><<<>>><<<>>>><<<<>><>>>><>><<>>>><><<>><<<<><><<<>>><<<>><<<>>>><<<<>>>><<<<>>>><<<>>>><>>>><<<>>>><>><<<>><>>><<<><>>><<><>>><<<<>><<<<>><<><<<>>>><<<<>>><<<<>>>><<<<><<<<>>><<<>>><<<>><<<>>><<<<>><<<><<<>><<<><<<<>>>><<<>>><<<><<<<>>><<<>>>><><<<<>>><><<<>>>><<<<>><>>>><<><>>>><><<<><<<<>>>><<<>><<>>><<<<><<>>><><<><<>>><<<>>><<<<><<>><<><<<>>><<>>>><<<>>><<><>>><<<>><<<>>><>>>><<<<>>>><<>>>><<>><<>><<<<><<<>>>><<<<>>>><><<<><<>><<<<>>><>><>><<>>>><<<><<<>>>><>>><<><<><<<<>>>><<<>>>><<>><><<<<>>><<>>><<<<>><>><<<<><<>>><<<>>><<<<>>><>><<<>><<>>>><<<>>><><<<>><<<<>><>>><<>><<<<>>><<><<>>><>>><><<<<>>>><<<<>><<>><<<>>><<<<>>><<>>>><<><<<<>>>><>>><<>>>><>>><<<<>>>><<<<>>><<>>><<<>>><<<><<<<><>>>><<>><><<<<>>>><>>>><<<<>><>>>><>><>>>><<<<>>>><<>>>><<><<<<>>>><<<><>>><<<<><<>>><<<><<<<><>><<<>>><<>><<<<><<<>>>><<>><<>>><<<><<<<>><><<<><>>><<<<>>>><<>>><>>>><>>><<<<>>><<<><><<>>>><<<>><<<<>>>><<><<<>>><<<<>><<<<>>><>>>><<<<>><<>>><<<<>>><>>><<<<><<<>>>><<>>><<<<><<><<<>>>><<<<>><><<<<>>>><<<>>>><<<<><<>><<>>><<<>>><>><><<>>><<>><<<<><>><<<><>>><<<<>>><<>>><>><<<>>>><<<<>><><<<>><<<>><<>><<<>><<<<>>>><<<<><<<<>>>><<<<>>><<<><<<>>><>>>><<<>>><<<<>>>><>>>><>>><<<<>>>><<>>><<>>>><<>><>>><<>>>><>>>><<<<>>>><>>><<<><<<<><>>><<<<><>>>><<<>>>><>>><<>><<><<<>><<<<><<<><<<>><<<><<>>>><<<><<>>>><<><>><<>>><<>>><>><<<>><>>>><<>>>><<>>><>>><<<<>>>><<><<>>>><<<>>>><><<>>>><<<<>><>><<><>><<><>>><>>>><<<>>>><><<<>>><<<>>>><<<>>><<<>>><>><>>><>>>><<<><<<>><>>><<><<>><<<<><<>><<>><<<>>><<>>><<<<>>><<><>>><<>>>><<<><<<>>><><<<<><<><<<>><<<<>>><><<<<><<<<><>>>><<>>>><<<<>>><<<<>><<<<>><<<><<>><<>><>><<<<>>><<<<><>><<<<><<<<><<><<>><<<><<>>><<<<>>><<<>>>><<<>><>><<<>>><<<>><>>><<>>>><<>>><<<<>><<>>>><<<<><>>><<<><<<>>><<<>>><<><>>><>>>><<<>><<<<>><><<<>>>><<<<>>><<>><<<<>>><<<>><><<>>>><<>>>><<<>>>><<<><<<>>>><<<<>><<<<>>>><<>>><<<<><>>>><>>>><>><>>>><<<>>>><>>><<<<><<<><<<<>>><><<<<>><>><<>>>><<<>><<<>>>><>><<<><>>><<<><>><<<<>><<>>>><<>><>>><<<<>>><<<>><>>><<<>>><<>>><>>><<<<>>>><<>>>><>>>><<<<>><<<>><><>><<><<<>>>><<<>>><<<>>>><<<<>><<<<><<<>>>><<>><>><<<<>>><<>>>><>>>><<<<>>><><<<>>>><<<>>><<<>>>><<<><<>><<>>>><<<<>><<<>>>><<<>><<<<>>>><<>><<>>><<>>><<>>>><<>><>>><><<>>>><>><>><>><>><<<>><<<<>><>>><<<><><<<<>>>><<<>>>><<<<>><<<<><>>><<><<<<>><<<<>><<<>>>><<<<>>><>>>><<<<>>><>><>>>><<<>>><<<<>><>>>><<><<<<>>>><<<>>>><<<><<<>>>><<<>>><<<>><>>><<<>>><<<<>>>><<<>><>>>><<>>><<>>><><<<<>>><<>><<>>><<>>><<<<>>><<<>><>>><<>>>><<<>><<<>>>><<<>><<<<>><<>>>><<<<><>>><<<><<<>>>><<>><<<<><<<>>><>>><<<<>>><<<<>><<<<>><<<<>><<<>><<<>>><<<<>>>><<<>>>><><>><>><<<>>><<<<><<<<>>><<<<><<<<><><>>><<<>>>><<<<>>>><>><<<<><<<>><>>>><<<>><>>>><<<>><>>><<>>><<<<>><><<>>><<<<><<<<><<<><<<<>>><<><<><>>>><<><<<<>><>>><<<<>>><>>><<<<><<<<>>><>>>><<>>>><<<>>>><<<>>>><>>><>><<<<><<<<>><<<<>>>><<<<>><>>><<>>><<<>>><>>><<<><><><>>><<<<><<>>>><>><<>><<<<>><<<<>>><><<<<>><<>>><<<>>>><>><><><<<><>><<<<>>><>>>><>>><<>><<<<><<>>><<<>>><<><<<>>><>>>><<<<>>>><<<><>>><>>><<<>><>>><<><<>><<><<<>><><>>><<<<>>>><<<>><<<><<<>>><<>><>>>><>>>><<<>>><<<>>><<>>>><<<<><<>>>><<>>>><<<<>>>><<<<>>>><<<>>><<>>><<>><<>>><<<<>><<<><>>>><<<>>><<<>>><<>>>><>><<>>>><<<<>>><<>>><<<<>><<>>>><<<<>>><>>>><<>>><<<>>><<<>><<<<><>>>><<><<>>><>>><<<>><<><<<<>>>><<<<>><>>>><<>>><<<>><<>>>><>><<>><<<<>><<>>><>>><<<>><<>><><<<<>>><>><<><>>>><<>>>><<<<>><><>>>><>>>><>>>><<>><<<<><>>>><<<>><<<>>><<>><<<><<<<>>><>>>><<>>><<<<>><>><<<<>><>>>><<<>><<<<>>>><<<<>>><>>>><<><<<><<>>><<><<>><<<><<><>>>><<>>><>><<<<>>>><<<<><>><<<>><>><<<><><<<<>>><<>>><<<>><<<><<<>>>><<<<>>><<<><>>>><<<><<><>><<<<>>>><<<<><<>>><<<<>>><<>>><>>>><<<>>>><<><>>><<<<>><>>><<<><<<>>>><<<<>><<<<>>><>>>><<>>><>>>><>>>><<>>>><<<>><<<><<<><<>>>><<<<><<>>><<>><>><<>><<<>>><<<<>>>><<>>><<<>><<>>><><>>>><<<>>><<<<>>>><<<<>>><<<<>><<><<<>><>><<<<><<<<>>><<<<><<<<><<<>>><<<<>>><<<<>>>><<<>>>><<<<>>><<<<><<<>>>><<><<<>>>><<<<>>>><>>>><<<<>>><<><<>><<>><<>>>><<<<><>>><<><<>><<><<<>><<>>>><<<<><>><<<><<<><<<>>>><<<<><<><<<<><<>>><>>>><<>>><<<>>>><<><<<<><<<<>><<<<><<><<>><<>>>><>><<<>>><<><<<>>>><<<>>>><<>><<><>><>><<<<>><<<>><>>>><<<<><<<>>>><<><<<<>><<<<><<<<>><<<<>>>><<<>>><<<<>>><<><<<>>>><>>>><<<>>>><<<<>><<><<<<>>><<<>>><<>><<<><><<>>>><<><<<>>>><<<>>>><<<<>>>><>>>><<<>>>><<<>>><>><<<><<<>>><<><<>>>><<<><<<>>><<>><<<>><><<<<>><><<<><<>>><<<>><<<<>>>><<>><<<<>>><<<<><>><>>>><<>><<<<>>>><<>><<<<>>>><>>>><<<>><<<>>>><><>>>><<>>><<>>><<<>><>><<><>><<<<>><<<<><<><<<<>><<<>>><<<><<<>>>><<<>>>><<<>>>><<<<>>>><<>>><<<<>><<<<>><<>>><>>><<><>><<<><><>>>><<><>>><<>>><<<>><>>><<><<<<>>><<>><<<<>>><<><>><<><<<<>>><<<>>>><>><<<<><<>>><<>><<<>>>><<<>><<<<>><<<<><<<>><>>><<<<>><<<<>>>><<<<><<>>><>>><<<<>>>><<<<>>><><><<<><<<<>>><><>><>>>><>>><>>>><<<>>>><<>><<<<><<<>>>><>>><<<<>>>><<>>>><<<<><<><<>>>><<>>><>><><>>><<<<>><>><<>>><<<>><>>><<>><<<><<>>>><<<<>>><<>>>><<<<>>><<><<<>>>><<<>>><<<>>><><<<>><<<<>>><>><<<<>><<>>><<<<><<<<>><<<<>>><>>><<>>><<>><<<>><>>><<<<>>><<<<><<<>>><<<>>>><<><><<<><<>><<>>>><<<>>>><<<<><<<<>>><>>>><<><<<<>><<<<>>>><<<<>>>><>>><<<<>><<<>>>><<<<>>><<<<>>>><<<<><>>>><<><>><<><<><<>>><<<<><<>>><<>>>><<<>><<<<><<<>>>><<<><>><<<<>>><<<>>><<<><<>><<<<>><<<><<>>>><><>>><<>>>><<>><>>>><<<><<>>>><<>>><<<<>><<<>>>><<>>>><<<<>>>><<<<>>><>><<<>>><<<<><<<>>>><<<>>>><>><<<<>>><<>><<<>>>><<>>><>>><<<<>><>>><<<>>><<<<><><<<>><<<<>>>><<<<>>>><<<<>>><>><><<>>>><<<>>>><<<>><<<>>><<>><<<<>><><<><<>>>><<>>><<<><<>>>><<<<>>>><<<>><>>><><<<><<<>>><<><<<<>>>><<<<>>><<>><<>>><<<<><<>>>><<>>>><<<>>>><<><>><<<>><<<<>>><<<<>>><<>><<<<>>>><<<<>>>><<<<><<<<>>>><<>>>><<<>>><<>><>>><<>>><<>>><<<>>>><<<>>><><>>>><<>><>>>><<<>><>>><<<><<>>><<><<<>><>>><<>><>>><<>>>><<<<>><<>>>><>><<<><<<<>>><<<><>>><<<<>>>><<<>><<<<><>>><<<<>><>>><<<>>>><<>>>><<<<>>><<><<<<>>><<<>>><><<<>>>><<><<<>>>><<>><>>>><<>>>><><<<><<>>>><<>><<>>><>><><<<>>>><<>>><<<<>><>>>><<<>><<><>>><<><<<>>>><<><<>>><>>>><<>>>><<<><<>>><>>><>><>><<<>>>><<<><<<>><<<<>><<<>><<>>>><>>>><<<<>>>><<>>><<><<<>>><<<<>><<<<>>>><<>><<<<><<><>>>><<<>>>><<>>><><<<<>><>>><<<<><<<<>>>><<<<>><>><>>>><<<<>>><<>>><>>>><<>>><<<<>>><><<<>>>><<>>><<<<>><<<><>>><><<><<><<><<<><<<>>>><<<>>>><<<<><>>>><>>><>><<>>><<<><>><<<<>>>><><<<>>><<<>><<><<<>>><<><<<>><<<><<<<>>><<>>>><<>>><<<><<<>><<><><<>>>><<>><<<>>>><<>>><<<<>>><<<<>>><<<>>>><<<<>><<<>>><<>>><<>>><>>><<>>><<>>><<<<>><<<<><<>><<<<>>>><>>><<>>>><<<<>><>><>>>><><>>>><>>>><<<>><<<<>>>><<<>>><<>>><<<<><<>><<<<>>><<<>>>><>>>><<<>><<<><<<>><<<<>><<><<>>><><<<<>><>><<>>><><<<<>>><<>>><<<><<>><<>><>><<>><<>>>><<<><<<<>>>><<<>>><<>><<<<>>><<<<>><><<<<>>>><<<<><>><>>>><<<><<>>>><<>>><<>><<<<>>>><><>><<<><>>>><<<>>><<<>>><>><<>>>><<<><<<><<<<><<>><<<>>><<<<>><<<<><<<<><<<>>>><<<><><<<<>><<><<>>>";

printf("Length of inp is %d\n", length($inp));

my $w=7;
my @col=();
my $maxh=0;
my $rc=0;
my $ri=0;
my $ii=0;

while($rc<2022) {
	my $rh=$maxh+3;
	my $rx=2;
	$ri=$rc%(scalar @rocks);

	printf("Dropping rock %d type %d starting at rh=%d rx=%d\n", $rc, $ri, $rh, $rx);

	my $falling=1;
	do {
		if(substr($inp,$ii,1) eq ">") {
			$rx+=1 if(!collisionlr($ri, $rx+1, $rh));
		} else {
			$rx-=1 if(!collisionlr($ri, $rx-1, $rh));
		}
		printf("Moved %s to rx=%d\n", substr($inp, $ii, 1), $rx);

		$ii=(++$ii)%length($inp);

		if(collisiond($ri, $rx, $rh-1) || $rh==0) {
			$falling=0;
			$maxh=max($maxh,$rh+int(max(@{$rocks[$ri]})/$w)+1);
			foreach my $i (@{$rocks[$ri]}) {
				$col[$i+$rh*$w+$rx]=$ri+1;
			}
			printf("Stopped at rh=%d\n", $rh);
		} else {
			$rh-=1;
			printf("Moved down to rh=%d\n", $rh);
		}
	} while ($falling);

#	printcol();
	$rc++;

}

printf("Answer is %d\n", $maxh);

sub printcol {
	# for(my $i=(int((scalar @col)/$w)+1)*$w; $i>0; $i--) {
	# 	print $col[$w-($i%$w)+(int($i/$w)*$w)] // ".";
	# 	print "\n" if($i%$w == $w-1);
	# }
#	print Dumper \@col;
	for(my $i=(int((scalar @col)/$w)+1); $i>=0; $i--) {
		foreach my $j(0..$w-1) {
			print $col[$i*$w+$j] // ".";
		}
		print "\n";
	}
}

sub collisionlr {
	my $ri=shift;
	my $rx=shift;
	my $rh=shift;

	my $collision=0;

	# check the wall

	if($rx<0) {
		$collision=1;
	} else {
		foreach my $i (@{$rocks[$ri]}) {
			if(($rx+($i%$w))>=$w) {
				$collision=1;
				last;
			}
		}
	}

	# check fallen rocks
	if(!$collision) {
		$collision=collisiond($ri, $rx, $rh);
	}
	return $collision;
}

sub collisiond {
	my $ri=shift;
	my $rx=shift;
	my $rh=shift;

	my $collision=0;

	foreach my $i (@{$rocks[$ri]}) {
		if($col[$rh*$w+$rx+$i]) {
			$collision=1;
			last;
		}
	}
	return $collision;
}