#!/usr/bin/perl

#perl d16b.pl  14742.18s user 10.13s system 99% cpu 4:05:55.99 total

use strict;
use Data::Dumper;
use List::Util qw(min max);

my %v;
my %vs=();
my @vp=();

map { chomp; my ($e, $f, $g) = $_ =~ q/Valve (\w*) has flow rate=(\d*); tunnels? leads? to valves? ([A-Z, ]*)/; $v{$e}{"rate"} =$f; 
		$v{$e}{"cons"}= [split / ?, ?/,$g]; 
		$v{$e}{"on"}="";
		$vs{$e}=$f if($f);
		push @vp, $e;
	} <STDIN>;

@vp=sort @vp;

print Dumper \%v;
print Dumper \%vs;

my $timelimit=26;
#my $answer=checkpath("AA", "AA", 0, "|AA-AA|", %vs);
my $answer=checkpath("AA", "AA", 0,  %vs);

printf("Answer is %d\n", $answer);

my %memo={};

sub checkpath {
	my $hnode=shift;
	my $enode=shift;
	my $ts=shift;
#	my $path=shift;
	my %vs=@_;

	return 0 if($ts>=$timelimit);

	my $key=$ts.join("",sort(keys %vs)).join("",sort($hnode, $enode));
#	printf("memo{%s} is %s\n", $key, $memo{$key});
	return $memo{$key} if(defined($memo{$key}));

#	printf("Checking h=%s (%d), e=%s (%d) at time %d from %s\n", $hnode, $vs{$hnode}, $enode, $vs{$enode}, $ts, $path);

	my $bestpath=0;

	if(defined($vs{$hnode})) {
		delete $vs{$hnode};
		my $thisflow=$v{$hnode}{"rate"}*($timelimit-($ts+1));
		foreach my $en (@{$v{$enode}{"cons"}}) {
#			$bestpath=max($bestpath, $thisflow+checkpath($hnode, $en, $ts+1, $path."|".$hnode."!-".$en, %vs));
			$bestpath=max($bestpath, $thisflow+checkpath($hnode, $en, $ts+1, %vs));
		}
		$vs{$hnode}=$v{$hnode}{"rate"};
	}
	if(defined($vs{$enode})) {
		delete $vs{$enode};
		my $thisflow=$v{$enode}{"rate"}*($timelimit-($ts+1));
		foreach my $hn (@{$v{$hnode}{"cons"}}) {
#			$bestpath=max($bestpath, $thisflow+checkpath($hn, $enode, $ts+1, $path."|".$hn."-".$enode."!", %vs));
			$bestpath=max($bestpath, $thisflow+checkpath($hn, $enode, $ts+1, %vs));
		}
		$vs{$enode}=$v{$enode}{"rate"};
	}
	if(defined($vs{$enode}) && defined($vs{$hnode}) && !($enode eq $hnode)) {
		delete $vs{$enode}; delete $vs{$hnode};
#		$bestpath=max($bestpath, ($v{$hnode}{"rate"}+$v{$enode}{"rate"})*($timelimit-($ts+1))+checkpath($hnode, $enode,$ts+1, $path."|".$hnode."!-".$enode."!",%vs));
		$bestpath=max($bestpath, ($v{$hnode}{"rate"}+$v{$enode}{"rate"})*($timelimit-($ts+1))+checkpath($hnode, $enode,$ts+1, %vs));
		$vs{$enode}=$v{$enode}{"rate"};
		$vs{$hnode}=$v{$hnode}{"rate"};
	}

 	# Now check paths without turning on this valve
	foreach my $nn (@{$v{$hnode}{"cons"}}) {
		foreach my $en (@{$v{$enode}{"cons"}}) {
#			$bestpath=max(checkpath($nn, $en, $ts+1,$path."|".$nn."-".$en,%vs),$bestpath);
			$bestpath=max(checkpath($nn, $en, $ts+1,%vs),$bestpath);
		}
	}

#	printf("Done checking h=%s (%d), e=%s (%d) at time %d - bestpath %d from %s\n", $hnode, $vs{$hnode}, $enode, $vs{$enode}, $ts, $bestpath, $path);
#	printf("Memoize %s as %d\n", $key, $bestpath);
	$memo{$key}=$bestpath;

	return $bestpath;
}
