use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);
use Math::Polygon;

my %v=(R => [0,1], L => [0,-1], U => [-1,0], D => [1,0],
		0 => [0,1], 2 => [0,-1], 3 => [-1,0], 1 => [1,0]);
my %turns=(
	R=>{D=>"R", U=>"L"},
	L=>{D=>"L", U=>"R"},
	U=>{R=>"R", L=>"L"},
	D=>{R=>"L", L=>"R"},
	0=>{1=>"R", 3=>"L"},
	2=>{1=>"L", 3=>"R"},
	3=>{0=>"R", 2=>"L"},
	1=>{0=>"L", 2=>"R"}
);


my @p=(0,0);
my @points;
my $tp=0;
my $lastturn='R';
my $lastdir='';
my $lastl=-1;

push (@points, [@p]);

while (<>) {
	chomp; 
	my($dir, $l, $blh, $bdir)= $_ =~ /([RLDU]) ([0-9]+) \(\#([0-9a-f]{5})([0-9a-f])/;
	my $bl=hex($blh);

	my $turn='';
	if($lastdir ne '') {
		$turn=$turns{$lastdir}{$bdir};
	} else {
		$turn='R';
	}

	if($turn eq 'L' && $lastturn eq 'L') {
		$lastl-=1;
	} elsif($turn eq 'R' && $lastturn eq 'R') {
		$lastl+=1;
	}

	if($lastdir ne '') {
		@p=map { $p[$_] + ($v{$lastdir}->[$_]) * $lastl} 0..1;
		push(@points, [@p]);
	}

	$lastdir=$bdir; $lastl=$bl; $lastturn=$turn;
}

@p=map { $p[$_] + ($v{$lastdir}->[$_]) * $lastl} 0..1;
push(@points, [@p]);

print Dumper \@points;

my $pit=Math::Polygon->new(@points);
printf("Area is %d, perimeter is %d, diff is %d, tp is %d\n", $pit->area,$pit->perimeter, 952408144115-$pit->area, $tp);
