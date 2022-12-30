#!/usr/bin/perl

#perl d16b.pl  14742.18s user 10.13s system 99% cpu 4:05:55.99 total

use strict;
use Data::Dumper;
use List::Util qw(min max);

#my %v;
my %vs=();
my @nodename=();
my @cons=();
my @rates=();
my $i=0;

map { chomp; my ($e, $f, $g) = $_ =~ q/Valve (\w*) has flow rate=(\d*); tunnels? leads? to valves? ([A-Z, ]*)/; 
		$nodename[$i]=$e;
		$rates[$i]=$f;
		$cons[$i]=[split / ?, ?/,$g]; 
		$vs{$i}=$f if($f);
		$i++
	} <STDIN>;

@cons=map{ my @ans; 
	foreach my $node (@{$_}) {
		push @ans, node2num($node);
	}
	\@ans
} @cons;


#print Dumper \@nodename;
#print Dumper \@cons;
print Dumper \%vs;

my $timelimit=26;
my $hashbase=max($timelimit, scalar @nodename);
print("hashbase is $hashbase\n");
#my $answer=checkpath("AA", "AA", 0, "|AA-AA|", %vs);
my $start=node2num("AA");
printf("Starting at AA=%d (%s)\n", $start, $nodename[$start]);
my $answer=checkpath($start, $start, 0,  %vs);

printf("Answer is %d\n", $answer);

my %memo={};

sub node2num {
	my $start=0;
	while($start<@nodename-1) {
		last if($nodename[$start] eq $_[0]);
		$start++;
	}
	return $start;
}

sub gethash {
	my $hash=0;
	foreach my $v (@_) {
		$hash=$hash*$hashbase+$v;
	}
	return $hash;
}

sub checkpath {
	my $hnode=shift;
	my $enode=shift;
	my $ts=shift;
#	my $path=shift;
	my %vs=@_;

	return 0 if($ts>=$timelimit);

	my $key=$ts.join("",@nodename[sort(keys %vs)]).join("",@nodename[sort($hnode, $enode)]);
#	my $key=gethash(sort(keys %vs), sort($hnode, $enode), $ts);
#	printf("memo{%s} is %s\n", $key, $memo{$key});
	return $memo{$key} if(defined($memo{$key}));

#	printf("Checking h=%s (%d), e=%s (%d) at time %d from %s\n", $hnode, $vs{$hnode}, $enode, $vs{$enode}, $ts, $path);

	my $bestpath=0;

	if(defined($vs{$enode}) && defined($vs{$hnode}) && !($enode eq $hnode)) {
		delete $vs{$enode}; delete $vs{$hnode};
		printf("Time %d: Brate %d - %d and %d - %d for %d sec=%d\n", $ts, $hnode, $rates[$hnode], $enode, $rates[$enode], $timelimit-($ts+1), ($rates[$hnode]+$rates[$enode])*($timelimit-($ts+1)));

#		$bestpath=max($bestpath, ($v{$hnode}{"rate"}+$v{$enode}{"rate"})*($timelimit-($ts+1))+checkpath($hnode, $enode,$ts+1, $path."|".$hnode."!-".$enode."!",%vs));
		$bestpath=max($bestpath, ($rates[$hnode]+$rates[$enode])*($timelimit-($ts+1))+checkpath($hnode, $enode,$ts+1, %vs));
		$vs{$enode}=$rates[$enode];
		$vs{$hnode}=$rates[$hnode];
	} 
	if(defined($vs{$hnode})) {
		delete $vs{$hnode};
		my $thisflow=$rates[$hnode]*($timelimit-($ts+1));
		printf("Time %d: Hrate %d - %d for %d sec=%d\n", $ts, $hnode, $rates[$hnode], $timelimit-($ts+1), $thisflow);
		foreach my $en (@{$cons[$enode]}) {
#			$bestpath=max($bestpath, $thisflow+checkpath($hnode, $en, $ts+1, $path."|".$hnode."!-".$en, %vs));
			$bestpath=max($bestpath, $thisflow+checkpath($hnode, $en, $ts+1, %vs));
		}
		$vs{$hnode}=$rates[$hnode];
	} 
	if(defined($vs{$enode})) {
		delete $vs{$enode};
		my $thisflow=$rates[$enode]*($timelimit-($ts+1));
		printf("Time %d: Erate %d - %d for %d sec=%d\n", $ts, $enode, $rates[$enode], $timelimit-($ts+1), $thisflow);
		foreach my $hn (@{$cons[$hnode]}) {
#			$bestpath=max($bestpath, $thisflow+checkpath($hn, $enode, $ts+1, $path."|".$hn."-".$enode."!", %vs));
			$bestpath=max($bestpath, $thisflow+checkpath($hn, $enode, $ts+1, %vs));
		}
		$vs{$enode}=$rates[$enode];
	}
 	# Now check paths without turning on this valve
	foreach my $nn (@{$cons[$hnode]}) {
		foreach my $en (@{$cons[$enode]}) {
#			$bestpath=max(checkpath($nn, $en, $ts+1,$path."|".$nn."-".$en,%vs),$bestpath);
			$bestpath=max(checkpath($nn, $en, $ts+1,%vs),$bestpath);
		}
	}
	

	printf("Done checking h=%s (%d), e=%s (%d) at time %d - bestpath %d \n", $hnode, $vs{$hnode}, $enode, $vs{$enode}, $ts, $bestpath);
#	printf("Memoize %s as %d\n", $key, $bestpath);
	$memo{$key}=$bestpath;

	return $bestpath;
}
