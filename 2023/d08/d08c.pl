#/usr/bin/perl

use Data::Dumper;
#use bignum;

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
	$allz
}

sub lcm {
	use integer;
	my ($x, $y) = @_;
	my ($f, $s) = @_;
	while ($f != $s) {
		($f, $s, $x, $y) = ($s, $f, $y, $x) if $f > $s;
		$f = $s / $x * $x;
		$f += $x if $f < $s;
	}
	$f
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

my $answer=0;
my $rl=@route;
my $node='AAA';
my @memo;
my $done;
my @history;

foreach (@nodes) {
	my %h; my @a; my @b;
	$h{"Z"}=\@a;
	push (@memo, \%h);
	push (@history, \@b);
}

print "Start\n";
my $minz=0;
my $minzn=-1;

do {
	my $i=0; my $s=$answer % $rl;
	@nodes = map {
		my $n=$_;
		my $hash="$n,$s";

		if(! ($memo[$i]->{"done"})) {

			if($memo[$i]->{$hash}) {
				$memo[$i]->{"rpt"}=$hash;
				$memo[$i]->{"rpts"}=$answer;
				$memo[$i]->{"cycle"}=$answer-$memo[$i]->{$hash};
				$memo[$i]->{"start"}=$memo[$i]->{$hash};
				printf("Path %d cycled at t=%d (step %d) Last visit at t=%d\n", $i, $answer, $s,$memo[$i]->{$hash});
				printf("   Cycle=%d Start=%d\n", $memo[$i]->{"cycle"}, $memo[$i]->{"start"});
				$done++;
				$memo[$i]->{"done"}=1;
			} else {
				$memo[$i]->{"$n,$s"}=$answer;
				push(@{$history[$i]}, $n); 
				if($n =~ /..Z/ ) {
					push(@{$memo[$i]->{"Z"}}, $answer-$memo[$i]->{"rpts"});
					if(!$minz) {
						$minz=$answer; $minzn=$i;
					}
				}
			}
		}
		$i++;
		$map{$n}{$route[$s]}
	} @nodes;
	$answer++;
	print("$answer\n") if(!($answer%1000000));
} while (!allzed() && !($done == scalar @nodes));

my @click= qw/0 0 0 0 0 0/;
$done=0;

if(!allzed()) {
	my $inc=1;
	$answer=$minz;
	$inc=$memo[$minzn]->{"cycle"};
	printf("Starting at point %d, %d\n", $answer, $inc);
	do {
		my @points;
		foreach my $i (0..$#nodes) {
			next if($click[$i]);
			my $pih=(($answer-$memo[$i]->{"start"})%$memo[$i]->{"cycle"})+$memo[$i]->{"start"} ;
#			printf("path %d answer %d point %d is %s\n", $i, $answer, $pih, $history[$i][$pih]);
			if($history[$i][$pih] =~ /..Z/ ) {
				$click[$i]=1; $done++; 
				$inc=lcm($inc,$memo[$i]->{"cycle"});
				printf("Click!!! %d done - inc now %d\n", $done, $inc);
			}
		}
		$answer+=$inc;
	} while (!($done== scalar @nodes));
	$answer-=$inc;
}
printf("Answer is %s\n", $answer);
