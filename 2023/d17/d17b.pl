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

my $huge=999999999999;

# for each node there are 12 virtual nodes - for each of the 4 directions, there are 3 values of number of steps

my @nodetypes=(
	[0, 1,0,1],
	[1,1,0,2],
	[2,1,0,3],
	[3,1,0,4],
	[4,1,0,5],
	[5,1,0,6],
	[6,1,0,7],
	[7,1,0,8],
	[8,1,0,9],
	[9,1,0,10],
	[10,-1,0,1],
	[11,-1,0,2],
	[12,-1,0,3],
	[13,-1,0,4],
	[14,-1,0,5],
	[15,-1,0,6],
	[16,-1,0,7],
	[17,-1,0,8],
	[18,-1,0,9],
	[19,-1,0,10],
	[20,0,1,1],
	[21,0,1,2],
	[22,0,1,3],
	[23,0,1,4],
	[24,0,1,5],
	[25,0,1,6],
	[26,0,1,7],
	[27,0,1,8],
	[28,0,1,9],
	[29,0,1,10],
	[30,0,-1,1],
	[31,0,-1,2],
	[32,0,-1,3],
	[33,0,-1,4],
	[34,0,-1,5],
	[35,0,-1,6],
	[36,0,-1,7],
	[37,0,-1,8],
	[38,0,-1,9],
	[39,0,-1,20]
);

my $nt=scalar @nodetypes;

print("w=$w h=$h n=$n nt=$nt\n");



foreach my $i(0..($n*$nt)) {
	$distances[$i]=$huge;
	$visit[$i]=0;
}

sub ser {
	return (($_[0]*$w)+$_[1])*$nt+$_[2];
}

sub node {
	my $node=int($_[0]/$nt);
	return (int($node/$w), $node%$w, $_[0]%$nt);
}

sub minpath {
	return -1 if(scalar keys %active == 0);
	return reduce { $distances[$a]<$distances[$b]?$a:$b } keys %active;
}

sub minpath3 {
	return -1 if(scalar keys %active == 0);
	my @k=sort { $distances[$a]<=>$distances[$b] } keys %active;
	return $k[0]; 
}

sub minpath2 {
	my $imin=-1;
	my $dmin=$huge+1;

	foreach my $i (keys %active) {
		if($distances[$i]<$dmin) {
			$imin=$i;
			$dmin=$distances[$i];
		}
	}
	return $imin;
}

sub cost {
	return $m[$_[0]][$_[1]];
}

sub activate {
	$active{$_[0]}=1;
}

$distances[0]=0;
activate(0);
$distances[20]=0;
activate(20);

foreach my $i (0..($n-1)*$nt) {
	my $node=minpath();
	last if($node<0);

	my ($ny, $nx, $t)=node($node);

	print "Next $i: node $node - $ny, $nx, $t - distance=$distances[$node]\n";

	$visit[$node]=1;
	delete($active{$node});

	# Move up?
	if($ny>0 && !($t==19 || ($t>=0 && $t<=9) || ($t>=20 && $t<23) || ($t>=30 && $t<33))) {
		print(" U");
		my $newd=$distances[$node]+cost($ny-1, $nx);
		my $newt;
		if($t>=10 && $t<19) { $newt=$t+1; }
		else {$newt=10; }
		if($newd<$distances[ser($ny-1, $nx, $newt)]) {
			$distances[ser($ny-1, $nx, $newt)]=$newd;
			activate(ser($ny-1, $nx, $newt));
		};
	}
	# Move left (dx==-1)
	if($nx>0 && !($t==39 || ($t>=20 && $t<=29) || ($t>=10 && $t<13) || ($t>=0 && $t<3))) {
		print(" L");
		my $newd=$distances[$node]+cost($ny, $nx-1);
		my $newt;
		if($t>=30 && $t<39) { $newt=$t+1; }
		else {$newt=30;}
		if($newd<$distances[ser($ny, $nx-1, $newt)]) {
			$distances[ser($ny, $nx-1, $newt)]=$newd;
			activate(ser($ny, $nx-1, $newt));
		};
	}
	# Move down
	if($ny<($h-1) && !($t==9 || ($t>=10 && $t<=19) || ($t>=20 && $t<23) || ($t>=30 && $t<33))) {
		print(" D");
		my $newd=$distances[$node]+cost($ny+1, $nx);
		my $newt;
		if($t>=0 && $t<9) { $newt=$t+1; }
		else {$newt=0;}
		print(" $newt");
		printf(" %d %d %d\n", ser($ny+1, $nx, $newt), $distances[ser($ny+1, $nx, $newt)], $newd);
		if($newd<$distances[ser($ny+1, $nx, $newt)]) {
			$distances[ser($ny+1, $nx, $newt)]=$newd;
			activate(ser($ny+1, $nx, $newt));
		}
	}
	# Move right
	if($nx<($w-1) && !($t==29 || ($t>=30 && $t<=39) || ($t>=10 && $t<13) || ($t>=0 && $t<3))) {
		print(" R");
		my $newd=$distances[$node]+cost($ny, $nx+1);
		my $newt;
		if($t>=20 && $t<29) { $newt=$t+1; }
		else {$newt=20; }
		if($newd<$distances[ser($ny, $nx+1, $newt)]) {
			$distances[ser($ny, $nx+1, $newt)]=$newd;
			activate(ser($ny, $nx+1, $newt));
		}
	}
	print("\n");
}

my $answer=$huge;

foreach my $i(ser($h-1, $w-1, 0)..ser($h-1, $w-1, $nt-1)) {
	my($y, $x, $t)=node($i);
	print("Distance $i is $distances[$i]\n");
	next if($t % 10 <3);
	$answer=$distances[$i] if($distances[$i]<$answer);
}

print("Answer is $answer\n");