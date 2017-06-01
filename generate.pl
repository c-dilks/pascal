#!/usr/bin/perl -w

use bigint;
use Data::Dumper;
use POSIX "fmod";


my $max_row = 500;
my $divisor = 8;
if($#ARGV>=0) { 
  $max_row = $ARGV[0];
  if($#ARGV>=1) { 
    $divisor = $ARGV[1];
  }
}

if($max_row % 2 == 0) { $max_row++; }

my @ap; # store previous coefficients
my @ac; # store new coefficients
my $r; # row
my $c; # column

my $hx; # honeycomb x
my $hy; # honyecomb y
my $state; # state of coefficient 
my $mp = ($max_row+1)/2; # honeycomb mid-point

# read in perfect numbers
open(PERFECT,"perfect_numbers.list") or die;
my @perflist;
foreach $line (<PERFECT>) {
  chomp($line);
  push(@perflist,$line);
}
#print Dumper(\@perflist);

# read in fibonacci numbers
open(FIBONACCI,"fibonacci_numbers.list") or die;
my @fiblist;
foreach $line (<FIBONACCI>) {
  chomp($line);
  push(@fiblist,$line);
}
#print Dumper(\@fiblist);

my $outname = "data/triangle_${divisor}.dat";
open(my $datfile, '>', $outname) or die; # data table

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

  # determine and write out state of coefficient
  for($c=0; $c<$r+1; $c++) {
    # map row and column to honeycomb x and y
    $hx = $r%2==0 ? $mp+$c-$r/2 : $mp+$c-($r+1)/2;
    $hy = $max_row - $r;

    # set state of coefficient 
    #if($r>0) { $state = $ac[$c] % $r ? 2:1; }
    #if($r>0) { $state = $ac[$c] % 5 == 0 ? 2:1; }
    #if(grep {$ac[$c] eq $_} @perflist) { $state = 2; }
    #if(grep {$ac[$c] eq $_} @fiblist) { $state = 2; }
    #if($r>0) { $state = $ac[$c] % $r; }
    #if($r>0) { $state = $ac[$c] % $divisor; }
    if($r>0) { $state = fmod($ac[$c],$divisor); }
    else { $state = 1; }
    
    # write out
    print($datfile "$hx $hy $state\n"); 
  }
  print("end row $r\n");
};
close($datfile);
print("drawing maxrow=$max_row divisor=$divisor...\n");
`root -b -q -l draw.C'($max_row,"$divisor")'`