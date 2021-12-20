#!/usr/bin/perl

use Data::Dumper;
use List::MoreUtils qw(pairwise);
use List::Util qw(sum);

my $iscanr=0;
my @scanner=();

$scanner[$iscanr]=();

my $lines=0;


while(my $line=<STDIN>) {
    chomp $line;

    if ($line eq '') {
        $iscanr++;
        $lines=0;
        next;
    }
    if ($line =~ q/--- scanner (\d+) ---/) {
        die("Input weirdness") if($1 != $iscanr);
        next;
    }
    push @{$scanner[$iscanr]}, [ split ',', $line ];
    print "Scanner $iscanr, point $lines: @{$scanner[$iscanr][$lines]}\n-\n";
    $lines++;
}

my @distances=();

while(my ($s, $scnnr) = each(@scanner)) {
    my @scnr=@{$scnnr};
    my @sdist=();

    foreach $f (0..$#scnr) {
        $sdist[$f]=();
        print "Scanner $s F: $f, T: ";
        foreach $t ($f+1..$#scnr) {
            print "$t ";
            next if($f==$t);
#            my @deltas=($scnr[$f][0]-$scnr[$t][0], $scnr[$f][1]-$scnr[$t][1], $scnr[$f][2]-$scnr[$t][2]);
            my @deltas=pairwise { $a-$b } @{$scnr[$f]}, @{$scnr[$t]};
            $sdist[$f][$t]=\@deltas;
        }
        print "\n";
    }
    $distances[$s]=\@sdist;
}

print Dumper \@distances;

# Now look for pairs of beacons with equivalent distance in each pair of scanner outputs

my @matches;

foreach $sa (0..$#scanner) {
    foreach $sb($sa+1..$#scanner) {
        print "Comparing scanner $sa to scanner $sb\n";
        @scnr=@{$scanner[$sa]};
        @scnrb=@{$scanner[$sb]};
        foreach $f (0..$#scnr) {
            foreach $t ($f+1..$#scnr) {
                next if($f==$t);
                my $found=0;
                foreach $f2 (0..$#scnrb) {
                    foreach $t2 ($f2+1..$#scnrb) {
                        next if($f2==$t2);
                        my @s1=sort { $a <=> $b } map { abs($_)} @{$distances[$sa][$f][$t]};
                        my @s2=sort { $a <=> $b } map { abs($_)} @{$distances[$sb][$f2][$t2]};
#                        print "Comparing s:$sa f:$f t:$t (@s1) and s:$sb f:$f2 t:$t2 (@s2)\n";
                        $found=!(0+(grep {!$_} pairwise { $a==$b } @s1, @s2));
                        if ($found) {
                            print "Scanner $sa ($f -> $t) matches scanner $sb ($f2 -> $t2) - $found\n";

                            push @matches, {sa=>$sa, b1a=>$f, b2a=>$t, sb=>$sb, b1b=>$f2, b2b=>$t2};

                            last if($found);
                        }
                    }
                    last if($found);
                }
            }
        }
    }
}

print Dumper \@matches;

my @u_scnr=map { [ map { 1 } @{$_} ]} @scanner;

foreach $sa (0..$#scanner) {
    map { $u_scnr[$_->{sb}][$_->{b1b}]=0; $u_scnr[$_->{sb}][$_->{b2b}]=0; } grep { $_->{'sa'}==$sa } @matches;
}

my $answer1=0;
map { $answer1+=sum(@{$_}) } @u_scnr;

print "Answer 1: $answer1\n";

# First find the orientation of each scanner
#  - facing (up): +x -x (+y +z -y -z) +y -y (+x -x +z -z) +z -z (+x -x +y -y)
#  +x +y: +x +y +z
#  +x -y: +x -y -z
#  +x +z: +x +z -y
#  +x -z: +x -z +y
#  -x +y: -x +y -z
#  -x -y: -x -y +z
#  -x +z: -x +z -y
#  -x -z: -x -z +y
#  +y +x: +y +x -z
#  +y -x: +y -x +z
#  +y +z: +y +z +x
#  +y -z: +y -z -x
#  -y +x: -y +x +z
#  -y -x: -y -x -z
#  -y +z: -y +z -x
#  -y -z: -y -z +x
#  +z +x: +z +x +y
#  +z -x: +z -x -y
#  +z +y: +z +y -x
#  +z -y: +z -y +x
#  -z +x: -z +x -y
#  -z -x: -z -x +y
#  -z +y: -z +y +x
#  -z -y: -z -y -x

