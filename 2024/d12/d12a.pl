#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my @m=map { chomp; [ split //] } <STDIN>;
my $h=scalar @m;
my $w=scalar @{$m[0]};

my @dir=(
	[-1,0],
	[0,1],
	[1,0],
	[0,-1]
	);

my %plan=();
my %fence=();
my %arealist=();
my %areatype=();
my %fencelist=();
my %added=();
my %areastart=();
my $areas=0;
my %edges=();
my @next=();

push(@next, [0,0]);

my $i=0;
while(scalar @next) {
	my ($r, $c)=@{shift(@next)};
	my $f=0;

	printf("$r, $c (%d left) - ", scalar @next);

	next if(defined $fence{"$r,$c"});

	print("Checking\n");

	my $thisa=(defined $plan{"$r,$c"} ? $plan{"$r,$c"} : $areas++);

	$areatype{$thisa}=$m[$r][$c] unless (defined $areatype{$thisa});
	if(defined $areastart{$thisa}) {
		push(@{$areastart{$thisa}}, [$r,$c]);
	} else {
		$areastart{$thisa}=[ [$r,$c] ];
	}
	$arealist{$thisa}++;

	my @edge=(0,0,0,0);

	foreach my $d(0..(scalar @dir-1)) {
		my $nr=$r+$dir[$d][0];
		my $nc=$c+$dir[$d][1];

		if($nr<0 || $nr>=$h || $nc<0 || $nc>=$h) {
			$f++;
			$edge[$d]=1;
		} elsif($m[$nr][$nc] ne $m[$r][$c]) {
			$f++;
			$edge[$d]=1;
			if(!defined $added{"$nr,$nc"}) {
				push(@next, [$nr,$nc]) unless $fence{"$nr,$nc"};
			}
			$added{"$nr,$nc"}++;
		} else {
			unshift(@next, [$nr,$nc]) unless $fence{"$nr,$nc"};
			$plan{"$nr,$nc"}=$thisa;
		}
		# look for sides
	}
	$fence{"$r,$c"}=$f;
	$edges{"$r,$c"}=\@edge;
	$fencelist{$thisa}+=$f;
}

my $answer=0;

foreach my $ar(0..$areas-1) {
	printf("Area $ar - %s - %d * %d - %d\n", $areatype{$ar}, $arealist{$ar}, $fencelist{$ar}, $arealist{$ar}*$fencelist{$ar});
	$answer+=$arealist{$ar}*$fencelist{$ar};
}

print("Answer: $answer\n");

my $answer2=0;

foreach my $k(keys %areastart) {
	my @points=sort {$a->[0]*$w+$a->[1] <=> $b->[0]*$w+$b->[1] } @{$areastart{$k}};
	my $korners=0;

	printf("Area $k has %d squares, first is %d, %d\n", scalar @points, $points[0][0], $points[0][1]);

	for my $pt(@points) {
		my $corners=0;
		my $r=$pt->[0];
		my $c=$pt->[1];
		my $type=$m[$r][$c];

		# 0-top 1-right 2-bottom 3-left
		my @sides=@{$edges{"$r,$c"}};


		# Check for top-left inside corner
		if($sides[0] && $sides[3]) { $corners++; } 
		# Check for top-right inside corner

		if($sides[0] && $sides[1]) { $corners++; }
		# Check for bottom-right inside corner

		if($sides[2] && $sides[1]) { $corners++; }
		# Check for bottom-left inside corner

		if($sides[2] && $sides[3]) { $corners++; }

		# Check for an inside bottom-right or top-right corner
		if($sides[1] && $c<($w-1)) {
			if ($r<($h-1)) {
				if($m[$r+1][$c] eq $type && $m[$r+1][$c+1] eq $type) {
					$corners++;
				}
			}
			if ($r>0) {
				if($m[$r-1][$c] eq $type && $m[$r-1][$c+1] eq $type) {
					$corners++;
				}
			}
		}
		# Check for an inside bottom-left or top-left corner
		if($sides[3] && $c>0) {
			if ($r<($h-1)) {
				if($m[$r+1][$c] eq $type && $m[$r+1][$c-1] eq $type) {
					$corners++;
				}
			}
			if ($r>0) {
				if($m[$r-1][$c] eq $type && $m[$r-1][$c-1] eq $type) {
					$corners++;
				}
			}
		}
		print("Square $r, $c - $corners corners\n");
		$korners+=$corners;

	}

	printf("Area $k - %s - %d * %d - %d\n", $areatype{$k}, $arealist{$k}, $korners, $korners * $arealist{$k});

	$answer2+=$korners * $arealist{$k}
}

print("Answer 2: $answer2\n");