#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @m=map{ chomp; [split //] } <>;
my $h=scalar @m;
my $w=scalar (@{$m[0]});

#print Dumper \@m;
print("Size: $h x $w\n");

my %dir=( '^'=>[0,-1,'>'],'v'=>[0,1,'<'],'<'=>[-1,0,'^'],'>'=>[1,0,'v']);

my $px=-1;
my $py=-1;
my $pd='';

for my $i (0..$h-1) {
	for my $j (0..$w-1) {
#		print $m[$i][$j];
		if($m[$i][$j] ne '.' && $m[$i][$j] ne '#') {
			$py=$i; $px=$j; $pd=$m[$i][$j];
		}
	}
#	print("\n");
}

sub testpath {
	my $px=shift;
	my $py=shift;
	my $pd=shift;
	my $ox=shift;
	my $oy=shift;
	my %ld=@_;

	my $loop=0;

	while($px>=0 && $py>=0 && $px<$w && $py<$h && !$loop) {
		my $tx=$px+$dir{$pd}->[0];
		my $ty=$py+$dir{$pd}->[1];

		if(defined($ld{"$px,$py,$pd"}) ) {
			$loop=1;
			last;
		}
		$ld{"$px,$py,$pd"}++;

		if($tx>=0 && $ty>=0 && $tx<$w && $ty<$h && 
			($m[$ty][$tx] eq '#' || ($tx==$ox && $ty==$oy)) ) {
			#there's already an obstruction
			$pd=$dir{$pd}->[2];
			$tx=$px;
			$ty=$py;
		}
		$px=$tx; $py=$ty;
	}
	return $loop;
}

my %visits=();
my %pcons=();
my $answer3=0;
my %visited=();

while($px>=0 && $py>=0 && $px<$w && $py<$h) {

	$visits{"$px,$py,$pd"}++;
	$visited{"$px,$py"}++;

	my $tx=$px+$dir{$pd}->[0];
	my $ty=$py+$dir{$pd}->[1];

	if($tx>=0 && $ty>=0 && $tx<$w && $ty<$h) {
		if($m[$ty][$tx] eq '#') {
			#there's already an obstruction. Turn and reassess.
			$pd=$dir{$pd}->[2];
			$tx=$px;
			$ty=$py;
		} elsif(! defined($visited{"$tx,$ty"}) ) {
			# no obstruction, but consider if putting one here would create a loop
			# unless we've already passed through this location, in which case, 
			# there can't be an obstruction here.
			my $id=$dir{$pd}->[2];
			if(testpath($px,$py,$id,$tx,$ty,%visits)) {
				$pcons{"$tx,$ty"}++;
			}
		}
	}
	$px=$tx; $py=$ty;
}

printf("Answer 1: %d\n", scalar keys %visited);
printf("Real answer3: %d\n", scalar keys %pcons);
