@echo off
setlocal

rem MRB -- Fri 01-Nov-2013

:: Purpose: Batch file to move Orlando entity files

:: Description: Batch file script to move Orlando entity files into their own directory.  A file
:: is first created that contains a list of the Orlando entity file names.  Then the Orlando
:: entity files listed in this file are moved from the "data" directory to the "orlando" directory,
:: a new sibling directory created at the same directory tree level as the "data" directory.  The
:: batch file script is run from the parent directory of the "data" directory.  To run the script,
:: type the following at the command prompt:

::     movefiles.bat

set "_person_organization=<projectId>orlando</projectId>"
set "_title=<recordIdentifier source=\"orlando\">"

cd data
:: set search string variable: %_person_organization%, or %_title%
findstr /m /c:"%_title%" * > ..\filelist.txt
cd ..

mkdir orlando
for /f "delims=" %%i in (filelist.txt) do echo D|move "data\%%i" "orlando\%%i"
del filelist.txt