#!/usr/bin/perl

use Data::Dumper;


my $tminx=207;
my $tmaxx=263;
my $tminy=-115;
my $tmaxy=-63;

my $x=0; my $y=0;

my $ivx=0; my $ivy=10;

my $vx=$ivx; my $vy=$ivy;

my $done=0;
my $highest=0;
my $successes=0;
my $maxivy=0;

foreach $ivx (20..265) {
    foreach $ivy (-116..115) {

        $vx=$ivx; $vy=$ivy;
#        print "Starting vx=$ivx vy=$ivy\n";
        $x=0; $y=0; $done=0; $maxy=0;

        while(!$done) {
            my $tx=0; my $ty=0;
            $x+=$vx; $y+=$vy;
            $vx-=(($vx<0)?-1:1) if($vx);
            $vy-=1;

#            print("--$x, $y\n");

            $maxy=$y if($y>$maxy);

            if($x>=$tminx) {
                if($x>$tmaxx && $tminx>0) {
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
            $maxivy=$ivy if $ivy>$maxivy;
            $successes++;
        } else {
#            print "Missed - x=$x y=$y\n";
        }
    }
}

print "Answer=$highest\n";
print "Answer2=$successes\n";
print "Highest ivy=$maxivy\n"
