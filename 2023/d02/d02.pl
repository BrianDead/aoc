#!/usr/bin/perl
use Data::Dumper;


my $mr=12;
my $mg=13;
my $mb=14;
my $score=0;

sub checkposs {
	my ($r)= $_[0] =~ /(\d+) red/;
	my ($g)= $_[0] =~ /(\d+) green/;
	my ($b)= $_[0] =~ /(\d+) blue/;
	printf("%d red %d blue %d green", $r, $b, $g);
	return ($r<=$mr & $g<=$mg & $b<=$mb);
}

while (<>) {
	$poss=1;
	print $_;
	my ($game,$sets) = $_=~ /Game (\d+): (.*)/;
	my @set=split /;/,$sets;

	foreach my $i(0..$#set) {
		if(!checkposs($set[$i])) {
			printf(" Impossible\n");
			$poss=0;
			last;
		} else {
			printf(" Possible\n");
		}
	}
	printf("Poss=%d game=%d\n", $poss, $game);
	$score+=$game*$poss;
}

print "Answer is $score\n";	

	
