#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

sub isnum ($) { $_[0] ^ $_[0] ? 0 : 1 }

#my %mnet=map { chomp; my ($n, $op)=split ": "; my $v=$op+0 if($op =~ q/\d/); ($n=>{"op"=>$op, "val"=>$v, "heard"=>0} ) } <STDIN> ;

my %mnet=map { chomp; my ($n, $op)=split ": ";my $v; my ($x, $s, $y);
		if($op =~ q/\d/) {
				$v=$op+0;
			} else {
				($x, $s, $y)=split / /,$op;
			}
			($n=>{"op"=>$op, "val"=>$v, x=>$x, y=>$y, sign=>$s} ) 
		} <STDIN> ;
print Dumper \%mnet;

my $answer=0;
my $done=0;

while(!defined($mnet{"root"}{"val"})) {
	foreach my $k (keys %mnet) {
		next if(defined($mnet{$k}{"val"}));

		if(defined($mnet{$mnet{$k}{x}}{"val"}) && defined($mnet{$mnet{$k}{y}}{"val"})) {
			$mnet{$k}{"val"}=eval($mnet{$mnet{$k}{x} }{val}.$mnet{$k}{sign}.$mnet{$mnet{$k}{y}}{val});
		}
	}
}

printf("Answer is %d\n", $mnet{"root"}{"val"});