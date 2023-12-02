#!/usr/bin/perl
use Data::Dumper;

my $score=0;


while (<>) {
	print $_;
	my ($game,$sets) = $_=~ /Game (\d+): (.*)/;
	my @set=split /;/,$sets;

	my $rr=0;
	my $rg=0;
	my $rb=0;

	foreach my $i(0..$#set) {
		my ($r)= $set[$i] =~ /(\d+) red/;
		my ($g)= $set[$i] =~ /(\d+) green/;
		my ($b)= $set[$i] =~ /(\d+) blue/;
		printf("%d red %d blue %d green\n", $r, $b, $g);
		$rr=($r>$rr)?$r:$rr;
		$rg=($g>$rg)?$g:$rg;
		$rb=($b>$rb)?$b:$rb;
	}
	printf("rr=%d rg=%d rb=%d power=%d\n", $rr, $rg, $rb, $rr*$rg*$rb);
	$score+=$rr*$rg*$rb;
}

print "Answer is $score\n";	

	
