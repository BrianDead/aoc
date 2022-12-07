#!/usr/bin/perl
use Data::Dumper;

my @stacks=();

my $answer="";
my $rules=0;
my $first=1;


while(<STDIN>) {
    chomp;

    if (substr($_,0,2) eq " 1") {
        $rules=1;
        printf("found middle\n");

        print Dumper \@stacks;

        next;
    }
    next if($_ eq "");

    if ($rules) {
        my ($q, $f, $t) = $_ =~ q/move (\d*) from (\d*) to (\d*)/;
        printf("Move %d from %d to %d\n", $q, $f, $t);
        for($i=0;$i<$q;$i++ ){
            push(@{$stacks[$t-1]},pop(@{$stacks[$f-1]}));
        }
#        print Dumper \@stacks;

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