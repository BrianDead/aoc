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

printf("maxx=%d maxy=%d\n", $maxx, $maxy);

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
		printf("Turn %s Facing %d at %d, %d\n", $dir, $d, $x, $y);
		$let=0; $ind++;
	} else {
		my $dist=substr($path, $ind)+0;
		$let=1; $ind+=length($dist);
		printf("Move %d dir %d\n", $dist, $d);
		foreach my $p (1..$dist) {
			my ($nextx, $nexty)=move($d, $x, $y);
			my $nextd=$d;
			printf("Pace %d step to %d,%d\n", $p, $nextx, $nexty);
#			while(($board[$nexty][$nextx] // " ") eq " " ) {
			if(($board[$nexty][$nextx] // " ") eq " " ) {
				printf("Edge\n");
				#face 1
				# d==0 to face 4 149,0 -> 99,149; 149,49 -> 99,100; d=2
				if($d==0 && $nextx==0 && $nexty>=0 && $nexty<50) {
					$nexty=149-$nexty;
					$nextx=99;
					$nextd=2;
					printf("1->4: %d, %d dir=%d\n", $nextx, $nexty, $nextd); ###3
				}
				# d==1 to face 3; 100,49->99,50; 149,49->99,99; d=2
				elsif($d==1 && $nexty==50 && $nextx>=100 && $nextx<150) {
					$nexty=$nextx-50;
					$nextx=99;
					$nextd=2;
					printf("1->3: %d, %d dir=%d\n", $nextx, $nexty, $nextd); ###7
				}
				# d==2 direct to face 2
				# d==3 to face 6; 100,0->0,199; 149,0->49,199; d=3
				elsif($d==3 && $nexty==199 && $nextx>=100 && $nextx<150) {
					$nextx=$nextx-100;
					$nexty=199;
					$nextd=3;
					printf("1->6: %d, %d dir=%d\n", $nextx, $nexty, $nextd);
				}

				#face 2
				# d==0 direct to face 1
				# d==1 direct to face 3
				# d==2 to face 5 50,0 -> 0,149; 50,49 -> 0,100; d=2 => d=0
				elsif($d==2 && $nextx==49 && $nexty>=0 && $nexty<50) {
					$nexty=149-$nexty;
					$nextx=0;
					$nextd=0;
					printf("2->5: %d, %d dir=%d\n", $nextx, $nexty, $nextd);###9
				}
				# d==3 to face 6 50,0 -> 0,150; 99,0->0,199; d=3 to d=0
				elsif($d==3 && $nexty==199 && $nextx>=50 && $nextx<100) {
					$nexty=$nextx+100;
					$nextx=0;
					$nextd=0;
					printf("2->6: %d, %d dir=%d\n", $nextx, $nexty, $nextd); ###1
				}

				#face 3
				# d==0 to face 1 99,50->100,49; 99,99->149,49; d=2->d=3
				elsif($d==0 && $nextx==100 && $nexty>=50 && $nexty<100) { 
					$nextx=$nexty+50;
					$nexty=49;
					$nextd=3;
					printf("3->1: %d, %d dir=%d\n", $nextx, $nexty, $nextd); ###8
				}
				# d==1 direct to face 4
				# d==2 to face 5 50,50->0,100; 50,99->49,100; d=2 -> d=1 to face 5
				elsif($d==2 && $nextx==49 && $nexty>=50 && $nexty<100) { 
					$nextx=$nexty-50;
					$nexty=100;
					$nextd=1;
					printf("3->5: %d, %d dir=%d\n", $nextx, $nexty, $nextd);###13
				}
				# d==3 direct to face 2

				#face 4
				# d==0 to face 1 99,100->149,49; 99,149->149,0; d=2
				elsif($d==0 && $nextx==100 && $nexty>=100 && $nexty<150) {
					$nexty=149-$nexty;
					$nextx=149;
					$nextd=2;
					printf("4->1: %d, %d dir=%d\n", $nextx, $nexty, $nextd); ###4
				}
				# d==1 to face 6 50,149->49,150; 99,149->49,199; d=2
				elsif($d==1 && $nextx>=50 && $nextx<100 && $nexty==150) {
					$nexty=100+$nextx;
					$nextx=49;
					$nextd=2;
					printf("4->6: %d, %d dir=%d\n", $nextx, $nexty, $nextd);###5

				} 
				# d==2 direct to face 5
				# d==3 direct to face 3
				
				#face 5
				# d==0 is direct to face 4
				# d==1 is direct to face 6
				# d==2 to face 2  0,100 -> 50,49; 0,149->50,0 d=0
				elsif($d==2 && $nextx==$maxx && $nexty<150 && $nexty>=100) { #
					$nexty=149-$nexty;
					$nextx=50;
					$nextd=0;
					printf("5->2: %d, %d dir=%d\n", $nextx, $nexty, $nextd);###12
				}
				# d==3 to face 3 0,100->50,50; 49,100->50,99 d=1
				elsif($d==3 && $nextx<50 && $nexty==99) { # 
					$nexty=$nextx+50;
					$nextx=50;
					$nextd=0;
					printf("5->3: %d, %d dir=%d\n", $nextx, $nexty, $nextd);###10
				}

				#face 6
				# d==0 to face 4 49,150->50,149; 49,199->99,149 d=3
				elsif($d==0 && $nextx==50 && $nexty>=150) {
					$nextx=$nexty-100;
					$nexty=149;
					$nextd=3;
					printf("6->4: %d, %d dir=%d\n", $nextx, $nexty, $nextd);###6

				}
				# d==1 to face 1 0,199->100,0; 49,199->149,0 d=1
				elsif($d==1 && $nextx<50 && $nexty==0) { 
					$nextx=$nextx+100;
					$nexty=0;
					$nextd=1;
					#no dir change
					printf("6->1: %d, %d dir=%d\n", $nextx, $nexty, $nextd);###11

				}
				# d==2 to face 2 0,150->50,0; 0,199->99,0 d=1
				elsif($d==2 && $nextx==149 && $nexty>=150) {
					$nextx=$nexty-100;
					$nexty=0;
					$nextd=1;
					printf("6->2: %d, %d dir=%d\n", $nextx, $nexty, $nextd); ###2

				} else {die;}
				# face 6 d==3 is direct to face 5
				printf("Actually %d, %d dir %d\n", $nextx, $nexty, $d);
			}
			if($board[$nexty][$nextx] eq "#") {
				printf("Hit rock\n");
				last;
			}
			$x=$nextx; $y=$nexty; $d=$nextd;
		}
		$let=1;
	}
}


printf("Row %d, Col %d, facing %d, Answer:%d\n", $y, $x, $d, 1000*($y+1)+4*($x+1)+$d);

sub move {
	my $dir=shift;
	my $x=shift;
	my $y=shift;

	return(($x+$maxx+1+$moves[$dir][0])%($maxx+1), ($y+$maxy+1+$moves[$d][1])%($maxy+1));
}