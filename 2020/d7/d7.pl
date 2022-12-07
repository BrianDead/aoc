#!/usr/bin/perl

use Data::Dumper;
use List::MoreUtils qw(any);

my @rules=map { chomp; my @chunk= $_=~q/([a-z]* [a-z]* bag)s? contain ([0-9a-z,. ]*)$/; print "@chunk\n"; { o=>$chunk[0], i=>[split /[,.] ?/, $chunk[1]]}} <>;
my %tree;

#print Dumper \@rules;


foreach my $outer(@rules) {
    $tree{$outer->{'o'}}{holds}= [map { print "Trying $_\n"; $_=~q/([0-9]+) ([0-9a-z,. ]+ bag)s?$/; { n=>$1, d=>$2} } @{$outer->{'i'}}];
    foreach my $inner (@{$tree{$outer->{'o'}}{holds}}) {
        print "Outing $inner->{d}\n";
        push @{$tree{$inner->{d}}{goesin}}, $outer->{'o'};
    }
}

my @paths;

my @outers;



sub tracepath {
    my $inner=$_[0];
    my $path=$_[1];

    #find the name of every bag that can contain the inner bag

    my @containers=( grep { any { $_->{d} eq $inner } @{$tree{$_}{holds}} } keys %tree);

    # if there are none, we're finished on this path

    if((0+@containers)==0) {
        return 0;
    }

    # if there are some, check if we've seen each before, if not: record it and then step back

    print "$inner can be held by @containers\n";

    foreach $n (@containers) {
        if(! any { $_ eq $n } @outers) {
            push @outers, $n;
            $path="$n - $path";
            tracepath($n, $path);
        } 
    }

}

tracepath("shiny gold bag","(shiny gold bag)");

print Dumper \%tree;

print Dumper \@outers;

printf "Answer: %d\n", (0+@outers);

printf "Answer 2: %d\n", tracein("shiny gold bag","");

sub tracein {
    my $bag=$_[0];
    my $indent=$_[1];
    my $count=1;

    print "$indent$bag contains:\n";

    foreach $inside (@{$tree{$bag}{holds}}) {
        last if(! defined($inside->{d}));
        print "$indent$inside->{n} $inside->{d}\n";
        $count+=$inside->{n}*tracein($inside->{d},$indent."  ");
    }
    return $count;
}