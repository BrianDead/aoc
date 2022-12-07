#!/usr/bin/perl

use Data::Dumper;
use List::Util qw(max min);

# Each step, need to look back through all the previous volumes and count the number of overlapping cubes


sub overlap {
    my $v1=$_[0];
    my $v2=$_[1];

    print "in Overlap $v1{action} $v2{action}\n";

    #check X
    $ofx=min($v1->{fx}, $v2->{fx});
    $otx=min($v1->{tx}, $v2->{tx});
    if($ofx>$otx) {
        return 0;
    }

    #check Y
    $ofy=min($v1->{fy}, $v2->{fy});
    $otx=min($v1->{ty}, $v2->{ty});
    if($ofy>$oty) {
        return 0;
    }

    #check Z
    #check Y
    $ofz=min($v1->{fz}, $v2->{fz});
    $otx=min($v1->{tz}, $v2->{tz});
    if($ofy>$oty) {
        return 0;
    }

    $odx=$otx-$ofx;
    $ody=$oty-$ofy;
    $odz=$otz-$otz;

    $osize=$osx*$ody*$odz;

    print "Overlap - size ($odx, $ody, $odz) = ".$osize."\n";

    return $osize;
}

my @volumes=();

my $minx; my $maxx;
my $id=0;

while ($line=<STDIN>) {
    chomp $line;

    print "$line\n";

    my ($action, $fx, $tx, $fy, $ty, $fz, $tz)=$line =~ q/(on|off) x=([0-9-]*)..([0-9-]*),y=([0-9-]*)..([0-9-]*),z=([0-9-]*)..([0-9-]*)/ ;

    my %volume=(action=>$action, fx=>$fx, tx=>$tx, fy=>$fy, ty=>$ty, fz=>$fz, tz=>$tz, id=>$id);

    $minx=$fx if($fx<$minx);
    $maxx=$tx if($tx>$maxx);

    # print Dumper %volume;

    # foreach(@volumes) {
    #     my $ol=overlap(\%{$_}, \%volume);
    #     print "Overlap: $ol\n";
    # }

    push @volumes, \%volume;

    $id++;
#    last if($#volumes>10);
}

sub breakdown {
    my $new=shift;
    my $old=shift;
    my @nr=();


    if($new->{ty}>$old->{ty}) {
        push @nr, { tf => 1, action => $new->{action}, fy => ($old->{ty})+1, ty => $new->{ty}, fz => $new->{fz}, tz => $new->{tz}, id => $new->{id} };
    }
    if($new->{fz}<$old->{fz}) {
        push @nr, { tf => 2, action => $new->{action}, fy => max($old->{fy}, $new->{fy}), ty => min($old->{ty}, $new->{ty}), fz => $new->{fz}, tz => ($old->{fz})-1 , id => $new->{id}};
    }
    if($new->{tz}>$old->{tz}) {
        push @nr, { tf => 3, action => $new->{action}, fy => max($old->{fy}, $new->{fy}), ty => min($old->{ty}, $new->{ty}), fz => ($old->{tz})+1, tz => $new->{tz}, id => $new->{id} }
    }
    if($new->{fy}<$old->{fy}) {
        push @nr, { tf => 4, action => $new->{action}, fy => $new->{fy}, ty => ($old->{fy})-1, fz => $new->{fz}, tz => $new->{tz}, id => $new->{id} };
    }

    # print Dumper $new;
    # print Dumper $old;

    # print Dumper \@nr;

    return @nr;
}

sub poverlaps {
    my $new=shift;
    my $old=shift;

#    return ($new->{fy} >= $old {fy} && $new->{fy} <= $old->{ty} &&
#        $new->{tz} >= $old {fz} && $new->{fz} <= $old->{tz});

    # print "Checking for overlaps (ID=$new->{id}.$new->{tf} vs ID=$old->{id}.$old->{tf}):\n";
    # print "   ($new->{fy},$new->{fz}) -> ($new->{ty}, $new->{tz})\n";
    # print "   ($old->{fy},$old->{fz}) -> ($old->{ty}, $old->{tz})\n";

    # check if either is above the other
    my $overlap1=(($new->{fy} > $old->{ty}) || ($old->{fy} > $new->{ty}));
    # print "Above\n" if($overlap1);

    # check if either is left of the other
    my $overlap2=(($new->{fz} > $old->{tz}) || ($old->{fz} > $new->{tz}));
    # print "Left\n" if ($overlap2);
    
    return ($overlap1 || $overlap2) ? 0 : 1;

}

