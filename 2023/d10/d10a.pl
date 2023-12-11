#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $x=-1;
my $y=-1;
my @la=([-1,0],[0,-1],[0,1],[1,0]);

my %bend= ('|'=> [[-1,0],[1,0]],
			'-'=> [[0,-1],[0,1]],
			'L'=> [[-1,0],[0,1]],
			'J'=> [[-1,0],[0,-1]],
			'7'=> [[1,0],[0,-1]],
			'F'=> [[1,0],[0,1]] );

my @plan=map { chomp; if($x<0) {$x=index($_, 'S'); $y++;};  [split //] } <>;

sub findexit {
	my ($now, $from)=@_;
	my $p=$plan[$now->[0]][$now->[1]];
	my $exit=0;

	print Dumper $now;
	print Dumper $from;

	printf("exit 0 leads to %d, %d\n", $now->[0]+$bend{$p}[0][0],$now->[1]+$bend{$p}[0][1] );
	printf("exit 1 leads to %d, %d\n", $now->[0]+$bend{$p}[1][0],$now->[1]+$bend{$p}[1][1] );

	$exit=1	if($now->[0]+$bend{$p}[0][0]==$from->[0] && $now->[1]+$bend{$p}[0][1]==$from->[1]);
	print("Choosing exit $exit\n");

	($now->[0]+$bend{$p}[$exit][0],$now->[1]+$bend{$p}[$exit][1])
}

sub isopen {
	my $pos=shift;
	my $p=$plan[$_[0]][$_[1]];
	print "from $pos->[0],$pos->[1]: $p at $_[0],$_[1]\n";
	return 0 if($p eq '.');

	my $r=0;

#	print Dumper $_;
	print Dumper $bend{$p};

	printf("exit 0 leads to %d, %d\n", $_[0]+$bend{$p}[0][0],$_[1]+$bend{$p}[0][1] );
	printf("exit 1 leads to %d, %d\n", $_[0]+$bend{$p}[1][0],$_[1]+$bend{$p}[1][1] );
	

	my $o=0;
	$o=1 if ( ($_[0]+$bend{$p}[0][0]==$pos->[0] && $_[1]+$bend{$p}[0][1]==$pos->[1]) ||
		($_[0]+$bend{$p}[1][0]==$pos->[0] && $_[1]+$bend{$p}[1][1]==$pos->[1]) );
	print "Open: $o\n";
	return $o;
}

print Dumper \@plan;
print("S is at row $y col $x\n");

my $done=0;
my @moves;
my $answer=0;

my @pos=($y, $x);

foreach my $pk(@la) {
	my $ix=$x+$pk->[0];
	my $iy=$y+$pk->[1];
	next if($ix<0 || $iy<0);

	if(isopen(\@pos,$iy,$ix)) {
		push @moves, [($iy, $ix)];
	}
}

print "Moves:\n";
print Dumper \@moves;
print "\n";


my @lp=(\@pos, \@pos);
print "LP:\n";
print Dumper \@lp;
print "\n";

$answer++;

do {
	print("\n\nMove $answer position:\n");
	print Dumper @moves;
	print("\nCalculating moves:\n");
	foreach my $i(0..$#moves) {
		my 	($ix,$iy)=findexit($moves[$i], $lp[$i]);
		$lp[$i]=$moves[$i];
		@moves[$i]=[($ix, $iy)];
	}

	print("\nNew position:\n");
	print Dumper @moves;
	print("\nLast position:\n");
	print Dumper @lp;

	if( ($moves[0][0]==$moves[1][0] && $moves[0][1]==$moves[1][1]) ||
		($moves[0][0]==$lp[1][0] && $moves[0][1]==$lp[1][1]) ) {
		$done=1;
	}

	$answer++;
	} until($done);

print("Answer is $answer\n");