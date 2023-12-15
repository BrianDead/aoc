#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @m=map{ chomp; [split //] } <>;
my $w=scalar(@{$m[0]});
my $h=scalar @m;

sub move {
	my @dir=@_;

	my $rs=0;
	$rs=$h-1 if($dir[0]>0);
	my $rf=($h-1)-$rs;
	my $rd=($rs<$rf)?1:-1;

	my $cs=0;
	$cs=$w-1 if($dir[1]>0);
	my $cf=($w-1)-$cs;
	my $cd=($cs<$cf)?1:-1;

	my $moved=0;

#	print("rs=$rs rf=$rf cs=$cs cf=$cf\n");

	do {
		$moved=0;
		for(my $r=$rs; ($rd<0)?($r>=$rf):($r<=$rf); $r=$r+$rd) {
			for(my $c=$cs; ($cd<0)?($c>=$cf):($c<=$cf); $c=$c+$cd) {
				next if($m[$r][$c] ne "O");
				my $rt=$r+$dir[0]; my $ct=$c+$dir[1];
#				print("$r,$c to $rt,$ct\n");
				next if($rt<0 || $rt>=$h || $ct<0 || $ct>=$h);
#				print("$m[$r][$c] to $m[$rt][$ct]\n");
				next if($m[$rt][$ct] ne ".");
#				print("Moving\n");
				$m[$rt][$ct]="O"; $m[$r][$c]="."; $moved++;
			}
		}
	} until ($moved==0);
}

sub loadcalc {
	my $load=0;

	foreach my $r(0..$h-1) {
		foreach my $c(0..$w-1) {
			$load+=($h-$r) if($m[$r][$c] eq "O");
		}
	}
	return $load;
}

my %v=("."=>0, "#"=>1, "O"=>2);
my %memo;
sub sum {
	my $sum=0;
	my $s="";
	foreach my $r(0..$h-1) {
		foreach my $c(0..$w-1) {
			$sum=($sum*3)+$v{$m[$r][$c]};
		}
		$s=$s."$sum,";
		$sum=0;
	}
	return $s;


}
sub printit {
	foreach(@m) {
		foreach(@{$_}) {
			print "$_";
		}
		print "\n";
	}
	print "\n";

}

printit();

my $a2=0;
my $answer2=0;
my $go=0;
do {
	$a2++;
	move(-1,0);
	printit();
	move(0,-1);
	printit();
	move(1,0);
	printit();
	move(0,1);
	printit();
	my $s=sum();
	print "Sum: $s\n";
	if(exists $memo{$s} && !$go) {
		printf("Repeat at $a2 from $memo{$s} - load=%d\n",loadcalc());
		$a2+=($a2-$memo{$s})*int((1000000000-$a2)/($a2-$memo{$s}));
		$go=1;
	}
	$memo{$s}=$a2;
	print "$a2\n" ;
} until ($a2>=1000000000);

printit();
printf("Answer is %d\n", loadcalc());