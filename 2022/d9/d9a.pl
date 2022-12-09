#!/usr/bin/perl

use strict;

my @board=();
my @tpos=(0,0);
my @hpos=(0,0);
my @touched=();

my %moves=( 'Rx'=>1, 'Ry'=>0,'Lx'=>-1,'Ly'=>0,'Uy'=>1, 'Ux'=>0, 'Dy'=>-1, 'Dx'=>0);

sub touch {
    my @p=@_;

#    printf("Touched %d,%d\n", $p[0], $p[1]);

    foreach my $t (@touched) {
        return if($t->[0]==$p[0] && $t->[1]==$p[1]);
    }
#    print("- new\n");
    push @touched, \@p;
}

while(<STDIN>) {
    chomp;
    my ($m, $n)=split / /;

    foreach (1..$n) {
        touch(@tpos);
        # Move head
        $hpos[0]+=$moves{$m.'x'};
        $hpos[1]+=$moves{$m.'y'};

        # Now move tail
        my $dx=$hpos[0]-$tpos[0];
        my $dy=$hpos[1]-$tpos[1];

        if($dx>1) {
            $tpos[0]+=1;
            $tpos[1]+=$dy;
        } elsif($dx<-1) {
            $tpos[0]-=1;
            $tpos[1]+=$dy;
        }  elsif($dy<-1) {
            $tpos[1]-=1;
            $tpos[0]+=$dx;
        }  elsif($dy>1) {
            $tpos[1]+=1;
            $tpos[0]+=$dx;
        }
    }
}

touch(@tpos);


printf("The answer is %s", scalar @touched);