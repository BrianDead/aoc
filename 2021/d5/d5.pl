#!/usr/bin/perl

my @space;

while (my $line=<STDIN>) {
	chomp $line;
	my @points= $line =~ q/([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)/;

	if($points[0]==$points[2]) {
		print "Horizontal: $points[0],$points[1] -> $points[2],$points[3]\n";
		my $left=($points[1]<$points[3])?$points[1]:$points[3];
		my $right=($points[1]<$points[3])?$points[3]:$points[1];
		for(my $i=$left; $i<=$right; $i++) {
			$space[$points[0]][$i]++;
			if($space[$points[0]][$i] > 1) {
				print "Cross $space[$points[0]][$i] at $points[0],$i\n"
			}
		}
	} elsif($points[1]==$points[3]) {
		print "Vertical: $points[0],$points[1] -> $points[2],$points[3]\n";
		my $bottom=($points[0]<$points[2])?$points[0]:$points[2];
		my $top=($points[0]<$points[2])?$points[2]:$points[0];
		for(my $i=$bottom; $i<=$top; $i++) {
			$space[$i][$points[1]]++;
			if($space[$i][$points[1]] > 1) {
				print "Cross $space[$i][$points[1]] at $i,$points[1]\n"
			}
		}
	} else {
		my $dy=1; my $dx=1;
		print "Diagonal: $points[0],$points[1] -> $points[2],$points[3]\n";
		if($points[2]<$points[0]) {
			$dy=-1;
		}
		if($points[3]<$points[1]) {
			$dx=-1;
		}

		for(my $i=0; ; $i++) {
			my $x=$points[1]+($i*$dx); my $y=$points[0]+($i*$dy);
			$space[$y][$x]++;
			if($space[$y][$x] > 1) {
				print "Cross $space[$y][$x] at $y,$x\n";
			}
			last if ($y==$points[2]);
		}
	}

}

my $height=@space;
my $crosses=0;

foreach(@space) {
	foreach(@{$_}) {
		$crosses++ if($_>1);
	}
}

print "Crosses: $crosses\n";