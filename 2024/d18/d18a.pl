#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
my %direction=(
	'n'=>[-1,0],
	'w'=>[0,-1],
	's'=>[1,0],
	'e'=>[0,1]
	);

my $bytestofall=1024;
my $mx=70;
my $my=70;

my $bc=0;

my @m=map{ [ ('.') x ($mx+1)] } (0..$my);

while(<STDIN> ) {
	chomp;
	my ($x, $y)=split /,/ ;
	$m[$y][$x]='#';
	last if($bc++ >= $bytestofall);
} 

foreach(@m) {
	foreach(@{$_}) {
		print("$_");
	}
	print("\n");
}

printf("Answer 1: %d", navigate(@m));

while(<STDIN>) {
	chomp;
	my($x, $y)=split /,/ ;
	$m[$y][$x]='#';
	my $r=navigate(@m);
	print("$x,$y - $r\n", );
	last if($r<0);

}


sub navigate {
	my @m=@_;

	my @candidates=();
	my %visited=();

	push(@candidates, [0, 0, 0]);

	my $answer=-1;

	while(@candidates) {
		my $cm=shift(@candidates);
		my $cc=$cm->[0];
		my $cy=$cm->[1];
		my $cx=$cm->[2];

		next if($visited{"$cy,$cx"});

#		print("Check $cy, $cx ($cc)\n");

		if($cy==$my && $cx==$mx) {
#			printf("Answer is: %d\n", $cm->[0]);
			$answer=$cm->[0];
			last;
		}

		foreach my $d(keys %direction) {
			my $ny=$cy+$direction{$d}->[0];
			my $nx=$cx+$direction{$d}->[1];

			next if($ny<0 || $ny>$my || $nx<0 || $nx>$mx);

			next if( ($m[$ny][$nx] eq '#') || (defined $visited{"$ny,$nx"}) );

			my $nc=$cm->[0]+1;
#			print("Pushing $ny, $nx ($nc)\n");
			push(@candidates, [$nc, $ny, $nx]);
		}

		if(!defined $visited{"$cy,$cx"}) {
			$visited{"$cy,$cx"}=$cc;
		} elsif($visited{"$cy,$cx"}>$cc) {
			$visited{"$cy,$cx"}=$cc;
		}
		@candidates=sort {$a->[0]<=>$b->[0]} @candidates;
	}
	return $answer;
}