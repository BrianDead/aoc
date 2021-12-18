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


print "Max x=$maxx, Max y=$maxy\n";

my @nodedist;
my @intree;
my @nodes=();
my $maxnodes;

sub setdistance {
    my ($x, $y, $dist)=@_;
    my $first=!defined($nodedist[$y][$x]);

    push @nodes, [ $x, $y ] if($first);
    $maxnodes=@nodes if($maxnodes<@nodes);
    $nodedist[$y][$x]=$dist if($first || $dist<$nodedist[$y][$x]);
}


sub minpath {
    my $imin; my $kmin;
    my $dmin=$huge;

    while (my ($k, $i) = each @nodes) {
        if($nodedist[$i->[1]][$i->[0]]<$dmin) {
            $imin=$i;
            $kmin=$k;
            $dmin=$nodedist[$i->[1]][$i->[0]];
        }
    }
    splice @nodes, $kmin, 1;
    return $imin;
}

sub cost {
    my $x=$_[1];
    my $y=$_[0];

    my $ocost=$data[$y % $omaxy][$x % $omaxx];
    my $ret=($ocost+int($y/$omaxy)+int($x/$omaxx));
    while ($ret>9) { $ret-=9};
    return $ret;

}

setdistance(0,0,0);

foreach my $iy (0..$maxy-1) {
    foreach my $ix (0..$maxx-1) {
        my $next=minpath();

        my $ny=$next->[1];
        my $nx=$next->[0];

        print "Next ($ny, $nx)...\r";

        $intree[$ny][$nx]=1;

        if($ny>0) { my $newd=$nodedist[$ny][$nx]+cost($ny-1, $nx);
                    setdistance( ($nx, $ny-1), $newd); }
        if($nx>0) { my $newd=$nodedist[$ny][$nx]+cost($ny,$nx-1);
                    setdistance( ($nx-1, $ny), $newd); }
        if($nx<($maxx-1)) { my $newd=$nodedist[$ny][$nx]+cost($ny, $nx+1);
                    setdistance( ($nx+1, $ny), $newd); }
        if($ny<($maxy-1)) { my $newd=$nodedist[$ny][$nx]+cost($ny+1, $nx);
                    setdistance( ($nx, $ny+1), $newd); }
                    
    }
}

print "\n";

#print Dumper \@nodedist;

#print Dumper \@intree;

$answer1=$nodedist[$maxy-1][$maxx-1];

print "Answer1: $answer1\nMaxnodes: $maxnodes\n";