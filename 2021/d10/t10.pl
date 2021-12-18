#!/usr/bin/perl

use Data::Dumper;

my $answer=0;
my $count=0;


#my @input=map { chomp ; $_ } <>;
my @input=();

my %opp=('['=>']','{'=>'}','('=>')', '<'=>'>', ']'=>'[','}'=>'{',')'=>'(','>'=>'<');
my %score=( ')'=>'3',']'=>57,'}'=>1197,'>'=>'25137');
my %score2=( '('=>1, '['=>2,'{'=>3,'<'=>4);
my @num=(1,2,3,4,6,9,13);

print Dumper \%score;
print "@{[%score]}\n";
print "$_ $score{$_}\n" foreach (keys %score);
while (my ($k, $v)=each %score) { print "$k: $v\n"; }
map { print $count++."$_\n"; } %opp;

foreach $t (grep { print "grep ".$count++."$_\n"; $_ =~ /[<>]/ } %opp) {print "Found $t\n";}

print Dumper map [$_,chr(32+$_)], @num;