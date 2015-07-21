#!/usr/bin/perl

# This script print information about function calls
# in a trace file.
#
# usage: 
# getcallinfo.pl trace

use strict;
use warnings;

my $tracefile = $ARGV[0];
my $odfile = $ARGV[1];
my $c_name = "[A-Za-z_][A-Za-z_0-9]*";
my ($in, $inod);
my $line;
my $counter = 0;
my $fun_num = 0;
my @callstack;
my $line_num = 0;

my @print_buf; # used to save the functions info

open $in, "<$tracefile" or die "Cannot read infile: $!";
open $inod,"<$odfile" or die "Cannot read infile: $!";

while ($line = <$in>) {
    $line_num++;
    if ($line =~ m/^addr 0x((\d|[a-f])+) \@asm \"call\s+0x((\d|[a-f])+)\"/) {
	my $instaddr = $1;
	my $jmpaddr = $3;
#	printspace();
#	print "$counter", " ", $instaddr, " ", getfuninfo($instaddr), "\n";
	
	push @print_buf, { printinfo => " " x $counter . "$counter" . " " . "$line_num" . " " . $instaddr . " " . getfuninfo($instaddr) . " ",
			   loc       => $line_num,
	};
	push @callstack, $fun_num;
	$fun_num++;
	$counter++;
    } elsif ($line =~ m/^addr 0x((\d|[a-f])+) \@asm \"call\s+(.+)\" \@tid/) {
	my $instaddr = $1;
	my $regname = $3;
	push @print_buf, { printinfo => " " x $counter . "$counter" . " " . "$line_num" . " " . $instaddr . " " . $regname . " ",
			   loc       => $line_num,
	};
	push @callstack, $fun_num;
	$fun_num++;
	$counter++;	
    } elsif ($line =~ m/^addr 0x((\d|[a-f])+) \@asm \"ret\s+\"/) {
	$counter--;
	my $size = @callstack;
	if ($size > 0) {
	    my $curfun = pop @callstack;
	    $print_buf[$curfun]{printinfo} .= "$line_num ";
	    $print_buf[$curfun]{printinfo} .= $line_num - $print_buf[$curfun]{loc};
	}
#	print $line_num - $print_buf[$curfun]{loc}, "\n";
#	printspace();
#	print $line;
    }
}

foreach my $item (@print_buf) {
    print $item->{printinfo} . "\n";
}

close $in;
close $inod;

sub printspace {
    for (my $n = 0; $n < $counter; $n++) {
	print " ";
    }
}

sub getfuninfo {
    my @arglist = @_;
    my $curAddr = $arglist[0];
    my $line;
    seek $inod, 0, 0;

    for ($line = <$inod>; $line !~ m/^\s$curAddr:/; $line = <$inod>) {}
    $line =~ m/call\s+((\d|[a-f])+)\s<(.+)>/;
    my $name = $3;
#    print $line, "\n";
    return $name;
}
