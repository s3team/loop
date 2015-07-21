#!/usr/bin/perl

use strict;
use warnings;
use Set::Scalar;

my $addr_list = Set::Scalar->new;
my $fun_name = Set::Scalar->new;
my $c_name = "[A-Za-z_][A-Za-z_0-9]*";
my $line;

while ($line = <STDIN>) {
    if ($line =~ m/^addr 0x((\d|[a-f]){7}) \@asm/) {
	$addr_list->insert($1);
    }
}

print $addr_list, "\n";

my $infile = $ARGV[0];
my $in;

open $in, "<$infile" or die "Cannot read infile: $!";

while (defined(my $e = $addr_list->each)) {
    seek $in, 0, 0;
    while ($line = <$in>) {
	if ($line =~ m/(\d|[a-f]){8} <($c_name)>/) {
	    my $name = $2;
	    while ($line = <$in>) {
		if ($line =~ m/^ $e:/) { $fun_name->insert($name); last; }
		elsif ($line eq "\n") { last; }
	    }
	}
    }
}

print $fun_name, "\n";
