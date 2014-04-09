#!/usr/bin/sh

# MRB -- Mon 07-Apr-2014

# Purpose: Bash shell script to geocode place names using NRCan's CGNDB API

# Description: Bash shell script to geocode place name into their associated coordinates of
# latitude and longitude using Natural Resources Canada's (NRCan) Canadian Geographical
# Names Data Data Base (CGNDB) API.  The input file consists of place names for a particular
# province, with each place name appearing on a separate new line.  The resulting output file
# consists of two lines for each record: a header line, that contains the field names for each
# data element; and a data line, that contains the data for each particular field.  To run the
# script, type the following at the command prompt:

#     sh geocode-NRCan.sh

# Useful documentation about the CGNDB API:
# * Application Programming Interface -- API: http://www.nrcan.gc.ca/earth-sciences/geography/place-names/data/9249
# * API parameters: https://www.nrcan.gc.ca/earth-sciences/geography/place-names/data/9251 
# * Search Place Names: http://www4.rncan.gc.ca/search-place-names/name.php

### Begin script
# set input file name
INPUT_FILE='input.csv'
# set output file name
OUTPUT_FILE='output.csv'
# set the MATCH parameter
MATCH='exact'
# set the CONCISE_CODE parameter
CONCISE_CODE='P'
# set the STATUS_CODE parameter; A = current
STATUS_CODE='A'
# set the REGION_CODE parameter (province code); AB = 48, BC = 59, MB = 46, NB = 13, NF = 10,
# NT = 61, NS= 12, NU = 62, ON = 35, PE = 11, QC = 24, SK = 47, YT = 60
REGION_CODE=59
# set the ORDER parameter
ORDER='geoname'
# set the OUTPUT parameter (many output options, including "xml")
OUTPUT='csv'

# count the number of records to be processed and put this total in the TOTAL_RECORDS variable
TOTAL_RECORDS=`wc -l < $INPUT_FILE`
# initialize the RECORD_COUNT variable
RECORD_COUNT=0
# print out an initial batch geocoding statement
echo "### Begin the batch geocoding of" $TOTAL_RECORDS "place name records."

# loop through the INPUT_FILE records
while read PLACE_NAME
do
    # increment the FILE_COUNT number by 1
    RECORD_COUNT=`expr $RECORD_COUNT + 1`
    # print out a record processing statement
    echo "    Processing record number" $RECORD_COUNT "of" $TOTAL_RECORDS "records, the place name" $PLACE_NAME ". . ."
	# set the GEONAME parameter with the next PLACE_NAME value
	GEONAME="$PLACE_NAME"
	# query the CGNDB database, and append the results to the OUTPUT_FILE
	wget -O - "http://www.nrcan.gc.ca/earth-sciences/api?geoname=""$GEONAME""&match="$MATCH"&conciseCode="$CONCISE_CODE"&statusCode="$STATUS_CODE"&regionCode="$REGION_CODE"&order="$ORDER"&output="$OUTPUT >> $OUTPUT_FILE
done < $INPUT_FILE

###
# #Code in this section can be used to process response back from the server, deleting the
# header line, and only returning the data elements of place name, latitude, and longitude.
# However, if the server cannot geocode a particular place name, there will be no indication
# of this if processing is implemented.  To implement processing, change $OUTPUT_FILE at
# end of loop above to tmp1, and uncomment the sed, awk, and rm statements below.#
#
# delete the header line that precedes every data line in the response back from the server
#sed /geoname,status_term/d tmp1 > tmp2

# extract the place name, latitude, and longitude, and write these strings to OUTPUT_FILE
#awk -F',' '{ print $1","$5","$6 }' tmp2 > $OUTPUT_FILE

# delete temporary files
#rm tmp1 tmp2
###

# print out a final batch geocoding statement
echo "### The batch geocoding of" $TOTAL_RECORDS "place name records is now finished."
### End script
