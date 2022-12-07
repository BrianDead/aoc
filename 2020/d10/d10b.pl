#!/usr/bin/perl

use Data::Dumper;
use List::Util qw(max reduce);

my @adapters=map{ chomp $_ ; $_} <STDIN>;


@adapters=sort { $a <=> $b} @adapters;

print "@adapters\n";

my $target=max(@adapters)+3;

push @adapters, $target;

my @ways=map {0} (0..$target);
$ways[0]=1;

foreach(@adapters) {
    $ways[$_]=$ways[$_-1];
    $ways[$_]+=$ways[$_-2] if[$ways>1];
    $ways[$_]+=$ways[$_-3] if[$ways>2];
    print "Adapter with $_ jolts - $ways[$_] ways\n";
}

$diff[3]++;

print "d1=$diff[1] d3=$diff[3] Answer:".$diff[1]*$diff[3]."\n";