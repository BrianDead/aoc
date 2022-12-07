#!/usr/bin/perl

my @nums;

while(my $num=<STDIN>) {
	chomp $num;
	my $max3=-1;

	foreach(@nums) {
		my $n1=$_;
		if ($num+$_==2020) {
			my $answer=$num*$_;
			print "Answer: $answer ($num x $_)\n";
		}
		if ($num+$_<2020) {
			for(my $i=0; $i<$max3; $i++) {
#				print "Try $num+$n1+$nums[$i]\n";
				if($num+$n1+$nums[$i] == 2020) {

					my $answer2=$num*$n1*$nums[$i];
					print "Answer2: $answer2 ($num x $n1 x $nums[$i])\n";
				}

			}
		}
		$max3++;
	}
	push @nums, $num;
}


