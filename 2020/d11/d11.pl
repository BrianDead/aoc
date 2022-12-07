#!/usr/bin/perl

my @map=map { chomp; [ split // ] } <STDIN>;

foreach my $i (@map) {
	foreach my $j (@{$i}) {
		print $j;
	}
	print "\n";	
}

my $rmax=(@map-1);
my $cmax=(@{$map[0]}-1);

print "$rmax $cmax \n";

sub getadjacent_o {
	my $r=shift;
	my $c=shift;
	my $m=shift;
	my @map=@{$m};
	my $occupied=0;

	foreach my $dr(-1..1) {
		my $cr=$r+$dr;
		foreach my $dc(-1..1) {
			next if($dr==0 && $dc==0);
			my $cc=$c+$dc;
			$occupied++ if( ($cr>=0) && ($cc>=0) && ($cr<=$rmax) && ($cc<=$cmax) && ($map[$cr][$cc] eq '#') );
		}
	}
#	print "$r $c $map[$r][$c] $occupied\n";
	return $occupied;
}

sub getadjacent {
	my $r=shift;
	my $c=shift;
	my $m=shift;
	my @map=@{$m};
	my $occupied=0;

	foreach my $dr(-1..1) {
		foreach my $dc(-1..1) {
			next if($dr==0 && $dc==0);
			foreach my $dist(1..$cmax) {
				my $cr=$r+($dr*$dist);
				my $cc=$c+($dc*$dist);
#				print "$dist: $cr,$cc $map[$cr][$cc] ";
				last if($cr<0 || $cc<0 || $cr>$rmax || $cc>$cmax || $map[$cr][$cc] eq 'L');
				if($map[$cr][$cc] eq '#') {
					$occupied++ ;
					last;
				}
			}
#			print"--";
		}
#		print "\n";
	}
#	print "$r $c $map[$r][$c] $occupied\n";
	return $occupied;
}

my @newmap=();
my $done=0;
my $iter=0;

while(!$done) {
	$iter++;
	@newmap=map{ [@$_] } @map;

	$done=1;

	for(my $r=0; $r<@map; $r++) {
		my @row=@{$map[$r]};
		for(my $c=0; $c<@row; $c++) {
			next if($map[$r][$c] eq '.');
			# If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
			my $adj=getadjacent($r, $c, \@map);
			if ($map[$r][$c] eq 'L') {
				if($adj==0) {
					$newmap[$r][$c]="#";
					$done=0;
				} 
			} elsif ($map[$r][$c] eq '#') {
			# If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
#				if($adj>=4) {
				if($adj>=5) {
					$newmap[$r][$c]="L";
					$done=0;
				}
			}
		}
	}
	@map=@newmap;
	foreach my $i (@map) {
		foreach my $j (@{$i}) {
			print $j;
		}
		print "\n";	
	}
	print "\n";
#	last if($iter>1);

}

my $answer=0+(grep {$_ eq '#'}	 map { @$_ } @map);

print "Answer: $answer\n";
