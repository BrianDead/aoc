#!/usr/bin/perl

use strict;

my $pn=0;
my $answer=0;

my $l1; my $l2;

sub checkLists {
    my $l1=shift;
    my $l2=shift;
    my $i=0;

    print(@{$l1}," - ");
    print(@{$l2},"\n");

    my $valid=-1;
    do {
        my $r1=ref($l1->[$i]);
        my $r2=ref($l2->[$i]);

        printf("i: %d r: %s %s v: %d %d\n", $i, $r1, $r2, $l1->[$i], $l2->[$i]);
    
        if($i>=(scalar @{$l1})) {
            printf("No more on left %d %d\n", $i, scalar @{$l1});
            if($i>=(scalar @{$l2})) {
                printf("List ended together %d %d\n", $i, scalar @{$l2});
                #no decision
            } else {
                printf("Left finished first\n");
                # left finished first - correct
                $valid=1;
            }
        } else {
            printf("Left OK %d %d\n", $i, scalar @{$l1});
            if($i>=(scalar @{$l2})) {
                printf("Right finished first %d %d\n", $i, scalar @{$l2});
                # right finished first - invalid
                $valid=0;
            } else {
                printf("Continue\n");
                #continue
            }
        }

        if($valid==-1) {
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
                        $valid=1;
                    } elsif($l1->[$i] > $l2->[$i]) {
                        $valid=0;
                    }
                }
            }
        }
        $i++;

    } while ($valid==-1 && ($i<=(scalar @{$l1})) && ($i<=(scalar @{$l2})));

    printf("Returning %d\n", $valid);
    return($valid);
}

while(<STDIN>) {
    chomp;
    next if($_ eq "");
    $pn++;
    printf("%d-%d %s\n", int($pn/2), $pn%2, $_);

    if($pn%2) {
        $l1=eval($_);
    } else {
        $l2=eval($_);

        printf("%d %d\n", scalar @{$l1}, scalar @{$l2});

        my $valid=-1;
        $valid=checkLists($l1, $l2);
        $answer+=$pn/2 if($valid==1);
        printf("Input pair: %d - valid? %d - answer now %d\n", $pn/2, $valid, $answer)
    }
}

printf("Here\n");