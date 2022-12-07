#!/usr/bin/perl

my $maxid=0;
my @seats;

while($line=<STDIN>) {
	chomp $line;

	my $base=1; my $id=0;
	for(my $i=length($line)-1; $i>=0; $i--) {
		if(substr($line,$i,1) eq 'B' || substr($line, $i, 1) eq 'R') {
			$id+=$base;
		}
		$base*=2;
	}
	$maxid=$id if($id>$maxid);
	$seats[$id]=1;
}

print "Max ID=$maxid\n";

my $s=@seats;
print "Seats: $s\n";
my $ii=0;
for ($ii=0; $ii<$s; $ii++) {
	next if($seats[$ii] || $ii<1) ;
	last if($seats[$ii-1] && $seats[$ii+1]);
}
print "My seat is: $ii";