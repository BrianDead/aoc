#!/usr/bin/perl

use Data::Dumper;

my @space=map { [ map { [map { 0 } (0..100) ]} (0..100)] } {0.100} ;

while ($line=<STDIN>) {
    chomp $line;

    print $line;

    my ($action, $fx, $tx, $fy, $ty, $fz, $tz)=$line =~ q/(on|off) x=([0-9-]*)..([0-9-]*),y=([0-9-]*)..([0-9-]*),z=([0-9-]*)..([0-9-]*)/ ;

    if(($fx < -50 && $tx < -50) || ($fx > 50 && $tx > 50) ||
        ($fy < -50 && $ty < -50) || ($fy > 50 && $ty > 50) ||
        ($fz < -50 && $tz < -50) || ($fz > 50 && $tz > 50) ) {
        print " Dumped \n";
        next;

    }

    $fx+=50; $tx+=50;
    $fy+=50; $ty+=50;
    $fz+=50; $tz+=50;

    print " Action: ($action, $fx, $tx, $fy, $ty, $fz, $tz)\n";

    map { my $mx=$_; map { my $my=$_; map { $space[$mx][$my][$_] = ($action eq "on") ? 1 : 0} ($fz..$tz) } ($fy..$ty)} ($fx..$tx); 
    # foreach $mx ($fx..$tx) {
    #     foreach $my ($fy..$ty) {
    #         foreach $mz ($tz..$tz) {
    #             $space[$mx][$my][$mz]= ($aci)
    #         }
    #     }
    # }


}

my $count=0;

foreach $mx (0..100) {
    foreach $my (0..100) {
        foreach $mz (0..100) {
            $count+=$space[$mx][$my][$mz];                
        }
    }
}

print "Answer: $count\n";