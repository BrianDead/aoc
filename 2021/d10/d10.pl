#!/usr/bin/perl

use Data::Dumper;

my $answer=0;
my $count=0;


#my @input=map { chomp ; $_ } <>;
my @input=();

my %opp=('['=>']','{'=>'}','('=>')', '<'=>'>', ']'=>'[','}'=>'{',')'=>'(','>'=>'<');
my %score=( ')'=>'3',']'=>57,'}'=>1197,'>'=>'25137');
my %score2=( '('=>1, '['=>2,'{'=>3,'<'=>4);

my @lss=();

while( <STDIN>) {
	chomp ;
	my @line=split //, $_;
	my @o=();

	foreach my $c ( @line) {
		print "$c";
		if($c=~ /[{\[<(]/) {
			push @o, $c;
			print "Open @o\n";
		} else {
			if ((pop @o ) ne $opp{$c}) {
				print "Error $c - score $score{$c}\n";
				$answer+= $score{$c};
				@o=();
				last;
			}
			print "Close @o\n";

		}

	}
	my $ls=0;
	while(@o) {
		$ls = $ls*5+$score2{pop @o};
	}
	push @lss, $ls if($ls>0);
}

print "Answer: $answer\n";

my @slss= sort {$a <=> $b} @lss;
print Dumper \@slss;
printf ("Answer %d of %d: %d\n", int((0+@slss)/2), 0+@slss, $slss[int((0+@slss)/2)]);