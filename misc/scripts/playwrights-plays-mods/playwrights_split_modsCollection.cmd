@echo off
setlocal

rem MRB -- Thu 07-Jan-2016

:: Purpose: Batch file to split Playwrights MODS collection XML files using Saxon-HE

:: Description: Batch file script to call the Saxon-HE (Saxon Home Edition) JAR file
:: to run the XSLT file "playwrights_split_modsCollection.xsl" on a directory of files;
:: the XSLT file splits each of the Playwrights MODS collection XML files into individual
:: MODS files, and writes each MODS file to a directory called "data".  The Playwrights
:: MODS collection XML files to be processed are put in a directory called "mods", and
:: this batch file script "playwrights_split_modsCollection.cmd", the XSLT file
:: "playwrights_split_modsCollection.xsl", and the Saxon-HE JAR file "saxon9he.jar" are
:: placed in the parent directory of the "mods" directory.  To run the script, type the
:: following at the command prompt:

::     playwrights_split_modsCollection.cmd

:: Notes:
::    * The full directory path to the source MODS collection XML files must not
::      contain any blank spaces.
::    * To produce the source MODS collection XML files, the XProc pipeline file
::      "playwrights_published_plays2mods.xpl" is run, which calls the XSLT file
::      "playwrights_published_plays2mods.xsl" which produces the MODS collection
::      (<modsCollection>) XML files.

rem count the number of files in the "mods" directory and put this total in the total_files variable
cd mods
for /f %%a in ('dir ^| find "File(s)"') do set total_files=%%a
cd ..

rem echo beginning processing statement
echo Processing %total_files% Playwrights MODS collection XML files . . .

rem loop through the "mods" directory
for /r mods %%f in (*) do (

rem echo file processing statement
echo Processing the file %%f . . .

rem run Saxon-HE command
java -jar saxon9he.jar %%f playwrights_split_modsCollection.xsl

)

rem echo ending processing statement
echo Processing of %total_files% Playwrights MODS collection XML files is now finished.
