#!/usr/bin/perl

use strict;

use Data::Dumper;

my @data=map{chomp; [ split //]} <STDIN>;

my $answer1=0;
my $answer2=0;

my $x=0;
my $y=0;

my $fin=0;

my $omaxx=@{$data[0]};
my $omaxy=@data;

my $maxx=$omaxx*5;
my $maxy=$omaxy*5;
my $huge=9999999999;

my %cl=();
my $visited=0;

print "Max x=$maxx, Max y=$maxy\n";

my @nodedist;
my @intree;
my @nodes=();
my $maxnodes;

sub setdistance {
    my ($x, $y, $dist)=@_;
    $nodedist[getIndex($x, $y)]=$dist if(!defined($nodedist[getIndex($x,$y)]) || $dist<$nodedist[getIndex($x,$y)]);
    $maxnodes=keys %cl if($maxnodes<(keys %cl));
}

sub minpath {
    my $dmin=$huge;
    my $xmin; my $ymin; my $nmin;

    foreach (keys %cl) {
        $visited++;
#        printf("min test %d,%d = %d vs %d - intree %d\n", $x, $y, $nodedist[$y][$x], $dmin, $intree[$y][$x]);

        if(!$intree[$_] && $nodedist[$_]<$dmin) {
#            $xmin=$x; $ymin=$y;
            $nmin=$_;
            $dmin=$nodedist[$_];
        }
    }

    return (getXY($nmin));
}


sub cost {
    my $x=$_[1];
    my $y=$_[0];

    my $ocost=$data[$y % $omaxy][$x % $omaxx];
    my $ret=($ocost+int($y/$omaxy)+int($x/$omaxx));
    while ($ret>9) { $ret-=9};
    return $ret;

}

sub getIndex {
    return ($_[0]+$_[1]*$maxx);
}

sub getXY {
    return ($_[0]%$maxx,int($_[0]/$maxx));
}

setdistance(0,0,0);
$cl{getIndex(0,0)}=1;

foreach my $iy (0..$maxy-1) {
    foreach my $ix (0..$maxx-1) {
        my ($nx, $ny)=minpath();

#        print "b2-Next ($ny, $nx)...\n";

        $intree[getIndex($nx, $ny)]=1;
        delete $cl{getIndex($nx, $ny)};

        foreach my $a ([0,-1],[-1,0],[1,0],[0,1]) { 
            my $tx=$nx+$a->[0]; my $ty=$ny+$a->[1];
            if($tx>=0 && $tx<=($maxx-1) && $ty>=0 && $ty<=($maxy-1)) {
                my $newd=$nodedist[getIndex($nx,$ny)]+cost($ty, $tx);
                setdistance( ($tx, $ty), $newd);
                $cl{getIndex($tx, $ty)}=1 if(!$intree[getIndex($tx, $ty)]);
            }
        }
    }
}

print "\n";

#print Dumper \@nodedist;

#print Dumper \@intree;

$answer1=$nodedist[getIndex($maxx-1,$maxy-1)];

print "Answer1: $answer1\nMaxnodes: $maxnodes\nVisited: $visited\n";