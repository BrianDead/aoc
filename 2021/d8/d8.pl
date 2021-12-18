#!/usr/bin/perl

use Data::Dumper;

my @digits=("abcefg","cf","acdeg","acdfg","bcdf","abdfg","abdefg","acf","abcdefg","abcdfg");
my %d;
#               2  4  3  7   6  6  6   5  5  5
# a appears in !1 !4  7  8   0  6  9   2  3  5  = 7
# b appears in !1  4 !7  8   0  6  9  !2 !3  5  = 6
# c appears in  1  4  7  8   0 !6  9   2  3 !5  = 7
# d appears in !1  4 !7  8  !0  6  9   2  3  5  = 6
# e appears in !1 !4 !7  8   0  6 !9   2 !3 !5  = 4
# f appears in  1  4  7  8   0  6  9  !2  3  5  = 8
# g appears in !1 !4 !7  8   0  6  9   2  3  5  = 6

# 0 if it has 6 letters and not d (the missing letter appears in the 4 letter group but not 2 or 3)
# 1 if it has 2 letters
# 2 if it has 5 letters and not b or f (one missing letter is in the 2 group, the other is in the only in the 4 group)
# 3 if it has 5 letters and not b or e (neither missing letter is in the 2 group)
# 4 if it has 4 letters
# 5 if it has 5 letters and not c or e (one missing letter is in the 2 group and the other is not in the 2,3 or 4 group)
# 6 if it has 6 letters and not c (the missing letter appears in the 2, 3 and 4 letter combinations)
# 7 if it has 3 letters
# 8 if it has 7 letters
# 9 if it has 6 letters and not e (the missing letter does not appear in the 2,3 or 4 letter combination)

my @letters=('a','b','c','d','e','f','g');

my $i=0;
foreach(@digits) {
	$d{$_}=$i++;
}

my %map;
my $d=1;
foreach(@digits) {
	my $ll=length($_);
	for(my $i=0; $i<$ll; $i++) {
		$map{substr($_, $i, 1)}++;
	}
}
my $count=0;
my $answer=0;
my $answer2=0;

while(my $line=<STDIN>) {
	chomp $line;
	my @sorted;
	my @input= $line=~ q/([a-z ]*)\|([a-z ]*)/;
	print "@input\n";

	my @ten=split / /, $input[0];
	my $num=@ten;
	print "$num - @ten\n";
	for(my $j=0; $j<$num; $j++) {
		$sorted[$j]=(join '', sort { $a cmp $b } split(//, $ten[$j]));
		my $len=length($sorted[$j]);
		if($len==2) {
			$output[1]=$sorted[$j];
		}
		if($len==4) {
			$output[4]=$sorted[$j];
		}
		if($len==3) {
			$output[7]=$sorted[$j];
		}
		if($len==7) {
			$output[8]=$sorted[$j];
		}
	}

	my @four=split / /, $input[1];
	my $value=0;
	my $base=1000;
	foreach(@four) {
		next if($_ eq '');
		print "$_ ";
		my $len=length($_);
		my $pattern=$_;
		if ($len==2 || $len==4 || $len==3 || $len==7) {$answer++; print" Yes ";}

		my $digit;

		if ($len==2) {
			$digit=1;
		} elsif ($len==3) {
			$digit=7;
		} elsif ($len==4) {
			$digit=4;
		} elsif ($len==5) {
			my @missing;
			foreach(@letters) {
				push @missing, $_ if(!($pattern =~ $_));
			}

			if($output[1] =~ $missing[0]) {
				if($output[4] =~ $missing[1]) {
					$digit=2;
				} else {
					$digit=5;
				}
			} elsif($output[1] =~ $missing[1]) {
				if($output[4] =~ $missing[0]) {
					$digit=2;
				} else {
					$digit=5;
				}
			} else {
				$digit=3;
			}
		} elsif ($len==6) {
			my $missing;
			foreach(@letters) {
				$missing=$_ if(!($pattern =~ $_));
			}

			if($output[4] =~ $missing) {
				if($output[1] =~ $missing) {
					$digit=6;
				} else {
					$digit=0;
				}

				} else {
					$digit=9;
				}
		} elsif($len==7) {
			$digit=8;
		} else { print "Weird";}
		$value+=$digit*$base;
		$base/=10;
	}
	$answer2+=$value;
	print"\nValue: $value\n";

	$count++;
}

print "Answer: $answer (Count: $count)\n";
print "Answer2: $answer2\n"