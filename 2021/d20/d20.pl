#!/usr/bin/perl

use Data::Dumper;

my $iea;
my @startimage;
my $lines=0;
my $answer1=0;
my $answer2=0;

sub printimage {
    my @image=@{$_[0]};
    my $count=0;

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

    push @image, [ '.','.','.', '.','.', (split //,$line), '.','.','.','.','.' ];

}

unshift @image, [ map {'.'} (0..(@{$image[0]}-1))];
unshift @image, [ map {'.'} (0..(@{$image[0]}-1))];
unshift @image, [ map {'.'} (0..(@{$image[0]}-1))];
unshift @image, [ map {'.'} (0..(@{$image[0]}-1))];
unshift @image, [ map {'.'} (0..(@{$image[0]}-1))];
push @image, [ map {'.'} (0..(@{$image[0]}-1))];
push @image, [ map {'.'} (0..(@{$image[0]}-1))];
push @image, [ map {'.'} (0..(@{$image[0]}-1))];
push @image, [ map {'.'} (0..(@{$image[0]}-1))];
push @image, [ map {'.'} (0..(@{$image[0]}-1))];


print "$iea\n";
print "Lit: ".printimage(\@image)."\n";


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

    print"sx: $sx sy: $sy\n";

    @newimage=map { [ map {$add} (0..$sx+1)]} (0..$sy+1);

    unshift @image, [ map {$ins} (0..($sx-1)) ];
    push @image, [ map {$ins} (0..($sx-1)) ];

    @image=map { [$ins, @{$_},$ins]} @image;

    $sx+=2; $sy+=2;

    printimage(\@image);
    print "\n";

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

print "Answer 1: $answer1\n";

$answer1=0;

my $sx=(0+@{$image[0]});
my $sy=(0+@image);


print "sx: $sx sy: $sy\n";


foreach $y (3..($sy-4)) {
    foreach $x (3..($sx-4)) {
        $answer1++ if($image[$y][$x] eq '#');
    }
}

print "Answer 1: $answer1\n";

