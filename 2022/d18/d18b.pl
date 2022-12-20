#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(max);

my %space;
my $maxx=0; my $maxy=0; my $maxz=0;

while(<STDIN>) {
	chomp;
	my ($x, $y, $z)=split ',',$_;

	$space{$x,$y,$z}=0;
	$maxx=max($maxx,$x);
	$maxy=max($maxy,$y);
	$maxz=max($maxz,$z);
}

my $answer=0;

foreach my $ix(0..$maxx) {
	foreach my $iy(0..$maxy) {
		foreach my $iz(0..$maxz) {
			if(!defined($space{$ix,$iy,$iz})) {
				checkint($ix,$iy,$iz,0);
			}
		}
	}
}

printspace();


foreach my $ix(0..$maxx) {
	foreach my $iy(0..$maxy) {
		foreach my $iz(0..$maxz) {
			$answer+=6-touching($ix,$iy,$iz) if($space{$ix,$iy,$iz}==0);
		}
	}
}

printf("Answer is %d\n", $answer);

sub touching {
	my $cx=shift;
	my $cy=shift;
	my $cz=shift;

#	printf("Checking %d,%d,%d\n", $cx, $cy, $cz);
	my $touches=0;
	foreach my $t ([1,0,0],[-1,0,0],[0,1,0],[0,-1,0],[0,0,1],[0,0,-1]) {
		$touches++ if(($space{$cx+$t->[0],$cy+$t->[1],$cz+$t->[2]} // 3)<2);
#		printf("%d,%d,%d=%d\n",$cx+$t->[0],$cy+$t->[1],$cz+$t->[2],($space{$cx+$t->[0],$cy+$t->[1],$cz+$t->[2]} // -1));
	}
	return $touches;
}

sub setext {
	my $cx=shift;
	my $cy=shift;
	my $cz=shift;
	my $r=shift;

	print "r=$r setext $cx, $cy, $cz =".($space{$cx,$cy,$cz} // "u")."\n";
	if(defined($space{$cx,$cy,$cz})) {
		return if($space{$cx, $cy, $cz}==0);
		return if($space{$cx, $cy, $cz}>=2);
	}

	$space{$cx, $cy, $cz}=2;

	foreach my $t ([1,0,0],[-1,0,0],[0,1,0],[0,-1,0],[0,0,1],[0,0,-1]) {
		if($cx>=0 && $cx<=$maxx && $cy>=0 && $cy<=$maxy && $cz>=0 && $cz<=$maxz) {
			setext($cx+$t->[0],$cy+$t->[1],$cz+$t->[2], $r+1);
		}
	}
}

sub checkint {
	my $cx=shift;
	my $cy=shift;
	my $cz=shift;
	my $r=shift;

	print "r=$r chkint $cx, $cy, $cz =".($space{$cx,$cy,$cz} // "u")."\n";
	if(defined($space{$cx,$cy,$cz})) {
		return if($space{$cx, $cy, $cz}==0);
		return if($space{$cx, $cy, $cz}>=2);
	}

	# Not interior if on the edge. If so, recurse until you hit lava
	if($cx<=0 || $cx>=$maxx || $cy<=0 || $cy>=$maxy || $cz<=0 || $cz>=$maxz) {
#		printf("EDGE\n");
		setext($cx, $cy, $cz);
	} else {
		$space{$cx, $cy, $cz}=1;
	}

}

sub printspace {
	foreach my $ix(-1..$maxx) {
		foreach my $iz(0..$maxz) {
			if($ix<0) {
				printf("z=%01d            ",$iz);
			} else {
				foreach my $iy(0..$maxy) {
					print($space{$ix,$iy,$iz});
				}
			}
			print("  ");
		}
		print("\n");
	}

}

#2050 is too low