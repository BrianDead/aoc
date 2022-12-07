#!/usr/bin/perl

my @program=map {chomp $_ ; $_} <STDIN>;

for(my $i=89956115999999; $i>11111111111111; $i-- ) {
    my $iter=0;
#    print "$i\n";
    if ($i =~ q/0/) {
#        print "Contains 0\n";
        foreach(my $j=13; $j>=0; $j--) {
            if(substr($i,$j,1) eq '0') {
                $i-=((10 ** (13-$j)));
#                print "At pos $j - try $i\n";
            }
        }
    }
#    print "$i\n";

    $iter=run($i);

    if($iter<14) {
        $i-=($i % (10**(13-($iter-1))));
    }
}

sub run {
    my $input=shift;

    my @inst=@program;
    my @inp=split //, $input;

    my %var=(w => 0, x => 0, y => 0, z => 0);

    my $iter=0;

    foreach(@inst) {
        my ($op, $arg)= $_=~ qr/([a-z]{3}) (.*)/;

        if($op eq 'inp') {
            $var{$arg}=shift @inp;
#            print "$_: inp $var{$arg}";
            if(($iter>=13 && $var{z}>(26 ** 2)) || 
                ($iter>=12 && $var{z}>(26 ** 3)) || 
                ($iter>=11 && $var{z}>(26 ** 4)) || 
                ($iter>=7 && $var{z}>(26 ** 5)) ||
                ($iter==6 && $var{z}>(26**5)) ) {
                print "\n$input: z of $var{z} too high at iter $iter\n";
                last;
            }
            $iter++; #print "\nIteration $iter\n";
        } else {
            my @arg=split / /,$arg;

            if($arg[1] =~ q/[wxyz]/) {
                $arg[1] = $var{$arg[1]};
            }
            if ($op eq 'add') {
                $var{$arg[0]}=$var{$arg[0]}+$arg[1];
            } elsif ($op eq 'mul') {
                $var{$arg[0]}=$var{$arg[0]}*$arg[1];
            } elsif ($op eq 'mod') {
                $var{$arg[0]}=$var{$arg[0]} % $arg[1];
            } elsif ($op eq 'div') {
                $var{$arg[0]}=int($var{$arg[0]} / $arg[1]);
            } elsif ($op eq 'eql') {
                $var{$arg[0]}=($var{$arg[0]}==$arg[1]) ? 1 : 0;
            }
#            print "$_: $op $arg[0] $arg[1]";
        }
#        print ": w=$var{w} x=$var{x} y=$var{y} z=$var{z}\n";
    }

    if($var{z}==0) {
        print "$input is valid\n";
    } else {
        print "$input is NOT valid z=$var{z}\n";
    }

    return $iter;
}