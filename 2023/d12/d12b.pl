#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw/sum/;

use Data::Dumper;

my @clumps;
my %memo;

my @plan = map {
	chomp;
	my ($p, $c)=split / +/;
	push(@clumps, [split /,/,($c.",") x 5]);
#	push(@clumps, [split /,/,$c ]);
#	[split //, $p]
	(($p."?") x 4).$p;
#	$p;
} <>;

sub matches {
	my $row=shift;
	my $ci=shift;
	my $pati=shift;
	my $answer=0;
	my $expr='[?#]{'.$clumps[$row][$ci].'}';

	printf("Matching row %d, clump %d , pos %d - %s - %s\n", $row, $ci, $pati, $plan[$row],$expr);
	if(exists $memo{"$row,$ci,$pati"}) {
		printf("Remember %d\n", $memo{"$row,$ci,$pati"});
		return $memo{"$row,$ci,$pati"};
	}


	foreach my $i ($pati..(length($plan[$row])-1)) {
		if(substr($plan[$row],$i,1) eq ".") {
			next;
		}
		if(substr($plan[$row],$i,$clumps[$row][$ci]) =~ /$expr/) {
			printf("Match clump $ci at $i: %s =~ %s\n", substr($plan[$row],$i,$clumps[$row][$ci]), $expr);
			my $next=$i+$clumps[$row][$ci];
			if($next==length($plan[$row]) || 
				substr($plan[$row],$next,1) =~ /[?.]/ ) {
				print("End or .\n");
				if($ci == (scalar @{$clumps[$row]})-1) {

					print ("Last clump - MATCH!\n");
					if(substr($plan[$row],$next) =~ /#/) {
						printf("Unconsumed hashes %s\n",substr($plan[$row],$next));
					} else {
						$answer=$answer+1;
					}
				} else {
					print("Find next clump\n");
					$answer=$answer + matches($row,$ci+1,$i+$clumps[$row][$ci]+1);	
				}
			}
		}
		last if(substr($plan[$row],$i,1) eq "#");
	}
	$memo{"$row,$ci,$pati"}=$answer;
	return $answer;
}

print Dumper \@plan;
print "\n";
print Dumper \@clumps;

my $answer;

foreach my $i (0..$#plan) {
	my $done=0;
	my $h=sum(@{$clumps[$i]});
	my $c=scalar @{$clumps[$i]};

	my $finished;
	
	$answer+=matches($i, 0, 0);
	printf("Answer so far: %d\n", $answer);

}

print("Answer is $answer\n");
