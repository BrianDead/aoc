#!/usr/bin/perl


my $answer;
my $count;

my @map= map { chomp; [ split //] } <STDIN>;

my @colors=("\e[0;41m","\e[0;42m","\e[0;43m","\e[0;44m","\e[0;45m","\e[0;46m");

my @m2=();

#while(my $line=<STDIN>) {
#	chomp $line;
#	my @a=split '', $line;
#	push @map, \@a;
#	$count++;
#	$w=length($line) unless (length($line)<$w);
#}

my $count=@map;
my $w=@{$map[0]};

for(my $i=0; $i<$count; $i++) {
	my @line=@{$map[$i]};
	my $w=@line;
	for(my $j=0; $j<$w; $j++) {
		my $th=$map[$i][$j];
		if($j == $w-1 || $th<$map[$i][$j+1]) {
			if($i == 0  || $th<$map[$i-1][$j]) {
				if($i == $count-1 || $th<$map[$i+1][$j]) {
					if($j == 0 || $th<$map[$i][$j-1]) {
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
my $maxext=0;

sub check {
	my $y=$_[0];
	my $x=$_[1];
	my $basin=$_[2];
	my $ext=$_[3];
	$maxext=$ext if($ext>$maxext);

	print "Check basin $basin - Ext: $ext Pos: $y, $x - stat: $m2[$y][$x] h:$map[$y][$x] - ";
	$checks++;
	if($m2[$y][$x]) {
		print "Already checked - abort\n";
		return $basin;
	}
	$goodchecks++;

	if($map[$y][$x]==9) {
		$m2[$y][$x]=-1;
		print "Edge\n";
		return $basin;
	} else {
		print "Dig in\n";
		$m2[$y][$x]=$basin;
		$basins[$basin]++;
		check($y-1, $x, $basin, $ext+1) if($y>0);
		check($y, $x+1, $basin, $ext+1) if($x<($w-1));
		check($y+1, $x, $basin, $ext+1) if($y<($count-1));
		check($y, $x-1, $basin, $ext+1) if($x>0);
		print "Done extent $ext\n";
		return $basin+1;
	}
	return $basin;
}

for(my $i=0; $i<$count; $i++) {
	my @line=@{$map[$i]};
	my $w=@line;
	for( my $x=0; $x<$w; $x++) {
		print "Looking for basin $basin at $i,$x ($m2[$i][$x])\n";
		next if($m2[$i][$x]);
		$basin=check($i, $x, $basin, 0);
		print "Check done\n";
	}
}

my $c=0;
foreach(@basins) {
	print "Basin $c: $_\n";
	$c++;
}

foreach(@m2) {
	foreach(@{$_}) {
		my $col="\e[0;37m";
		$col=$colors[$_ % (0+@colors)] unless $_<0;
		printf("%s%03d ", $col, $_);
	}
	print "\e[0m;\n";
}

foreach(@m2) {
	foreach(@{$_}) {
		my $col="\e[0;37m";
		$col=$colors[$_ % (0+@colors)] unless $_<0;
		printf("%s#", $col);
	}
	print "\e[0m\n";
}


my @sorted=sort { $b <=> $a } @basins;
print "Largest: $sorted[0] $sorted[1] $sorted[2] = ";
print $sorted[0]*$sorted[1]*$sorted[2]."\n";
$answer2=$sorted[0]*$sorted[1]*$sorted[2];

print "Answer: $answer\nAnswer2: $answer2 (Checks: $checks, Goodchecks: $goodchecks, Max extent: $maxext)\n";


