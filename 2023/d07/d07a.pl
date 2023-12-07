#/usr/bin/perl

use Data::Dumper;

my %rank=(A=>13,K=>12,Q=>11,J=>10,T=>9,9=>8,8=>7,7=>6,6=>5,5=>4,4=>3,3=>2,2=>1);
my %type=(five=>7,four=>6,full=>5,three=>4,twop=>3,onep=>2,high=>1 );

sub gettype {
	my @hand=@{$_};
	my %con;
	my $hv=0;
	my $val;

	foreach my $i (0..4) {
		$con{$hand[$i]}++;
		$hv=$hv*14+$rank{$hand[$i]};
		print "$hand[$i]";
	}
	print Dumper %con;
	my $four=0;
	my $five=0;
	my $two=0;
	my $three=0;
	my $one=0;


	foreach my $c (keys %con) {
		if($con{$c}==5) {
			$val=$type{'five'};
			last;
		} elsif($con{$c}==4) {
			$val=$type{'four'};
			last;
		} elsif($con{$c}==3) {
			if($two) {
				$val=$type{'full'};
				last;
			} elsif ($one) {
				$val=$type{'three'};
				last;
			} else { $three++; }
		} elsif($con{$c}==2) {
			if($three) {
				$val=$type{'full'};
				last;
			} elsif($two) {
				$val=$type{'twop'};
				last;
			}
			elsif($one>1) {
				$val=$type{'onep'};
				last;
			}
			else { $two++; }
		} elsif($con{$c}==1) {
			$one++;
			if($one==3 && $two) {
				$val=$type{'onep'};
				last;
			} elsif ($one==4) {
				$val=$type{'high'};
				last;
			} elsif ($three) {
				$val=$type{'three'};
				last;
			}
		}
	}

	printf(" hv=%d val=%d score=%d\n", $hv, $val, $val*(14**5)+$hv);

	return $val*(14**5)+$hv;
}

my @hands=map{ chomp; [ $_ =~ /^([\dTJQKA])([\dTJQKA])([\dTJQKA])([\dTJQKA])([\dTJQKA]) ([\dTJQKA]+)/] } <>;

foreach (@hands) {
	push( @{$_}, gettype($_));
}

@hands = sort { @{$a}[6]<=>@{$b}[6] } @hands;

foreach my $i (0..$#hands) {
	$answer+=($i+1)*$hands[$i][5];
}
printf("Answer is %d\n", $answer);