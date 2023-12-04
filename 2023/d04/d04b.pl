#!/usr/bin/perl

my $answer=0;
my $answer2=0;
my %p2={};

map {
	chomp;
	my ($card, $win, $num) = $_ =~ /Card +(\d+): +([\d ]+) \| +([\d ]+)/;
	printf("Card %d: Winners: %s, Chosen: %s | ", $card, $win, $num);
	my @card=split / +/, $num;
	my $score=0;
	$p2{$card}++;

	foreach my $w (split / +/, $win) {
		my $match=0;
		foreach my $n (@card) {
			if($n == $w) {
				printf("%d ", $n);
				$match=1;
				last;
			}
		}
		$score++ if($match);
	}
	$answer+=(2**($score-1)) if($score>0);

	foreach my $nx (($card+1)..($card+$score)) {
		$p2{$nx}+=$p2{$card};
	}
	printf("Score: %d So far: %d\n", $score, $answer)

} <>;

printf("Answer is %d\n", $answer);
foreach my $k (keys %p2) {
	$answer2+=$p2{$k};
}
printf("Answer 2 is %d\n", $answer2);