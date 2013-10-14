#!/usr/bin/perl

# MRB -- Fri 11-Oct-2013

# Perl script to loop through a CSV code file and create a key-value pairs
# hash using two fields in each row, and then use these key-value pairs
# to process a copy of a second input CSV file, globally searching and
# replacing the keys with their corresponding values, and then writing out
# this new third CSV output file.  To run the script, type the following
# at the command prompt:

#     perl search-replace.pl

# [This script adapted from a script located at this URL:
# http://www.batw.net/perlexamples/Search-Replace-Within-File.shtml]

# MRB: Note: to process the GeoNames data, this script needs to be run six
# times, to process the six different GeoNames variable code files: (1) admin2Code,
# (2) admin1Code, (3) countryCode, (4) featureCode, (5) featureClass, and 
# (6) timezone

use strict;
use utf8;
# open pragma approach to UTF-8 (use)
use open ":encoding(utf8)";
# use open IN => ":encoding(utf8)", OUT => ":utf8";
# binmode approach to UTF-8 (binmode)
binmode(STDOUT, ":utf8");
# binmode(STDIN, ":encoding(utf8)");

# MRB: GeoNames: names for code, input, and output files
# (1) admin2Code: $a: admin2Codes.txt; $b: places.txt; $new_b: places1.txt
# (2) admin1Code: $a: admin1CodesASCII.txt; $b: places1.txt; $new_b: places2.txt
# (3) countryCode: $a: countryInfo.txt; $b: places2.txt; $new_b: places3.txt
# (4) featureCode: $a: featureCodes_en.txt; $b: places3.txt; $new_b: places4.txt
# (5) featureClass: $a: featureClasses.txt; $b: places4.txt; $new_b: places5.txt
# (6) timezone: $a: timeZones.txt; $b: places5.txt; $new_b: places6.txt

our $a = "a.txt"; # MRB: set CSV code file that contains key-value pairs
our $b = "b.txt"; # MRB: set CSV input file that contains keys that need to be replaced with values
our $new_b = "new_b.txt"; # MRB: set CSV output file, a copy of $b, but with keys replaced with values
open (INDUMP, "<$a")  || die "cannot open $a"; # note: the "<" is included with file name

our %key_value=(); # hash, or associate array %key_value to contain element key-value pairs
our @lines2 = <INDUMP>; # read file into array list @lines2
chomp(@lines2); # remove newline characters from the end of each line
foreach my $item (@lines2) { # loop through array list
  chomp($item); # remove newline characters from the end of each line
  my @data=split("\t",$item); # MRB: set field delimiter to split the code file $a, e.g., "\t"
  # print "key: $data[0] - value: $data[1]\n"; ## MRB: writes to the shell so can monitor output (can comment out)
  
  # MRB: GeoNames: array index numbers for keys and values
  # (1) admin2Code: key: 0; value: 1
  # (2) admin1Code: key: 0; value: 1
  # (3) countryCode: key: 0; value: 4
  # (4) featureCode: key: 0; value: 1
  # (5) featureClass: key: 0; value: 1
  # (6) timezone: key: 1; value: 2
  
  # MRB: set element key-value pairs for the code file $a; to the left of
  # the assignment operator is the key index field, and to the right of the
  # assignment operator is the value index field
  
  $key_value{$data[0]} = $data[1]; 
  
} # end for each
close INDUMP;

open (INGROUP, "<$b") || die "cannot open $b";
open (DUMP, ">$new_b") || die "cannot open $new_b"; 
                     ## if use ">>" will append to existing file $new_b
                     ## if use ">" will make a new version of the file $new_b
while (<INGROUP>){ 
       my $in_line = $_; # use "my" to keep variables local to while loop
       chomp($in_line); # remove newline characters from the end of each line
       my @inline = split("\t",$in_line); # MRB: set field delimiter to split the new output file $new_b, e.g., "\t"
	   
	   # MRB: GeoNames: array index numbers for substituting the value and matching the key
       # (1) admin2Code: sub value: 11; match key: 11 . 10 . 8 [three fields concatenated]
       # (2) admin1Code: sub value: 10; match key: 10 . 8 [two fields concatenated]
       # (3) countryCode: sub value: 8; match key: 8
       # (4) featureCode: sub value: 7; match key: 7 . 6 [two fields concatenated]
       # (5) featureClass: sub value: 6; match key: 6
       # (6) timezone: sub value: 17; match key: 17 
	   
	   # MRB: set index fields for the substitution of the hash value for the key or
	   # the partial key in the new output file $new_b; to the left of the assignment
	   # operator is the index field in the output file $new_b that will be
	   # substituted with the hash value, and to the right of the assignment operator
	   # is the index field string or concatenated index fields string in the output
	   # file $new_b that matches the key; use the appropriate one field, two fields,
	   # or three fields line below, and comment the other two lines out
	   
       $inline[1] = $key_value{$inline[1]}; # one field matches key
	   # $inline[10] = $key_value{$inline[10] . "." $inline[8]}; # two fields concatenated match key
	   # $inline[11] = $key_value{$inline[11] . "." $inline[10] . "." . $inline[8]}; # three fields concatenated match key
	   
       my $line = &join_array(@inline);
       # print "$line\n"; ## MRB: writes to the shell so can monitor output (can comment out)
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
      $joinline ="$joinline" . "\t" . "$array[$i]"; # MRB: set field delimiter to join the new output file $new_b, e.g., "\t"
  }
 return $joinline;
} # end sub

################### End Program ###################