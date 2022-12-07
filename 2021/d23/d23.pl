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
die if(countsteps(10,18) != 4);
die if(countsteps(16,1) != 7);

my %cost={'A'=>1,'B'=>10,'C'=>100, 'D'=>1000};

my %homes=(A => [11,12], B=>[13,14], C=>[15,16], D=>[17,18]);

my $mincost=999999999999;

my %counts;

#my @gb=@board;

#my @positions=( {b=>"...........BACDBCDA", cost=>0, state=>'P'} );
my @positions=( {b=>"...........ADCDBBAC", cost=>0, state=>'P'} );

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
        if($board[$_] ne '.') {
#            print "Found $board[$_] at $_\n";
            next if(($_==0 && $board[1] ne '.') || ($_==10 && $board[9] ne '.'));
            my $home='';
            my $target=-1;

            # is there an available home?
            if($board[$homes{$board[$_]}[1]] eq '.' && $board[$homes{$board[$_]}[0]] eq '.' ) {
                $target=$homes{$board[$_]}[1];
            } elsif($board[$homes{$board[$_]}[0]] eq '.' && $board[$homes{$board[$_]}[1]] eq $board[$_]) {
                $target=$homes{$board[$_]}[0];
            } else { next; }
#            print "Target: $target\n";

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
    foreach my $pl (11..18) {
#        print "$pl - $board[$pl]\n";
        if($board[$pl] ne '.') {
            # is it already home?
            next if($pl~~$homes{$board[$pl]} && !(($pl % 2) && $board[$pl+1] ne $board[$pl]));

            # is it stuck?
            next if(!($pl % 2) && $board[$pl-1] ne '.');

            # so where can it go?
            my $step=-1;
            my $d=0;
            foreach my $poss (0..10) {
                next if ($poss==2 || $poss==4 || $poss==6 || $poss==8);
                next if ($board[$poss] ne '.');
                if(isnotblocked($pl, $poss, @board)) {
                    push @moves, [$pl, $poss];
                }
            }

        }
    }

    return @moves;

}


