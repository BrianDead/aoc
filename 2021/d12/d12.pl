#!/usr/bin/perl

my %map;

use Data::Dumper;

while (my $line=<STDIN>) {
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

    print "Starting: $node :: ";
    printtrail(\@trail);

    foreach $next (@{$map{$node}}) {
        print "$next...";
        next if ($next eq "start");
        if($next =~ q/[a-z]{1,2}/) {
            print "small";
            # is it a small cave and have we been here before
            next if (0+(grep { $_ eq $next } @trail));
        }
        my @newtrail=(@trail, $next);
        if($next eq "end") {
            push @paths, [@newtrail];
            printtrail (\@newtrail);
        } else {
            trypaths($next, \@newtrail);
        }
        print "\n";
    }
}


my @trail=("start");

print "$trail[0]\n";

printtrail(\@trail);

trypaths('start', \@trail);

foreach(@paths) {
    printtrail(\@{$_});
}



printf("Answer: %d\n", (0+@paths));

