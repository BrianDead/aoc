#!/usr/bin/perl

use Data::Dumper;

#my @data = map { print $_; chomp } <STDIN>;

my $result=0;

while(my $ln=<STDIN>) {
    chomp $ln;
    my ($ld, $consumed)=parseline($ln);
    print Dumper \%{$ld};

    if(ref($result) eq '') {
        $result=$ld;
        next;
    }

    $result=doadd($result, $ld);
    print Dumper \%{$result};

    while(!$done) {
        my $action1=0; my $action2=0;
        my $l; my $r;
        $action1=explode($result, 0, 0);
        $action2=dosplit($result) unless ($action1);
        print "Explode: $action1 - Split: $action2\n";
        print printnum($result)."\n";
        last unless($action1 || $action2);
    }

}

print "Answer: ".getmagnitude($result)."\n";



sub doadd {
    return { l=> $_[0], r=>$_[1]};
}

sub dosplit {
  
    my $ld=$_[0];
    my $action=0;

    foreach('l','r') {
        if(ref($ld->{$_}) eq '') {
            my $n=($ld->{$_});
            if( $n >= 10) {
                $ld->{$_} = { l=> int($n/2), r=>int(($n/2)+0.5)};
                $action=1;
            }
        } else {
            $action=dosplit($ld->{$_});
        }
        last if($action);
    }
    return $action;
}

sub getmagnitude {
    my $mag=0;
    my $ld=$_[0];

    map { 
            if(ref($ld->{$_}) eq '') {
                $mag += ( ($ld->{$_}) * ( ($_ eq 'l') ? 3 : 2 ) );
            } else {
                $mag += (getmagnitude($ld->{$_}) * ( ($_ eq 'l') ? 3 : 2 ));
            }
        } ('l','r');
    return $mag;
}

my $lastlnum=0;
my $lastlside='';
my $nextr=0;
my $gaction=0;

sub explode {
    my $ld=$_[0];
    my $depth=$_[1];
    my $action=$_[2];
    my $l=0; my $r=0;

    if($depth==0) {
        $lastlnum=0;
        $lastlside='';
        $nextr=0;
        $gaction=0;
    }

    if($depth>=4 && (ref($ld->{l}) eq '') && (ref($ld->{r}) eq '' && !$action)) {
#        print "Exploding [$ld->{l}][$ld->{r}]\n";
        if(ref($lastlnum) ne '') {
            $lastlnum->{$lastlside}+=($ld->{l});
        }
#        print "Setting nextr to $ld->{r}\n";
        $nextr=($ld->{r});
#        print "Set nextr to $nextr\n";
        $action=1;
    } else {

        foreach('l','r') {
#            print("$depth:$_\n");
            my $isnum=(ref($ld->{$_}) eq '');
            if(!$action || $nextr) {
                if(!$isnum) {
                    $action=explode($ld->{$_}, $depth+1, $action);
                    if($action==1) {
                        $ld->{$_}=0;
                        $action=2;
                    }
                }
            }
            if($isnum) {
                if($nextr) {
 #                   print "Next r - $nextr";
                    $ld->{$_} += ($nextr);
                    $nextr=0;
                }
                $lastlnum=$ld; $lastlside=$_;
            }
    #        last if($action);
        }
    }

    return $action;
}


sub parseline {
    my $line=$_[0];
    my $depth=0;
    my %ret=();
    my $i=1;
    my $consumed=0;

    print "Parsing line: $line\n";

    #find left side

    printf "%s", substr($line,1);

    if (substr($line,$i) =~ q/^([0-9]+),.*/ ) {
        print "Left - number $1\n";
        $ret{'l'}=$1;
        $consumed=length($1);
    } elsif (substr($line,$i,1) eq '[') {
        print "Left - pair\n";
        ($ret{'l'}, $consumed)=parseline(substr($line,1));
        $consumed++;
    } else { die; }
    print "Consumed: $consumed\n";
    $i+=($consumed+1);

    #now find right side
    #skip the ,[

    printf "%s\n", substr($line,$i);
    if (substr($line,$i) =~ q/^([0-9]+)\]/ ) {
        print "Right - number $1\n";
        $ret{'r'}=$1;
        $consumed=length($1);
    } elsif (substr($line, $i,1) eq '[') {
        ($ret{'r'}, $consumed)=parseline(substr($line,$i));
        $consumed++;
    } else { die; }
    $i+=$consumed;

    print "Return $i consumed\n";

    return (\%ret, $i);
}

sub printnum {
    my $ld=$_[0];
    my $ret="";

    $ret="[";
    if(ref($ld->{l}) eq '') {
        $ret=$ret.$ld->{l};
    } else {
        $ret=$ret.printnum($ld->{l});
    }
    $ret=$ret.",";
    if(ref($ld->{r}) eq '') {
        $ret=$ret.$ld->{r};
    } else {
        $ret=$ret.printnum($ld->{r});
    }
    $ret=$ret."]";
}

