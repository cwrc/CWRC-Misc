#!/usr/bin/sh

# MRB -- Fri 01-Nov-2013

# Purpose: Shell script to move Orlando entity files

# Description: Shell script to move Orlando entity files into their own directory.  The Orlando
# entity files are first identified using grep, and then the file names as standard output are
# piped as standard input to xargs.  Using the arguments from xargs, the mv command is then used
# to move the Orlando entity files from the "data" directory to the "orlando" directory, a new
# sibling directory created at the same directory tree level as the "data" directory.  The shell
# script is run from the parent directory of the "data" directory.  To run the script,
# type the following at the command prompt:

#     sh movefiles.sh

PERSON_ORGANIZATION='<projectId>orlando</projectId>'
TITLE='<recordIdentifier source="orlando">'

mkdir orlando
# set search string variable: $PERSON_ORGANIZATION, or $TITLE
grep -l "$TITLE" ./data/* | xargs -I{} mv {} ./orlando