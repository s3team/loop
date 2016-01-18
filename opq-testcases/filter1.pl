#!/usr/bin/perl

use strict;
use warnings;

my $num = 0;
my $hexnum = sprintf("%x", $num);

while (my $line = <STDIN>) {
    $line =~ s/\@taint_intro \d+, \"stdin\", \d+//;
    $line =~ s/^label pc_0x((\d|[a-f])+)//;
    if ($line =~ m/^addr 0x((\d|[a-f])+) \@asm/) {
	$line =~ s/^addr 0x((\d|[a-f])+) \@asm/addr 0x$hexnum \@asm/;
	++$num;
	$hexnum = sprintf("%x", $num);
    }
    print $line;
}
