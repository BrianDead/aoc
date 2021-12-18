#!/usr/bin/perl

my %map;

use Data::Dumper;

while (my $line=<>) {
    @part= $line =~ q/([a-zA-Z]*)-([a-zA-Z]*)/;
    push (@{$map{$part[0]}}, $part[1]);
    push (@{$map{$part[1]}}, $part[0]);
}

print Dumper \%map;

my @paths=();

my $done=1;


sub printtrail {
    my @trail=@{$_[0]};
    foreach $place (@trail) {
        print "-$place";
    }
    print "\n";
}

sub trypaths {
    my $node=$_[0];
    my @trail=@{$_[1]};

    foreach $next (@{$map{$node}}) {
        my $ds=0;
        next if ($next eq "start");
        if($next =~ q/[a-z]{1,2}/) {
            # is it a small cave and have we been here before
            my $q=(0+(grep { $_ eq $next } @trail));
            next if ($q>1);
            if ($q==1) {
                next if($trail[0] eq "!");
                $ds=1;
            }
        }
        my @newtrail=(@trail, $next);
        unshift(@newtrail, "!") if($ds);
        
        if($next eq "end") {
            push @paths, [@newtrail];
            printtrail (\@newtrail);
        } else {
            trypaths($next, \@newtrail);
        }
    }
}


my @trail=("start");

trypaths('start', \@trail);

#foreach(@paths) {
#    printtrail(\@{$_});
#}

printf("Answer 1: %d\nAnswer: %d\n", (0+grep { $_->[0] ne "!" } @paths), (0+@paths));


