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

#print "Route\n";
#print Dumper @route;
#print "Map\n";
#print Dumper \%map;
#print "Nodes\n";
#print Dumper @nodes;
my $answer=0;
my $rl=@route;
my $node='AAA';
my @memo;

foreach (@nodes) {
	my %h; my @a;
	$h{"Z"}=\@a;
	push (@memo, \%h);

}

print "Start\n";

do {
#	printf("Step %d node %s point %d turn %s\n", $answer, $node, $answer % $rl,$route[$answer % $rl]);
#	print Dumper \$map{$node};
	my $i=0; my $s=$answer % $rl;
	@nodes = map {
		my $n=$_;
		my $hash="$n,$s";

		if(! ($memo[$i]->{"done"})) {
			if($memo[$i]->{"rpts"}) {
				if($n =~ /..Z/ ) {
					push(@{$memo[$i]->{"Z"}}, $answer-$memo[$i]->{"rpts"});
				}
			}

			if($memo[$i]->{$hash}) {
#				printf("%s\n", $hash);
				if($hash eq $memo[$i]->{"rpt"}) {
					printf("Second time round for %d at %d\n", $i, $answer);
					printf("rpt=%s\nrpts=%d\ncycle=%d\nZ at %d\n", $memo[$i]->{"rpt"}, $memo[$i]->{"rpts"},
						 $memo[$i]->{"cycle"}, $memo[$i]->{"Z"}->[0]);
					print Dumper $memo[$i]->{'Z'};
					print "\n";
					$memo[$i]->{"done"}=1;
				} elsif(!$memo[$i]->{"rpts"}) {
					$memo[$i]->{"rpt"}=$hash;
					$memo[$i]->{"rpts"}=$answer;
					$memo[$i]->{"cycle"}=$answer-$memo[$i]->{$hash};
					printf("Path %d cycled at t=%d (step %d) Last visit at t=%d\n", $i, $answer, $s,$memo[$i]->{$hash});
				}
			} else {
				$memo[$i]->{"$n,$s"}=$answer;
			}
		}
		$i++;
		$map{$n}{$route[$s]}
	} @nodes;
	$answer++;
	print("$answer\n") if(!($answer%1000000));
} while (!allzed());

print "Answer is $answer\n";