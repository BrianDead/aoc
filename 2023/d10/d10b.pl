#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $x=-1;
my $y=-1;
my @la=([-1,0],[0,-1],[0,1],[1,0]);
#my @walk=([-1,-1][-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]);


my %bend= ('|'=> [[-1,0],[1,0]],
			'-'=> [[0,-1],[0,1]],
			'L'=> [[-1,0],[0,1]],
			'J'=> [[-1,0],[0,-1]],
			'7'=> [[1,0],[0,-1]],
			'F'=> [[1,0],[0,1]] );

my @plan=map { chomp; if($x<0) {$x=index($_, 'S'); $y++;};  [split //] } <>;
my $w=scalar @{$plan[0]};
my $h=scalar @plan;
my @record;

foreach(0..$#plan) {
	push(@record, [split //, 0 x $w]);
}

sub findexit {
	my ($now, $from)=@_;
	my $p=$plan[$now->[0]][$now->[1]];
	my $exit=0;

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

sub mark {
	my $p=shift;
	$record[$p->[0]][$p->[1]]=$plan[$p->[0]][$p->[1]];
}

my %memo;

sub walkfrom {
	my @pos=@_;
	return if($memo{"$pos[0],$pos[1]"});
	$memo{"$pos[0],$pos[1]"}=1;

	print("Walk from $pos[0],$pos[1]\n");

	$record[$pos[0]][$pos[1]]='2' if ($record[$pos[0]][$pos[1]] eq '0');

	foreach my $m (@la) {
		next if( $pos[0]+$m->[0]<0 || $pos[1]+$m->[1]<0 || $pos[0]+$m->[0] ge $h || $pos[1]+$m->[1] ge $w  );
		next if($record[$pos[0]+$m->[0]][$pos[1]+$m->[1]] eq '2');
		if($record[$pos[0]+$m->[0]][$pos[1]+$m->[1]] eq '0') {
			walkfrom($pos[0]+$m->[0],$pos[1]+$m->[1]);
		} else {
			my $pipe=$plan[$pos[0]+$m->[0]][$pos[1]+$m->[1]];
			# it's a live pipe
			if( ( $m->[0] eq $bend{$pipe}[0][0] && $m->[1] eq $bend{$pipe}[0][1]) ||
				($m->[0] eq $bend{$pipe}[1][0] && $m->[1] eq $bend{$pipe}[1][1])) {
				walkfrom($pos[0]+$m->[0],$pos[1]+$m->[1]);
			}

		}
	}
}

sub inorout {
	my @pos=@_;
#	print("Checking $pos[0],$pos[1]:\n");
	my $inters=0;
	my $down=0;
	my $up=0;

	foreach my $x($pos[1]+1..$w-1) {
		my $p=$record[$pos[0]][$x];
		if($p eq '|') {
			$inters++;
		} elsif ($p eq 'L') {
			$down=1;

		} elsif($p eq 'F') {
			$up=1;

		} elsif($p eq 'J') {
			if($up) {
				$up=0;
				$inters++;
			} else {$down=0;}
		} elsif($p eq '7') {
			if($down) {
				$down=0;
				$inters++;
			} else { $up=0;}
		}
	}
	$inters%2
}


print("S is at row $y col $x\n");

my $done=0;
my @moves;
my $answer=0;

my @pos=($y, $x);
#mark(\@pos);
my @sbend;

foreach my $pk(@la) {
	my $iy=$y+$pk->[0];
	my $ix=$x+$pk->[1];
	next if($ix<0 || $iy<0 || $ix>=$w || $ix>=$h);

	if(isopen(\@pos,$iy,$ix)) {
		push @moves, [($iy, $ix)];
		push @sbend, $pk;
	}

}

foreach my $bnd (keys %bend) {
	my $ang=$bend{$bnd};
	if( ( $ang->[0][0]==$sbend[0][0] && $ang->[0][1]==$sbend[0][1] && $ang->[1][0]==$sbend[1][0] && $ang->[1][1]==$sbend[1][1]) ||
		( $ang->[1][0]==$sbend[0][0] && $ang->[1][1]==$sbend[0][1] && $ang->[0][0]==$sbend[1][0] && $ang->[0][1]==$sbend[1][1])  ) {
		$record[$y][$x]=$bnd;
		print("S is a $bnd\n");
		last;
	}
}


mark($moves[0]); mark($moves[1]);

print "Moves:\n";
print Dumper \@moves;
print "\n";


my @lp=(\@pos, \@pos);
print "LP:\n";
print Dumper \@lp;
print "\n";

$answer++;

do {
	foreach my $i(0..$#moves) {
		my 	($ix,$iy)=findexit($moves[$i], $lp[$i]);
		$lp[$i]=$moves[$i];
		@moves[$i]=[($ix, $iy)];
		mark($moves[$i]);
	}

	if( ($moves[0][0]==$moves[1][0] && $moves[0][1]==$moves[1][1]) ||
		($moves[0][0]==$lp[1][0] && $moves[0][1]==$lp[1][1]) ) {
		$done=1;
	}

	$answer++;
	} until($done);

print("Answer is $answer\n");

foreach(@record) {
	foreach my $cell (@{$_}) {
		print $cell;
	}
	print "\n";
}

my $a2=0;

foreach my $iy (0..$h-1) {
	foreach my $ix (0..$w-1) {
		if($record[$iy][$ix] eq '0') {
			if(inorout($iy,$ix)) {
				$record[$iy][$ix]='I';
				$a2++;
			}
		}
	}
}

foreach(@record) {
	foreach my $cell (@{$_}) {
		print $cell;
	}
	print "\n";
}

print "Answer 2 is $a2\n";