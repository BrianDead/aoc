#!/usr/bin/perl

use strict;
use Data::Dumper;

my @map=map { chomp; [split //]} <STDIN>;

#print Dumper @map;

my $done=0;
my $width=(0+@{$map[0]});
my $height=(0+@map);
my @last=();
my $count=1;

print "W: $width H: $height\n";
    foreach my $i (@map) {
        foreach(@{$i}) {
            print $_;
        }
        print "\n";
    }

while(!$done) {
#while($count<2) {
    my $changes=0;
    @last=map{ [@$_] } @map;


     #move east
    foreach my $i (0..$#map) {
        for(my $j=0;$j<$width;$j++) {
#            print "East [$i][$j]=$map[$i][$j] ";
            if($last[$i][$j] eq '>') {
                my $next=$j+1;
                $next=0 if($next==$width);
#               print "next: [$next] =$map[$i][$next]";
                if($last[$i][$next] eq '.') {
                    $map[$i][$j]='.'; $map[$i][$next]='>';
                    $j++;
                    $changes++;
                } else {
                    $map[$i][$j]=$last[$i][$j];
                }
            } else {
                $map[$i][$j]=$last[$i][$j];
            }
 #           print " j is $j\n";
        }
    }
    @last=map{ [@$_] } @map;
    # print "Mid-turn $count:\n";
    # foreach my $i (@map) {
    #     foreach(@{$i}) {
    #         print $_;
    #     }
    #     print "\n";
    # }
    #move south
    foreach my $i (0..($width-1)) {
        for(my $j=0;$j < $height;$j++) {
            if($last[$j][$i] eq 'v') {
                my $next=$j+1;
                $next=0 if($next>=$height);
                if($last[$next][$i] eq '.') {
                    $map[$j][$i]='.'; $map[$next][$i]='v';
                    $j++;
                    $changes++;
                } else {
                    $map[$j][$i]=$last[$j][$i];
                }
            } else {
                $map[$j][$i]=$last[$j][$i];
            }
        }
    }

    my $same=0;

    print "\nAfter turn $count:\n";

    # foreach my $i (@map) {
    #     foreach(@{$i}) {
    #         print $_;
    #     }
    #     print "\n";
    # }

    print "Changes: $changes\n\n";

    last unless($changes);

    $count++;
}

my $answer=$count;

print "Answer: $answer\n";