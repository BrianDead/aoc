#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);

my %arules;
my %brules;
#my @manuals;
my $phase=0;
my $answer=0;
my @badbooks;

while(<STDIN>) {
	chomp;
	if($_ eq "") {
#		print Dumper \%arules;
#		print Dumper \%brules;
		$phase=1 if($_ eq "");
		next;
	}
	if($phase) {
#		push(@manuals, [split /,/]);
		my @seq=split /,/;
#		print Dumper \@seq;
		my %rec;
		my $bad=0;
		my $c=0;
		foreach(@seq) {
			$rec{$_}=$c++;
		}
		$c=0;
		foreach(@seq) {
#			print("Page $_: ");
			if(defined($brules{$_})) {#
#				print("before rule exists ");
				foreach(@{$brules{$_}}) {
#					print("$_ ");
					if(! defined($rec{$_})) {
#						print("OK ");
					} else {
						if($rec{$_}>$c) {
#							print("after-bad ");
							$bad=1;
						}
					}
					last if($bad);
				}
			}
			if(!$bad && defined($arules{$_})) {
#				print("after rule exists ");
				foreach(@{$arules{$_}}) {
#					print("$_ ");
					if(! defined($rec{$_})) {
#						print("OK ");
					} else {
						if($rec{$_}<$c) {
#							print("after-bad ");
							$bad=1;
						}
					}
					last if($bad);
				}
			}
			$rec{$_}++;
#			print("\n");
			$c++;
			last if($bad);
		}	
		if($bad) {
			push(@badbooks, \@seq);
		} else {		
			$answer+=$seq[int(scalar(@seq))/2];
		}

	} else {
		my ($ln, $rn)=split /\|/;
		if(! defined($brules{$rn})) {
			$brules{$rn}=[$ln];
		} else {
			push(@{$brules{$rn}},$ln);
		}
		if(! defined($arules{$ln})) {
			$arules{$ln}=[$rn];
		} else {
			push(@{$arules{$ln}},$rn);
		}
	}
}

print("Answer: $answer\n");

# print Dumper \@badbooks;

my $answer2=0;

for my $book (@badbooks) {
	my @sortedbook=sort {
		my $cmp=0;
#		print("Considering $a and $b: ");
		if(defined($arules{$a})) {
			# if b must be after a, negative return
			if( grep($_ == $b, @{$arules{$a}}) ) {
#				print("$b must be after $a ");
				$cmp=-1;
			}
		} 
		if(!$cmp && defined($brules{$a})) {
			# if b must be before a, positive return
			if(grep($_ == $b , @{$brules{$a}}) ) {
#				print("$b must be before $a ");
				$cmp=1; 
			}
		}
#		print("returning $cmp\n");
		return $cmp;
		} @$book;

#		print Dumper \@sortedbook;
		$answer2+=$sortedbook[int(scalar(@sortedbook))/2];

}

print("Answer 2: $answer2\n");
