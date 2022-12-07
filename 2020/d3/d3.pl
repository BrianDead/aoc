#!/usr/bin/perl

my $hpos=0;
my $vpos=0;
my $lines=0;
my $trees=0;

my @part2=({ 'r'=>1, 'd'=>1, 'h'=>0, 't'=>0},
			{'r'=>3,'d'=>1,'h'=>0,'t'=>0}, 
			{ 'r'=>5, 'd'=>1, 'h'=>0, 't'=>0},
			{ 'r'=>7, 'd'=>1, 'h'=>0, 't'=>0},
			{ 'r'=>1, 'd'=>2, 'h'=>0, 't'=>0});

while ($line=<STDIN>) {
	chomp $line;

	foreach (@part2) {
		print "R: $_->{'r'}, D: $_->{'d'} ";
		print $vpos%$_->{'d'};
		if(! ($vpos%$_->{'d'})) {
			print " Row ";
			if(substr($line, $_->{'h'} % length($line), 1) eq '#') {
				print "TREE! line $vpos";
				$_->{'t'}++;
			}
		$_->{'h'}+=$_->{'r'};
		} else { print "no row"}
	$vpos++;
	print "\n";
	}

}

$answer=1;

foreach (@part2) {
	print "R: $_->{'r'}, D: $_->{'d'} - $_->{'t'} trees\n";
	$answer=$answer*$_->{'t'};
}

print "Answer: $answer\n";
