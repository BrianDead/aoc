#!/usr/bin/perl


my @code= map { chomp; [split / /] } <>;

my $end=@code;

print "End: $end\n";

my $dupe=0;
my %seq=();
my $acc=0;
my $pc=0;

#while(!($seq{$pc}++)) {

sub run {
    my $pc=$_[0];
    my $acc=$_[1];
    my $spec=$_[2];
    my %seq=%{$_[3]};
    my $indent=($spec)?">>>":"";
    my $tmp=0;

    print Dumper \%seq;

    while(!$tmp && $pc<$end && !($seq{$pc}++)) {
        print "$indent$pc: ";
        if($code[$pc][0] eq "nop") {
            print "NOP - ";
            $tmp=run($pc+$code[$pc][1], $acc, 1, \%seq) unless($spec);
            $pc++;
        } elsif ($code[$pc][0] eq "acc") {
            print "ACC $code[$pc][1]";
            $acc+=($code[$pc][1]);
            $pc++;
        } elsif ($code[$pc][0] eq "jmp") {
            last if($pc+1==$end-1);
            print "JMP $code[$pc][1]";
            $tmp=run($pc+1, $acc, 1, \%seq) unless($spec);
            $pc+=($code[$pc][1]);
        }

        print " - PC:$pc ACC:$acc\n";

    }
    if($pc==$end) {
        return $acc;
    } else {
        return $tmp;
    }

}

$acc=run(0,0,0,());

print "Answer: $acc\n"