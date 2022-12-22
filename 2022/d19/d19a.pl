#!/usr/bin/perl

# Stage1: perl d19a.pl  1525.51s user 4.77s system 99% cpu 25:45.48 total
# Stage2: perl d19a.pl  2834.62s user 45.63s system 98% cpu 48:32.91 total

use strict;
use warnings;
use List::Util qw(max);
use Data::Dumper;

my %cache;

my @bp=map {
	chomp;
	my ($oro, $cro, $bro, $brc, $gro, $grb) =
		$_ =~ q/Each ore robot costs (\d*) ore.*clay robot costs (\d*) .*obsidian robot costs (\d*) ore and (\d*) cl.*geode robot costs (\d*) ore and (\d*) obsidian/;
		print("$oro, $cro, $bro, $brc, $gro, $grb\n");
	[$oro, $cro, $bro, $brc, $gro, $grb]	
} <STDIN>;

print Dumper \@bp;

my @ans=();

#Stage 1
#my $timelimit=24;

#Stage 2 - change timelimit and truncate input to 3 lines
my $timelimit=32;

my $maxg=0;

for my $bpi(0..(@bp-1)) {
	my %start= (
		"ocr"=>1,
		"ore"=>0,
		"ccr"=>0,
		"clay"=>0,
		"bcr"=>0,
		"obs"=>0,
		"gcr"=>0,
		"geodes"=>0,
		"bp"=>$bp[$bpi]
	);

	$ans[$bpi]=bestres(1, %start);
	printf("Answer %d is %d\n", $bpi+1,$ans[$bpi]);
	%cache=();
	$maxg=0;
}

my $answer;
foreach my $i (0..@ans-1) {
	$answer+=($i+1)*$ans[$i];
	printf("Plan %d Answer %d geodes\n", $i+1, $ans[$i]);
}
print("Answer=$answer\n");

sub build {
	my $t=shift;
	my $type=shift;
	my %state=@_;

	#Collect
	$state{"ore"}+=$state{"ocr"};
	$state{"clay"}+=$state{"ccr"};
	$state{"obs"}+=$state{"bcr"};
	$state{"geodes"}+=$state{"gcr"};

	#Build (& pay)
	if($type eq "ore") {
		$state{"ore"}-=$state{"bp"}->[0];
		$state{"ocr"}++;
	} elsif ($type eq "clay") {
		$state{"ore"}-=$state{"bp"}->[1];
		$state{"ccr"}++;
	} elsif ($type eq "obsidian") {
		$state{"ore"}-=$state{"bp"}->[2];
		$state{"clay"}-=$state{"bp"}->[3];
		$state{"bcr"}++;
	} elsif ($type eq "geode") {
		$state{"ore"}-=$state{"bp"}->[4];
		$state{"obs"}-=$state{"bp"}->[5];
		$state{"gcr"}++;
	}
	#or else nothing was built

	return bestres($t+1,%state);
}

sub bestres {
	my $t=shift;
	my %state=@_;

#	print $t."\n";

	if($t>$timelimit) {
#		print $t." - ".$state{"geodes"}."\n";
		$maxg=max($maxg, $state{"geodes"});
		return $state{"geodes"};
	}

	my $mposs=$state{"geodes"}+($state{"gcr"}*(($timelimit-$t)+1)+(($timelimit-$t)+1)*(($timelimit-$t)+2)/2);
	if($maxg>$mposs) {
#		print("Early out $t - $maxg vs $mposs\n") if($t<22);
		return $mposs;
	}

	my $hash=join("-",$t,$state{"ocr"},$state{"ore"},$state{"ccr"},$state{"clay"},$state{"bcr"},$state{"obs"},$state{"gcr"},$state{"geodes"});
	if(defined($cache{$hash})) {
#		print"Cache hit at $hash\n" if $t<15;
		return $cache{$hash};
	}


	#Phases:
	# Spend?
	# Collect
	# Build

	# Optimization - after finishing each robot, fork on plan to build next - jump state forward to when it's ready

	my @results=();

	if($t<$timelimit) {

		if($state{"obs"}>=$state{"bp"}->[5] && $state{"ore"}>=$state{"bp"}->[4] ) {
			push @results, build($t, "geode", %state);
		} 
		if($state{"clay"}>=$state{"bp"}->[3] && $state{"ore"}>=$state{"bp"}->[2]) {
			push @results, build($t, "obsidian",%state);
		}
		if($state{"ore"}>=$state{"bp"}->[1]) {
			push @results, build($t, "clay",%state);
		}
		if($state{"ore"}>=$state{"bp"}->[0]) {
			push @results, build($t, "ore",%state);
		}
	}
	# If we don't have enough ore to make the most expensive thing, we could wait
	if ($state{"ore"}<max($state{"bp"}->[0],$state{"bp"}->[1],$state{"bp"}->[2],$state{"bp"}->[4])
			|| $state{"clay"}<$state{"bp"}->[3] || $state{"obs"}<$state{"bp"}->[5] || $t==$timelimit) {
		push @results, build($t, "nothing", %state);
	}

	$cache{$hash}=max(@results);

	return max(@results);
}