sub reccontains {
    my $in=shift;
    my $out=shift;

    # print "Checking for containment (In ID=$in->{id}.$in->{tf} vs OutID=$out->{id}.$out->{tf}):\n";
    # print "   ($in->{fy},$in->{fz}) -> ($in->{ty}, $in->{tz})\n";
    # print "   ($out->{fy},$out->{fz}) -> ($out->{ty}, $out->{tz})\n";

    return ($in->{fy} >= $out->{fy} && $in->{ty} <= $out->{ty} &&
        $in->{fz} >= $out->{fz} && $in->{tz} <= $out->{tz});
}

my $answer2=0;

foreach $x ($minx..$maxx) {
    my @intersects=grep { $x>=$volumes[$_]->{fx} && $x<=$volumes[$_]->{tx} } (0..$#volumes);

    # print "Layer $x - Intersects @intersects\n";

    # my $i=0;
    # foreach(@intersects) {
    #     print "$_: action: $volumes[$_]->{action} fx: $volumes[$_]->{fx} tx: $volumes[$_]->{tx} fy: $volumes[$_]->{fy} ty: $volumes[$_]->{ty} fz: $volumes[$_]->{fz} tz: $volumes[$_]->{tz}\n";
    #     $i++;
    # }

    next if(!(0+@intersects));

    my @checked=();

    foreach $v (@intersects) {
        my $n=0;
#        print "n=$n checked=$#checked\n"
        while ($n<=$#checked){
            my @same=($v->{action} == $_->{action});
            my $ncstart=$#checked;
            # print "Turn $n for volume $v - Now $ncstart items in checked list\n";
            if(reccontains($volumes[$v], $checked[$n])) {
                # print "$n contains $v\n";
                #$v is fully within $n  -split it up so it surrounds $v
                splice @checked, $n, 1, breakdown($checked[$n], $volumes[$v]);
            } elsif (reccontains($checked[$n], $volumes[$v])) {
                # print "$n contained by $v\n";
                #$v contains this rectangle fully. 
                # We can delete it from the list whether it's the same action or not
                splice(@checked, $n, 1); $n--;
            } elsif (poverlaps($checked[$n], $volumes[$v])) {
                # print "$n Overlaps $v\n";
  
                splice @checked, $n, 1, breakdown($checked[$n], $volumes[$v]); 
            }
#            $n+=($ncstart-$#checked);
            $n++;
        }
        push @checked, $volumes[$v];
    }

    my $layeron=0;

    my @layer=map{ [map {'0'} (0..100) ] } (0..100);

    my $i=0;
    map { 
        # $i++;
        # my $rect=$_;
        # foreach $y ($rect->{fy}..$rect->{ty}) {
        #     foreach $z ($rect->{fz}..$rect->{tz}) {
        #         die("($rect->{fy},$rect->{fz}) -> ($rect->{ty}, $rect->{tz}) has $layer[$y+50][$z+50] already\n") if($layer[$y+50][$z+50] ne '0');
        #         $layer[$y+50][$z+50]=(($rect->{action} eq 'on') ? "\e[0;44m" : "\e[0;0m").chr(65+$i)."\e[0;0m";
        #     }
        # }

         $layeron+=(($_->{ty} - $_->{fy})+1) * (($_->{tz}-$_->{fz})+1);
         # print "ID: $_->{id}.$_->{tf}: ($_->{fy}, $_->{fz}) to ($_->{ty}, $_->{tz}) - $layeron\n";
         } grep { $_->{action} eq 'on'} @checked;
    $answer2+=$layeron;

    # foreach $y (0..100) {
    #     foreach $z (0..100) {
    #         print $layer[$y][$z];
    #     }
    #     print "\n";
    # }

    print "Layer $x - $layeron -- $answer2\n"; 



}