#!/usr/bin/perl

my $answer=0;

while ( <STDIN> ) {
	chomp;
	my $f=-1;
	my $l=-1;

	foreach $c (split //, $_) {
		if($c =~ /\d/) {
			if($f<0) { $f=$c ;}
			$l=$c;
		} 
	}
	printf("Line %s: First %s Last %s Score %d\n", $_, $f, $l, $f*10+$l);
	$answer+=($f*10)+$l;

}

printf("Answer is %d\n", $answer);