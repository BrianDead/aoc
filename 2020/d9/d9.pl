#!/usr/bin/perl

use List::Util qw(sum min max);

my @data;
my @databank;
my $count=0;
my $lim=25;
my $answer;

while(my $num=<STDIN>) {
	chomp $num;
	push @data, $num;
	push @databank, $num;
	if ($#data>($lim-1)) {
		my $match=0;
		foreach $i (0..($lim-2)) {
			foreach $j ($i+1..($lim-1)) {
#				my $sum=$data[i]+$data[j];
#				print("$data[i]+$data[j]=$sum\n");
				if(($data[$i]+$data[$j])==$data[$lim] && ($data[$i]!=$data[$j])) {
					$match=1; last;
				}
			}
			last if($match);
		}
		print("Number $count: $data[$lim] - ");
		printf("%s\n", $match? "Match" : "No match");
		last unless($match);
		shift @data;
	}
	$count++;
}

print "Answer: $data[$lim]\n";
$answer=$data[$lim];
my @testset;

foreach $h (0..$#databank) {
	@testset=$databank[$h];

	foreach $i ($h+1..$#databank) {
		push @testset, $databank[$i];
		last if(sum(@testset)>=$answer);
	}
	last if(sum(@testset)==$answer);
}

if(sum(@testset)==$answer) {
	my $a1=min(@testset);
	my $a2=max(@testset);

	print "Answer2: $a1 + $a2 = ".($a1+$a2)."\n";
} else {
	print "No answer\n";
}
