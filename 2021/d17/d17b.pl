#!/usr/bin/perl

use Data::Dumper;


my $tminx=20;
my $tmaxx=30;
my $tminy=-10;
my $tmaxy=-5;

my $x=0; my $y=0;

my $ivx=0; my $ivy=10;

my $vx=$ivx; my $vy=$ivy;

my $done=0;
my $highest=0;
my $successes=0;

foreach $ivx (0..30) {
    foreach $ivy (-11..100) {

        $vx=$ivx; $vy=$ivy;
        print "Starting vx=$ivx vy=$ivy\n";
        $x=0; $y=0; $done=0; $maxy=0;

        while(!$done) {
            my $tx=0; my $ty=0;
            $x+=$vx; $y+=$vy;
            $vx-=(($vx<0)?-1:1) if($vx);
            $vy-=1;

            print("--$x, $y\n");

            $maxy=$y if($y>$maxy);

            if($x>=$tminx) {
                if($x>=$tmaxx && $tminx>0) {
                    $done=2;
                }
                if($x<=$tmaxx) {
                    $tx=1;
                }
            }

            if($y>=$tminy) {
                if($y<=$tmaxy) {
                    $ty=1;
                } 
            } elsif($vy<0) {
                $done=2;
            }

            $done=1 if($tx && $ty);
        }



        if($done==1) {
            print "Success - vx=$ivx vy=$ivy\n";
            print "Maxy=$maxy Highest=$highest\n";
            $highest=$maxy if($maxy>$highest);
            $successes++;
        } else {
#            print "Missed - x=$x y=$y\n";
        }
    }
}

print "Answer=$highest\n";
print "Answer2=$successes\n";
