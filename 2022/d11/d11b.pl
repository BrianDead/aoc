#!/usr/bin/perl

use strict;

my %monkeys=();
my $monkey;
my $tm=0;
my $pm=1;

sub applyop {
    my ($o, $q, $wl)=@_;

    $q=$wl if($q eq "old");

    return(eval("$wl$o$q")%$pm); 
}

while (<STDIN>) {
    chomp;
    if($_ eq "") {
        $tm=$monkey if ($monkey > $tm);
        next;
        }    

    if(substr($_,0,6) eq "Monkey") {
        ($monkey)= $_=~ q/Monkey (\d*):/;
        my %info=();
        $monkeys{$monkey}=\%info;
    } else {
        my ($line, $rest)=split /: /, $_;
        if($line eq "  Starting items") {
            my @items=split /, /, $rest;
            $monkeys{$monkey}{"items"}=\@items;
        } elsif($line eq "  Operation") {
            ($monkeys{$monkey}{"op"}, $monkeys{$monkey}{"q"})=$rest =~ q/new = old ([+*]) ([0-9old]*)/;
        } elsif($line eq "  Test") {
            ($monkeys{$monkey}{"test"})= $rest =~ q/divisible by (\d*)/;
            $pm=$pm*$monkeys{$monkey}{"test"};
        } elsif($line eq "    If true") {
            ($monkeys{$monkey}{"true"})= $rest =~ q/throw to monkey (\d*)/;
        } else {
            ($monkeys{$monkey}{"false"})= $rest =~ q/throw to monkey (\d*)/;
        }
    }
}

foreach my $round (1..10000) {
    foreach my $m (0..$tm) {
        my $i=0;
        my @tmi=@{$monkeys{$m}{"items"}};
        foreach my $wl (@tmi) {
            $monkeys{$m}{"inspected"}++;
            $wl=applyop($monkeys{$m}{"op"}, $monkeys{$m}{"q"}, $wl);
            if($wl%$monkeys{$m}{"test"}==0) {
                push @{$monkeys{$monkeys{$m}{"true"}}{"items"}}, $wl;
            } else {
                push @{$monkeys{$monkeys{$m}{"false"}}{"items"}}, $wl;
            }
            shift(@{$monkeys{$m}{"items"}});
            $i++;
        }
    }
    # printf("End of round %d\n", $round);
    # foreach my $m (0..$tm) {
    #     printf("Monkey %d:\n", $m);
    #     print Dumper $monkeys{$m}{"items"};
    # }
}

my $a1=0;
my $a2=0;

my @ins=map{ $monkeys{$_}{"inspected"} } sort { $monkeys{$b}{"inspected"} <=> $monkeys{$a}{"inspected"} } keys %monkeys;

printf("Answer is %d\n\n", $ins[0]*$ins[1]);
