#/usr/bin/perl

use Data::Dumper;

my %rank=(A=>13,K=>12,Q=>11,J=>1,T=>10,9=>9,8=>8,7=>7,6=>6,5=>5,4=>4,3=>3,2=>2);
my %type=(five=>7,four=>6,full=>5,three=>4,twop=>3,onep=>2,high=>1 );

sub gettype {
	my @hand=@{$_};
	my %con;
	my $hv=0;
	my $val=0;

	foreach my $i (0..4) {
		$con{$hand[$i]}++;
		$hv=$hv*14+$rank{$hand[$i]};
		print "$hand[$i]";
	}

	my @p=(0,0,0,0,0);

	foreach my $c (keys %con) {
		$p[$con{$c}]++;
	}

	if($p[5]) {
		$val=$type{'five'};
	} elsif($p[4]) {
		if($con{'J'}) {
  			$val=$type{'five'};
  		} else {
  			$val=$type{'four'};
  		}
	} elsif($p[3]) {
		if(%con{'J'}==3) {
			if($p[2]) {
				$val=$type{'five'};
			} else {
				$val=$type{'four'};
			}
		} elsif($con{'J'}==2) {
			$val=$type{'five'};
		} elsif($con{'J'}==1) {
			$val=$type{'four'};
		} elsif($p[2]) {
			$val=$type{'full'};
		} else {
			$val=$type{'three'};
		}
	} elsif($p[2]==2) {
		if($con{'J'}==2) {
			$val=$type{'four'};
		} elsif($con{'J'}==1) {
			$val=$type{'full'};
		} else {
			$val=$type{'twop'};
		}
	} elsif($p[2]==1) {
		if($con{'J'}) {
			$val=$type{'three'};
		} else {
			$val=$type{'onep'};
		}
	} elsif($con{'J'}) {
		$val=$type{'onep'};
	} else {
		$val=$type{'high'};
	}

	die if($val==0);
	
	printf(" hv=%d val=%d score=%d\n", $hv, $val, $val*(14**5)+$hv);

	return $val*(14**5)+$hv;
}

my @hands=map{ chomp; [ $_ =~ /^([\dTJQKA])([\dTJQKA])([\dTJQKA])([\dTJQKA])([\dTJQKA]) ([\dTJQKA]+)/] } <>;

foreach (@hands) {
	push( @{$_}, gettype($_));
}


@hands = sort { @{$a}[6]<=>@{$b}[6] } @hands;

print Dumper @hands;

foreach my $i (0..$#hands) {
	$answer+=($i+1)*$hands[$i][5];
}
printf("Answer is %d\n", $answer);