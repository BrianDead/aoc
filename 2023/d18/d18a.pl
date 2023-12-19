use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);

my %v=(R => [0,1], L => [0,-1], U => [-1,0], D => [1,0]);

my @map;
my @p=(0,0);
my @lim=(0,0);

sub insrow {
	unshift (@map, [map { '.' } 0..$lim[1]]);
	$lim[0]++;
}


sub addrow {
	push (@map, [map { '.' } 0..$lim[1]]);
	$lim[0]++;
}

sub inscol {
	foreach (@map) {
		unshift(@{$_},'.');
	}
	$lim[1]++;
}


sub addcol {
	foreach (@map) {
		push(@{$_},'.');
	}
	$lim[1]++;
}

while (<>) {
	chomp;
	my($dir, $l, $col)= $_ =~ /([RLDU]) ([0-9]+) \((\#[0-9a-f]{6})/;

	foreach my $i (1..$l) {
		@p=map { $p[$_] + $v{$dir}->[$_]} 0..1;
		if($p[0]<0) {insrow(); $p[0]=0; } 
		if($p[1]<0) {inscol(); $p[1]=0; }
		if($p[0]>$lim[0]) { addrow(); }
		if($p[1]>$lim[1]) { addcol(); }
		$map[$p[0]][$p[1]]=$col;
	}

}

foreach (@map) {
	foreach (@{$_}) {
		if($_ eq '.') {
			print $_;
		} else {
			print '#';
		}
	}
	print "\n";
}

my $y=0;

my $answer=reduce { $a+$b } map { 
			my $in=0;
			my $on=0;
			my $row=$_;

			reduce { $a+$b } 
				my @rm=map { 
					my $r; 
					
					if($map[$y][$_] eq '.') { 
						if($on!=0) {
							if( ($on==1) && $y>0 && $map[$y-1][$_-1] ne '.') {
								$on=0;
							}
							if( ($on==2) && $y<$lim[0] && $map[$y+1][$_-1] ne '.') {
								$on=0;
							}
						}
						$in=($on)?(!$in):($in);
						$on=0;
						$r= $in?1:0; 
					} else {
						if($on==0) {
							if( $y>0 && $map[$y-1][$_] ne '.') {
								$on=1;
							}
							if($y<$lim[0] && $map[$y+1][$_] ne '.') {
								$on+=2;
							}
						}
						$r=1; 
					}
					print $r;
					$r 
				} (0..(scalar @{$_}-1));
			$y++; print "\n"; @rm
			} @map;

print $answer;