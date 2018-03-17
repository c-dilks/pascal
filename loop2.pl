#!/usr/bin/perl -w
# creates condor batch job for a loop over generate.pl

my $n_rows=300;

my $deciDigits=2;
my $lowerBound = 2.00;
my $upperBound = 19.00;
my $step = 0.01;


open(my $batfile, '>', 'exe.bat') or die;
print($batfile "Executable = ./generate.pl\n");
print($batfile "Universe = vanilla\n");
print($batfile "notification = never\n");
print($batfile "getenv = True\n");
print($batfile "\n");



my $d = $lowerBound;
while($d <= $upperBound) {
  $d = sprintf "%.${deciDigits}f", $d;
  print($batfile "Arguments = $n_rows $d $deciDigits\n");
  print($batfile "Log    = log/job_$d.log\n");
  print($batfile "Output = log/job_$d.out\n");
  print($batfile "Error  = log/job_$d.err\n");
  print($batfile "Queue\n\n");
  $d += 0.01;
}
 close($batfile);

`condor_submit exe.bat`
