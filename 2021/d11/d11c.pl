#!/usr/bin/perl

use Data::Dumper;
use Term::ANSIScreen qw(cls locate);
use Time::HiRes qw(usleep);

my @input= map {chomp; [ split //]} <>;
my @colors=("\e[0;100m","\e[0;44m","\e[0;46m","\e[0;105m","\e[0;41m","\e[0;43m","\e[0;41m");

my $count=@input;
my $answer=0;
my $answer1=0;
my $answer2=0;
my $w=@{$input[0]};

my $level=0;

my $step=0;

my $novis=0;

print cls() unless ($novis);
sleep(2) unless ($novis);


sub printmap {
    return if($novis);
    print locate()."   Step $step\n";
    foreach(@input) {
        print "  ";
        foreach(@{$_}) {
            if($_==0) { print "$colors[5]*\e[0m"}
            elsif($_<10) { print "$colors[$_/3]$_\e[0m"; }
            else { print $colors[6].chr(55+$_),"\e[0m";}
        }
        print "\n";
    }
    print "\n";
    printf "Flashes: %d\n",$answer+$_[0];
#    usleep(400/($level+2));
}


sub flashall {
    my $r=$_[0];
    my $c=$_[1];
    my $ret=0;
    $level++;
    
    $input[$r][$c]=0;

    for my $dr (-1..1) {
        for my $dc (-1..1) {
            $ret+=flash($r+$dr,$c+$dc) unless(!($dr || $dc));
        }
    }
    $input[$r][$c]=0;
#    print "return $ret\n" if ($level==1);
    $level--;
    printmap($ret+1);
    return $ret+1;
}

sub flash {
    my $r=$_[0];
    my $c=$_[1];
 
    return 0 if ($r<0 || $c<0 || $r>=$count || $c>=$w || $input[$r][$c]==0);

    return flashall($r, $c)  if ((++$input[$r][$c])>9);
    return 0;
}


for($step=0; $step<10000; $step++) {
    # First - increase energy level of each octopus by 1
    @input= map { [map { $_+1 } @{$_}] } @input;

    printmap(0);

# Then any octopus with an energy level greater than 9 flashes

#    my $r=0;
#    my $c=0;

#    map { map { flashall($r,$c) if($input[$r][$c]>9); $c++;} @{$_} ; $r++; $c=0 } @input;

    while (my ($r, $l) = each @input) {
        while (my ($c, $n) = each @{$l}) {
            $answer+=flashall($r,$c) if ($n>9);
        }
    }

    printmap(0);

    $answer1=$answer if ($step<100);
    $answer2=$step+1;

# Check for all 0s

    my $done=1;

    foreach(@input) {
        foreach(@{$_}) {
            if($_) {$done=0;last}
        }
        last if($done);
    }
    last if($done);

#    last unless (0+(map { grep !/0/, @{$_} } @input));
}

print "Answer1: $answer1\nAnswer2: $answer2\nTotal flashes: $answer";