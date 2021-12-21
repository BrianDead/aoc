#!/usr/bin/perl

use Data::Dumper

my %count;


foreach $d1 (1..3) {
    foreach $d2 (1..3) {
        foreach $d3 (1..3) {
            $count{$d1+$d2+$d3}++;
        }
    }
}

print Dumper %count;