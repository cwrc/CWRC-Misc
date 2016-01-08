#!/bin/sh

# MRB -- Thu 07-Jan-2016

# Purpose: Shell script to split Playwrights MODS collection XML files using Saxon-HE

# Description: Shell script to call the Saxon-HE (Saxon Home Edition) JAR file
# to run the XSLT file "playwrights_split_modsCollection.xsl" on a directory of files;
# the XSLT file splits each of the Playwrights MODS collection XML files into individual
# MODS files, and writes each MODS file to a directory called "data".  The Playwrights
# MODS collection XML files to be processed are put in a directory called "mods", and
# this shell script "playwrights_split_modsCollection.sh", the XSLT file
# "playwrights_split_modsCollection.xsl", and the Saxon-HE JAR file "saxon9he.jar" are
# placed in the parent directory of the "mods" directory.  To run the script, type the
# following at the command prompt:

#     sh playwrights_split_modsCollection.sh

# Notes:
#    * The full directory path to the source MODS collection XML files must not
#      contain any blank spaces.
#    * To produce the source MODS collection XML files, the XProc pipeline file
#      "playwrights_published_plays2mods.xpl" is run, which calls the XSLT file
#      "playwrights_published_plays2mods.xsl" which produces the MODS collection
#      (<modsCollection>) XML files.

# count the number of files in the "mods" directory and put this total in the TOTAL_FILES variable
TOTAL_FILES=`ls -1 ./mods | wc -l`

# echo beginning processing statement
echo 'Processing' $TOTAL_FILES 'Playwrights MODS collection XML files . . .'

# loop through the "mods" directory
for FILE in ./mods/*; do

# echo file processing statement
echo 'Processing the file' $FILE '. . .'

# run Saxon-HE command
java -jar saxon9he.jar $FILE playwrights_split_modsCollection.xsl

done

# echo ending processing statement
echo 'Processing of' $TOTAL_FILES 'Playwrights MODS collection XML files is now finished.'
