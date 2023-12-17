#!/usr/bin/perl

use strict;
use warnings;

sub hashof {
	my @str=split //, shift;
	my $cv=0;

	foreach(@str) {
		$cv+=ord($_);
		$cv=$cv*17;
		$cv=$cv % 256;
	}
	return $cv;
}


chomp(my $line=<>);
my @sequence=split ",", $line;

my $answer=0;
my @boxes;

foreach(0..255) {
	push(@boxes, []);
}

foreach(@sequence) {
	print("$_\n");
}

foreach(@sequence) {
	my ($label,$action,$fl)= $_ =~ /([a-z]+)([=-])(\d?)/;
	die($_) if ($label eq "");
	die($_) if ($action eq "=" && $fl==0);
	my $box=hashof($label);

	print("Box $box - $label, $action, $fl\n");
	foreach my $j (0..(scalar @{$boxes[$box]})-1) {
		printf("Box %d, slot %d, %s\n", $box, $j, $boxes[$box][$j]);

	}

	if($action eq "=") {
		my $found=0;
		print("Adding $label $fl to box $box\n");

		foreach my $i (0..(scalar @{$boxes[$box]})-1) {
			my $re=". ".$label."\$";
			if($boxes[$box][$i] =~ /$re/) {
				print("Replaced $label at $i\n");
				my($fl2,$l2)=split(" ", $boxes[$box][$i]);
				die if($l2 ne $label);
				$boxes[$box][$i]="$fl $label";
				$found=1;
				last;
			}
		}
		if(!$found) {
			push(@{$boxes[$box]},"$fl $label");
		}
	} elsif ($action eq "-") {
		print("Removing $label from $box\n");
   
		foreach my $i (0..(scalar @{$boxes[$box]})-1) {
			my $re=". ".$label."\$";
			if($boxes[$box][$i] =~ /$re/) {
				printf("Removed $label at %d - %s\n", $i, ($i>0 && $i<(scalar @{$boxes[$box]})-1)?"Midway":"Ender");
				my($fl2,$l2)=split(" ", $boxes[$box][$i]);
				die if($l2 ne $label);
				splice(@{$boxes[$box]},$i,1);
				last;
			}
		}
	} else { die;}
	print "Finshed:\n";
	foreach my $j (0..(scalar @{$boxes[$box]})-1) {
		printf("Box %d, slot %d, %s\n", $box, $j, $boxes[$box][$j]);

	}

	print "\n";
}

$answer=0;

foreach my $i (0..$#boxes) {
	foreach my $j (0..(scalar @{$boxes[$i]})-1) {
		my ($bv, $l)=split(" ", $boxes[$i][$j]);
		my $s=(1+$i)*(1+$j)*$bv;
		printf("Box %d, slot %d, %s (%d) = %d\n", $i, $j, $boxes[$i][$j], $bv, $s);
		$answer= $answer+$s;
	}
}


print "Answer: $answer\n";