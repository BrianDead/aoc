#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @m=map{ chomp; [split / /] } <>;

my $answer=0;
my $answer2=0;

sub testreport {
	my @row=@_;
#	print Dumper \@row;
	my $tdir=0;
	my $good=1;

	for(my $i=1; $i<(scalar @row); $i++) {
		my $gap=$row[$i]-$row[$i-1];
		my $dir=$gap ? $gap/abs($gap) : 0;  # avoid div by 0
#		printf("Considering %d: %d %d: gap: %d dir: %d tdir:%d\n", $i, $row->[$i-1], $row->[$i], $gap, $dir, $tdir);
		$good=0 if(abs($gap)>3 || $gap==0);
		$good=0 if($i>1 && $dir != $tdir);
#		print("Good? $good\n");
		last if($good==0);
		$tdir=$dir;
	}

	return $good;
}


map {
	my $row=$_;
	my $tdir=0;
	my $good=1;
#	printf("Row length: %d\n", scalar @$row);

	$good=testreport(@$row);

	$answer+=$good;
	$answer2+=$good;

	if($good==0) {
		my $g1=0;
		for(my $skip=0; $skip<(scalar @$row); $skip++) {
			my @test=@$row;
			splice @test,$skip,1;
			$g1=testreport(@test);
			last if($g1);
		}
		$answer2+=$g1;
	}
} @m;

print("Answer: $answer\nAnswer2: $answer2\n");