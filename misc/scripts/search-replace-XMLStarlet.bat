@echo off
setlocal

rem MRB -- Fri 29-Aug-2014

:: Purpose: Batch file to search and replace element values in Playwrights XML files using XMLStarlet

:: Description: Batch file script to call the XMLStarlet command line XML utility to search and
:: replace element values in defined XPaths for all the Playwrights CWRC entry XML files.
:: Certain elements in the Playwrights XML files have a numeric code value, and these numeric
:: code values need to be replaced with their label equivalent.  For example, for the element
:: <GENDER>, replace "2" with "Female", "3" with "Male", etc.  All numeric value substitutions
:: with their label equivalents are performed "in place" in the source XML files by the utility
:: XMLStarlet.  The Playwrights files to be batch processed are put in a directory called "files",
:: and the batch file script "search-replace-XMLStarlet.bat" is placed in the parent directory of
:: the "files" directory.  To run the script, type the following at the command prompt:

::     search-replace-XMLStarlet.bat

rem Note: XMLStarlet must be installed; the XMLStarlet executable is called via the command "xml"

:: loop through the "files" directory
for /r files %%f in (*) do (

:: XPath element value substitutions
rem Gender: 1b1
xml ed -L -u "/CWRC/ENTRY/CULTURALFORMATION/P/SEXUALIDENTITY[GENDER='2']/GENDER" -v "Female" %%f
xml ed -L -u "/CWRC/ENTRY/CULTURALFORMATION/P/SEXUALIDENTITY[GENDER='3']/GENDER" -v "Male" %%f
xml ed -L -u "/CWRC/ENTRY/CULTURALFORMATION/P/SEXUALIDENTITY[GENDER='4']/GENDER" -v "Transgendered Female to Male" %%f
xml ed -L -u "/CWRC/ENTRY/CULTURALFORMATION/P/SEXUALIDENTITY[GENDER='5']/GENDER" -v "Transgendered Male to Female" %%f
rem Sexual orientation: 1b2
xml ed -L -u "/CWRC/ENTRY/CULTURALFORMATION/P[SEXUALIDENTITY='Sexual Identity: 1']/SEXUALIDENTITY" -v "Sexual Identity: Heterosexual" %%f
xml ed -L -u "/CWRC/ENTRY/CULTURALFORMATION/P[SEXUALIDENTITY='Sexual Identity: 2']/SEXUALIDENTITY" -v "Sexual Identity: Homosexual" %%f
xml ed -L -u "/CWRC/ENTRY/CULTURALFORMATION/P[SEXUALIDENTITY='Sexual Identity: 3']/SEXUALIDENTITY" -v "Sexual Identity: Bisexual" %%f
rem Relationship status: 3a
xml ed -L -u "/CWRC/ENTRY/FAMILY/MARRIAGE[P='Relationship Status: 1']/P" -v "Relationship Status: single" %%f
xml ed -L -u "/CWRC/ENTRY/FAMILY/MARRIAGE[P='Relationship Status: 2']/P" -v "Relationship Status: married" %%f
xml ed -L -u "/CWRC/ENTRY/FAMILY/MARRIAGE[P='Relationship Status: 4']/P" -v "Relationship Status: separated" %%f
xml ed -L -u "/CWRC/ENTRY/FAMILY/MARRIAGE[P='Relationship Status: 5']/P" -v "Relationship Status: divorced" %%f
xml ed -L -u "/CWRC/ENTRY/FAMILY/MARRIAGE[P='Relationship Status: 6']/P" -v "Relationship Status: widowed" %%f
xml ed -L -u "/CWRC/ENTRY/FAMILY/MARRIAGE[P='Relationship Status: 7']/P" -v "Relationship Status: common-law partner" %%f
rem Marital relationship: 3a1
xml ed -L -u "/CWRC/ENTRY/FAMILY[P='Marital Relationship: 1']/P" -v "Marital Relationship: Different sex partner" %%f
xml ed -L -u "/CWRC/ENTRY/FAMILY[P='Marital Relationship: 2']/P" -v "Marital Relationship: Same sex partner" %%f
rem Common-law relationship: 3a2
xml ed -L -u "/CWRC/ENTRY/FAMILY[P='Commonlaw Relationship: 1']/P" -v "Commonlaw Relationship: Different sex partner" %%f
xml ed -L -u "/CWRC/ENTRY/FAMILY[P='Commonlaw Relationship: 2']/P" -v "Commonlaw Relationship: Same sex partner" %%f
rem Regional playwright: 2d
:: xml ed -L -u "/CWRC/ENTRY/PRODUCTION/P[PLITERARYMOVEMENTS='Identify as a regional playwright: Y ']/PLITERARYMOVEMENTS" -v "Identify as a regional playwright: Yes" %%f
xml ed -L -u "/CWRC/ENTRY/PRODUCTION/P[starts-with(PLITERARYMOVEMENTS,'Identify as a regional playwright: Y')]/PLITERARYMOVEMENTS" -v "Identify as a regional playwright: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/PRODUCTION[P/PLITERARYMOVEMENTS='Identify as a regional playwright:  ']" %%f

)