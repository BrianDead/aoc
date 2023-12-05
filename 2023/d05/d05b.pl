#!/usr/bin/perl

use Data::Dumper;

my @stagenames=[ 'seed' ];
my @maps;
my @seeds;
my $map;

my $answer=9999999999;

my $header="";

my $from;
my $to;

sub max {
	return (($_[0])>($_[1])?$_[0]:$_[1]);
}
sub min {
	return (($_[0])<($_[1])?$_[0]:$_[1]);
}

while(<>) {
	chomp;
	next if($_ eq "");
	if($_ =~ /:/ ) {
		my ($header, $rest) = split /: +/;
		if($header eq "seeds") {
				my @sl=split / /, $rest;
				foreach my $si (0..($#sl / 2)) {
					printf("Seedrange %d for %d\n", $sl[$si*2], $sl[$si*2+1]);
					my %t1=('s'=>$sl[$si*2],'l'=>$sl[$si*2+1]);
					push (@seeds, \%t1)
				} 
		} else {
			($from, $to) = $rest =~ /([a-z]+)-to-([a-z]+) map/;
			$i=0;
		}
	} else {

		if($i==0) {
			$map=[ ];
			push(@stagenames, $to);
			push(@maps,$map);
			$i++;
		}
		my %list;
		($list{'d'}, $list{'s'}, $list{'l'})=split / /;
		push (@{$map}, \%list);
	}
}

# Now calculate

print Dumper @seeds;

printf("Max %d\n", max(5,4));

my @sr=@seeds;

# Now, go through each stage, rewriting and fragmenting the seed list as needed
foreach my $um (@maps) {
	my @dr;

# First, sort each stage by source
	my @m=sort { $a->{'s'} <=> $b->{'s'}} @{$um};
	print Dumper @m;
	print "=========\n";
	print Dumper @sr;
	print "=========\n";

# Walk the seed list
	foreach my $seedrange (@sr) {
		my $st=$seedrange->{'s'};
		my $sl=$seedrange->{'l'};
		printf("Range from %d for %d\n", $st, $sl);

# Find the transformation that matched the start of the list
		foreach my $o (@m) {
			printf("Checking for overlap %d with transform starting at %d\n", $st, $o->{'s'});
#			next if(( ($o->{'s'}+$o->{'l'})<$st) || ;
# Does it start before our seed block
			if($o->{'s'} < $st) {
				printf("Starts before our block\n");
# If so, does it end before our seed block starts - then jump to the next
				if($o->{'l'}+$o->{'s'} < $st) {
					printf("Ends before our block\n");
					next;
				} else {
					printf("Ends after our block starts\n");
# Follow the transform for the overlapping bit
					my $ol=min($o->{'s'}+$o->{'l'}-$st, $sl);
					my $tf=$o->{'d'}+($st-$o->{'s'});
					printf("s=%d l=%d\n", $tf, $ol);
					my %tmp=('s'=>$tf, 'l'=>$ol);
					push(@dr, \%tmp);
					$st+=$ol;
					$sl-=$ol;
					printf("%d remaining at %d\n", $sl, $st);
#if there's any of the seedblock left, move on to check the next transform
				}

			} else {
				printf("Starts on or after our block\n");
# Transform starts on or after our block starts

# Does it start after our seed block ends
				if(($st+$sl)<$o->{'s'}) {
				printf("Starts after our block ends\n");
# The whole seed block fits before the transformation
					my %tmp=('s'=>$st, 'l'=>$sl);
					push(@dr, \%tmp);
					$sl=0;
				} else {
				printf("Starts before our block ends\n");
#The chunk before the transform block is copied as a new, smaller block
					my $l1=$o->{'s'}-$st;
					my %t1=('s'=>$st, 'l'=>$l1);
#The chunk that overlaps is transformed.
					my $l2=min($o->{'l'} , $sl-$l1 );
					my %t2=('s'=>$o->{'d'}, 'l'=>$l2);
					printf("Before %d for %d, in transform %d for %d\n", $st, $l1, $o->{'d'}, $l2);
					push(@dr, \%t1) if($l1>0);
					push(@dr, \%t2) if($l2>0);
# Reduce the size of the block remaining to handle 
					$st=$o->{'s'}+$l2;
					$sl-=($l1+$l2);
				}
			}
# If we've used up all the block, stop walking the map and move to the next block
			last if ($sl<1);
		}
# If we've walked all transforms and still have range left, push it untransformed
		if($sl>0) {
			my %t1=('s'=>$st, 'l'=>$sl);
			push(@dr, \%t1);
		}

	}
# On to the next stage. The @dr list becomes the working @sr list
	@sr=@dr;
}

my @sorted= sort { $a->{'s'}<=>$b->{'s'} } @sr;

printf("Answer is %d\n", $sorted[0]->{'s'});

