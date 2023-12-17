#!/usr/bin/perl

use strict;
use warnings;

sub hashof {
	my @str=split //, shift;
	my $cv=0;

	foreach(@str) {
		$cv+=ord($_);
		$cv=$cv*17;
		$cv=$cv % 256;
	}
	return $cv;
}


chomp(my $line=<>);
my @sequence=split ",", $line;

my $answer=0;

foreach(@sequence) {
	print("$_\n");
	$answer+=hashof($_);
}
print "Answer: $answer\n";