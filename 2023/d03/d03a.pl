#!/usr/bin/perl

# Part one answer=525119  test=4361
# Part two answer=76504829  test=467835

my $answer=0;

my @in=map { chomp; [split //] } <>;

my %cogs={};
my $cogn={};

my $h=@in;
my $w=@{$in[0]};

my @la=([-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]);

printf("h=%d w=%d\n", $h, $w);

for $i (0..$h) {
	my $num=0;
	my $adj=0;
	for $j (0..$w) {
		if($in[$i][$j] =~ /\d/) {
			$num=$num*10+$in[$i][$j];
			foreach $m (@la) {
				if($in[$i+@{$m}[0]][$j+@{$m}[1]] =~ /[^.\d]/) {
					$adj=1;
				}
				if($in[$i+@{$m}[0]][$j+@{$m}[1]] eq "*") {
					$cogi=$i+@{$m}[0]; $cogj=$j+@{$m}[1];
				}
			}
		} 
		if($num && ($j==$w || $in[$i+@{$m}[0]][$j+@{$m}[1]] =~ /[^\d]/ )) {
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