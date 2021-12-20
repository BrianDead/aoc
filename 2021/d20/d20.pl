#!/usr/bin/perl

use Data::Dumper;
use Term::ANSIScreen qw(cls locate);

my $iea;
my @startimage;
my $lines=0;
my $answer1=0;
my $answer2=0;

sub printimage {
    my @image=@{$_[0]};
    my $count=0;

    print cls().locate();

    foreach(@image) {
        foreach(@{$_}) {
            print $_;
            $count++ if($_ eq '#');
        }
        print "\n";
    }
    return $count;
}

while(my $line=<STDIN>) {
    chomp $line;

    if($lines==0) {
        $iea=$line;
        $lines++;
        next;
    }

    $lines++;
    next if($line eq "");

    push @image, [  '.',(split //,$line),'.' ];

}

 unshift @image, [ map {'.'} (0..(@{$image[0]}-1))];
 push @image, [ map {'.'} (0..(@{$image[0]}-1))];

foreach $turn (0..49) {
    my $sx=(0+@{$image[0]});
    my $sy=(0+@image);

    if($turn % 2) {
        $ins='#';
        $add='.';
    } else {
        $ins='.';
        $add='#';
    }

    my @newimage=();

    @newimage=map { [ map {$add} (0..$sx+1)]} (0..$sy+1);

    unshift @image, [ map {$ins} (0..($sx-1)) ];
    push @image, [ map {$ins} (0..($sx-1)) ];

    @image=map { [$ins, @{$_},$ins]} @image;

    $sx+=2; $sy+=2;

    foreach $y (1..($sy-2)) {
        foreach $x (1..($sx-2)) {
            my $binary=0;
            my $base=256;
            my $char=$add;
            if ($y==0 || $y==($sy-1) || $x==0 || $x==($sx-1)) {
                $char=$add;
            } else {   
                foreach $dy (-1..1) {
                    foreach $dx (-1..1) {
                        $binary+=$base if($image[$y+$dy][$x+$dx] eq '#');
                        $base/=2;
                    }
                }
                $char=substr($iea, $binary, 1);
            }
            $newimage[$y][$x]=$char;
        }
    }

    $answer1=printimage(\@newimage);

    print "-----\n";

    @image=@newimage;
}

print "Answer (15653): $answer1\n";

