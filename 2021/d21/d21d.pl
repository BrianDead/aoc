#!/usr/bin/perl

use List::Util qw(min max sum);
use Data::Dumper;

#actual
my $start1=7;
my $start2=3;

#example
# my $start1=4;
# my $start2=8;


my @p1=();
my @p2=();

$start1--;
$start2--;

@probs=(0,0,0,1,3,6,7,6,3,1);


sub playall {
    my @pl=@{$_[0]};
    my $turn=$_[1];
    my $ret=0;

    print "Playing...\n";

    foreach $br ( grep { ($_->{l}==($turn-1))} @pl ) {
        if($br->{sc}<21) {
            push @pl, map {
                my @dice=(@{$br->{d}}, $_);
                my %step=(  l   =>$turn,
                            d   => \@dice , 
                            p   =>($br->{p}+$_) % 10 ,
                            sc  =>$br->{sc}+(($br->{p}+$_) % 10)+1,
                         );
                \%step } (3..9);
           
        } else {
             $ret++;
        }
    }
    return (@pl, $ret);
}

@p1=map{ { l=>0, d=> [$_], p=>($start1+$_) % 10 , sc=>(($start1+$_) % 10)+1 } } (3..9);
@p2=map{ { l=>0, d=> [$_], p=>($start2+$_) % 10 , sc=>(($start2+$_) % 10)+1 } } (3..9);


foreach $t (1..11) {
    my $r1; my $r2;
    @p1=playall(\@p1,$t);
    $r1=pop @p1;
    print "P1 Turn $t: $r1\n";
    @p2=playall(\@p2,$t);
    $r2=pop @p2;
    print "P2 Turn $t: $r2\n";
}

#print Dumper \@p1;
#print Dumper \@p2;

my $p1w=0;
my $p2w=0;
my $p2l=0;

foreach $t(0..11) {
    my $p1l=0;

    print "Turn $t Player1:\n";

    map {
        if($_->{sc}<21) {
            my $chain=1;
            foreach(@{$_->{d}}) {
                $chain *= $probs[$_];
            }
            $p1l+=$chain;
        } else {
            my $chain=1;
            foreach(@{$_->{d}}) {
                $chain *= $probs[$_];
            }
            $p1w+=$chain*$p2l;
        }
    } grep { ($_->{l}==$t) } @p1;

    print "  p1l=$p1l p1w=$p1w\n";
    $p2l=0;

    print "Turn $t Player2:\n";

    map {
        if($_->{sc}<21) {
            my $chain=1;
            foreach(@{$_->{d}}) {
                $chain *= $probs[$_];
            }
            $p2l+=$chain;
        } else {
            my $chain=1;
            foreach(@{$_->{d}}) {
                $chain *= $probs[$_];
            }
            $p2w+=$chain*$p1l;
        }
    } grep { ($_->{l}==$t)} @p2;

    print "  p2l=$p2l p2w=$p2w\n";


}

print "P1 wins: $p1w, P2 wins: $p2w";

