#!/usr/bin/perl

my %lc=();
my $tc=0; my $tcx=0;
my $gs=0;

while ($line=<STDIN>) {
	chomp $line;

	if($line eq '') {
		my $c=0; my $cx=0;

		foreach(keys %lc) {
			$c++; $tc++;
			if($lc{$_}==$gs) {$cx++; $tcx++;}
		}
		print "Group answers: $c, $cx\tGroup size: $gs\n";
		%lc=(); $gs=0;
	} else {
		for(my $i=0; $i<length($line); $i++) {
			$lc{substr($line, $i, 1)}++;
		}
		$gs++;
	}
}
print "Total cunt: $tc\tTotal fucking cunt: $tcx\n"