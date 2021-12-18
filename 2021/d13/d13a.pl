#!/usr/bin/perl

use Data::Dumper;

my @dots=();

while(my $line=<STDIN>) {
    chomp $line;
    last if($line eq "");
    if (my @pos= $line=~ q/([0-9]*),([0-9]*)/) {
        push @dots, {'x'=>$pos[0], 'y'=>$pos[1]};
    }
}

printf "Starting dots: %d\n", (0+@dots);

while(my $line=<STDIN>) {
	chomp $line;
	my %dupes=();
    my @fold= $line =~ q/fold along ([xy])=([0-9]*)/;

    print "Fold $fold[0] -- $fold[1]\n";

    my $other='x';

    if($fold[0] eq 'x') { $other='y'; }

	@dots=grep { !($dupes{"$_->{'x'},$_->{'y'}"}++) }
			map { 
				my %dot=%{$_}; my %ret; 
				if($dot{$fold[0]}>$fold[1]) {
					$dot{$fold[0]}=$fold[1]*2-$dot{$fold[0]};
				}
				\%dot
	} grep { my %dot=%{$_}; $dot{$fold[0]}!=$fold[1] } @dots;

	printf "New dots: %d\n", (0+@dots);
}

my @pat=();
my $maxx=0; my $maxy=0;

foreach (@dots) {
	my %dot=%{$_};
#	print "X: $dot{'x'} Y: $dot{'y'}\n";
	$pat[$dot{'x'}][$dot{'y'}]='#';
	$maxx=$dot{'x'} if($dot{'x'}>$maxx);
	$maxy=$dot{'y'} if($dot{'y'}>$maxy);
}

foreach $y (0..$maxy) {
	foreach $x (0..$maxx) {
		if($pat[$x][$y] eq '#') {
			print "\e[43m#\e[0m";
		} else {
			print '.';
		}
	}
		print "\n";
}

