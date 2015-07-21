#!/usr/bin/perl

# This script scans a trace il file and do some simple replace work.
# 
# 1. remove the assertion in repnz instructions

use strict;
use warnings;

my $line = <STDIN>;

while (defined $line) {
    if ($line =~ m/^addr 0x(\d|[a-f])+ \@asm \"repnz scas/) {
	print $line;
	$line = <STDIN>;
	while (defined $line && $line !~ m/^addr 0x(\d|[a-f])+ \@asm/) {
	    if ($line !~ m/^assert/) { print $line; }
	    $line = <STDIN>;
	}
    } else {
	print $line;
	$line = <STDIN>;
	while (defined $line && $line !~ m/^addr 0x(\d|[a-f])+ \@asm/) {
	    print $line;
	    $line = <STDIN>;
	}
    }
}
