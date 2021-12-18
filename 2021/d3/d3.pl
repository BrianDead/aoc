
use warnings;
#use strict;

my @ones;
my @zeroes;
my @lines;

my $maxlen=0;

sub frombin {
	my $t=0;
	my $base=1;
	my $bin=$_[0];

	for($i=length($bin)-1; $i>=0; $i--) {
		if(substr($bin, $i, 1) eq "1") {
			$t+=$base;
		}
		$base*=2;
	}
	return $t;
}

sub filteronbit {
	my $nums=$_[0];
	my $checkbit=$_[1];
	my $most=$_[2];
	my @out;
	my $ones=0; my $zeroes=0;
	my $include="";

	for(@$nums) {
		my $len=length($_);

		$ones++ if(substr($_, $checkbit, 1) eq "1");
		$zeroes++ if(substr($_, $checkbit, 1) eq "0");
	}

	if ($most) {
		if ($ones>=$zeroes) {
			$include="1";
		} else { $include="0";}
	} else {
		if ($zeroes<=$ones) {
			$include="0";
		} else {
			$include="1";
		}
	}

	print"bit $checkbit - $zeroes $ones\n";

	for(@$nums) {
		push(@out, $_) if(substr($_, $checkbit,1) eq $include);
	}
	return @out;
}

while (my $line=<STDIN> ){
	chomp $line;
	push(@lines, $line);

	my $len=length($line);

	for(my $i=0; $i<$len; $i++) {
		$ones[$i]++ if(substr($line, $i, 1) eq "1");
		$zeroes[$i]++ if(substr($line, $i, 1) eq "0");
	}
	$maxlen=$len if($len>$maxlen);
}

print "Maxlen=$maxlen\n";

my $gamma="";
my $epsilon="";
my $g=0;
my $e=0;
my $base=1;

for (my $i=$maxlen-1; $i>=0;$i--) {
	if($ones[$i]>$zeroes[$i]) {
		$gamma="1$gamma";
		$g+=$base;
		$epsilon="0$epsilon";

	} else {
		$gamma="0$gamma";
		$epsilon="1$epsilon";
		$e+=$base;
	}
	$base=$base*2;
}

print"gamma=$gamma ($g) epsilon=$epsilon ($e)\n";
my $product=$g*$e;
print"Product: $product\n";	

print"\n------\n";

print 0+@lines." lines\n";

my @left=@lines;
my $i=0;
my $o2=0;
my $co2=0;

do {
	print 0+@left." lines left\n";
	@left=filteronbit(\@left, $i, 1);
	$i++;
	} while ((0+@left)>1 && $i<$maxlen);

$o2=frombin($left[0]);
print 0+@left." lines left - $left[0]=$o2\n";

@left=@lines;
$i=0;

do {
	print 0+@left." lines left\n";
	@left=filteronbit(\@left, $i, 0);
	$i++;
	} while ((0+@left)>1 && $i<$maxlen);

$co2=frombin($left[0]);
print 0+@left." lines left - $left[0]=".frombin($left[0])."\n";
print "Product=".$co2*$o2."\n";


