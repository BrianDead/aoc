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

#print("Start: $px, $py facing $pd\n");

my $sx=$px;
my $sy=$py;
my $sd=$pd;

my %visited;

while($px>=0 && $py>=0 && $px<$w && $py<$h) {
	my $tx=$px+$dir{$pd}->[0];
	my $ty=$py+$dir{$pd}->[1];
#	print("At $px, $py heading $pd - next $tx, $ty ");
	$visited{"$px,$py"}++;
	if($tx>=0 && $ty>=0 && $tx<$w && $ty<$h && $m[$ty][$tx] eq '#') {
#		print("which is a # so turning");

		$pd=$dir{$pd}->[2];
		$tx=$px+$dir{$pd}->[0];
		$ty=$py+$dir{$pd}->[1];
#		print("now heading $pd - next $tx, $ty ");
	}
	$px=$tx; $py=$ty;
#	print("\n");
}

printf("Answer 1: %d\n", scalar keys %visited);

sub testpath {
	my $px=shift;
	my $py=shift;
	my $pd=shift;
	my $ox=shift;
	my $oy=shift;
	my %ld=@_;

	my $loop=0;

#	print("LOOP DETECTOR ENABLED\n");

	while($px>=0 && $py>=0 && $px<$w && $py<$h && !$loop) {
		my $tx=$px+$dir{$pd}->[0];
		my $ty=$py+$dir{$pd}->[1];

#		print("	At $px, $py heading $pd - next $tx, $ty ");
		if(defined($ld{"$px,$py,$pd"}) ) {
#			print("Loop!\n");
			$loop=1;
			last;
		}
		$ld{"$px,$py,$pd"}++;

		if($tx>=0 && $ty>=0 && $tx<$w && $ty<$h && 
			($m[$ty][$tx] eq '#' || ($tx==$ox && $ty==$oy)) ) {
			#there's already an obstruction
			$pd=$dir{$pd}->[2];
#			$tx=$px+$dir{$pd}->[0];
#			$ty=$py+$dir{$pd}->[1];
			$tx=$px;
			$ty=$py;
#			print("now heading $pd - next $tx, $ty ");
		}
		$px=$tx; $py=$ty;
#		print("\n");
	}
	return $loop;
}

my %visits=();
my %pcons=();
my $answer3=0;
%visited=();
$px=$sx;
$py=$sy;
$pd=$sd;

while($px>=0 && $py>=0 && $px<$w && $py<$h) {

	$visits{"$px,$py,$pd"}++;
	$visited{"$px,$py"}++;

	my $tx=$px+$dir{$pd}->[0];
	my $ty=$py+$dir{$pd}->[1];
#	print("At $px, $py heading $pd - next $tx, $ty ");

	if($tx>=0 && $ty>=0 && $tx<$w && $ty<$h) {
		if($m[$ty][$tx] eq '#') {
			#there's already an obstruction
			$pd=$dir{$pd}->[2];
#			$tx=$px+$dir{$pd}->[0];
#			$ty=$py+$dir{$pd}->[1];
			$tx=$px;
			$ty=$py;
#			print("now heading $pd - next $tx, $ty ");
		} elsif(! defined($visited{"$tx,$ty"}) ) {
#		 ! defined($visits{"$tx,$ty,<"})
#				&& ! defined($visits{"$tx,$ty,>"})
#				&& ! defined($visits{"$tx,$ty,^"})
#				&& ! defined($visits{"$tx,$ty,v"}) ) {
			# no obstruction, but consider if putting one here would create a loop
			# unless we've already passed through this location, in which case, 
			# there can't be an obstruction here.
			my $id=$dir{$pd}->[2];
#			my $ix=$px+$dir{$id}->[0];
#			my $iy=$py+$dir{$id}->[1];
#			print("testing $px,$py,$id ");
			if(testpath($px,$py,$id,$tx,$ty,%visits)) {
				$pcons{"$tx,$ty"}++;
#				print("Loop!\n");
			}
		}
	}
	$px=$tx; $py=$ty;
#	print("\n");
}

printf("Answer 1: %d\n", scalar keys %visited);
printf("Real answer3: %d\n", scalar keys %pcons);
