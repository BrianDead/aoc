#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $answer=0;
my $answer1=0;

my @list;

while(<STDIN>) {
	push(@list, ( $_ =~ m/(mul\([0-9]{1,3},[0-9]{1,3}\)|do(?:n't)?\(\))/g ));

#	my @list= ( $_ =~ m/mul\(([0-9]{1,3}),([0-9]{1,3})\)/g );
}

my $do=1;

while(@list) {
	my $next=shift(@list);
	if($next eq "do()") {
		$do=1 ;
	} elsif($next eq "don't()") {
		$do=0 ;
	} else {
		my ($n1,$n2) = $next =~ m/mul\(([0-9]{1,3}),([0-9]{1,3})\)/;
		$answer+=$n1 * $n2;
		$answer1+= $n1 * $n2 if($do);
	}	
}

print "Answer: $answer\n";
print "Answer: $answer1\n";


