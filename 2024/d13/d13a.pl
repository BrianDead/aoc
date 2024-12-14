#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my $count=0;
my @machines=();
my %tm;

while(<STDIN>) {
	chomp;
	my $button;
	my $x;
	my $y;

	if($_ eq '') {
		my %pm=%tm;
		push(@machines, \%pm);
	}
	if( ($button, $x, $y) = $_ =~ m/Button ([AB]): X\+([0-9]*), Y\+([0-9]*)/ ) {
#		print("Button $button - X+$x, Y+$y\n");
		$tm{$button}=[$x, $y];
	} elsif ( ($x, $y) = $_ =~ m/Prize: X=([0-9]*), Y=([0-9]*)/ ) {
#		print("Prize - X: $x, Y: $y\n");
		$tm{'p'}=[$x,$y];
	}

}
push(@machines, \%tm);

my $answer=0;

foreach(@machines) {
	my $X=$_->{'p'}->[0];
	my $Y=$_->{'p'}->[1];
	my $x1=$_->{'A'}->[0];
	my $y1=$_->{'A'}->[1];
	my $x2=$_->{'B'}->[0];
	my $y2=$_->{'B'}->[1];

	my $pressa=($X*$y2-$Y*$x2)/($x1*$y2-$x2*$y1);
	my $pressb=($Y*$x1-$X*$y1)/($x1*$y2-$x2*$y1);

	if($pressa==int($pressa) && $pressb==int($pressb)) {
		print("A=$pressa, B=$pressb ");
		printf("cost=%d\n", $pressa*3+$pressb*1);
		$answer+=$pressa*3+$pressb;
	} else {
		print("Impossible\n");
	}

} 

print("Answer: $answer\n");

my $answer2=0;

foreach(@machines) {
	my $X=$_->{'p'}->[0]+10000000000000;
	my $Y=$_->{'p'}->[1]+10000000000000;
	my $x1=$_->{'A'}->[0];
	my $y1=$_->{'A'}->[1];
	my $x2=$_->{'B'}->[0];
	my $y2=$_->{'B'}->[1];

	my $pressa=($X*$y2-$Y*$x2)/($x1*$y2-$x2*$y1);
	my $pressb=($Y*$x1-$X*$y1)/($x1*$y2-$x2*$y1);

	if($pressa==int($pressa) && $pressb==int($pressb)) {
		print("A=$pressa, B=$pressb ");
		printf("cost=%d\n", $pressa*3+$pressb*1);
		$answer2+=$pressa*3+$pressb;
	} else {
		print("Impossible\n");
	}

} 

print("Answer 2: $answer2\n");