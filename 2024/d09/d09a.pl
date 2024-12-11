#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @m=();

while(<STDIN>) {
	chomp;
	push(@m, split//);
}

my $index=0;

sub resetdisk {
	my $fileflag=1;
	my @disk=();
	for my $num (@m) {
		if($fileflag) {
			push(@disk, ($index) x $num);
			$index++;
			$fileflag=0;
		} else {
			push(@disk, (-1) x $num);
			$fileflag=1;		
		}
	}
	return @disk
}

sub displaydisk {
	foreach(@{$_}) {
		if($_<0) {
			print '.';

		} else {
			print $_;
		}
	}
	print "\n";

}

my @disk=resetdisk();

displaydisk(\@disk);

my $insert=0;
my $from=scalar @disk-1;

while($insert<$from) {
	if($disk[$insert]==-1) {
		if($disk[$from]!=-1) {
			$disk[$insert] = $disk[$from];
			$disk[$from]=-1;
			$from--;
			$insert++;
		} else {
			$from--;
		}
	} else {
		$insert++;
	}
}

my $answer=0;

displaydisk(\@disk);

for my $i (0..(scalar @disk)-1) {
	last if($disk[$i]<0);
	$answer+=$i*$disk[$i];

}

print "Answer: $answer\n";

my @filelist=();
my @spacelist=();
my $fileflag=1;
my $block=0;

for my $num (@m) {
	if($fileflag) {
		push(@filelist, [$block,$num] );
		$index++;
		$fileflag=0;
	} else {
		push(@spacelist, [$block, $num] ) unless($num==0);
		$fileflag=1;		
	}
	$block+=$num;
}

my $firstspace;

for(my $i=(scalar @filelist)-1; $i>=0; $i--) {
#	printf("Considering file $i at %d size %d\n", $filelist[$i][0], $filelist[$i][1]);
	$firstspace=$block;
	for my $s (0..scalar @spacelist - 1) {
#		printf("Space of %d at %d ", $spacelist[$s][1], $spacelist[$s][0]);
		$firstspace=$spacelist[$s][0] if($spacelist[$s][1]>0 && $spacelist[$s][0]<$firstspace);
		if($spacelist[$s][1] >= $filelist[$i][1] && $spacelist[$s][0] < $filelist[$i][0]) {
#			print("fits ");
			my $fblock=$filelist[$i][0];
			$filelist[$i][0]=$spacelist[$s][0];
			$spacelist[$s][1]-=$filelist[$i][1];
			$spacelist[$s][0]+=$filelist[$i][1];
			if($spacelist[$s][1]==0) {
				splice(@spacelist,$s,1);
			}
#			printf("file $i now at %d size %d, ", $filelist[$i][0], $filelist[$i][1]);
#			printf("Space now %d at %d ", $spacelist[$s][1], $spacelist[$s][0]);
			last;
		}
#		print("\n");
	}
#	print("\n");
	last if($filelist[$i][0]<$firstspace);
}

my $answer2=0;

#my @disk2=('-1') x $block;

for my $fn (0..(scalar @filelist)-1) {
	my $sblock=$filelist[$fn][0];
	foreach(0..$filelist[$fn][1]-1) {
		$answer2 += ($sblock+$_) * $fn;
#		$disk2[$sblock+$_]=$fn;
	}
}

#displaydisk(\@disk2);

print("Answer2: $answer2\n");
