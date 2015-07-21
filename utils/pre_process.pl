#!/usr/bin/perl

# This script takes a trace il file (.il) as input and finish two jobs:
# 1. Cut the .il file when meeting the assert (cjmp) statement
# 2. Negate the last condition
#    We need to test the satisfiability of the following predicate:
#    ~( p1 ^ p2 ^ ... ^ pn -> pn+1 ) 
#  = ~( ~(p1 ^ p2 ^ ... ^ pn) U pn+1 )
#  = (p1 ^ p2 ^ ... ^ pn) ^ ~pn+1

use strict;
use warnings;

my $infile = $ARGV[0];
my $outfile;

my $num = 0;
my ($line, $last);
my ($in, $out);

open $in, "<$infile" or die "Cannot read infile: $!";

while ($line = <$in>) {
    seek $in, 0, 0;
    ($outfile = $infile) =~ s/\.il/\.$num\.il/;
    open $out, ">$outfile" or die "Cannot write outfile: $!";

    # skip the first num predicates
    my $i = 0;
    $last = "";
    while ($i < $num) {
	$line = <$in>;
	if ($line =~ m/Removed: cjmp/ && $last =~ m/^assert/) {
	    ++$i;
	}
	print $out $line;
	$last = $line;
    }

    # negate the next predicate
    $last = "";
    while ($line = <$in>) {
	if ($line =~ m/Removed: cjmp/ && $last =~ m/^assert/) {
	    chomp $last;
	    $last =~ s/^assert /assert ~\(/;
	    $last .= ")\n";
	    print $out $last, "halt true\n";
	    last;
	}
	print $out $last;
	$last = $line;
    }
    ++$num;
    close $out;
}

close $in;
