#!/user/bin/perl

my $total=0;
my $total2=0;

while(my $line=<STDIN>) {
	chomp $line;
	my @shit= $line=~ q/([0-9]+)-([0-9]+) ([a-z]): ([a-z]*)/;
	my $regex="^([^$shit[2]]*$shit[2]\[^$shit[2]\]*){$shit[0],$shit[1]}\$";
	print "$line - $regex";
	if( $shit[3]=~ $regex) {
		print " - YES";
		$total++;
	} else { print " - NO"; }

	if(substr($shit[3],$shit[0]-1,1) eq $shit[2] xor substr($shit[3],$shit[1]-1,1) eq $shit[2]) {
		print " - ALSO\n";
		$total2++;
	} else { print " - ALSO NOT\n";}

}

print "Total: $total\tTotal2: $total2\n";	