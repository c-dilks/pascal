#!/usr/bin/perl -w

use bignum;
use Data::Dumper;


# arguments
my $max_row;
my $divisor;
my $nLead = 2;
if($#ARGV+1>=2) { 
  $max_row = $ARGV[0];
  $divisor = $ARGV[1];
  if($#ARGV+1==3) {
    $nLead = $ARGV[2];
  }
} else {
  printf "usage: $0 [max_rows] [divisor] [nLead=2]\n";
  printf " - [max_rows] = how many rows of pascal's triangle to draw\n";
  printf " - [divisor] = used in calculation [pascal_triangle] mod [divisor]\n";
  printf " - [nLead=2] = pad filename with up to [nLead] zeros (default value=2)\n";
  exit;
}


# count number of digits beyond decimal
my $divisorStr = "$divisor";
$divisorStr =~ s/^.*\.//;
my $deciDigits = length($divisorStr);
print "deciDigits=$deciDigits\n";

if($max_row % 2 == 0) { $max_row++; } #(for drawing)


# read in perfect numbers
#open(PERFECT,"perfect_numbers.list") or die;
#my @perflist;
#foreach $line (<PERFECT>) {
  #chomp($line);
  #push(@perflist,$line);
#}
#print Dumper(\@perflist);

# read in fibonacci numbers
#open(FIBONACCI,"fibonacci_numbers.list") or die;
#my @fiblist;
#foreach $line (<FIBONACCI>) {
  #chomp($line);
  #push(@fiblist,$line);
#}
#print Dumper(\@fiblist);


# add up to $nLead leading zeros for output file name
my $suffix = "$divisor";
my $p;
for($p=1; $p<=$nLead; $p++) {
  if($divisor<10**$p) { $suffix = "0$suffix"; }
}

# prepare output file
my $outname = "data/triangle_${suffix}.dat";
printf "outname = $outname\n";
open(my $datfile, '>', $outname) or die; # data table


# pascal triangle numbers
my @ap; # store previous coefficients
my @ac; # store new coefficients
my $r; # row
my $c; # column

my $hx; # honeycomb x
my $hy; # honyecomb y
my $mp = ($max_row+1)/2; # honeycomb mid-point

my $a; # used in mod calculation
my $b; # used in mod calculation
my $ee = 10**$deciDigits; # used in mod calulation
my $result; # result of mod calcluation


for($r=0; $r<$max_row; $r++) {
  # compute coefficents
  if($r==0) { $ac[0]=1; } 
  else {
    for($c=0; $c<$r+1; $c++) {
      $ap[$c] = $ac[$c];
      if($c==0 || $c==$r) { $ac[$c] = 1; } # trivial case
      elsif($c==1 || $c==$r-1) { $ac[$c] = $r; } # trivial case
      elsif($c>$r/2) { $ac[$c] = $ac[$r-$c]; } # reflection symmetry case
      else { $ac[$c] = $ap[$c-1] + $ap[$c]; } # compute sum as last resort
      #print("$ac[$c] "); # enable to print coeffiencts
    }
  }

  # calculate honeycomb coordinates and pascal # mod divisor
  for($c=0; $c<$r+1; $c++) {
    # map row and column to honeycomb x and y
    $hx = $r%2==0 ? $mp+$c-$r/2 : $mp+$c-($r+1)/2;
    $hy = $max_row - $r;

    # calculate pascal # mod divisor
    #if($r>0) { $result = $ac[$c] % $divisor; } # for ints only
    $a = int($ac[$c]*$ee);
    $b = int($divisor*$ee);
    $result = ( $a % $b ) / $ee; 
    
    # write out
    print($datfile "$hx $hy $result\n"); 
    print("$result ");
  }
  print("\nend row $r\n");
};
close($datfile);
print("drawing maxrow=$max_row divisor=$divisor...\n");
`root -b -q -l draw.C'($max_row,"$suffix")'`
