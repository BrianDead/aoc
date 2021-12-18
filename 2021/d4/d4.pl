#!/usr/bin/perl

use Data::Dumper;

sub checkboard {
	my @board=@{$_[0]};
	my @boardwon;

	my @rows=(0,0,0,0,0);
	my @cols=(0,0,0,0,0);
	my $r=0;
	my $c=0;
	my $leftt=0;
	my $bingo=0;

	foreach(@board) {
		foreach(@{$_}) {
			if($_->{'x'}) {
				$rows[$r]++;
				$cols[$c]++;
			} else {
				$leftt=$leftt+$_->{'n'};
			}
			$c++;
		}
		$r++; $c=0;
	}

	print "Left - $leftt\n";

	for(my $i=0; $i<5; $i++) {
		print "$i: r:$rows[$i] c:$cols[$i]\n";
		if ($rows[$i] == 5 || $cols[$i] == 5) {
			$bingo=$leftt;
			print "bingo $bingo\n";
			printboard(\@board);

		}
		last if($bingo);
	}
	return $bingo;
}

sub printboard {
	my @board=@{$_[0]};

	foreach(@board) {
		foreach(@{$_}) {
			print $_->{'n'}."(".$_->{'x'}.") ";
		}
		print "\n";
	}
}

my @numbers;
my @boards;
my %map;

my $lc;

#read numbers
my $nl=<STDIN>;
chomp $nl;

@numbers= split /,/, $nl;


my $bl=0;
my $bn=0;

$tl=<STDIN>;

#read boards
while (my $tl=<STDIN>) {
	chomp $tl;

	print "n: $bn, l: $bl, $tl\n";

	if ($tl eq "") {
		$bn++; $bl=0; next;
	}

#	my @ln= split / +/, $tl;
	my @ln= $tl=~ q/ ?([0-9]+) +([0-9]+) +([0-9]+) +([0-9]+) +([0-9]+)/;
	my $bc=0;
	foreach (@ln) {
		$boards[$bn][$bl][$bc]{'n'}=$_;
		$boards[$bn][$bl][$bc]{'x'}=0;
		my %lh=('b'=> $bn, 'l'=> $bl, 'c'=> $bc);
		push @{$map{$_}}, \%lh;
		$bc++;
	}
	$boardwon[$bn]=0;
	$bl++;
}

my $score;
my $lastnum=0;
my $firstscore=0; my $lastscore=0;

#call the numbers
foreach(@numbers) {
	$lastnum=$_;
	@hits=@{$map{$_}};
	$numhits=@hits;
	print "Call $_: $numhits hits\n";

	for(my $i=0; $i<$numhits; $i++) {
		%loc=%{$hits[$i]};
		print "\t at $loc{'b'} $loc{'l'} $loc{'c'}\n";
		$boards[$loc{'b'}][$loc{'l'}][$loc{'c'}]{'x'}=1;
		if(!$boardwon[$loc{'b'}]) {
			$score=checkboard($boards[$loc{'b'}]);
			print "score $score\n";
			if($score) {
				$boardwon[$loc{'b'}]=1;
				$firstscore=$score*$lastnum unless ($firstscore);
				$lastscore=$score*$lastnum;
			}
		}
	}
}

foreach(@boards) {
	printboard($_);
	print "\n----------\n\n";
}

print $score." ".$lastnum."-==>".$score*$lastnum;
print "FIrst board score=$firstscore\n";
print "Last board score=$lastscore\n";