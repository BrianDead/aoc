#!/usr/bin/perl

use strict;
use warnings;

my $ind=0;
my @onumbers=map { chomp; {i=>$ind++,v=>$_} }<STDIN>;


foreach my $x (@onumbers) {
	$x->{v} = $x->{v} * 811589153;
}

my @numbers=@onumbers;

foreach(1..10) {
	print("Mix $_\n");
	@numbers=mix(@numbers);
}

#pn(\@numbers);

my $answer=pick(1000,\@numbers)+ pick(2000,\@numbers)+pick(3000,\@numbers);

print "Answer is $answer\n";

sub pn {
	my @numbers=@{$_[0]};

	foreach(@numbers) {
		print "$_->{v} ";
	}
	print "\n";
}

sub mix {
	my $nn=scalar @onumbers;
	my @rnumbers=@_;

	foreach my $i(my @n=@onumbers) {
		my $i2move=-1;
		#find where the next item in the original list is now
		foreach my $v(0..(scalar @rnumbers)-1) {
			if($rnumbers[$v]->{i}==$i->{i}){
				$i2move=$v; last;
			}
		}
		die if $i2move<0;

		#move it v spaces
		splice @rnumbers,($nn-1+$i2move+$i->{v})%($nn-1),0,(splice @rnumbers,$i2move,1);
#		pn(\@rnumbers);
	}
	return @rnumbers;
}

sub pick {
	my $i=shift;
	my $na=shift;
	my @nums=@{$na};
#	print "\n"; pn(\@nums);
	my $n=0;
	my $nn=(scalar @nums);

	while ($n<($nn-1) && $nums[$n]->{v}!=0){ $n++; };

	my $p=($n+$i)%$nn;
	print "Found 0 at pos $n of $nn, add 1000 for pos $p = $nums[$p]->{v}\n";

	return $nums[$p]->{v};
}