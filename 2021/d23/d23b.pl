#!/usr/bin/perl

use strict;
use Data::Dumper;
use experimental 'smartmatch';
use List::Util qw(min max);

my @plan=map { {content=>'.', home=>'.'} } (0-10);
$plan[11]={content=>'B',home=>'A', up=>2, down=>12};
$plan[12]={content=>'A', home=>'A', up=>11 };
$plan[13]={content=>'C', home=>'B', up=>4, down=>14};
$plan[14]={content=>'D', home=>'B', up=>13};
$plan[15]={content=>'B', home=>'C', up=>6, down=>16};
$plan[16]={content=>'C', home=>'C', up=>15};
$plan[17]={content=>'D', home=>'D', up=>8, down=>18};
$plan[18]={content=>'A', home=>'D', up=>17};

die if(countsteps(0,11) != 3);
die if(countsteps(10,18) != 10);
die if(countsteps(16,1) != 5);
die if(countsteps(22,23) != 7);
die if(countsteps(14,23) != 11);
die if(isnotblocked(25,10,(split //, 'A........D.BDDACCBDBBAC..CA') != 0));
die if(isnotblocked(25,1,(split //, 'A........D.BDDACCBDBBAC..CA') != 1));
die if(tellcolumn(19) != 3);
die if(tellcolumn(25)-tellcolumn(11) != 3);

my %cost={'A'=>1,'B'=>10,'C'=>100, 'D'=>1000};

my %homes=(A => [11,12,13,14], B=>[15,16,17,18], C=>[19,20,21,22], D=>[23,24,25,26]);

my $mincost=999999999999;

my %counts;

#my @gb=@board;

#my @positions=( {b=>"...........BACDBCDA", cost=>0, state=>'P'} );
my @positions=( {b=>"...........ADCDBBAC", cost=>0, state=>'P'} );

my %position=(b=>"...........ADCDBBAC", cost=>0, state=>'P');  # Challenge
#my %position=(b=>"...........BACDBCDA", cost=>0, state=>'P');  #Example
#my %position=(b=>"...........BDDACCBDBBACDACA", cost=>0, state=>'P');  #Example2
my %position=(b=>"...........ADDDCCBDBBABAACC", cost=>0, state=>'P');  # Challenge2


my $done=0;
my %played=();

sub findmoves {
    my $pos=shift;
#    print Dumper \%{$pos};
    my @moves=();
    my @board=split //, $pos->{b};

    #first check for amphipods that can get home
    #find ones in the top row that can move
    foreach(0..10) {
#        print "$_\n";
        my $apod=$board[$_];
        if($apod ne '.') {
#            print "Found $board[$_] at $_\n";
            next if(($_==0 && $board[1] ne '.') || ($_==10 && $board[9] ne '.'));
            my $home='';
            my $target=-1;

            # is there an available home?
            # has to be the lowest empty spot with only its own type below it

#            foreach my $tp (0..(@{$homes{$board[$_]}})) {
            foreach my $tp (@{$homes{$board[$_]}}) {
                if($board[$tp] eq '.') {
                    $target=$tp;
                } elsif($board[$tp] ne $apod) {
                    $target=-1;
                } ; #Otherwise if it's not empty it's the wrong kind - can't go home this time
                # It's an empty spot
            }

            print "Target: $target from $_\n";

            # is there anything in the way?
#            print "Check if it's blocked - ";
            if(isnotblocked($_, $target, @board)) {
#                    print "No!\n";
                push @moves, [$_, $target];
            } else {
 #               print "Yes :-(\n";
            }
        }
    }

    #Now look for amphipods who can move out of a home
    foreach my $pl (11..26) {
#        print "$pl - $board[$pl]\n";
        if($board[$pl] ne '.') {
            # is it already home? If it's in its home column, make sure it's not got any other type around it
            if($pl~~$homes{$board[$pl]}) {
                print "$pl is home for $board[$pl]\n";
                my $athome=1;
                foreach(@{$homes{$board[$pl]}}){
                    if(($board[$_] ne '.') && $board[$_] ne $board[$pl]) {
                        $athome=0;
                    }
                }
                print "Athome=$athome\n";
                next if($athome);
            }
            # is it stuck?

            my $coltop=(int(($pl+1)/4)*4-1);
            my $stuck=0;
            foreach($coltop..($coltop+3)) {
                if(($pl>$_) && $board[$_] ne '.') {
                    $stuck=1;
                }
            }

            next if($stuck);

            # so where can it go?
            my $step=-1;
            my $d=0;
            foreach my $poss (0..26) {
                next if ($poss==2 || $poss==4 || $poss==6 || $poss==8 || $poss==$pl);
                next if ($board[$poss] ne '.');
                next unless ($poss<=10 || $poss~~$homes{$board[$pl]}); # Can only go to the top row or a home square

                if($poss>10) {
                    my $nope=0;
                    #if we're not trying to land at the bottom of a column, make sure there's nothing empty or of a different type below
                    if($poss!=max(@{$homes{$board[$pl]}})) { 
                        print "Finding $poss - Max of homes for $board[$pl]: ";
                        print max(@{$homes{$board[$pl]}})."\n";
                        foreach($poss+1..max(@{$homes{$board[$pl]}})) {
                            $nope=1 if ($board[$_] ne $board[$pl]);
                        }
                        next if($nope);
                    }
                }

                if(isnotblocked($pl, $poss, @board)) {
                    print "Target $poss from $pl\n";
                    push @moves, [$pl, $poss];
                }
            }

        }
    }

    return @moves;

}

sub tellcolumn {
    my $cell=shift;

    return int(($cell+1)/4)-2;
}


sub countsteps {
    my $from=shift;
    my $to=shift;

    my $start=min($from, $to);
    my $end=max($from, $to);
    my $ret=0;
    my $top=0;

    if ($end>=11 && $end<=14) {
        $ret=($end-10);
        $top=abs($start-2);
    } elsif ($end>=15 && $end<=18) {
        $ret=($end-14);
        $top=abs($start-4);
    } elsif ($end>=19 && $end<=22) {
        $ret=($end-18);
        $top=abs($start-6);
    } elsif ($end>=23 && $end<=26) {
        $ret=($end-22);
        $top=abs($start-8);
    }

    if ($start>=11 && $start<=14) {
        $ret+=($start-10)+2*(tellcolumn($end)-tellcolumn($start));
    } elsif ($start>=15 && $start<=18) {
        $ret+=($start-14)+2*(tellcolumn($end)-tellcolumn($start));
    } elsif ($start>=19 && $start<=22) {
        $ret+=($start-18)+2*(tellcolumn($end)-tellcolumn($start));
    } elsif ($start>=23 && $start<=26) {
        $ret+=($start-22)+2*(tellcolumn($end)-tellcolumn($start));
    } else {
        $ret+=$top;
    }

    return $ret;

}

sub makemove {
#    print "makemove\n";
    my $pos=shift;
    my $smove=shift;
    my @move=@$smove;

    my $movecost=0;

#    print "Board $pos->{b} Move from $move[0] to $move[1]\n";

    my $movecost=(10**(ord(substr($pos->{b},$move[0],1))-ord('A')))*countsteps($move[0], $move[1]);

    my $board=$pos->{b};
    my $pod=substr($pos->{b}, $move[0],1);
    my $nboard=substr($pos->{b},0, $move[0]).'.'.substr($pos->{b}, $move[0]+1);
    $nboard=substr($nboard,0,$move[1]).$pod.substr($nboard,$move[1]+1);

    my %npos=( b=>$nboard, movecost=>$movecost, cost=>$pos->{cost}+$movecost, state=>'P', 
        hist=> [ map {$_} @{$pos->{hist}}, $pos->{b}],
        hcost=> [ map {$_} @{$pos->{hcost}}, $pos->{cost}]);

    $npos{state}='W' if (substr($nboard,11) eq 'AAAABBBBCCCCDDDD');
#    if ($npos{cost} > $mincost) {
#        $npos{state}='B';
#        print "Cost $npos{cost} > $mincost\n";
#    }

    print "New board $npos{b}, cost $npos{cost}, state $npos{state}\n";

    if($npos{state} eq 'W') {
        print "WINNER: Path to victory:\n";

        foreach(@{$npos{hist}}) {
            print "$_\n";
        }
        $mincost=$npos{cost} if($mincost>$npos{cost});
    }

    return %npos;

}

print Dumper \%position;

play(1, \%position);

print "Answer: $mincost\n";


sub play {
    my $level=shift;
    my $pos=shift;
#    my @in_positions=@{$_[0]};
    my $bestwin=0;
 
    print "Playing level $level\n";

    my @endpos=();

    print "Playing $pos->{b} (cost so far $pos->{cost})\n";
    if ($played{$pos->{b}}) {
        print "Played this before!!: $pos->{b}: $played{$pos->{b}}\n";
        if ($played{$pos->{b}}>0) {
            if(($pos->{cost}+$played{$pos->{b}})<$mincost) {
                $pos->{state}="w";
                $mincost=($pos->{cost}+$played{$pos->{b}});
                print "NEW MINIMUM $mincost\n";
                # foreach my $i (0..@{$pos->{hist}}) {
                #     my $wincost=$mincost-$pos->{hcost}[$i];
                #     $played{$pos->{hist}[$i]}=$wincost if($played{$pos->{hist}[$i]}<=0 || $played{$pos->{hist}[$i]}>$wincost);
                # }
            } else {
                $pos->{state}='B';
                print "SHORTCUT BUSTED\n";
            }
        } elsif($played{$pos->{b}}==-1) {
            $pos->{state}='L';
            print "SHORTCUT LOSE\n";
            $bestwin=-1;
            # foreach my $i (0..@{$pos->{hist}}) {
            #     $played{$pos->{hist}[$i]}=-1 if($played{$pos->{hist}[$i]}==0);
            # }
        }
    }

    if($pos->{state} eq 'P') {
        my @nextmoves=findmoves($pos);

        print "Found $#nextmoves possible moves\n";

        if(0+@nextmoves) {
            my %npos=();
            foreach(@nextmoves) {
                %npos=makemove(\%{$pos}, $_);

                if($npos{state} eq 'W') {
                    $bestwin=$npos{movecost} if($bestwin<=0 || ($bestwin>0 && $npos{movecost}<$bestwin));
                    print "A WINNNING MOVE costs $npos{movecost} from here - best is $bestwin\n";   
                } else {
                    push @endpos, {%npos};
                }
            }

            if($bestwin==0) {
                print "$#endpos new positions\n";
                my $i=0;
        #            my @positions=sort { $b->{cost} <=> $a->{cost} } @in_positions;
                foreach(@endpos) {
                #     print "$i: $_->{b} state $_->{state}\n";
                    my $thiswin=play($level+1, $_);
                    print "Back at level $level - $thiswin\n";
                    if($thiswin>0 && ($bestwin<1 || $thiswin<$bestwin)) {
                        $bestwin=$thiswin;
                    } elsif ($thiswin<1 && $bestwin<1) {
                        $bestwin=$thiswin;
                    }
                }
            }
        } else {
            $pos->{state}='L';
            print "Oh dear $pos->{b}, cost $pos->{cost}, state $pos->{state}\n";
            $bestwin=-1;
        }
    } elsif($pos->{state} eq 'W') {
        print "WINNER - $pos->{b} - $pos->{cost}\n";

        $bestwin=$pos->{cost}-$pos->{movecost};

        $mincost=$pos->{cost} if($mincost>$pos->{cost});
    } elsif($pos->{state} eq 'w') {
        my $finalcost=$pos->{cost}+$played{$pos->{b}};
        print "SHORTCUT WINNER - $pos->{b} - $finalcost\n";

        $bestwin=$played{$pos->{b}};

        $mincost=$finalcost if($mincost>$finalcost);
    } elsif ($pos->{state} eq 'B') {
        $bestwin=$played{$pos->{b}};
    }

    print "Finished play on $pos->{b}. Best win cost is $bestwin\n";

    $played{$pos->{b}}=$bestwin; # if($played{$pos->{b}}==0 || ($bestwin>0 && $played{$pos->{b}}>$bestwin));

    return $bestwin+(($bestwin>0) ? $pos->{movecost} : 0);
}



sub isnotblocked {
    my $pl=shift;
    my $poss=shift;
    my $ret=0;
    my @board=@_;

#   print "Checking $pl to $poss on @board\n";

    if($poss==0) {
        if($pl==11 || $pl==12 || $pl==13 || $pl == 14) {
            $ret=1;
        } elsif ($pl==15 || $pl==16 || $pl==17 || $pl==18) {
            $ret=1 if($board[3] eq '.');
        } elsif ($pl==19 || $pl==20 || $pl==21 || $pl==22) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.');
        } elsif ($pl==23 || $pl==24 || $pl==25 || $pl==26) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        }
        if($board[1] ne '.') {
            $ret=0;
        }
    } elsif($poss==1) {
        if($pl==11 || $pl==12 || $pl==13 || $pl == 14) {
            $ret=1;
        } elsif ($pl==15 || $pl==16 || $pl==17 || $pl==18) {
            $ret=1 if($board[3] eq '.');
        } elsif ($pl==19 || $pl==20 || $pl==21 || $pl==22) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.');
        } elsif ($pl==23 || $pl==24 || $pl==25 || $pl==26) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        }
    } elsif($poss==3) {
        if($pl==11 || $pl==12 || $pl==13 || $pl == 14) {
            $ret=1;
        } elsif ($pl==15 || $pl==16 || $pl==17 || $pl==18) {
            $ret=1;
        } elsif ($pl==19 || $pl==20 || $pl==21 || $pl==22) {
            $ret=1 if($board[5] eq '.');
        } elsif ($pl==23 || $pl==24 || $pl==25 || $pl==26) {
            $ret=1 if($board[5] eq '.' && $board[7] eq '.');
        }
    } elsif($poss==5) {
        if($pl==11 || $pl==12 || $pl==13 || $pl == 14) {
            $ret=1 if($board[3] eq '.');
        } elsif ($pl==15 || $pl==16 || $pl==17 || $pl==18) {
            $ret=1;
        } elsif ($pl==19 || $pl==20 || $pl==21 || $pl==22) {
            $ret=1;
        } elsif ($pl==23 || $pl==24 || $pl==25 || $pl==26) {
            $ret=1 if($board[7] eq '.');
        }

    } elsif($poss==7) {
        if($pl==11 || $pl==12 || $pl==13 || $pl == 14) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.');
        } elsif ($pl==15 || $pl==16 || $pl==17 || $pl==18) {
            $ret=1 if($board[5] eq '.');
        } elsif ($pl==19 || $pl==20 || $pl==21 || $pl==22) {
            $ret=1;
        } elsif ($pl==23 || $pl==24 || $pl==25 || $pl==26) {
            $ret=1;
        }
    } elsif($poss==9) {
        if($pl==11 || $pl==12 || $pl==13 || $pl == 14) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==15 || $pl==16 || $pl==17 || $pl==18) {
            $ret=1 if($board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==19 || $pl==20 || $pl==21 || $pl==22) {
            $ret=1 if($board[7] eq '.');
        } elsif ($pl==23 || $pl==24 || $pl==25 || $pl==26) {
            $ret=1;
        }
    } elsif($poss==10) {
        if($pl==11 || $pl==12 || $pl==13 || $pl == 14) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==15 || $pl==16 || $pl==17 || $pl==18) {
            $ret=1 if($board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==19 || $pl==20 || $pl==21 || $pl==22) {
            $ret=1 if($board[7] eq '.');
        } elsif ($pl==23 || $pl==24 || $pl==25 || $pl==26) {
            $ret=1;
        }
        if($board[9] ne '.') {
            $ret=0;
        }
    } elsif($poss==11 || $poss==12 || $poss==13 || $poss == 14) {
        if($pl==0 || $pl==1 || $pl==3) {
            $ret=1;
        } elsif ($pl==5 || ($pl>=15 && $pl<=18)) {
            $ret=1 if($board[3] eq '.');
        } elsif ($pl==7 || ($pl>=19 && $pl<=22)) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.');
        } elsif ($pl==9 || $pl==10 || $pl>=23) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        }
    } elsif($poss==15 || $poss==16 || $poss==17 || $poss==18) {
        if($pl==0 || $pl==1 || ($pl>=11 && $pl<=14)) {
            $ret=1 if($board[3] eq '.');
        } elsif ($pl==5 || $pl==3) {
            $ret=1;
        } elsif ($pl==7 || ($pl>=19 && $pl<=22)) {
            $ret=1 if($board[5] eq '.');
        } elsif ($pl==9 || $pl==10 || $pl>=23) {
            $ret=1 if($board[5] eq '.' && $board[7] eq '.');
        }

    } elsif($poss==19 || $poss==20 || $poss==21 || $poss==22) {
        if($pl==0 || $pl==1 || ($pl>=11 && $pl<=14)) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.');
        } elsif ($pl==3 || ($pl>=15 && $pl<=18)) {
            $ret=1 if($board[5] eq '.');
        } elsif ($pl==5 ||$pl==7) {
            $ret=1;
        } elsif ($pl==9 || $pl==10 || $pl>23) {
            $ret=1 if($board[7] eq '.');
        }
    } elsif($poss==23 || $poss==24 || $poss==25 || $poss==26) {
        if($pl==0 || $pl==1 || ($pl>=11 && $pl<=14)) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==3 || ($pl>=15 && $pl<=18)) {
            $ret=1 if($board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==5 || ($pl>=19 && $pl<=22) ) {
            $ret=1 if($board[7] eq '.');
        } elsif ($pl==9 || $pl==10 || $pl==7) {
            $ret=1;
        }
    }

    return $ret;

}