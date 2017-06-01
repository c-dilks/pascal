#!/usr/bin/perl -w
# creates condor batch job for a loop over generate.pl

my $n_rows=500;
my $max_divisor=500;

open(my $batfile, '>', 'exe.bat') or die;
print($batfile "Executable = ./generate.pl\n");
print($batfile "Universe = vanilla\n");
print($batfile "notification = never\n");
print($batfile "getenv = True\n");
print($batfile "\n");

for (my $d=2; $d<=$max_divisor; $d++) {
  print($batfile "Arguments = $n_rows $d\n");
  print($batfile "Log    = log/job_$d.log\n");
  print($batfile "Output = log/job_$d.out\n");
  print($batfile "Error  = log/job_$d.err\n");
  print($batfile "Queue\n\n");
}
 close($batfile);

`condor_submit exe.bat`
