#!/usr/bin/perl -w

# MRB -- Sun 06-Apr-2014

# Purpose: Perl script to geocode place names using the gecoder.ca API

# Description: Perl script to geocode place name into their associated coordinates of
# latitude and longitude using the geocoder.ca API.  The input file consists of a CSV
# text file with two fields, place name and 2-letter province/territory code, separated
# by a comma, e.g., "Edmonton, AB", with each line in the text file containing these two
# data elements.  The resulting output file contains four comma-separated fields: place
# name, 2-letter province/territory code, latitude, and longitude.  To run the script,
# type the following at the command prompt:

#     perl geocode-geocoder.ca.pl input.csv > output.csv

# [This script adapted from a script located at this URL:
# http://geocoder.ca/?premium_api=1]

use strict;
use warnings;

my $file = $ARGV[0] or die "Need to set input CSV file on the command line\n";
 
my $city = "";
my $province = "";

open(my $data, '<', $file) or die "Could not open '$file' $!\n";
 
while (my $line = <$data>) {
    chomp $line;

    my @fields = split "," , $line;
    $city = $fields[0];
	$province = $fields[1];

    my %data;
    my $url = "http://geocoder.ca" . "/?" . "&city=" . $city . "&prov=" . $province . "&geoit=XML";
    use LWP::UserAgent;
    my $ua = new LWP::UserAgent;
    $ua->agent("ruci/0.1 " . $ua->agent);
    my $req = new HTTP::Request('GET', $url);
    $req->header(Subject => 'XML Get',
             From    => 'nospam@nospam.ca',
             timeout => '3*10');
    my $res = $ua->request($req);
    if ($res->is_success) {
        my $result = $res->content;
        if ($result =~ /<latt>(.*)<\/latt>/) {
            $data{latt} = $1;
        }
        if ($result =~ /<longt>(.*)<\/longt>/) {
            $data{longt} = $1;
        }
    }
	else {
        print "Error -- server message: " . $res->code . $res->message . "\n\n";
    }

    # print out place name, 2-letter province/territory code, latitude, and longitude
    print "\"" . $city . "\"" . "," . $province . "," . $data{latt} . "," . $data{longt} . "\n";
}