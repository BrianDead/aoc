#!/usr/bin/perl

my @data;
my $result=0;

while(my $ln=<STDIN>) {
    chomp $ln;
    push @data, $ln;
}

my $maxmag=0;

foreach $l1 (@data) {
    foreach $l2 (@data) {
        next if($l1 eq $l2);

        my $result=0;
        my $c;

        my ($m1, $c)=parseline($l1);
        my ($m2, $c)=parseline($l2);

        $result={ l=>$m1, r=>$m2 };

        while(!$done) {
            my $action1=0; my $action2=0;
            $action1=explode($result, 0, 0);
            $action2=dosplit($result) unless ($action1);
            last unless($action1 || $action2);
        }
        my $mag=getmagnitude($result);
        if($mag>$maxmag) {
            $maxmag=$mag;
            print "New max: $mag\n".printnum($m1)."\n + ".printnum($m2)."\n =".printnum($result)."\n";
        }
    }
}

print "Answer: ".$maxmag."\n";

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
        if(ref($lastlnum) ne '') {
            $lastlnum->{$lastlside}+=($ld->{l});
        }
        $nextr=($ld->{r});
        $action=1;
    } else {

        foreach('l','r') {
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
                    $ld->{$_} += ($nextr);
                    $nextr=0;
                }
                $lastlnum=$ld; $lastlside=$_;
            }
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

    if (substr($line,$i) =~ q/^([0-9]+),.*/ ) {
        $ret{'l'}=$1;
        $consumed=length($1);
    } elsif (substr($line,$i,1) eq '[') {
        ($ret{'l'}, $consumed)=parseline(substr($line,1));
        $consumed++;
    } else { die; }
    $i+=($consumed+1);

    if (substr($line,$i) =~ q/^([0-9]+)\]/ ) {
        $ret{'r'}=$1;
        $consumed=length($1);
    } elsif (substr($line, $i,1) eq '[') {
        ($ret{'r'}, $consumed)=parseline(substr($line,$i));
        $consumed++;
    } else { die; }
    $i+=$consumed;

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

