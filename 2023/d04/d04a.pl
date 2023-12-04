#!/usr/bin/perl

$answer=0;

map {
	chomp;
	my ($win, $num) = $_ =~ /.*: +([\d ]+) \| +([\d ]+)/;
	printf("Winners: %s, Chosen: %s | ", $win, $num);
	my @card=split / +/, $num;
	my $score=0;
	my %check={};
	foreach my $w (split / +/, $win) {
		my $match=0;
		foreach my $n (@card) {
			if($n == $w) {
				$check{$w}++;
				printf("%d(%d) ", $n,$check{$w});
				printf("Alert!!\n\n") if($check{$w}>1);
				$match=1;
				last;
			}
		}
		if($match) {
			if($score) {
				$score*=2;
			} else {
				$score=1;
			}
		}
	}
	$answer+=$score;
	printf("Score: %d So far: %d\n", $score, $answer)

} <>;

printf("Answer is %d\n", $answer);