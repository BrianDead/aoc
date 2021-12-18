#!/usr/bin/perl



my @raw= map {chomp; split//} <STDIN>;
print "$raw[0] ".sprintf("%04b", hex($raw[0]));
my @data= map { my $bits=sprintf("%04b", hex($_)); split //,$bits} @raw;


print "$#data $#raw\n";

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


    $ver=getbits(3);
    $ret+=$ver;
    print "Packet version: $ver\n";
    $type=getbits(3);
    if ($type==4) {
        print "Type: Literal (4)\n";
        while(1) {
            $num=getbits(5);
            last if ($num<16);
        }
    } else {
        print "Type: Other ($type)\n";
        my $lent=getbits(1);
        if($lent) {
            my $len=getbits(11);
            print "Length type $lent - $len packets\n";
            foreach(1..$len) {
                print "Type 1 Inner ";
                $ret+=nextpacket();
            }
        } else {
            my $len=getbits(15);
            print "Length type $lent - $len bits\n";
            my $sbc=$bc;
            while($bc<($sbc+$len)) {
                print "Type 2 Inner ";
                $ret+=nextpacket();
            }
        }

    }
    return $ret;
}


while($bc<$#data) {
    print "$bc\n";
    $answer1+=nextpacket();
    print "$answer1";
    last;
}

print "Answer: $answer1\n";
