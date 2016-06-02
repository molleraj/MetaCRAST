#!/usr/bin/perl --

use strict;
use warnings;
my $usage = "getDRquery.pl DR_database_path query output_file";

my $DR_database_path = $ARGV[0] or die $usage;
my $query = $ARGV[1] or die $usage;
my $output_file = $ARGV[2] or die $usage;

print `grep --no-group-separator -E -A1 '$query' $DR_database_path > $output_file`; 
#print $query."\n";
#print $output_file."\n"; 
