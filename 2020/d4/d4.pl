#!/user/bin/perl

use Data::Dumper;

my $passports;
my $valid;
my $complete;

my $block;
my %f;

my %vr=(
	'byr'=>{ 'type'=>'val', 'min'=>1920, 'max'=>2002 },
	'iyr'=>{ 'type'=>'val', 'min'=>2010, 'max'=>2020 },
	'eyr'=>{ 'type'=>'val', 'min'=>2020, 'max'=>2030 },
	'hgt'=>{ 'type'=>'rex', 'rex'=>'^((1[5-8][0-9]cm)|(19[0-3]cm)|(((59)|(6[0-9])|(7[0-6]))in))$'},
	'hcl'=>{ 'type'=>'rex', 'rex'=>'^\#[0-9a-f]{6}$'},
	'ecl'=>{ 'type'=>'rex', 'rex'=>'^(amb)|(blu)|(brn)|(gry)|(grn)|(hzl)|(oth)$'},
	'pid'=>{ 'type'=>'rex', 'rex'=>'^[0-9]{9}$'}
);


while ($line=<STDIN>) {
	chomp $line;

	if($line eq '') {
		if($f{'byr'}+$f{'iyr'}+$f{'eyr'}+$f{'hgt'}+$f{'hcl'}+$f{'ecl'}+$f{'pid'}==7) {
			print"Valid\n";
			$valid++;
		} else {
			print "Invalid\n";
		}
		%f=();
	} else {
		my @kv=split ' ', $line;
		foreach(@kv) {
			@x= $_=~ q/([a-z]{3}):(.*)/;
			print "$x[0] --- $x[1] ";
			if($vr{$x[0]}{'type'} eq 'val') {
				if($x[1]>=$vr{$x[0]}{'min'} && $x[1]<=$vr{$x[0]}{'max'} ) {
					$f{$x[0]}++;
					print "Valid val";
				} else { print "Invalid val";}
			} elsif ($vr{$x[0]}{'type'} eq 'rex') {
				if($x[1] =~ $vr{$x[0]}{'rex'}) {
					$f{$x[0]}++;
					print "Valid rex";
				} else {print "Invlid rex";}
			} else {print "No validation";}
			print "\n";
		}
	}
}

print "Valid: $valid\n"