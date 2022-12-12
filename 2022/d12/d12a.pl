#!/usr/bin/perl

# WARNING - this is a terrible idea. It can solve the test puzzle, but will run forever
# on the real input. See d12a2.pl for the real solution.


use strict;
use Data::Dumper;

my @grid=map{ chomp; [split //] } <STDIN>;

my $w=@{$grid[0]};
my $h=@grid;
my @s=(-1,-1); my @e=(-1,-1);
my @paths=();

my $x=0; my $y=0;

foreach (@grid) {
    foreach (@{$_}) {
        if ($_ eq "S") {
            @s=($x, $y);
        } elsif ($_ eq "E") {
            @e=($x, $y);
        }
        $x++;
    }
    $y++;
    $x=0;
}

printf("Start at %d, %d - End at %d, %d - Grid w=%d, h=%d\n", @s, @e, $w, $h);

try(@s);

@paths=sort { $a <=> $b } @paths;
printf("Answer is %d\n", $paths[0]);
print Dumper \@paths;


sub testH {
    my $t=$grid[$_[1]][$_[0]];
    my $f=$_[2];

    printf("Inputs %d %d %s\n", $_[0], $_[1], $_[2]);

    $f="a" if($f eq "S");
    $t="z" if($t eq "E");

    printf("Testing %s to %s (%d to %d)\n", $f, $t, ord($f), ord($t));

    return((ord($t)-ord($f))<=1);
}

sub beenBefore {
    my $been=0;
    my $x=shift @_; my $y=shift @_;
    my @m=@{shift @_};

    foreach(@m) {
        if($_->{"x"}==$x && $_->{"y"}==$y) {
            $been=1;
            last;
        }
    }
    printf("Been to %d, %d? %d\n", $x, $y, $been);
    return $been
}

sub try {
#    my $x=$_[0]; my $y=$_[1];
    my $x=shift @_; my $y=shift @_;
    my @path=@_;

    printf("Trying %d, %d - path is %d\n", $x, $y, scalar @path);

    my %p=("x"=>$x, "y"=>$y, "t"=>0);
    push @path, \%p;

    # Is this the end
    my $d=($grid[$y][$x] eq "E");
    if( $d) {
        printf("Path %d\n", @path-1);
        push(@paths, @path-1);
    }

    if($x>0 && !beenBefore($x-1, $y, \@path) && testH($x-1, $y, $grid[$y][$x])) {
        $d=try($x-1, $y, @path);
    }
    $p{"t"}++;
    if($x<($w-1) && !beenBefore($x+1, $y, \@path) && testH($x+1, $y, $grid[$y][$x])) {
        $d=try($x+1, $y, @path);
    }
    $p{"t"}++;
    if($y>0 && !beenBefore($x, $y-1, \@path) &&testH($x, $y-1, $grid[$y][$x])) {
        $d=try($x, $y-1, @path);
    }
    $p{"t"}++;
    if($y<($h-1) && !beenBefore($x, $y+1, \@path) && testH($x, $y+1, $grid[$y][$x])) {
        $d=try($x, $y+1, @path);
    }
    $p{"t"}++;

    return($d);
}


