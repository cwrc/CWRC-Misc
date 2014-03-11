#!/bin/sh

# MRB -- Fri 07-Mar-2014

# Purpose: Shell script to normalize, join, and format and indent Orlando files using xmllint

# Description: Shell script to strip leading and trailing blank spaces (normalize), linearize
# the document into one line, with one space between the joined lines (join), and pretty print
# the document (format and indent).  The formatting and indenting is performed by the utility
# xmllint and library libxml2, written by Daniel Veillard.  The Orlando files to be batch
# processed are put in a directory called "old", and the processed files are written with the
# same name to a directory called "new"; the directory "new" is created before the script is
# run, and it is created at the same level as the directory "old", and the shell script 
# "xmllint.sh" is placed in the parent directory of the "old" and "new" directories.  To run
# the script, type the following at the command prompt:

#     sh xmllint.sh

### Begin script
# count the number of files in the "old" directory and put this total in the TOTAL_FILES variable
TOTAL_FILES=`ls -1 ./old | wc -l`
# initialize the FILE_COUNT variable
FILE_COUNT=0
# print out an initial batch file processing statement
echo "### Begin the batch file processing of $TOTAL_FILES Orlando documents."

# loop through the "old" directory; put the file path name in the PATH_NAME variable
for PATH_NAME in ./old/*; do
    # increment the FILE_COUNT number by 1
    FILE_COUNT=$[$FILE_COUNT+1]
    # get the file name from the PATH_NAME variable, and put the file name in the FILE_NAME variable
    FILE_NAME=`basename $PATH_NAME`
    # print out a file processing statement
    echo "    Processing file number $FILE_COUNT of $TOTAL_FILES files, the file $FILE_NAME . . ."
    # normalize and join the file, and put the file contents in the TMP_VAR variable
    TMP_VAR=`sed 's/^[ \t]*//;s/[ \t]*$//' $PATH_NAME | tr '\n' ' '`
    # format and indent the file using xmllint, and write the file to the "new" directory
    echo "$TMP_VAR" | XMLLINT_INDENT='    ' xmllint --format --encode utf-8 --dropdtd - > ./new/$FILE_NAME
done

# print out a final batch file processing statement
echo "### The batch file processing of $TOTAL_FILES Orlando documents is now finished."
### End script