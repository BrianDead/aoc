use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);

my @m = map { chomp; [split //]} <>;
my %memo;

my $w=scalar @{$m[0]};
my $h=scalar @m;
my $n=$w*$h;

my @distances;
my @visit;

my %active;
my %inactive;

my $huge=999999999999;

# for each node there are 12 virtual nodes - for each of the 4 directions, there are 3 values of number of steps

my @nodetypes=(
	[0, 1,0,1],
	[1,1,0,2],
	[2,1,0,3],
	[3,-1,0,1],
	[4,-1,0,2],
	[5,-1,0,3],
	[6,0,1,1],
	[7,0,1,2],
	[8,0,1,3],
	[9,0,-1,1],
	[10,0,-1,2],
	[11,0,-1,3]
);

my $nt=scalar @nodetypes;

print("w=$w h=$h n=$n nt=$nt\n");



foreach my $i(0..($n*$nt)) {
	$distances[$i]=$huge;
	$visit[$i]=0;
	$inactive{$i}=1;
}

sub ser {
	return (($_[0]*$w)+$_[1])*$nt+$_[2];
}

sub node {
	my $node=int($_[0]/$nt);
	return (int($node/$w), $node%$w, $_[0]%$nt);
}

sub minpath {
	my $imin=-1;
	my $dmin=$huge+1;

	foreach my $i (keys %active) {
		if($distances[$i]<$dmin) {
			$imin=$i;
			$dmin=$distances[$i];
		}
	}
#	if($imin<0) {
#		foreach my $i (0..$n-1) {
#			foreach my $j (0..$nt-1) {
#				if(!$visit[$i*$nt+$j] && $distances[$i*$nt+$j]<$dmin) {
#					$imin=$i*$nt+$j;
#					$dmin=$distances[$i*$nt+$j];
#				}
#			}
#		}
#		foreach my $i (keys %inactive) {
#			if($distances[$i]<$dmin) {
#				$imin=$i;
#				$dmin=$distances[$i];
#			}
#		}
#	}
	return $imin;
}

sub cost {
	return $m[$_[0]][$_[1]];
}

sub activate {
	$active{$_[0]}=1;
	delete $inactive{$_[0]};
}

$distances[0]=0;
activate(0);

foreach my $i (0..($n-1)*$nt) {
	my $node=minpath();
	last if($node<0);

	my ($ny, $nx, $t)=node($node);

	print "Next $i: node $node - $ny, $nx, $t - distance=$distances[$node]\n";

	$visit[$node]=1;
	delete($active{$node});

	# Move up?
	if($ny>0 && !($t==5 || $t==0 ||$t==1 ||$t==2 )) {
		print(" U");
		my $newd=$distances[$node]+cost($ny-1, $nx);
		my $newt;
		if($t==3 || $t==4) { $newt=$t+1; }
		else {$newt=3; }
		if($newd<$distances[ser($ny-1, $nx, $newt)]) {
			$distances[ser($ny-1, $nx, $newt)]=$newd;
			activate(ser($ny-1, $nx, $newt));
		};
	}
	# Move left (dx==-1)
	if($nx>0 && !($t==11 || $t==6 ||$t==7 ||$t==8 )) {
		print(" L");
		my $newd=$distances[$node]+cost($ny, $nx-1);
		my $newt;
		if($t==9 || $t==10) { $newt=$t+1; }
		else {$newt=9;}
		if($newd<$distances[ser($ny, $nx-1, $newt)]) {
			$distances[ser($ny, $nx-1, $newt)]=$newd;
			activate(ser($ny, $nx-1, $newt));
		};
	}
	# Move down
	if($ny<($h-1) && !($t==2 || $t==3 ||$t==4 ||$t==5 )) {
		print(" D");
		my $newd=$distances[$node]+cost($ny+1, $nx);
		my $newt;
		if($t==0 || $t==1) { $newt=$t+1; }
		else {$newt=0;}
		if($newd<$distances[ser($ny+1, $nx, $newt)]) {
			$distances[ser($ny+1, $nx, $newt)]=$newd;
			activate(ser($ny+1, $nx, $newt));
		}
	}
	if($nx<$w-1 && !($t==8 || $t==9 ||$t==10 ||$t==11 )) {
		print(" R");
		my $newd=$distances[$node]+cost($ny, $nx+1);
		my $newt;
		if($t==6 || $t==7) { $newt=$t+1; }
		else {$newt=6; }
		if($newd<$distances[ser($ny, $nx+1, $newt)]) {
			$distances[ser($ny, $nx+1, $newt)]=$newd;
			activate(ser($ny, $nx+1, $newt));
		}
	}
	print("\n");
}

my $answer=$huge;

foreach my $i(ser($h-1, $w-1, 0)..ser($h-1, $w-1, $nt-1)) {
	$answer=$distances[$i] if($distances[$i]<$answer);
	print("Distance $i is $distances[$i]\n")
}

print("Answer is $answer\n");