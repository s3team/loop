#!/usr/bin/perl

use strict;
use warnings;

my $c_name = "[A-Za-z_][A-Za-z_0-9]*";
my $low = 0xffffffff;
my $high = 0x0;

while (my $line = <STDIN>) {
    if ($line =~ m/^((\d|[a-f]){8})\s<($c_name)>/) {
	my $saddr = $1;
	my $fun_name = $3;
	if ($fun_name !~ m/^_/ && $fun_name ne "frame_dummy") {
#	    print $fun_name, "\n";
	    $saddr = hex("0x" . $saddr);
#	    printf "%x\n", $saddr;
	    if ($saddr < $low) { $low = $saddr; }

	    my $last;
	    my $eaddr;
	    while (($line = <STDIN>) ne "\n") { $last = $line; }
	    $last =~ m/^\s((\d|[a-f]){7}):/;
	    $eaddr = $1;
	    $eaddr = hex("0x" . $eaddr);
#	    printf "%x\n\n", $eaddr;
	    if ($eaddr > $high) { $high = $eaddr; }
	}
#	print $line;
    }
}

#printf "low:  %x\n", $low;
#printf "high: %x\n", $high;

printf "-trig_addr 0x0%x -trig_enaddr 0x0%x", $low, $high;
