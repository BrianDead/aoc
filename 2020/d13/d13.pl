#!/usr/bin/perl

$start=<STDIN>;
@buses=split /,/,<STDIN>;
my $best=-1;
my $bestbus=-1;

foreach(@buses) {
	if($_ > 0) {
		$wt=$_-($start % $_);
		if($wt<$best || $best<0) {
			$best=$wt;
			$bestbus=$_;
		}
	}
}

printf("Best bus is #%d in %d minutes. Answer=%d\n", $bestbus, $best, $best*$bestbus);
