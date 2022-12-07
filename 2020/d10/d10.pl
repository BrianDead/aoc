#!/usr/bin/perl

my @adapters=map{ chomp $_ ; $_} <STDIN>;

print "@adapters";

@adapters=sort { $a <=> $b} @adapters;

my $last=0;

my @diff=(0,0,0,0);

foreach(@adapters) {
    print "Adapter with $_ jolts\n";
    $diff[$_-$last]++;
    $last=$_;
}

$diff[3]++;

print "d1=$diff[1] d2=$diff[2] d3=$diff[3] Answer:".$diff[1]*$diff[3]."\n";