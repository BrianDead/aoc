#!/user/bin/perl

use Data::Dumper;

my $rs=0;
my $start;

my %pairs;

# {pair => XX, count =>n}


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


foreach my $i (0..length($start)-2) {
    $pairs{substr($start, $i, 2)}++;
}

print Dumper \%pairs;

foreach my $turn (1..40) {
    my %newpairs=();
    print "Turn $turn\n";
    foreach my $pair (keys %pairs) {
#        print "Expanding $pair ($pairs{$pair})\n";
        $newpairs{(substr($pair,0,1).$rules{$pair})}+=$pairs{$pair};
        $newpairs{($rules{$pair}.substr($pair,1,1))}+=$pairs{$pair};
    }

    %pairs=%newpairs;
}


my %acc=();

foreach my $pair (keys %pairs) {
    $acc{substr($pair,0,1)}+=$pairs{$pair};
    $acc{substr($pair,1,1)}+=$pairs{$pair};
}

print Dumper \%acc;

my $max=0;
my $min=-1;

foreach my $key (keys %acc) {
    $acc{$key}++ if(($key eq substr($start,0,1)) || ($key eq substr($start,length($start)-1,1)));
    print "$key: ".($acc{$key}/2)."\n";
    $max=$acc{$key} if($acc{$key}>$max);
    $min=$acc{$key} if($acc{$key}<$min || $min<0);
}

$max=$max/2; $min=$min/2;

print "Max: $max, Min: $min, ANswer:".($max-$min)."\n";