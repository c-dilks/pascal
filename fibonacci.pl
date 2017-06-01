#!/usr/bin/perl -w

use bigint;

my $max_iter = 1000;

open(my $list, '>', 'fibonacci_numbers.list') or die; 
my $a=0;
my $b=1;
my $c;
for(my $i=0; $i<$max_iter; $i++) {
  $c = $a + $b;
  $a = $b;
  $b = $c;
  print($list "$c\n");
};
close($list);
