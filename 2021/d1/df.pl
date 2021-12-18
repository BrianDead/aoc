my $count=0;
my $prev=1000000;
my $total=0;
my $w1=0;
my $w2=0;
my $w3=0;
my $minc=0;

while (my $line=<STDIN> ){
	chomp $line;
	$count++ if($line > $prev);
	$prev=$line;
	$total++;

	my $s1=$w2+$w1+$line;
	my $s2=$w3+$w2+$w1;
	print "$total - $w2+$w1+$line ($s1) > $w3+$w2+$w1 ($s2)?  ";
	$minc++ if($total>3 && ( ($w2+$w1+$line) > ($w3+$w2+$w1) ) ) ;
	print " $minc\n";
	$w3=$w2;$w2=$w1;
	$w1=$line;
}
print "$count increases out of $total\n";
print "$minc moving window increases\n";