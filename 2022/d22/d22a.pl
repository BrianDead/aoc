#!/usr/bin/perl

use List::Util qw(max);
use Data::Dumper;

my @board=();
my $boarding=1;
my $row=0;
my $maxx=0;
my $maxy=0;
my $path="";
my @moves=([1,0],[0,1],[-1,0],[0,-1]); # 0=r, 1=d, 2=l, 3=u

while(<STDIN>) {
	chomp;
	if($_ eq "") {
		$boarding=0;
		next;
	}

	if($boarding) {
		$maxx=max($maxx, length($_)-1);
		$board[$row++]=[split //, $_];
	} else {
		$path=$_;
	}
}
$maxy=$row-1;

print Dumper \@board;

my ($x, $y, $d);

foreach my $i (0..$maxx) {
	if(($board[0][$i] // " ") eq ".") {
		$x=$i ; last;
	}
}
$y=0;
$d=0;

printf("Start at %d, %d dir %d\n", $x, $y, $d);

my $ind=0;
my $let=0;

while($ind<length($path)) {
	if($let) {
		my $dir=substr($path, $ind, 1);
		printf("Turn %s\n", $dir);
		if ($dir eq "R") {
			$d=($d+1)%4;
		} else {
			$d=($d+3)%4;
		}
		printf("Turn %s Facing %d\n", $dir, $d);
		$let=0; $ind++;
	} else {
		my $dist=substr($path, $ind)+0;
		$let=1; $ind+=length($dist);
		printf("Move %d dir %d\n", $dist, $d);
		foreach(1..$dist) {
			my ($nextx, $nexty)=move($d, $x, $y);
			printf("step to %d,%d\n", $nextx, $nexty);
			while(($board[$nexty][$nextx] // " ") eq " " ) {
				 ($nextx, $nexty)=move($d, $nextx, $nexty);
			}
			last if($board[$nexty][$nextx] eq "#");
			$x=$nextx; $y=$nexty;
		}
		$let=1;
	}
}


printf("Row %d, Col %d, facing %d, Answer:%d\n", $y, $x, $d, 1000*($y+1)+4*($x+1)+$d);

sub move {
	my $dir=shift;
	my $x=shift;
	my $y=shift;

	return(($x+($maxx+1)+$moves[$dir][0])%($maxx+1), ($y+$maxy+1+$moves[$d][1])%($maxy+1));
}