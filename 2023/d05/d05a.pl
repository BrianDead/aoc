#!/usr/bin/perl

my @stagenames=[ 'seed' ];
my @maps;
my @seeds;
my $map;

my $answer=9999999999;

my $header="";

while(<>) {
	chomp;
	next if($_ eq "");
	if($_ =~ /:/ ) {
		my ($header, $rest) = split /: +/;
		if($header eq "seeds") {
				@seeds=split / /, $rest;
		} else {
			my ($from, $to) = $rest =~ /([a-z]+)-to-([a-z]+) map/;
			$i=0;
		}
	} else {

		if($i==0) {
			$map=[ ];
			push(@stagenames, $to);
			push(@maps,$map);
			$i++;
		}
		my %list;
		($list{'d'}, $list{'s'}, $list{'l'})=split / /;
		push (@{$map}, \%list);
	}
}

# Now calculate

foreach my $s (@seeds) {
	my $d=$s;
	foreach my $m (@maps) {
		foreach my $o (@{$m}) {
			my $dd=$d-$o->{'s'};
			if($dd>=0 && $dd<$o->{'l'}) {
				$d=$o->{'d'}+$dd;
				last;
			}
		}
	}
	printf("Seed %d in location %d\n", $s, $d);
	$answer= ($d<$answer)?$d:$answer;
}

printf("Answer is %d\n", $answer);