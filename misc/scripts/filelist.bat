@echo off

:: MRB -- Fri 01-Nov-2013

:: Batch file to create a file "filelist.txt" that contains a list of Orlando entity file names.

:: It is assumed the Orlando entities are in a directory called "data", and there is an empty
:: sibling directory at the same directory tree level called "orlando".  The batch file script
:: is to be run from the parent directory of the "data" and "orlando" subdirectories.  To run
:: the script, type the following at the command prompt:

::     filelist.bat

:: Note: run this batch file "filelist.bat" first, and then run the batch file "filemove.bat".

cd data
findstr /m /c:"<projectId>orlando</projectId>" * > ..\filelist.txt
cd ..