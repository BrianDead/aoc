#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(max);

my %space;
my $maxx; my $maxy; my $maxz;

while(<STDIN>) {
	chomp;
	my ($x, $y, $z)=split ',',$_;

	$space{$x,$y,$z}=1;
	$maxx=max($maxx,$x);
	$maxy=max($maxy,$y);
	$maxz=max($maxz,$z);
}

my $answer=0;

foreach my $ix(0..$maxx) {
	foreach my $iy(0..$maxy) {
		foreach my $iz(0..$maxz) {
			$answer+=6-touching($ix,$iy,$iz) if(($space{$ix,$iy,$iz} // 0)==1);
		}
	}
}

printf("Answer is %d\n", $answer);

sub touching {
	my $cx=shift;
	my $cy=shift;
	my $cz=shift;

	printf("Checking %d,%d,%d\n", $cx, $cy, $cz);
	my $touches=0;
	foreach my $t ([1,0,0],[-1,0,0],[0,1,0],[0,-1,0],[0,0,1],[0,0,-1]) {
		$touches++ if(($space{$cx+$t->[0],$cy+$t->[1],$cz+$t->[2]} // 0)==1);
		printf("%d,%d,%d=%d\n",$cx+$t->[0],$cy+$t->[1],$cz+$t->[2],($space{$cx+$t->[0],$cy+$t->[1],$cz+$t->[2]} // 0));
	}
	return $touches;
}