#!/usr/bin/perl

# MRB -- Fri 11-Oct-2013

# Perl script to loop through a CSV code file and create a key-value pairs
# hash using two fields in each row, and then use these key-value pairs
# to process a copy of a second input CSV file, globally searching and
# replacing the keys with their corresponding values, and then writing out
# this new third CSV output file.  To run the script, type the following
# at the command prompt:

#     perl search-replace.pl

# [This script adapted from a script by Bonnie Dalzell located at this URL:
# http://www.batw.net/perlexamples/Search-Replace-Within-File.shtml]

use strict;
our $a = "a.csv"; # MRB: set CSV code file that contains key-value pairs
our $b = "b.csv"; # MRB: set CSV input file that contains keys that need to be replaced with values
our $new_b = "new_b.csv"; # MRB: set CSV output file, a copy of $b, but with keys replaced with values
open (INDUMP, "<$a")  || die "cannot open $a"; # note: the "<" is included with file name

our %key_value=(); # hash, or associate array %key_value to contain element key-value pairs
our @lines2 = <INDUMP>; # read file into array list @lines2
chomp(@lines2); # remove newline characters from the end of each line
foreach my $item (@lines2) { # loop through array list
  chomp($item); # remove newline characters from the end of each line
  my @data=split(/\t/,$item); # MRB: set field delimiter to split the code file $a, e.g., \t
  print "key: $data[0] - value: $data[1]\n"; ## MRB: writes to the shell so can monitor output (can comment out)
  $key_value{$data[0]} = $data[1]; # MRB: set element key-value pairs for the code file $a; to the left of
                                   # the "=" sign is the key index field, and to the right of the "=" sign
                                   # is the value index field
} # end for each
close INDUMP;

open (INGROUP, "<$b") || die "cannot open $b";
open (DUMP, ">$new_b") || die "cannot open $new_b"; 
                     ## if use ">>" will append to existing file $new_b
                     ## if use ">" will make a new version of the file $new_b
while (<INGROUP>){ 
       my $in_line = $_; # use "my" to keep variables local to while loop
       chomp($in_line); # remove newline characters from the end of each line
       my @inline = split(/\t/,$in_line); # MRB: set field delimiter to split the new output file $new_b, e.g., \t
       $inline[1] = $key_value{$inline[0] . "." . $inline[1]}; # MRB: set index fields for the substitution
	   # of the hash value for the key in the new output file $new_b; to the left of the "=" sign is the
	   # index field in the output file $new_b that will be substituted, and to the right of the "=" sign
	   # is the index field or concatenated index fields string in the output file $new_b that matches the key
       my $line = &join_array(@inline);
       print "$line\n"; ## MRB: writes to the shell so can monitor output (can comment out)
       print DUMP "$line\n";
} # end while
close(INGROUP);
close DUMP;

##### begin subroutine #####
sub join_array {
  my $i=0; # use "my" to keep variables local to subroutine
  my @array = @_;
  my $joinline=$array[0];
  for( $i = 1; $i <= $#array; $i++){
      $joinline ="$joinline" . "\t" . "$array[$i]"; # MRB: set field delimiter to join the new file $new_b, e.g., \t
      $i++;
  }
 return $joinline;
} # end sub

################### End Program ###################