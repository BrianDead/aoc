
#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $answer=0;
my @map;

sub arrcmp {
	my $a1=shift;
	my $a2=shift;
	my $s1=join("",@{$a1});
	my $s2=join("",@{$a2});

	print("Comparing $s1 and $s2\n");
	return ($s1 eq $s2);
}

sub linecmp {
	my $l1=shift;
	my $l2=shift;
	my $s1="";
	my $s2="";
	print("Comparing line $l1 and $l2 - ");

	foreach my $i (0..$#map) {
		$s1=$s1.$map[$i][$l1];
		$s2=$s2.$map[$i][$l2];
	}
	print"$s1 $s2\n";
	return ($s1 eq $s2);
}

sub readmap {
	my $m=shift;
	my $match=-1;
	my $h=(scalar @{$m});

	foreach my $i(0..$h-2) {
		if(arrcmp($m->[$i], $m->[$i+1])) {
			$match=($i+1)*100;
			foreach my $j(1..($i>($h-$i-2)?($h-$i-2):$i)) {
				if(!arrcmp($m->[$i-$j],$m->[$i+$j+1])) {
					$match=-1; last;
				}
			}
		}
		last if($match>0);
	}

	print("After rows: $match\n");

	if($match<0) {
		my $w=(scalar @{$m->[0]});
		print("Columns: $w\n");
		foreach my $i(0..$w-2) {
			if(linecmp($i, $i+1)) {
				$match=$i+1;
				foreach my $j(1..($i>($w-$i-2)?($w-$i-2):$i)) {
					if(!linecmp($i-$j, $i+$j+1)) {
						$match=-1; last;
					}
				}
			}
			last if($match>0);
		}
	}
	$match=0 if($match<0);
	$match
}

while(<>) {
	chomp;

	if($_ eq "") {
		my $a=readmap(\@map);
		foreach(@map) {
			foreach(@{$_}) {
				print $_;
			}
			print"\n";
		}
		$answer=$answer+$a;
		print "Score $a, Answer now $answer\n";
		@map=();
	} else {
		push(@map,[split //, $_]);
	}
}

my $a=readmap(\@map);

		foreach(@map) {
			foreach(@{$_}) {
				print $_;
			}
			print"\n";
		}
		$answer=$answer+$a;
		print "Score $a, Answer now $answer\n";
print("Answer is $answer\n");
