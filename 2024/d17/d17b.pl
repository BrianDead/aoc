#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my @prog=(0,0,0);

sub comboval {
	my $ra=shift;
	my $rb=shift;
	my $rc=shift;
	my $op=shift;
	if($op<=3) {
		return $op;
	} elsif($op==4) {
		return $ra;
	} elsif($op==5) {
		return $rb;
	} elsif($op==6) {
		return $rc;
	}
	print("Invalid combo - $op\n");
	die;
}

sub run {
	my $ra=shift;
	my $rb=shift;
	my $rc=shift;
	my $ip=0;

	my @prog=@_;

	my @out=();

	while($ip < (@prog)) {
		if($prog[$ip]==0) {
			#adv
			$ra=int($ra/(2**comboval($ra, $rb, $rc, $prog[$ip+1])));
		} elsif($prog[$ip]==1) {
			#bxl
			$rb=$rb^$prog[$ip+1];
		} elsif($prog[$ip]==2) {
			#bst
			$rb=comboval($ra, $rb, $rc, $prog[$ip+1]) % 8;
		} elsif($prog[$ip]==3) {
			#jnz
			if($ra!=0) {
				$ip=$prog[$ip+1];
				next;
			}
		} elsif($prog[$ip]==4) {
			#bxc
			$rb=$rb^$rc;
		} elsif($prog[$ip]==5) {
			#out
			push(@out, comboval($ra, $rb, $rc, $prog[$ip+1]) % 8);
		} elsif($prog[$ip]==6) {
			#bdv
			$rb=int($ra/(2**comboval($ra, $rb, $rc, $prog[$ip+1])));
		} elsif($prog[$ip]==7) {
			#cdv
			$rc=int($ra/(2**comboval($ra, $rb, $rc, $prog[$ip+1])));
		} else {
			die("Bad instruction at ip=$ip\n");
		}
		$ip+=2;
	}
	return @out;
}

while(<STDIN>) {
	chomp;
	my $v;
	if(($v)= $_ =~ /Register A: ([0-9]+)/) {
		$prog[0]=$v;
	} elsif(($v)= $_ =~ /Register B: ([0-9]+)/) {
		$prog[1]=$v;
	} elsif(($v)= $_ =~ /Register C: ([0-9]+)/) {
		$prog[2]=$v;
	} elsif(($v)= $_ =~ /Program: ([0-9\,]+)/) {
		push(@prog, split(/\,/, $v));
	}
}

printf("A=%d B=%d C=%d\n", $prog[0], $prog[1], $prog[2]);
printf("%s\n",join ';', @prog);

my @out=run(@prog);

printf("Answer: %s\n", join(',', @out));

my $done=0;
my $target=$prog[3];
#my $guess=$prog[3];
for my $i(4..(@prog-1)) {
	my $t=$prog[$i];
	$target="$target,$t";
}



print("Target: $target \n");
$prog[0]=1;

my $set=1;
my $setval=$prog[@prog-$set];
my $inc=1;
my $cyc=0;
my $last=-1;
my $curlen=1;
my $cylen=0;

my @cycles=();

while($cyc<@prog-3) {
	$prog[0]+=$inc;

	my @o=run(@prog);
	my $os=join(',', @o);
	
	printf("Cycle $cyc.$cylen - A=%d: $os\n", $prog[0]);
	$done=($os eq $target);
	last if($done);
	print("curlen=$curlen, cylen=$cylen, cyc=$cyc\n");

	if($o[0] == $prog[scalar @prog-$cyc-1]) {
		unshift(@cycles, $cylen);
		
		$prog[0]=8**(scalar @cycles);
		$cyc++;
		$cylen=0;
	}

#	if((scalar @o)!=$curlen) {
#		print("Cycle $cyc - len=$cylen\n");
#		$cycles[$cyc]=$cylen;
#		$cylen=0;
#		$lookformatch=1;
#		$curlen=scalar @o;
#		my $nexthop=0;
#		for my $i(0..(scalar())) {
#			$nexthop+=($cycles[$i]-1)*(8**($cyc-$i));
#		}
#		$prog[0]=$nexthop;
#		$cyc++;
#		unshift(@digits,[]);
#	} else {
#		push(@{$digits[0]}, $o[0]);
#	}

	$cylen++;

}

my $guess=0;

print("Target: $target\n");

for my $i(0..(scalar @cycles)-1) {
	printf("Cycle $i - %d\n", $cycles[$i]);
	$guess+=(($cycles[$i]) % 8)*(8**$i);
}

$prog[0]=$guess;
printf("Result: %s\n", join(',', run(@prog)));
$prog[0]+=2*8**15;
printf("Result: %s\n", join(',', run(@prog)));



printf("Answer 2: %d\n", $prog[0]);
