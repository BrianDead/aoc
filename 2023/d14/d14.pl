#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @m=map{ chomp; [split //] } <>;
my $w=scalar(@{$m[0]});
my $h=scalar @m;

sub move {
	my @dir=@_;

	my $rs=0;
	$rs=$h-1 if($dir[0]>0);
	my $rf=($h-1)-$rs;

	my $cs=0;
	$cs=$w-1 if($dir[1]>0);
	my $cf=($w-1)-$cs;
	my $moved=0;

	print("rs=$rs rf=$rf cs=$cs cf=$cf\n");

	do {
		$moved=0;
		foreach my $r($rs..$rf) {
			foreach my $c ($cs..$cf) {
				next if($m[$r][$c] ne "O");
				my $rt=$r+$dir[0]; my $ct=$c+$dir[1];
				print("$r,$c to $rt,$ct\n");
				next if($rt<0 || $rt>=$h || $ct<0 || $ct>=$h);
				print("$m[$r][$c] to $m[$rt][$ct]\n");
				next if($m[$rt][$ct] ne ".");
				print("Moving\n");
				$m[$rt][$ct]="O"; $m[$r][$c]="."; $moved++;
			}
		}
	} until ($moved==0);
}

sub loadcalc {
	my $load=0;

	foreach my $r(0..$h-1) {
		foreach my $c(0..$w-1) {
			$load+=($h-$r) if($m[$r][$c] eq "O");
		}
	}
	return $load;
}
foreach(@m) {
	foreach(@{$_}) {
		print "$_";
	}
	print "\n";
}
	print "\n";

move(-1,0);
foreach(@m) {
	foreach(@{$_}) {
		print "$_";
	}
	print "\n";
}
printf("Answer is %d\n", loadcalc());