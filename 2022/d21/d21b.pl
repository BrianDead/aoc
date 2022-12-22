#!/usr/bin/perl

use strict;
use warnings;

# perl d21b.pl  0.39s user 0.01s system 96% cpu 0.418 total

my %mn=map { chomp; 
		my ($n, $op)=split ": ";my $v; my ($x, $s, $y);
		if($op =~ q/\d/) {
				$v=$op+0;
			} else {
				($x, $s, $y)=split / /,$op;
			}
			($n=>{"op"=>$op, "val"=>$v, x=>$x, y=>$y, sign=>$s} ) 
		} <STDIN> ;

my $answer=0;
my $done=0;
my $success=0;
my @l=(); my @r=();
my $inc=1;
my $steps=0; my $avg=0; my $sum=0;
my $jump=0;

do {
	($l[0], $r[0], $success )=checknum($answer,copy(\%mn));

	if(!$success) {

		 if(defined($l[1])) {
		 	my $step=($l[0]-$l[1]);
		 	if(abs($inc)==1) {
			 	$sum+=$step;
			 	$avg=$sum/++$steps;
			}
			if($steps==10) {
			 	$jump=int(($l[0]-$r[0])/(0-$avg));
			 }
		 	printf("Step # %d, Step is %d, Jump %d, Avg=%f - right=%d left=%d diff=%d \n", $steps, $step, $jump, $avg, $r[0], $l[0], $l[0]-$r[0]);
		}
		if($jump) {
			$inc=$jump; $jump=0;
		} elsif($r[0]>$l[0]) {
			$inc=-1;
		} else {
			$inc=1;
		}

		$answer+=$inc;
		$l[1]=$l[0]; $r[1]=$r[0];
	}
} while (!$success);

print "Answer is $answer\n";

sub copy {
	my $old=shift;
	my %new=();

	foreach my $k(keys %{$old} ) {
		my %ent=%{$old->{$k}};
		$new{$k}=\%ent;
	}
	return \%new;
}

sub checknum {
	my $test=shift;
	my %mnet=%{(shift)};

	$mnet{humn}{val}=$test;

	while(!defined($mnet{"root"}{"val"})) {
		foreach my $k (keys %mnet) {
			next if(defined($mnet{$k}{"val"}));

			if(defined($mnet{$mnet{$k}{x}}{val}) && defined($mnet{$mnet{$k}{y}}{val})) {
				$mnet{$k}{"val"}=eval("(".$mnet{$mnet{$k}{x} }{val}.")".$mnet{$k}{sign}."(".$mnet{$mnet{$k}{y}}{val}.")");
#				printf("%s: %s (%d) %s %s (%d) = %d\n", $k, $mnet{$k}{x}, $mnet{$mnet{$k}{x}}{val}, $mnet{$k}{sign}, $mnet{$k}{y}, $mnet{$mnet{$k}{y}}{val}, $mnet{$k}{val});
			}
		}
	}

	printf("Humn= %d - Answer is %d==%d: %s\n", $test, $mnet{$mnet{root}{x}}{"val"}, $mnet{$mnet{root}{y}}{val},
		$mnet{$mnet{root}{x}}{val}==$mnet{$mnet{root}{y}}{val}?"SUCCESS":"FAILURE");

	return ($mnet{$mnet{root}{x}}{"val"}, $mnet{$mnet{root}{y}}{"val"}, $mnet{$mnet{root}{x}}{"val"}==$mnet{$mnet{root}{y}}{"val"});
}