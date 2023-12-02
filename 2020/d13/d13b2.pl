#!/usr/bin/perl

$start=<STDIN>;
@buses=split /,/,<STDIN>;

my $tick=$buses[0];
my $inc=1;

for my $i (0..$#buses) {
	my $done=0;
	if($buses[$i] > 0) {
		do {
				printf("Step %d Bus %s Tick %d Increment %d Modulo %d\n", $i, $buses[$i], $tick, $inc, ($tick+$i) % $buses[$i]);
				if(($tick+$i) % $buses[$i] == 0) {
				$inc=$inc*$buses[$i];
				$done=1;
			} else {
				$tick+=$inc;
			}
		} while !$done;
	}
	printf("Step %d Bus %s Tick %d Increment %d\n", $i, $buses[$i], $tick, $inc);
}


printf("Answer=%d\n", $tick);
