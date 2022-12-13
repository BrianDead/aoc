#!/usr/bin/perl

use strict;

sub checkLists {
    my $l1=shift;
    my $l2=shift;
    my $i=0;


    my $valid=0;
    do {
        my $r1=ref($l1->[$i]);
        my $r2=ref($l2->[$i]);
    
        if($i>=(scalar @{$l1})) {
            if($i>=(scalar @{$l2})) {
                #no decision
            } else {
                # left finished first - correct
                $valid=-1;
            }
        } else {
            if($i>=(scalar @{$l2})) {
                # right finished first - invalid
                $valid=1;
            } else {
                #continue
            }
        }

        if($valid==0) {
            if($r1 eq "ARRAY") {
                if($r2 eq "ARRAY") {
                    $valid=checkLists($l1->[$i], $l2->[$i]);
                } else {
                    $valid=checkLists($l1->[$i], [$l2->[$i]]);        
                }
            } else {
                if($r2 eq "ARRAY") {
                    $valid=checkLists([$l1->[$i]], $l2->[$i]);
                } else {
                    if($l1->[$i] < $l2->[$i]) {
                        $valid=-1;
                    } elsif($l1->[$i] > $l2->[$i]) {
                        $valid=1;
                    }
                }
            }
        }
        $i++;

    } while ($valid==0 && ($i<=(scalar @{$l1})) && ($i<=(scalar @{$l2})));

    return($valid);
}

my %in=();

while(<STDIN>) {
    chomp;
    next if($_ eq "");

    $in{$_}=eval($_);
}

$in{"[[2]]"} = eval("[[2]]");
$in{"[[6]]"} = eval("[[6]]");

my @skeys=sort { checkLists($in{$a}, $in{$b}) } keys %in;

my $r2=0; my $r6=0;

while (my($i, $k) = each @skeys) {
    printf("%d - %s\n", $i, $k);
    $r2=$i+1 if($k eq "[[2]]");
    $r6=$i+1 if($k eq "[[6]]");
}

printf("Answer is %d\n", $r2*$r6);