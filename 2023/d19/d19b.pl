
#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(reduce);

my %flows;
my $rf=1;
my $answer=0;
my %blocks;
my @accepted;
my @rejected;

sub evalflow {
	my $flow=shift;
	my $step=shift;
	print("Flow $flow Step $step\n");
	my %block=@_;

	print("Flow $flow, Step $step, Block $block{'l'}\n");
	if($flow eq 'A') {
		push(@accepted, \%block);
		return;
	} 
	if($flow eq 'R') {
		push(@rejected, \%block);
		return;
	}

	if(scalar @{$flows{$flow}->[$step]}>1) {
		my ($pr, $co, $v)= $flows{$flow}->[$step]->[0] =~ /(\w)([<=>])([\w]+)/;
		my %b1=%block;
		my %b2=%block;
		if($co eq '>') {
			# b1 (lower half) is false
			$b1{"$pr".'h'}=$v;
			$b2{"$pr".'l'}=$v+1;
			$b1{'l'}="$block{'l'} $flow-$step-l";
			$b2{'l'}="$block{'l'} $flow-$step-h";
			# False
			evalflow($flow, $step+1, %b1);
			# True
			evalflow($flows{$flow}->[$step]->[1], 0, %b2);			
			#index of block 2 will have changed :-(
		} else {
			# b2 (upper half) is false
			$b1{"$pr".'h'}=$v-1;
			$b2{"$pr".'l'}=$v;
			$b1{'l'}="$block{'l'} $flow-$step-l";
			$b2{'l'}="$block{'l'} $flow-$step-h";
			evalflow($flow, $step+1, %b2);
			evalflow($flows{$flow}->[$step]->[1], 0, %b1);			
		}
	} else {
		evalflow($flows{$flow}->[$step]->[0], 0, %block);
		
	}
}


while (<>) {
	chomp;
	if($_ eq '') {
		$rf=0;
		next;
	}
	if($rf) {
		my ($label, $flow)= $_ =~ /^(\w+)\{(.*)\}$/;
		print("$label ---- $flow\n");
		$flows{$label}=[ map{ [split /:/, $_] } split /,/, $flow ];
	}

}

#$blocks{0}={x=>[0,4000], m => [0,4000], a => [0,4000],s => [0,4000]};
my %block=(l=>0, xl=>1, xh=>4000, ml => 1, mh => 4000, al => 1, ah=>4000,sl => 1, sh=>4000);

print Dumper %block;

evalflow('in',0,%block);

print Dumper \@accepted;

foreach (@accepted) {
	$answer+=((($_->{xh}-$_->{xl})+1) * (($_->{mh}-$_->{ml})+1) * (($_->{ah}-$_->{al})+1) * (($_->{sh}-$_->{sl})+1))	;
}

print "Answer is $answer\n";