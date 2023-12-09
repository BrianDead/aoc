#!/usr/bin/perl
use List::Util qw/sum/;
use Data::Dumper;

my $answer=0;
my $answer2=0;

my @readings=map { chomp; [split / +/]} <>;

#print Dumper @readings;

foreach my $l (@readings) {
	my @line=@{$l};
	my @seq;
	push(@seq, $l);
	my $done=0;
	do {
		my @int;
		foreach my $i (0..$#line-1) {
			push(@int, $line[$i+1]-$line[$i]);
		}
		unshift(@seq, \@int);
		
		@line=@int;

	} until (sum(@line)==0);

	push(@{$seq[0]},0);
	foreach my $i (1..$#seq) {
		push(@{$seq[$i]}, $seq[$i][-1]+$seq[$i-1][-1]);
	}
#	print "New sequence\n";
#	print Dumper \@seq;
	$answer+=$seq[-1][-1];

	unshift(@{$seq[0]},0);
	foreach my $i (1..$#seq) {
		unshift(@{$seq[$i]}, $seq[$i][0]-$seq[$i-1][0]);
	}
	$answer2+=$seq[-1][0];


}

print "Answer is $answer\n";
print "Answer 2 is $answer2\n";
