#!/usr/bin/perl

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
    my $node=$_[0];
    my $dist=$_[1];
#    my $first=any {$_ == $node} @nodes;
    my $first=!defined($nodedist[$node]);

    push @nodes, $node if($first);
    $maxnodes=@nodes if($maxnodes<@nodes);
    $nodedist[$node]=$dist if($first || $dist<$nodedist[$node]);
}


sub minpath {
    my $imin; my $kmin;
    my $dmin=$huge;

    while (my ($k, $i) = each @nodes) {
#        if(!$intree[$i] && $nodedist[$i]<$dmin) {
        if($nodedist[$i]<$dmin) {
            $imin=$i;
            $kmin=$k;
            $dmin=$nodedist[$i]
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
#    print "Cost of ($y, $x): Orig - $ocost : new - $ret\n";
    return $ret;

}

# foreach my $y (0..$maxy-1) {
#     foreach my $x (0..$maxx-1) {
#         $nodedist[($y*$maxx)+$x]=$huge;
#         $intree[($y*$maxx)+$x]=0;
#     }
# }

setdistance(0,0);

foreach my $i (0..(($maxx*$maxy)-1)) {
    my $next=minpath();

    print "Next $next \r";

    my $ny=int($next/$maxx);
    my $nx=($next % $maxx);

#    print "($ny, $nx)...";

    $intree[$next]=1;

    if($ny>0) { my $newd=$nodedist[$next]+cost($ny-1, $nx);
                setdistance($next-$maxx, $newd); }
    if($nx>0) { my $newd=$nodedist[$next]+cost($ny,$nx-1);
                setdistance($next-1, $newd); }
    if($nx<($maxx-1)) { my $newd=$nodedist[$next]+cost($ny, $nx+1);
                setdistance($next+1, $newd); }
    if($ny<($maxy-1)) { my $newd=$nodedist[$next]+cost($ny+1, $nx);
                setdistance($next+$maxx, $newd); }

}

#print Dumper \@nodedist;

#print Dumper \@intree;

$answer1=$nodedist[($maxx*$maxy)-1];

print "Answer1: $answer1\nMaxnodes: $maxnodes";