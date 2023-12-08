#/usr/bin/perl

use Data::Dumper;

my @route=split //, <>;
pop(@route);
my %map;

my @nodes;
my %nodelist;

sub allzed {
	my $allz=1;
	foreach (@nodes) {
		if($_ =~ /..[^Z]/ ) {
			$allz=0; last;
		}
	}
	return $allz;
}

while(<>) {
	chomp;
	next if($_ eq "");
	my ($n, $l, $r)= $_ =~ /([A-Z12]+) = \(([A-Z12]+), ([A-Z12]+)\)/;
	$map{$n}={(R=>$r,L=>$l)};
	if($n =~ /..A/) {
		push (@nodes, $n); 
	}
}

print "Route\n";
print Dumper @route;
print "Map\n";
print Dumper \%map;
print "Nodes\n";
print Dumper @nodes;
print "Start\n";
my $answer=0;
my $rl=@route;
my $node='AAA';

do {
#	printf("Step %d node %s point %d turn %s\n", $answer, $node, $answer % $rl,$route[$answer % $rl]);
#	print Dumper \$map{$node};
	@nodes = map {
		$map{$_}{$route[$answer % $rl]}
	} @nodes;
	$answer++;
	print("$answer\n") if(!($answer%100000));
} while (!allzed());

print "Answer is $answer\n";