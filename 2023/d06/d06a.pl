#!/usr/bin/perl

use POSIX;

sub solve {
	my ($t, $d)=@_;
	my $x=int((-$t+sqrt($t**2 - (4*$d)))/-2)+1;
	return ($t-$x-($x-1));
}

my @in=map { chomp; [ split / +/, ($_ =~ /.*: +([ 0-9]+)/)[0] ] }<>;

my $answer=1;

for my $i (0..@{$in[0]}-1) {
	my $sol=solve($in[0][$i], $in[1][$i]);
	printf("Time %d, distance %d, x=%d, solutions %d\n", $in[0][$i], $in[1][$i], $x, $sol);
	$answer*=$sol;
}

printf("Answer 1 = %d\n",$answer);

my $t2=join('',@{$in[0]});
my $d2=join('',@{$in[1]});
printf("Time %d, distance %d, x=%d, answer 2 = %d\n", $t2, $d2, $x, solve($t2, $d2));