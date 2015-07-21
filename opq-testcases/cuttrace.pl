#!/usr/bin/perl

# This script removes the procedures before and after
# a pair of instruction address.
#
# usage: 
# cuttrace.pl [addr|line] beginaddr endaddr trace output

use strict;
use warnings;

my $switch = $ARGV[0];
my $begin = $ARGV[1]; 
my $end = $ARGV[2];
my $tracefile = $ARGV[3];
my $outfile = $ARGV[4];

my ($in, $out);
my $line;

open $in, "<$tracefile" or die "Cannot read infile: $!";
open $out, ">$outfile" or die "Cannot write outfile: $!";

if ($switch eq "addr") {
    for ($line = <$in>; $line !~ m/^addr 0x$begin \@asm/; $line = <$in>) {}
    print $out $line;
    for ($line = <$in>; $line !~ m/^addr 0x$end \@asm/; $line = <$in>) {
	print $out $line;
    }
} elsif ($switch eq "line") {
    for ($line = <$in>; $line_num < $begin; $line = <$in>) { $line_num++; }
    print $line;
    for ($line = <$in>; $line_num <= $end; $line = <$in>) {
	print $line;
	$line_num++;
    }
} else {
    print "usage: rmlibcall.pl [addr|line] beginaddr endaddr trace output\n";
}

close $in;
close $out;
