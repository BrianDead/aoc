#!/usr/bin/perl

use strict;
use warnings;

my $ind=0;
my @numbers=map { chomp; {i=>$ind++,v=>$_} }<STDIN>;

mix();

#pn();

my $answer=pick(1000,\@numbers)+ pick(2000,\@numbers)+pick(3000,\@numbers);

print "Answer is $answer\n";

sub pn {
	foreach(@numbers) {
		print "$_->{v} ";
	}
print "\n";
}

sub mix {
	my $nn=scalar @numbers;

	foreach my $i(my @n=@numbers) {
		my $i2move=-1;
		#find where the next item in the original list is now
		foreach my $v(0..(scalar @numbers)-1) {
			if($numbers[$v]->{i}==$i->{i}){
				$i2move=$v; last;
			}
		}
		die if $i2move<0;

		#move it v spaces
		splice @numbers,($nn-1+$i2move+$i->{v})%($nn-1),0,(splice @numbers,$i2move,1);
#		pn();
	}
}

sub pick {
	my $i=shift;
	my $na=shift;
	my @nums=@{$na};
	my $n=0;
	my $nn=(scalar @nums);

	while ($n<($nn-1) && $nums[$n]->{v}!=0){ $n++; };

	my $p=($n+$i)%$nn;
	print "Found 0 at pos $n of $nn, add 1000 for pos $p = $nums[$p]->{v}\n";

	return $nums[$p]->{v};
}