#!/user/bin/perl

use Data::Dumper;

my $rs=0;
my $start;


while(my $line=<STDIN>) {
    chomp $line;
    if(!$rs) {
        $start=$line;
        $rs=1;
    } elsif ($rs==1) {
        $rs=2;
    } elsif ($rs==2) {
        $line =~ q/([A-Z]{2}) -> ([A-Z])$/;
        $rules{$1}=$2;
    }
}

foreach my $turn (1..10) {
    my $np="";
    foreach my $i (0..length($start)-2) {
        $np=$np.substr($start,$i,1).$rules{substr($start,$i,2)}
    }
    $np=$np.substr($start,length($start)-1,1);

    print "Turn $turn:".length($np)."\n";
    $start=$np;
}

my %acc;

foreach my $i (0..(length($start)-1)) {
#    print "$i: ".substr($start, $i, 1)."\n";
    $acc{substr($start, $i, 1)}++;
}

print Dumper \%acc;

my $max=0;
my $min=100000;

foreach my $key (keys %acc) {
    print "$key: $acc{$key}\n";
    $max=$acc{$key} if($acc{$key}>$max);
    $min=$acc{$key} if($acc{$key}<$min);
}

print "Max: $max, Min: $min, ANswer:".($max-$min)."\n";