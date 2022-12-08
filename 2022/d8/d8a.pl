#!/usr/bin/perl

my @data=map{chomp; [split //]} <STDIN>;

my $width=scalar @{$data[0]};
my $height=scalar @data;

printf("Width %d, Height %d\n",$width, $height);

my $result=$width*2 + ($height-2)*2;
my $result2=0;


for(my $i=1;$i<$width-1;$i++) {
    for(my $j=1; $j<$height-1; $j++) {
        my ($isv, $sc)=isVisible($i, $j);
        $result+=1 if($isv);
        $result2=$sc if($sc>$result2);

    }
}

printf("Result 1 is %d, Result 2 is %d\n", $result, $result2);

sub isVisible {
    my $tx=$_[0];
    my $ty=$_[1];
    my $th=$data[$ty][$tx];
    my $visibleleft=1;
    my $visibleright=1;
    my $visibleup=1;
    my $visibledown=1;
    my $nleft=0;
    my $nright=0;
    my $nup=0;
    my $ndown=0;


    printf("Check visibility for %d, %d - height %d - ", $tx, $ty, $th);

    for($i=$tx-1; $i>=0; $i--) {
        $nleft++;
        if($data[$ty][$i]>=$th) {
            $visibleleft=0;
            last;
        }
    }
    for($i=$tx+1; $i<$width; $i++) {
        $nright++;
        if($data[$ty][$i]>=$th) {
            $visibleright=0;
            last;
        }
    }
    for($i=$ty+1; $i<$height; $i++) {
        $ndown++;
        if($data[$i][$tx]>=$th) {
            $visibledown=0;
            last;
        }
    }
    for($i=$ty-1; $i>=0; $i--) {
        $nup++;
        if($data[$i][$tx]>=$th) {
            $visibleup=0;
            last;
        }
    }

    printf("%d %d %d %d", $visibleup, $visibleleft, $visibleright, $visibledown);

    printf(" - %d %d %d %d\n", $nup, $nleft, $nright, $ndown);

    return($visibleleft || $visibleright || $visibleup || $visibledown, $nleft*$nright*$ndown*$nup);
}

