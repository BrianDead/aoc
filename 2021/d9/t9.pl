#!/usr/bin/perl

use Data::Dumper;

my @map= map { chomp; my @a=split //; push @a, 'a'; [ @a ] } <STDIN>;

push @map, [1,2,3,4,5];

print Dumper \@map;