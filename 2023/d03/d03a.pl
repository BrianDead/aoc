#!/usr/bin/perl

# Part one answer=525119  test=4361
# Part two answer=76504829  test=467835

my $answer=0;

my @in=map { chomp; [split //] } <>;

my %cogs={};
my $cogn={};

$h=@in;
$w=@{$in[0]};

printf("h=%d w=%d\n", $h, $w);

for $i (0..$h) {
	my $num=0;
	my $adj=0;
	for $j (0..$w) {
		if($in[$i][$j] =~ /\d/) {
			$num=$num*10+$in[$i][$j];
			for $ii (-1..1) {
				for $jj (-1..1) {
					if($in[$i+$ii][$j+$jj] =~ /[^.\d]/) {
						$adj=1;
					}
					if($in[$i+$ii][$j+$jj] eq "*") {
						$cogi=$i+$ii; $cogj=$j+$jj;
					}
				}
			}
		} 
		if($num && ($j==$w || $in[$i][$j+1] =~ /[^\d]/ )) {
			$answer+=$num if($adj);
			printf("Finished number %d - adj=%d - answer=%d\n", $num, $adj, $answer );
			if($cogi>0) {
				printf("Adjacent to cog at %s, %s\n", $cogi, $cogj);
				$cogn{"$cogi,$cogj"}++;
				if($cogn{"$cogi,$cogj"}==1) {
					$cogs{"$cogi,$cogj"}=$num;
				} else {
					$cogs{"$cogi,$cogj"}*=$num;
				}
			}
			$num=0;
			$adj=0;
			$cogi=0;
			$cogj=0;
		}
	}
}

printf("Answer is %d\n", $answer);

my $a2=0;

foreach $j (keys %cogn) {
	printf("Cog at %s, %d numbers", $j, $cogn{$j});
	if($cogn{$j}==2) {
		printf(" - good, adding %d ", $cogs{$j});
		$a2+=$cogs{$j};
	}
	printf(" - answer now %d\n", $a2);
}

printf("Answer 2 is %d\n", $a2);