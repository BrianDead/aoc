#!/usr/bin/perl

# Using regexes inspired by /u/Smylers on reddit

my $total;
my %num=(zero=>0, one=>1, two=>2, three=>3, four=>4, five=>5, six=>6, seven=>7, eight=>8, nine=>9);
my $grp="\\d|one|two|three|four|five|six|seven|eight|nine";
while (<>) {
  my @a=map {($_>0)?$_:$num{$_}} ("$_ $_" =~ /($grp).*($grp)/s);
  $total += "$a[0]$a[1]";
}
print $total;
