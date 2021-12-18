#!/usr/bin/perl

use Data::Dumper;

my @input= map {chomp; [ split //]} <>;

my $count=@input;
my $answer=0;
my $answer1=0;
my $answer2=0;
my $w=@{$input[0]};

sub flashall {
    my $r=$_[0];
    my $c=$_[1];
    
#    print "FLASHALL Row $r Col $c is $input[$r][$c]\n";

    $input[$r][$c]=0;
    flash($r-1,$c-1);
    flash($r-1,$c);
    flash($r-1,$c+1);
    flash($r,$c-1);
    flash($r,$c+1);
    flash($r+1,$c-1);
    flash($r+1,$c);
    flash($r+1,$c+1);
    $input[$r][$c]=0;
    $answer++;

}

sub flash {
    my $r=$_[0];
    my $c=$_[1];

    return 0 if ($r<0 || $c<0 || $r>=$count || $c>=$w || $input[$r][$c]==0);
#     print "FLASH Row $r Col $c is $input[$r][$c]\n";

    flashall($r, $c)  if ((++$input[$r][$c])>9);

}


for(my $step=0; $step<1000; $step++) {
# First - increase energy level of each octopus by 1
    @input= map { [map { $_+1 } @{$_}] } @input;

    print "Step $step\n";
    foreach(@input) {
        foreach(@{$_}) {
            print $_;
        }
        print "\n";
    }

# Then any octopus with an energy level greater than 9 flashes

    my $r=0;
    my $c=0;

    map {  map {  flashall($r,$c) if($input[$r][$c]>9); $c++;} @{$_} ; $r++; $c=0 } @input;

#     for(my $r=0; $r<$count; $r++) {
#         for(my $c=0; $c<$w; $c++) {
# #            print "Row $r Col $c is $input[$r][$c]\n";
#             flashall($r,$c);
#         }
#     }

    print "Step $step: $answer\n";

# Check for all 0s


    # my $iss=0;

    # foreach(@input) {
    #     foreach(@{$_}) {
    #         print $_;
    #         $iss++ if ($_==0);
    #     }
    #     print "\n";
    # }

    $answer1=$answer if ($step<100);
    $answer2=$step+1;

#    last if($iss==$w*$count);
    last unless (0+(map { grep !/0/, @{$_} } @input));



}

print "Answer1: $answer1\nAnswer2: $answer2\n"