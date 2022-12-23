#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(max min);
use Data::Dumper;

my $maxx=0;
my $maxy=0;
my $minx=0;
my $miny=0;

my %map;
my @elves;
my @directions=([[0,-1],[1,-1],[-1,-1]],
				[[0,1],[1,1],[-1,1]],
				[[-1,0],[-1,-1],[-1,1]],
				[[1,0],[1,-1],[1,1]]); # N, S, W, E

@elves=map{
	chomp; 
	my @e; my $x=0; 
	foreach(split //) {
		if ($_ eq "#") { 
			push @e, {x=>$x, y=>$maxy };
			$map{"$x,$maxy"}=@elves+@e-1;
		}
		$x++;
	}
	$maxx=max($x-1, $maxx); $maxy++;
	@e 
} <STDIN>;

$maxy--;

#print Dumper \@elves;
#print Dumper \%map;

pm();

sub move {
	my $p=shift;

	my $fx=$elves[$p->{elf}]->{x};
	my $fy=$elves[$p->{elf}]->{y};

	my $tx=$p->{x};
	my $ty=$p->{y};

#	printf("Move %d to %d, %d from %d, %d\n", $p->{elf}, $tx, $ty, $fx, $fy);

	$maxx=max($maxx, $tx);
	$maxy=max($maxy, $ty);
	$minx=min($minx, $tx);
	$miny=min($miny, $ty);

	die if(!defined($map{"$fx,$fy"}));
	die if(defined($map{"$tx,$ty"}));

	$map{"$tx,$ty"}=$p->{elf};
	$elves[$p->{elf}]->{x}=$tx;
	$elves[$p->{elf}]->{y}=$ty;
	delete $map{"$fx,$fy"};
}

sub pm {
	my $empties=0;
	print "--------\n";
	printf("minx %d miny %d, maxx %d maxy %d\n", $minx, $miny, $maxx, $maxy);
	foreach my $y ($miny..$maxy) {
		foreach my $x ($minx..$maxx) {
			print defined($map{"$x,$y"}) ? "#" : ".";
			$empties++ if(!defined($map{"$x,$y"}));
		}
		print "\n";
	}
	print "--------\n\n";
	return $empties;
}

my $done=0;
my $rounds=0;

while(!$done) {
	#firsthalf
	my @proposals=();
	my %destinations=();

	$rounds++;

	foreach my $elf(0..(@elves-1)) {
		my $occupied=0;
		my $adjacent=0;
#		printf("Elf %d at %d, %d: ",$elf, $elves[$elf]->{x}, $elves[$elf]->{y});

		#Do I need to move?

		foreach my $dx(-1..1) {
			foreach my $dy(-1..1) {
				next if($dx==0 && $dy==0);
				my $cx=$elves[$elf]->{x}+$dx;
				my $cy=$elves[$elf]->{y}+$dy;
				$adjacent=defined($map{"$cx,$cy"});
				last if($adjacent);
			}
			last if($adjacent);
		}
#		print "Unadjacent\n" if(!$adjacent);
		next if(!$adjacent);

		foreach my $dir (@directions) {
			foreach my $p (@{$dir}) {
				my $px=$elves[$elf]->{x}+$p->[0];
				my $py=$elves[$elf]->{y}+$p->[1];
				$occupied=defined($map{"$px,$py"});
#				printf("%d, %d %s ",$px,$py,defined($map{"$px,$py"})? "BUSY":"FREE");
				last if($occupied);
			}
			if(!$occupied) {
				my $nx=$elves[$elf]->{x}+$dir->[0][0];
				my $ny=$elves[$elf]->{y}+$dir->[0][1];
				push @proposals, {elf=>$elf, x=>$nx, y=>$ny };
				$destinations{"$nx,$ny"}++;
#				printf("\nProposal: %d, %d (%d)\n", $nx, $ny, $destinations{"$nx,$ny"});
				last;
			}

		}
#		print"\n";
	}

	push @directions, shift @directions;

	if(@proposals) {
		foreach my $prop(@proposals) {
			my $px=$prop->{x}; my $py=$prop->{y};

			if($destinations{"$px,$py"}==1) {
				move($prop);
			}
		}
	} else {
		$done=1;
	}
}

# Re-check max and min
$maxx=0;$minx=0;$maxy=0;$miny=0;
foreach my $elf (@elves) {
	$maxx=max($maxx, $elf->{x});
	$maxy=max($maxy, $elf->{y});
	$minx=min($minx, $elf->{x});
	$miny=min($miny, $elf->{y});
}

printf("Answer 2 is %d\n", $rounds);