my @transformations= (
    [ 0, 1, 2,  1,  1,  1],
    [ 0, 1, 2,  1, -1, -1],
    [ 0, 2, 1,  1,  1, -1],
    [ 0, 2, 1,  1, -1,  1],
    [ 0, 1, 2, -1,  1, -1],
    [ 0, 1, 2, -1, -1,  1],
    [ 0, 2, 1, -1,  1, -1],
    [ 0, 2, 1, -1, -1,  1],

    [ 1, 0, 2,  1,  1, -1],
    [ 1, 0, 2,  1, -1,  1],
    [ 1, 2, 0,  1,  1,  1],
    [ 1, 2, 0,  1, -1, -1],
    [ 1, 0, 2, -1,  1,  1],
    [ 1, 0, 2, -1, -1,  1],
    [ 1, 2, 0, -1,  1, -1],
    [ 1, 2, 0, -1, -1,  1],

    [ 2, 0, 1,  1,  1,  1],
    [ 2, 0, 1,  1, -1, -1],
    [ 2, 1, 0,  1,  1, -1],
    [ 2, 1, 0,  1, -1,  1],
    [ 2, 0, 1, -1,  1, -1],
    [ 2, 0, 1, -1, -1,  1],
    [ 2, 1, 0, -1,  1,  1],
    [ 2, 1, 0, -1, -1, -1]
    );

sub transform {
    my @in=@{$_[0]};
    my $trans=$transformations[$_[1]];
    my @out=();

    @out=map { $in[$trans->[$_]]*$trans->[$_+3]} (0..2);

    return @out;
}

sub pwequals {
    return pairwise { $a==$b } (@{$_[0]}, @{$_[1]});
}

sub pwmatch {
    return !(0+(grep {$_==0} pwequals($_[0], $_[1])));
}

my @orientation=();

foreach $sa (0..$#scanner) {
    foreach $sb ($sa+1..$#scanner) {
        # find a matching pair
        my @pairs=grep { $_->{sa}==$sa && $_->{sb}==$sb } @matches;
        if(!@pairs) {
            print "No matches $sa -> $sb\n";
            next;
        }

        foreach $ip (0..$#pairs) {
            print "Comparing a:$sa  f:$pairs[$ip]->{b1a} t:$pairs[$ip]->{b2a} with b:$sb f:$pairs[$ip]->{b1b} t:$pairs[$ip]->{b2b}\n";
            my @d1=@{$distances[$sa][$pairs[$ip]->{b1a}][$pairs[$ip]->{b2a}]};
            my @d2=@{$distances[$sb][$pairs[$ip]->{b1b}][$pairs[$ip]->{b2b}]};
            print "Distance: (@d1) vs (@d2)\n";
            my $ft=55;

            while( my ($it, $trans)=each(@transformations)) {
                my @d2t=transform(\@d2, $it);

#                print "Transform (@d2) with (@{$trans}) gives (@d2t) ==> ";
                
                @res=pairwise { $a==$b } @d1, @d2t;
#                print "(@res) ";

                @resn=pairwise { ($a*-1)==$b } @d1, @d2t;
#                print "(@resn)\n";

                if(sum(@res)==3) {
                    print "Transform $it (@{$trans}) works\n";
                    $ft=$it;
                }
                if(sum(@resn)==3) {
                    print "Transform $it (@{$trans}) works backwards\n";
                    $ft=$it*-1;
                }

            }

            if($ft==55) {
                print "No match\n";
                next;
            }

            my @sabeacons=map { $scanner[$sa][$pairs[$ip]->{$_}] } ('b1a','b2a');
            my @sbbeacons=map { $scanner[$sb][$pairs[$ip]->{$_}] } ($ft>0) ? ('b1b', 'b2b') : ('b2b', 'b1b');
            print "sa: beacon 1 (@{$sabeacons[0]}) beacon 2 (@{$sabeacons[1]})\n";
            print "sb: beacon 1 (@{$sbbeacons[0]}) beacon 2 (@{$sbbeacons[1]})\n\n";
            
            @sbbeacons_t= map { my @r=transform(\@{$sbbeacons[$_]}, abs($ft) ); print "@r\n"; \@r } (0,1) ;
#            @sbbeacons_t=map { transform(\@{$sbbeacons[$_]}, abs($ft) ) } (0,1) ;

            print "sb transformed: beacon 1 (@{$sbbeacons_t[0]}) beacon 2 (@{$sbbeacons_t[1]})\n\n";

            @translate0=pairwise { $a - $b } @{$sabeacons[0]}, @{$sbbeacons_t[0]}; 
            @translate1=pairwise { $a - $b } @{$sabeacons[1]}, @{$sbbeacons_t[1]}; 

            print "Translations: (@translate0) and (@translate1)\n";

            die("Non-matching translations\n") unless(pwmatch(\@translate0, \@translate1));

            @orientation[$sb]={t => $ft};


        }

    }
}

