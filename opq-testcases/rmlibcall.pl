#!/usr/bin/perl

# This script removes all library calls from a trace.
# We view all the functions in the .plt section as
# library calls.
#
# usage: 
# rmlibcall.pl trace objdumpfile lowaddr highaddr output

use strict;
use warnings;

my $tracefile = $ARGV[0];
my $odfile = $ARGV[1]; # objdump file
my $outfile = $ARGV[4];

# read plt section address range from the commandline
my $low = $ARGV[2];
my $high = $ARGV[3];
#my $low = 0x80493e0;
#my $high = 0x8049aab;

my ($intrace, $inod, $out);
my $line;

open $intrace, "<$tracefile" or die "Cannot read infile: $!";
open $inod, "<$odfile" or die "Cannot read infile: $!";
open $out, ">$outfile" or die "Cannot write outfile: $!";

while ($line = <$intrace>) {
    if ($line =~ m/^addr 0x((\d|[a-f])+) \@asm \"call\s+0x((\d|[a-f])+)\"/) {
	my $instaddr = $1;
	my $jmpaddr = $3;
	if (hex($jmpaddr) >= hex($low) && hex($jmpaddr) <= hex($high)) {
	    print $instaddr, "\t", $jmpaddr, "\n";
	    my $nextAddr = getNextIntrAddr($instaddr);
	    print getNextIntrAddr($instaddr), "\n";
	    $line = <$intrace>;
	    while ($line !~ m/^addr 0x$nextAddr \@asm /) {
		$line = <$intrace>;
	    }
	    print $out $line;
	} else {
	    print $out $line;
	}
    } else {
	print $out $line;
    }
}

close $intrace;
close $inod;
close $out;

sub getNextIntrAddr {
    my @arglist = @_;
    my $curAddr = $arglist[0];
    my $nextAddr;
    seek $inod, 0, 0;

    while (my $line = <$inod>) {
	if ($line =~ m/^\s$curAddr:/) {
	    $line = <$inod>;
	    while ($line =~ m/nop$/) { $line = <$inod>; } # skip nop instructions
	    $line =~ m/^\s((\d|[a-f])+):/;
	    $nextAddr = $1;
	    return $nextAddr;
	}
    }
    return 1;
}

