#!/usr/bin/perl

use Data::Dumper;

my $answer;
my $count;

my @map=();

my @m2=();

while(my $line=<STDIN>) {
	chomp $line;
	$map[$count]=$line;
	my @a=split '', $line;
	push @{$m2[$count]{'h'}}, @a;
	$count++;
	$w=length($line) unless (length($line)<$w);
}

print Dumper \@m2;
print "$m2 $m2[0]{'h'}[0]\n";

print "$count rows.\n";

for(my $i=0; $i<$count; $i++) {
	for(my $j=0; $j<$w; $j++) {
		my $th=substr($map[$i],$j,1);
		if($j == $w-1 || $th<substr($map[$i],$j+1,1)) {
			if($i == 0  || $th<substr($map[$i-1], $j,1)) {
				if($i == $count-1 || $th<substr($map[$i+1], $j,1)) {
					if($j == 0 || $th<substr($map[$i], $j-1,1)) {
						$answer+=(1+$th);
					}
				}
			}
		}
	}

}

my $basin=1;
my @basins=();
my $checks=0;
my $goodchecks=0;

sub check {
	my @m2=@{$_[0]};
	my $y=$_[1];
	my $x=$_[2];
	my $basin=$_[3];
#	print "Check basin $basin - $y, $x - $m2[$y]{'b'}[$x] h:$m2[$y]{'h'}[$x]\n";
	$checks++;
	return $basin if($m2[$y]{'b'}[$x]);
	$goodchecks++;

	if($m2[$y]{'h'}[$x]==9) {
		$m2[$y]{'b'}[$x]=-1;
		return $basin;
	} else {
		$m2[$y]{'b'}[$x]=$basin;
		$basins[$basin]++;
		check(\@m2, $y-1, $x, $basin) if($y>0);
		check(\@m2, $y, $x+1, $basin) if($x<($w-1));
		check(\@m2, $y+1, $x, $basin) if($y<($count-1));
		check(\@m2, $y, $x-1, $basin) if($x>0);
		return $basin+1;
	}
	return $basin;
}

for(my $i=0; $i<$count; $i++) {
	my @row=$m2[$i]{'h'};
	for( my $x=0; $x<$w; $x++) {
		next if($m2[$i]{'b'}[$x]);
		$basin=check(\@m2, $i, $x, $basin);
	}
}

my $c=0;
foreach(@basins) {
	print "Basin $c: $_\n";
	$c++;
}

my @sorted=sort { $b <=> $a } @basins;
print Dumper \@sorted;
print "Largest: $sorted[0] $sorted[1] $sorted[2] = ";
print $sorted[0]*$sorted[1]*$sorted[2]."\n";
$answer2=$sorted[0]*$sorted[1]*$sorted[2];

print "Answer: $answer\nAnswer2: $answer2 (Checks: $checks, Goodchecks: $goodchecks)\n";