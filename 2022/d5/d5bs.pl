#!/usr/bin/perl
use Data::Dumper;

my @stacks=();

my $answer="";
my $rules=0;
my $first=1;
my $move=0;

while(<STDIN>) {
    chomp;

    if (substr($_,0,2) eq " 1") {
        $rules=1;
        printf("found middle\n");

#        print Dumper \@stacks;
        next;
    }
    next if($_ eq "");

    if ($rules) {
        $move++;
        my ($q, $f, $t) = $_ =~ q/move (\d*) from (\d*) to (\d*)/;
        printf("Move %d: %d from %d to %d\n", $move, $q, $f, $t);
        my $height=@{$stacks[$f-1]}-1;
        printf("Stack %d height %d, move items %d to %d\n", $f, $height, $height-($q-1), $height);
#       my @move=@{$stacks[$f-1]}[($height-($q-1))..$height];
        print "created move\n";
        
#        print Dumper \@move;
#        print Dumper @{$stacks[$f-1]}[($height-($q-1))..$height];
#        push(@{$stacks[$t-1]},@{$stacks[$f-1]}[($height-($q-1))..$height]);
        push(@{$stacks[$t-1]},splice(@{$stacks[$f-1]},$height-($q-1),$q));

    } else {

        my @line=split //;
        my $cols=@line;
        my $scount=$cols/4;

        for(my $i=0; $i<$scount; $i++) {
            if($first) {
                my @st=();
                $stacks[$i]=\@st;
            }
            unshift @{$stacks[$i]}, $line[($i*4)+1] unless ($line[($i*4)+1] eq " ");
            $stack++;
         }
    }
    $first=0;
}

for(@stacks) {
    $answer=$answer.pop(@$_);
}

printf("The answer is %s\n", $answer);
