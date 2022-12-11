#!/usr/bin/perl

use strict;
use Data::Dumper;

my %monkeys=();
my $monkey;
my $tm=0;

sub applyop {
    my $op=$_[0];
    my $wl=$_[1];

    my ($o, $q)= $op =~ q/new = old ([+*]) ([0-9old]*)/;

    $q=$wl if($q eq "old");


    print("$wl$o$q\n");

    return(eval("$wl$o$q")); 
}

while (<STDIN>) {
    chomp;
    if($_ eq "") {
        printf("Done monkey %d\n", $monkey);
        print Dumper $monkeys{$monkey};
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
            $monkeys{$monkey}{"op"}=$rest;
        } elsif($line eq "  Test") {
            ($monkeys{$monkey}{"test"})= $rest =~ q/divisible by (\d*)/
        } elsif($line eq "    If true") {
            ($monkeys{$monkey}{"true"})= $rest =~ q/throw to monkey (\d*)/
        } else {
            ($monkeys{$monkey}{"false"})= $rest =~ q/throw to monkey (\d*)/
        }
    }
}

foreach my $round (1..20) {
    foreach my $m (0..$tm) {
        printf("Round %d Monkey %d\n", $round, $m);
        my $i=0;
        my @tmi=@{$monkeys{$m}{"items"}};
        foreach my $wl (@tmi) {
            $monkeys{$m}{"inspected"}++;
            printf("Before %d - ", $wl);
            $wl=applyop($monkeys{$m}{"op"}, $wl);
            printf("After %d - ", $wl);
           $wl=int($wl/3);
            printf("Then %d\n", $wl);
            if($wl%$monkeys{$m}{"test"}==0) {
                printf("Test true - to monkey %d\n", $monkeys{$m}{"true"});
                push @{$monkeys{$monkeys{$m}{"true"}}{"items"}}, $wl;
            } else {
                printf("Test false - to monkey %d\n", $monkeys{$m}{"false"});
                push @{$monkeys{$monkeys{$m}{"false"}}{"items"}}, $wl;
            }
            shift(@{$monkeys{$m}{"items"}});
            $i++;
        }
    }
    printf("End of round %d\n", $round);
    foreach my $m (0..$tm) {
        printf("Monkey %d:\n", $m);
        print Dumper $monkeys{$m}{"items"};
    }
}

my $a1=0;
my $a2=0;

foreach (keys %monkeys) {
    my $ins=$monkeys{$_}{"inspected"};
    printf("Monkey %s did %d\n", $_, $ins);
    if($ins>$a1) {
        $a2=$a1;
        $a1=$ins;
    } elsif($ins>$a2) {
        $a2=$ins;
    }
}

printf("The Answer is %d\n", $a1*$a2);
