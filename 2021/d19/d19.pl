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
my $n_scanner=@scanner;

while(my ($s, $scnnr) = each(@scanner)) {
    my @scnr=@{$scnnr};
    my @sdist=();

    foreach $f (0..$#scnr-1) {
        $sdist[$f]=();
        foreach $t ($f+1..$#scnr) {
            next if($f==$t);
#            my @deltas=($scnr[$f][0]-$scnr[$t][0], $scnr[$f][1]-$scnr[$t][1], $scnr[$f][2]-$scnr[$t][2]);
            my @deltas=pairwise { $a-$b } @{$scnr[$f]}, @{$scnr[$t]};
            $sdist[$f][$t]=\@deltas;
        }
    }
    $distances[$s]=\@sdist;
}

# print Dumper \@distances;

# Now look for pairs of beacons with equivalent distance in each pair of scanner outputs

my @matches;

foreach $sa (0..$#scanner) {
    foreach $sb($sa+1..$#scanner) {
#        print "Comparing scanner $sa to scanner $sb\n";
        @scnr=@{$scanner[$sa]};
        @scnrb=@{$scanner[$sb]};
        foreach $f (0..$#scnr) {
            my $matches=0;
            foreach $t ($f+1..$#scnr) {
                next if($f==$t);
                my $found=0;
                my @s1=sort { $a <=> $b } map { abs($_)} @{$distances[$sa][$f][$t]};
                foreach $f2 (0..$#scnrb) {
                    foreach $t2 ($f2+1..$#scnrb) {
                        next if($f2==$t2);
                        my $q=abs($distances[$sb][$f2][$t2][0]);
                        next if (!(0+(grep { $_ == $q } @s1) ));
                        $q=abs($distances[$sb][$f2][$t2][1]);
                        next if (!(0+(grep { $_ == $q } @s1) ));
#                        $q=abs($distances[$sb][$f2][$t2][2]);
#                        next if (!(0+(grep { $_ == $q } @s1) ));

                        my @s2=sort { $a <=> $b } map { abs($_)} @{$distances[$sb][$f2][$t2]};
#                        print "Comparing s:$sa f:$f t:$t (@s1) and s:$sb f:$f2 t:$t2 (@s2)\n";
                        $found=pwmatch(\@s1, \@s2);
                        if ($found) {
                            print "Scanner $sa ($f -> $t) matches scanner $sb ($f2 -> $t2) - $found\n";

                            push @matches, {sa=>$sa, b1a=>$f, b2a=>$t, sb=>$sb, b1b=>$f2, b2b=>$t2};

                            last if($found);
                        }
                    }
                    last if($found);
                }
                $matches++ if($found);
            }
            if($matches>3) {
                print "Found $matches matches - early out\n";
                last;
            }
        }
    }
}
#print Dumper \@matches;

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
#  -x +z: -x +z +y
#  -x -z: -x -z -y

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
    [ 0, 2, 1, -1,  1,  1],
    [ 0, 2, 1, -1, -1, -1],

    [ 1, 0, 2,  1,  1, -1],
    [ 1, 0, 2,  1, -1,  1],
    [ 1, 2, 0,  1,  1,  1],
    [ 1, 2, 0,  1, -1, -1],
    [ 1, 0, 2, -1,  1,  1],
    [ 1, 0, 2, -1, -1, -1],
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

my @s_orientations=();

$s_orientations[0]={ tf=>0,tl=>[0,0,0]};

my @s_fixed=();

$s_fixed[0]=1;

sub normalize {
    my @s1=transform($_[0], $s_orientations[$_[1]]->{tf});
    my @out=translate(\@s1, $s_orientations[$_[1]]->{tl});
    return @out;
}

sub translate() {
    my @s1=@{$_[0]};
    my @tl=@{$_[1]};
#    my @out;
#    @out=pairwise { $a + $b} @s1, @tl;
#    return @out;
    return pairwise { $a + $b} @s1, @tl;
}

sub transform {
    my @in=@{$_[0]};
    my $trans=$transformations[$_[1]];
    # my @out=();

    # @out=map { $in[$trans->[$_]]*$trans->[$_+3]} (0..2);

    # return @out;
    return map { $in[$trans->[$_]]*$trans->[$_+3]} (0..2);
}

sub pwequals {
    return pairwise { $a==$b } (@{$_[0]}, @{$_[1]});
}

sub pwmatch {
    return !(0+(grep {$_==0} pwequals($_[0], $_[1])));
}

my $lastcount=0;

