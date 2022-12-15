use strict;
no warnings 'recursion';
use List::Util qw(min max);

my %map; # maps "$x,$y" to '#', 'o'
my $maxY = 0;

while (<>) {
    chomp;
    my @pairs = split / -> /;
    my $first = shift @pairs;
    my ($px, $py) = split /,/, $first;
    $maxY = max($maxY, $py);
    $map{"$px,$py"} = '#';
    foreach my $pair (@pairs) {
        my ($x, $y) = split /,/, $pair;
        $maxY = max($maxY, $y);
        if ($px == $x) {       # Vertical line
            $map{"$px,$_"} = '#' foreach (min($py, $y) .. max($py, $y));
        } elsif ($py == $y) {  # Horizontal line
            $map{"$_,$py"} = '#' foreach (min($px, $x) .. max($px, $x));
        } else {
            die "Bad pair $pair: $_";
        }
        ($px, $py) = ($x, $y);
    }
}

my $floor = $maxY + 2; # Stopping level, not '#' level

my $part = 2;
sub fill($$);
sub fill($$) {
    my ($x, $y) = @_;
    my $cell = $map{"$x,$y"};
    return 1 if ($y == $floor or (defined $cell and ($cell eq '#' or $cell eq 'o')));
    return 0 if ($part == 1 and $y > $maxY);
    my $continue = fill($x, $y+1) && fill($x-1, $y+1) && fill($x+1, $y+1);
    $map{"$x,$y"} = 'o' if $continue;
    return $continue;
}

fill(500,0);
my $grains = grep { $_ eq 'o' } values %map;
print "Sand count: $grains\n";
