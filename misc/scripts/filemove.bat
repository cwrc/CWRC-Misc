@echo off

:: MRB -- Fri 01-Nov-2013

:: Batch file to move Orlando entity files listed in the file "filelist.txt" from the directory
:: "data" into the sibling directory "orlando".

:: It is assumed the Orlando entities are in a directory called "data", and there is an empty
:: sibling directory at the same directory tree level called "orlando".  The batch file script
:: is to be run from the parent directory of the "data" and "orlando" subdirectories.  To run
:: the script, type the following at the command prompt:

::     filemove.bat

:: Note: run the batch file "filelist.bat" first, and then run this batch file "filemove.bat".

for /f "delims=" %%i in (filelist.txt) do echo D|move "data\%%i" "orlando\%%i"