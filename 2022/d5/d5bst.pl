#!/usr/bin/perl
use Data::Dumper;

my @stacks=();
my @astacks=();

my $answer="";
my $rules=0;
my $first=1;
my $move=0;
my $cols=0;
my $scount=0;

while(<STDIN>) {
    chomp;

    if (substr($_,0,2) eq " 1") {
        $rules=1;
        printf("found middle\n");

        for(my $i=0; $i<$scount;$i++) {
            map { $stacks[$i]=$stacks[$i].$_ } @{$astacks[$i]};
        }

#        print Dumper \@stacks;
#        print Dumper \@astacks;
        next;
    }
    next if($_ eq "");

    if ($rules) {
        $move++;
        my ($q, $f, $t) = $_ =~ q/move (\d*) from (\d*) to (\d*)/;
        printf("Move %d: %d from %d to %d\n", $move,$q, $f, $t);
        my $height=length($stacks[$f-1]);
        printf("Stack %d height %d, move items %d to %d\n", $f, $height, $height-($q-1), $height);
        $stacks[$t-1]=$stacks[$t-1].substr($stacks[$f-1],-$q);
        $stacks[$f-1]=substr($stacks[$f-1],0,$height-$q);

    } else {

        my @line=split //;
        $cols=@line;
        $scount=$cols/4;

#        for(my $i=0; $i<$scount; $i++) {
#            if($first) {
#                $stacks[$i]="";
#            }
#            $stacks[$i]=$line[($i*4)+1].$stacks[$i] unless ($line[($i*4)+1] eq " ");
#        }

        for(my $i=0; $i<$scount; $i++) {
            if($first) {
                my @st=();
                $astacks[$i]=\@st;
            }
            unshift @{$astacks[$i]}, $line[($i*4)+1] unless ($line[($i*4)+1] eq " ");
         }
    }
    $first=0;
}

for(@stacks) {
    $answer=$answer.substr($_,-1);
}

printf("The answer is %s\n", $answer);
