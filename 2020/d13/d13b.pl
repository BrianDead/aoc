#!/usr/bin/perl

$start=<STDIN>;
@buses=split /,/,<STDIN>;

my $done=0;
my $tick=$buses[0];
my $inc=1;

do {
	$tock=$tick;
	$done=1;
	$inc=1;

	foreach(@buses) {
		if($_ > 0) {
			if($tock % $_ == 0) {
			$inc=$inc*$_;
			} else {
				$done=0;
				last;
			}
		}
		$tock++;
	}
	printf("Tick %d Increment %d\n", $tick, $inc);
	$tick+=$inc;
} while !$done;
$tick-=$inc;

printf("Answer=%d\n", $tick);
