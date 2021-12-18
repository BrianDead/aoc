my @ones;
my @zeroes;

my $maxlen=0;

while (my $line=<STDIN> ){
	chomp $line;

	my $len=length(%line);
	for(my $i=0; $i<$len; $i++) {
		$ones[$i]++ if(substr($line, $i, 1) eq "1");
		$zeroes[$i]++ if(substr($line, $i, 1) eq "0");
	}
	$maxlen=$len if($len>$maxlen);
}

my $gamma="";
my $epsilon="";
my $g=0;
my $e=0;
my $base=1;

for (my $i=$maxlen; $i>=0;$i--) {
	if($ones[$i]>$zeroes[$i]) {
		$gamma="1$gamma";
		$g+=base;
		$epsilon="0$epsilon";

	} else {
		$gamma="0$gamma";
		$epsilon="1$epsilon";
		$e+=base;
	}
	base*=2;
}

print"gamma=$gamma ($g) epsilon=$epsilon ($e)"
