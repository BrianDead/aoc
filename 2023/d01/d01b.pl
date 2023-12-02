#!/usr/bin/perl

# results: a1=54304 a2=54418

my $answer1=0;
my $answer2=0;

my @num= qw(zero one two three four five six seven eight nine);

while ( <STDIN> ) {
	chomp;
	my $f1=-1;
	my $l1=-1;
	my $f2=-1;
	my $l2=-1;

	my $line=$_;

	my $i=0;
	do {
		my $d=-1;
		my $dw=-1;
		if(substr($line, $i, 1) =~ /\d/ ) {
			$d=substr($line,$i,1);
		} else {
			for my $j (0..$#num) {
				if(substr($line, $i, length($num[$j])) eq $num[$j]) {
					$dw=$j;
#					$i+=length($num[$j])-1;
					last;
				}
			}
		}

		if($d>0) {
			$f1=$d if($f1<0);
			$f2=$d if($f2<0);
			$l1=$d;
			$l2=$d;
		} 
		if($dw>0) {
			$f2=$dw if($f2<0);
			$l2=$dw;
		}
		$i++;
	} while $i<length($line);
	$answer1+=($f1*10)+$l1;
	$answer2+=($f2*10)+$l2;
	printf("Line %s: f1 %s l1 %s S1 %d a1: %d; f2 %s l2 %s S2 %d a2: %d\n",
		 $line, $f1, $l1, ($f1*10)+$l1, $answer1,
		 	$f2, $l2, $f2*10+$l2, $answer2);

}

printf("Answer1 is %d\n", $answer1);
printf("Answer2 is %d\n", $answer2);