while(sum(@s_fixed)!=$n_scanner) {
    $lastcount=sum(@s_fixed);
    foreach $sa (0..$#scanner) {
        next unless($s_orientations[$sa]);

        foreach $sb (0..$#scanner) {
            next if($s_orientations[$sb] || $sa==$sb);
    
            my @pairs=grep { $_->{sa}==$sa && $_->{sb}==$sb } @matches;
            my $b1a='b1a'; my $b1b='b1b'; my $b2a='b2a'; my $b2b='b2b'; my $txa=$sa; my $txb=$sb;

            if(!@pairs) {
                print "No matches $sa -> $sb\n";
                @pairs=grep { $_->{sb}==$sa && $_->{sa}==$sb } @matches;
                if(!@pairs) {
                    print "None the other way either\n";
                    next;
                } elsif (@pairs<12) {
                    print "Not enough the other way either\n";
#                    next;
                }
                $b1a='b1b'; $b1b='b1a';$b2a='b2b';$b2b='b2a'; $txa=$sb; $txb=$sa

            } elsif (@pairs<12) {
                print "Not enough matches $sa1 -> $sb1 : ".(0+@pairs)."\n";
#                next;
            }

            my @o_cand=();
            my $ft=0;
            my $bw=0;
            foreach $ip (0..$#pairs) {
                print "Comparing a:$sa  f:$pairs[$ip]->{$b1a} t:$pairs[$ip]->{$b2a} with b:$sb f:$pairs[$ip]->{$b1b} t:$pairs[$ip]->{$b2b}\n";
# if we switched earlier, need to switch here too
                
                my @d1=transform(\@{$distances[$sa][$pairs[$ip]->{$b1a}][$pairs[$ip]->{$b2a}]}, $s_orientations[$sa]->{tf});
                my @d2=@{$distances[$sb][$pairs[$ip]->{$b1b}][$pairs[$ip]->{$b2b}]};

                print "Distance: (@d1) vs (@d2)\n";
                $ft=55;

                while( my ($it, $trans)=each(@transformations)) {
                    my @d2t=transform(\@d2, $it);

    #                print "Transform (@d2) with (@{$trans}) gives (@d2t) ==> ";
                    
                    @res=pairwise { $a==$b } @d1, @d2t;
    #                print "(@res) ";

                    @resn=pairwise { ($a*-1)==$b } @d1, @d2t;
    #                print "(@resn)\n";

                    if(sum(@res)==3) {
                        print "Transform $it (@{$trans}) works\n";
                        $ft=$it; $bw=($b1b=='b1b') ? 1 : -1;
                    }
                    if(sum(@resn)==3) {
                        $ft=$it; $bw=($b1b=='b1b') ? -1 : 1;
                        print "Transform $it (@{$trans}) works backwards bw:$bw\n";
                    }
                    last if($bw);
                }
                last if($bw);
            }

            if($bw==0) {
                print "No match\n";
                next;
            }

            my @sabeacons=map { [normalize($_, $sa)] } map { $scanner[$sa][$pairs[$ip]->{$_}] } ($b1a,$b2a);
            my @sbbeacons=map { $scanner[$sb][$pairs[$ip]->{$_}] } ($bw>0) ? ($b1b, $b2b) : ($b2b, $b1b);
#            my @sbbeacons2=map { $scanner[$sb][$pairs[$ip]->{$_}] } ($b1b, $b2b);
            
            print "sa: beacon 1 (@{$sabeacons[0]}) beacon 2 (@{$sabeacons[1]})\n";

            print "sb: beacon 1 (@{$sbbeacons[0]}) beacon 2 (@{$sbbeacons[1]})\n";
            print "sb straight: beacon 1 (@{$sbbeacons2[0]}) beacon 2 (@{$sbbeacons2[1]})\n\n";
            

            print "Transforming sb:$sb with transform $ft\n";
            @sbbeacons_t= map { my @r=transform(\@{$sbbeacons[$_]}, abs($ft) ); print "@r\n"; \@r } (0,1) ;
#            @sbbeacons_t=map { transform(\@{$sbbeacons[$_]}, abs($ft) ) } (0,1) ;

            print "sb transformed: beacon 1 (@{$sbbeacons_t[0]}) beacon 2 (@{$sbbeacons_t[1]})\n\n";

            @translate0=pairwise { $a - $b } @{$sabeacons[0]}, @{$sbbeacons_t[0]}; 
            @translate1=pairwise { $a - $b } @{$sabeacons[1]}, @{$sbbeacons_t[1]}; 

            print "Translations: (@translate0) and (@translate1)\n";

            if(!pwmatch(\@translate0, \@translate1)) {
                print "Try the other way around\n";
                @translate0=pairwise { $a - $b } @{$sabeacons[0]}, @{$sbbeacons_t[1]}; 
                @translate1=pairwise { $a - $b } @{$sabeacons[1]}, @{$sbbeacons_t[0]}; 

                die("Non-matching translations") unless(pwmatch(\@translate0, \@translate1));
            } 

            $s_orientations[$sb]= {tf => $ft, tl => [ @translate0 ]};
            $s_fixed[$sb]=1;

        }

    }
    die if($lastcount==sum(@s_fixed));
}

print Dumper \@s_orientations;

my $answer2=0;

foreach $lf (0..$#s_orientations) {
    foreach $lt ($lf+1..$#s_orientations) {
        my $dist=0;
        pairwise { $dist+=(abs($a-$b))} @{$s_orientations[$lf]->{tl}}, @{$s_orientations[$lt]->{tl}};
        $answer2=$dist if($dist>$answer2); 
    }
}

print "Answer2: $answer2\n"
