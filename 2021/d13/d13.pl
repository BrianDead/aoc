#!/usr/bin/perl

use Data::Dumper;
my $answer1;
my $answer2;

my %map;
my $maxx=0;
my $maxy=0;
my $hashes=0;

while(my $line=<STDIN>) {
    my @pos=();
    chomp $line;
    last if($line eq "");
    if (@pos= $line=~ q/([0-9]*),([0-9]*)/) {
        $map{$pos[0]}{$pos[1]}='#';
        $maxx=$pos[0] if($pos[0]>$maxx);
        $maxy=$pos[1] if($pos[1]>$maxy);
    }
}

foreach $y (0..$maxy) {
    foreach $x (0..$maxx) {
        $map{$x}{$y}='.' if(!exists $map{$x}{$y});
        $answer2++ if($map{$x}{$y} eq '.');
        $hashes++ if($map{$x}{$y} eq '#');
#        print $map{$x}{$y};
    }
#    print "\n";
}
print"Original maxx=$maxx maxy=$maxy $answer2 #:$hashes\n";
printf "grid: %d counts:%d\n", ($maxx+1)*($maxy+1), $answer2+$hashes;

my @fold;

while(my $line=<STDIN>) {
    @fold= $line =~ q/fold along ([xy])=([0-9]*)/;

    print "Fold $fold[0] -- $fold[1]\n";


    if($fold[0] eq 'x') {
        foreach $y(0..$maxy) {
            for(my $ix=1; $ix<=$fold[1];$ix++) {
                $map{$fold[1]-$ix}{$y}='#' if($map{$fold[1]-$ix}{$y} eq '#' || $map{$fold[1]+$ix}{$y} eq '#');    
            }
            
        }
        for(my $y=0; $y<=$maxy; $y++ ) {
            for(my $x=$fold[1]; $x<=$maxx; $x++) {
                delete $map{$x}{$y};
            }
        }
        $maxx=$fold[1]-1;
    }
    if($fold[0] eq 'y') {
        for(my $iy=1; $iy<=$fold[1];$iy++) {
            for(my $x=0; $x<=$maxx; $x++ ) {
                $map{$x}{$fold[1]-$iy}='#' if($map{$x}{$fold[1]-$iy} eq '#' || $map{$x}{$fold[1]+$iy} eq '#');    
            }
        }

        for(my $y=$fold[1]; $y<=$maxy+1; $y++ ) {
            for(my $x=0; $x<=$maxx+1; $x++) {
                delete $map{$x}{$y};
            }
        }
        $maxy=$fold[1]-1;

    }

    print"New maxx=$maxx maxy=$maxy\n";
    $answer1=0;
    $hashes=0;

    foreach $y (0..$maxy) {
        foreach $x (0..$maxx) {
            $answer1++ if($map{$x}{$y} eq '.');
            $hashes++ if($map{$x}{$y} eq '#');
#            print $map{$x}{$y};
        }
#        print "\n";
    }
}

foreach $y (0..$maxy) {
    foreach $x (0..$maxx) {
        $map{$x}{$y}='.' if(!exists $map{$x}{$y});
        $answer2++ if($map{$x}{$y} eq '.');
        $hashes++ if($map{$x}{$y} eq '#');
        print $map{$x}{$y};
    }
    print "\n";
}

print "Answer: $answer1 Hashes: $hashes\n";
printf "grid: %d counts:%d\n", ($maxx+1)*($maxy+1), $answer1+$hashes;

