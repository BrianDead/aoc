#/usr/bin/perl

use Data::Dumper;

my @route=split //, <>;
pop(@route);
my %map;
while(<>) {
	chomp;
	next if($_ eq "");
	my ($n, $l, $r)= $_ =~ /([A-Z]+) = \(([A-Z]+), ([A-Z]+)\)/;
	$map{$n}={(R=>$r,L=>$l)};
}

print Dumper @route;
print Dumper \%map;

my $answer=0;
my $rl=@route;
my $node='AAA';

do {
	printf("Step %d node %s point %d turn %s\n", $answer, $node, $answer % $rl,$route[$answer % $rl]);
	$node=$map{$node}{$route[$answer % $rl]};
	$answer++;
} while ($node ne "ZZZ");

print "Answer is $answer\n";