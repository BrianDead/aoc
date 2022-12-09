#!/usr/bin/perl

use strict;

my %kpos=( 'Hx'=>0, 'Hy'=>0);
my @knots=('H','1','2','3','4','5','6','7','8','9');
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

#    printf("Moving %d %s\n", $n, $m);

    foreach (1..$n) {
        touch($kpos{'9x'},$kpos{'9y'});
        # Move head
        $kpos{'Hx'}+=$moves{$m.'x'};
        $kpos{'Hy'}+=$moves{$m.'y'};

#        printf("Head now at %d,%d\n", $kpos{'Hx'}, $kpos{'Hy'});

        # Now move the rest
        foreach my $i (1..(@knots-1)) {
            my $dx=$kpos{$knots[$i-1].'x'}-$kpos{$knots[$i].'x'};
            my $dy=$kpos{$knots[$i-1].'y'}-$kpos{$knots[$i].'y'};
#            printf("Comparing %s to %s (%d, %d)\n", $knots[$i-1], $knots[$i], $dx, $dy);

            print("ALARM $dx, $dy\n") if(abs($dx)>2 || abs($dy)>2);

            if(abs($dx)>1){
                $kpos{$knots[$i].'x'}+=$dx/2;
                $kpos{$knots[$i].'y'}+=($dy<0?-1:1) if($dy!=0);
            } elsif(abs($dy)>1) {
                $kpos{$knots[$i].'y'}+=$dy/2;
                $kpos{$knots[$i].'x'}+=($dx<0?-1:1) if($dx!=0);
            }
        }
    }
}

touch($kpos{'9x'},$kpos{'9y'});

printf("The answer is %s", scalar @touched);
