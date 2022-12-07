#!/usr/bin/perl

use Data::Dumper;

my %root=();
my @wdir=("/");
my %dir=();
my $answer=0;
my $required=0;
my $answer2=70000000;

sub walk {
    while(my ($k, $v)= each %{$_[0]}) {
#        printf("%s, %s (%s)\n",$k, $v, ref($v));
        next if($k eq "!fsize");
        next unless(ref($v) eq "HASH");
        my $dsize=$v->{"!fsize"};
#        printf("Got a directory %s\n", $dsize);
        if($dsize>=$required && $dsize<$answer2) {
            $answer2=$dsize;
        }
        if($dsize<100000) {
            $answer+=$dsize;
        }
        walk($v) if($v->{"!dirs"}>0);
    }
}

while(<STDIN>) {
    chomp;
    my $line=$_;
    my $input=0;

    printf("%s\n", $line);

    if(substr($line, 0, 1) eq "\$") {
        printf("Command ");
        my ($cmd) = $line =~ q/\$ (\w\w)/;
        printf("cmd=%s ", $cmd);
        if($cmd eq "cd") {
            print("cd ");
            my ($newdir) = $line =~ q/\$ cd (.*)$/;
            if($newdir eq "/") {
                @wdir=();
            } elsif($newdir eq "..") {
                pop(@wdir);
            } else {
                push(@wdir, $newdir);
            }
            printf("\n");
            print Dumper \@wdir;
        } else {
            print("not cd ");
            # assume it's ls - let's get into the right dir
            $dir=\%root;
            for(@wdir) {
                $dir=$dir->{$_};
            }
        }
    } else {
        ($s, $n)= split / /,$line;
        if($s eq "dir") {
            my %new=();
            $dir->{$n}=\%new;
            $dir->{"!dirs"}++;
        } else {
            $dir->{$n}=$s;
            my $tdir=\%root;
            $root{"!fsize"}+=$s;
            for(@wdir) {
                $tdir=$tdir->{$_};
                $tdir->{"!fsize"}+=$s;
            }
        }
    }
    print "\n";

}

print Dumper \%root;

my $unused=70000000-$root{"!fsize"};
$required=30000000-$unused;

printf("Root size is %d, need to free %d\n", $root{"!fsize"}, $required);

walk(\%root);

print "Answer is $answer\n";
print "Answer 2 is $answer2\n";