sub countsteps {
    my $from=shift;
    my $to=shift;

    my $start=min($from, $to);
    my $end=max($from, $to);
    my $ret;

    if ($end==11 || $end==12) {
        $ret=abs($start-2)+($end-10);
    }
    if ($end==13 || $end==14) {
        $ret=abs($start-4)+($end-12);
    }
    if ($end==15 || $end==16) {
        $ret=abs($start-6)+($end-14);
    }
    if ($end==17 || $end==18) {
        $ret=abs($start-8)+($end-16);
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

    my %npos=( b=>$nboard, cost=>$pos->{cost}+$movecost, state=>'P', 
        hist=> [ map {$_} @{$pos->{hist}}, $pos->{b}],
        hcost=> [ map {$_} @{$pos->{hcost}}, $pos->{cost}]);

    $npos{state}='W' if (substr($nboard,11) eq 'AABBCCDD');
    if ($npos{cost} > $mincost) {
        $npos{state}='B';
        print "Cost $npos{cost} > $mincost\n";
    }

    print "New board $npos{b}, cost $npos{cost}, state $npos{state}\n";

    if($npos{state} eq 'W') {
        print "Path to victory:\n";

        foreach(@{$npos{hist}}) {
            print "$_\n";
        }
        $mincost=$npos{cost} if($mincost>$npos{cost});
    }

    return %npos;

}

print Dumper @positions;

play(1, \@positions);

print "Answer: $mincost\n";


sub play {
    my $level=shift;
    my @in_positions=@{$_[0]};
 
    print "Playing level $level - $#positions positions\n";

    # foreach(@positions) {
    #     print "$_->{b}\n";
    # }

    my @positions=sort { $b->{cost} <=> $a->{cost} } @in_positions;

    foreach my $pos (@positions) {
        my @endpos=();

        print "Playing $pos->{b} (cost so far $pos->{cost}\n";
        if ($played{$pos->{b}}) {
            print "Played this before!!: $pos->{b}: $played{$pos->{b}}";
            if ($played{$pos->{b}}>0) {
                if(($pos->{cost}+$played{$pos->{b}})<$mincost) {
                    $pos->{state}="W";
                    $mincost=($pos->{cost}+$played{$pos->{b}});
                    print "NEW MINIMUM $mincost\n";
                    foreach my $i (0..@{$pos->{hist}}) {
                        my $wincost=$mincost-$pos->{hcost}[$i];
                        $played{$pos->{hist}[$i]}=$wincost if($played{$pos->{hist}[$i]}<=0 || $played{$pos->{hist}[$i]}>$wincost);
                    }
                } else {
                    $pos->{state}='B';
                    print "BUSTED\n";
                    # foreach my $i (0..@{$pos->{hist}}) {
                    #     $played{$pos->{hist}[$i]}=-2 if($played{$pos->{hist}[$i]}==0);
                    # }
                }
            } elsif($played{$pos->{b}}==-1) {
                $pos->{state}='L';
                print "WILL LOSE\n";
                foreach my $i (0..@{$pos->{hist}}) {
                    $played{$pos->{hist}[$i]}=-1 if($played{$pos->{hist}[$i]}==0);
                }
            } # elsif($played{$pos->{b}}==-2) {
            #     $pos->{state}='B';
            #     print "WILL BUST\n";
            #     foreach my $i (0..@{$pos->{hist}}) {
            #         $played{$pos->{hist}[$i]}=-2 if($played{$pos->{hist}[$i]}==0);
            #     }
            # }

        }

        if($pos->{state} eq 'P') {
            my @nextmoves=findmoves($pos);

            print "Found $#nextmoves possible moves\n";

            if(0+@nextmoves) {
                my %npos=();
                foreach(@nextmoves) {
                    %npos=makemove(\%{$pos}, $_);
                    push @endpos, {%npos};
                }
            } else {
                $pos->{state}='L';
                print "Oh dear $pos->{b}, cost $pos->{cost}, state $pos->{state}\n";
                foreach my $i (0..@{$pos->{hist}}) {
                    $played{$pos->{hist}[$i]}=-1 if($played{$pos->{hist}[$i]}==0);
                }
                next;
            }
        }
 
        if ($pos->{state} eq 'W') {
            print "WINNER - $pos->{b} - $pos->{cost}\n";
            foreach my $i (0..@{$pos->{hist}}) {
                my $wincost=$pos->{cost}-$pos->{hcost}[$i];
                $played{$pos->{hist}[$i]}=$wincost if($played{$pos->{hist}[$i]}<=0 || $played{$pos->{hist}[$i]}>$wincost);
            }

            $mincost=$pos->{cost} if($mincost>$pos->{cost});
        } elsif ($pos->{state} eq 'B') {
            foreach my $i (0..@{$pos->{hist}}) {
                $played{$pos->{hist}[$i]}=-2 if($played{$pos->{hist}[$i]}==0);
            }
        }

        if (0+@endpos) {
            print "$#endpos new positions\n";
            my $i=0;
            # foreach(@endpos) {
            #     print "$i: $_->{b} state $_->{state}\n";
            # }
            play($level+1, \@endpos);
            print "Back at level $level\n";
        }
    }
    print "Finished play\n";
}



sub isnotblocked {
    my $pl=shift;
    my $poss=shift;
    my $ret=0;
    my @board=@_;

#    print "Checking $pl to $poss on @board\n";

    if($poss==0 || $poss==1) {
        if($pl==11 || $pl==12) {
            $ret=1;
        } elsif ($pl==13 || $pl==14) {
            $ret=1 if($board[3] eq '.');
        } elsif ($pl==15 || $pl==16) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.');
        } elsif ($pl==17 || $pl==18) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        }
    } elsif($poss==3) {
        if($pl==11 || $pl==12) {
            $ret=1;
        } elsif ($pl==13 || $pl==14) {
            $ret=1;
        } elsif ($pl==15 || $pl==16) {
            $ret=1 if($board[5] eq '.');
        } elsif ($pl==17 || $pl==18) {
            $ret=1 if($board[5] eq '.' && $board[7] eq '.');
        }
    } elsif($poss==5) {
        if($pl==11 || $pl==12) {
            $ret=1 if($board[3] eq '.');
        } elsif ($pl==13 || $pl==14) {
            $ret=1;
        } elsif ($pl==15 || $pl==16) {
            $ret=1;
        } elsif ($pl==17 || $pl==18) {
            $ret=1 if($board[7] eq '.');
        }

    } elsif($poss==7) {
        if($pl==11 || $pl==12) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.');
        } elsif ($pl==13 || $pl==14) {
            $ret=1 if($board[5] eq '.');
        } elsif ($pl==15 || $pl==16) {
            $ret=1;
        } elsif ($pl==17 || $pl==18) {
            $ret=1;
        }
    } elsif($poss==9 || $poss==10) {
        if($pl==11 || $pl==12) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==13 || $pl==14) {
            $ret=1 if($board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==15 || $pl==16) {
            $ret=1 if($board[7] eq '.');
        } elsif ($pl==17 || $pl==18) {
            $ret=1;
        }
    } elsif($poss==11 || $poss==12) {
        if($pl==0 || $pl==1 || $pl==3) {
            $ret=1;
        } elsif ($pl==5) {
            $ret=1 if($board[3] eq '.');
        } elsif ($pl==7) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.');
        } elsif ($pl==9 || $pl==10) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        }
    } elsif($poss==13 || $poss==14) {
        if($pl==0 || $pl==1) {
            $ret=1 if($board[3] eq '.');
        } elsif ($pl==5 || $pl==3) {
            $ret=1;
        } elsif ($pl==7) {
            $ret=1 if($board[5] eq '.');
        } elsif ($pl==9 || $pl==10) {
            $ret=1 if($board[5] eq '.' && $board[7] eq '.');
        }

    } elsif($poss==15 || $poss==16) {
        if($pl==0 || $pl==1) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.');
        } elsif ($pl==3) {
            $ret=1 if($board[5] eq '.');
        } elsif ($pl==5 ||$pl==7) {
            $ret=1;
        } elsif ($pl==9 || $pl==10) {
            $ret=1 if($board[7] eq '.');
        }
    } elsif($poss==17 || $poss==18) {
        if($pl==0 || $pl==1) {
            $ret=1 if($board[3] eq '.' && $board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==3) {
            $ret=1 if($board[5] eq '.' && $board[7] eq '.');
        } elsif ($pl==5 ) {
            $ret=1 if($board[7] eq '.');
        } elsif ($pl==9 || $pl==10 || $pl==7) {
            $ret=1;
        }
    }

    return $ret;

}