#!/usr/local/bin/perl -I/orlando/www/wwp

##################################################
#
# Module: diffSCCSUnwrap
#
# Description: unwrap the various version of a SCCS archive
# and create 1 file for each version of the given file.
# based on the diffReport.cgi code
#
# find ../data_mirror/ -name austja-\* | xargs diffSCCSUnwrap.pl
# find ../data_mirror/ -regex '.*-[bw]\.sgm' | xargs diffSCCSUnwrap.pl
# find ../data_mirror/ -regex '.*-[bw]\.sgm' | xargs nice -n 19 diffSCCSUnwrap.pl > /video/tmp/z.txt
#
# Context: CWRC Credit Representation Service (Credit Rating)
# https://docs.google.com/a/ualberta.ca/document/d/1a9ffgOkGkJ5GXZbGjpTPpaobQ1cvWw5rV87CayMmKhk/edit#heading=h.qt4wpu2r90iv
#
# Filename: diffSCCSUnwrap.pl
#
# Created: 2013-01-15
#
##################################################

use Orlando::Environment;
use Cwd;
use Getopt::Long;
use File::Basename;

use strict;

my $output_dir = "/video/tmp/cmput401-2013/";

my @filename_list = @ARGV;

# output filenae
my $output_filename = undef;

#don't write in reports directory leaving body parts
my $original_directory = cwd();
chdir ($ENV{ORLANDO_SCCS_ARCHIVE_DIR});

foreach my $filename (@filename_list)
{
    &writeRevisions( basename($filename) );
}

$output_filename = undef;

chdir ($original_directory);

##################################################

# getRevList: Get the list of revision numbers from SCCS
# for the given filename.
# Parameters: filename - the name of the file to access

sub writeRevisions
{
    my $filename = shift;

    if (!$filename)
    {
        print "no file specified\n";
    }
    else
    {
        if (!-f "$ENV{ORLANDO_SCCS_ARCHIVE_DIR}s.$filename")
        {
            print "$filename is not a known file.\n";
            exit;
        }

        # get the revision list from SCCS
        my @rev = &getRevList($filename);

        foreach my $rev (@rev)
        {
            # filename: 12 characters - 8.3 formate (padded with '_' to extend to 12
            # separator: _
            # revision version: 1.xxx
            # separator: _
            # year - 2 digit: YY
            # separator: _
            # month - 2 digit: MM
            # separator: _
            # day - 2 digit: DD
            # separator: _
            # hour - 2 digit: HHT
            # separator: _
            # minute - 2 digit: MMT
            # separator: _
            # second - 2 digit: SST


            $output_filename = sprintf("%s_%s_%s_%s_%s_%s_%s_%s",
                    $filename,
                    $rev->{VERSION},
                    $rev->{YY},
                    $rev->{MM},
                    $rev->{DD},
                    $rev->{HHT},
                    $rev->{MMT},
                    $rev->{SST},
                    );

            print ( "$output_filename\n" );

            my $rv = system("/bin/get -s -r$rev->{VERSION} $ENV{ORLANDO_SCCS_ARCHIVE_DIR}s.$filename  && mv $filename $output_dir/$output_filename");

            die $! if $rv;

            $output_filename = undef;
        }


    }
}


##################################################

# getRevList: Get the list of revision numbers from SCCS
# for the given filename.
# Parameters: filename - the name of the file to access

sub getRevList
{
    my $filename = shift;

    my @rv;

    my $res = `/bin/get -lp $ENV{ORLANDO_SCCS_ARCHIVE_DIR}s.$filename`;

    while($res =~ /(\d+\.\d+)\s+(\d{2})\/(\d{2})\/(\d{2})\s+(\d{2}):(\d{2}):(\d{2})\s+(\w+)/g)
    {
    push @rv, {
            VERSION => $1,
            YY => $2,
            MM => $3,
            DD => $4,
            HHT => $5,
            MMT => $6,
            SST => $7,
            USER => $8
            };
    }

    return @rv;
}

