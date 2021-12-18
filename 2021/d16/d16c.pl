#!/usr/bin/perl



my @raw= map {chomp; split//} <STDIN>;
my @data= map { my $b=sprintf("%04b", hex($_)); split //, $b } @raw;

print "Original chars: $#raw \tBinary chars: $#data\n";

my $answer1=0;
my @pc=(0,0);
my $bc=0;

#first 3 bits=version
#second 3 bits=type
#type=4 -> literal value
## n groups of 5 bits starting with 1 - next four bits are the value
## final group of 5 bits starting with 0 - next four bits are the value
#type!=4 -> operator
## 2 bits -> length type ID
### length type = 0 -> 15 bits of length - total subpacket length in bits
### length type = 1 -> 11 bits of length - number of subpackets
### subpackets

sub getbits {
    my $num=$_[0];
    my $ret="";
    my $count=0;

    foreach(1..$num) {
        $ret=$ret.$data[$bc++];
    }
    print "Got $num bits: $ret (".oct("0b".$ret).")\n";
    return(oct("0b".$ret))
}

my $done=0;

sub nextpacket {
    my $ret=0;
    my $ver=0;
    my $type=0;
    my $num=0;
    my @vals=();
    my $final=0;

    $ver=getbits(3);
    $ret+=$ver;
    print "Packet version: $ver\n";
    $type=getbits(3);
    if ($type==4) {
        print "Type: Literal (4)\n";
        my @nybs=();
        while(1) {
            $num=getbits(5);
            push @nybs, $num & 15;
            last if ($num<16);
        }
        my $base=1;
        while(@nybs) {
            $final+=$base*(pop @nybs);
            $base*=16;
        }
    } else {

        print "Type: Other ($type)\n";
        my $lent=getbits(1);
        if($lent) {
            my $len=getbits(11);
            print "Length type $lent - $len packets\n";
            foreach(1..$len) {
                print "Type 1 Inner ";
                my @v=nextpacket();
                $ret+=pop @v;
                push @vals, @v;
            }
        } else {
            my $len=getbits(15);
            print "Length type $lent - $len bits\n";
            my $sbc=$bc;
            while($bc<($sbc+$len)) {
                print "Type 2 Inner ";
                my @v=nextpacket();
                $ret+=pop @v;
                push @vals, @v;
            }
        }
        if($type==0) {
            map { $final+= $_} @vals;
        } elsif ($type==1) {
            $final=1;
            map { $final*= $_} @vals;
        } elsif ($type == 2) {
            $final=$vals[0];
            map { $final=$_ if($_ < $final) } @vals;
        } elsif ($type == 3) {
            map { $final=$_ if($_ > $final) } @vals;
        } elsif ($type == 5) {
            $final=1 if($vals[0]>$vals[1]);
        } elsif ($type == 6) {
            $final=1 if($vals[0]<$vals[1]);
        } elsif ($type == 7) {
            $final=1 if($vals[0]==$vals[1]);
        }
    }
    print "Final $final\n";
 
    return ($final, $ret);
}

my @fvals=();

@fvals=nextpacket();
$answer1=pop @fvals;
$answer2=pop @fvals;

print "Answer: $answer1\n";
print "Answer2: $answer2\n";