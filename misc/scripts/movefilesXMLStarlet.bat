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

rem Note: XMLStarlet must be installed; the XMLStarlet executable is called via the command "xml"

:: absolute XPaths
set "_person=/entity/person/recordInfo/originInfo/projectId[text()='orlando'][1]"
set "_organization=/entity/organization/recordInfo/originInfo/projectId[text()='orlando'][1]"
set "_title=/_:mods/_:recordInfo/_:recordIdentifier[@source='orlando'][1]"
:: relative XPaths
set "_person_organization=//projectId[text()='orlando'][1]"
set "_title_rel=//_:recordIdentifier[@source='orlando'][1]"

cd data
:: set search string variable: %_person%, %_organization%, or %_title%
::     (or %_person_organization%, or %_title_rel%)
xml sel -t -m %_title% -f -n * > ..\filelist.txt
cd ..

mkdir orlando
for /f "delims=" %%i in (filelist.txt) do move "data\%%i" "orlando\%%i"
del filelist.txt