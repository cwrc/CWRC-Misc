@echo off
setlocal

rem MRB -- Fri 29-Aug-2014

:: Purpose: Batch file to edit nodes in Playwrights XML files using XMLStarlet

:: Description: Batch file script to call the XMLStarlet command line XML utility to search and
:: replace element text node values, and delete nodes, using defined XPaths and conditional text
:: patterns, in the Playwrights CWRC entry XML files.  All file edits are performed "in place" in
:: the source XML files by the utility XMLStarlet.  The Playwrights files to be batch processed
:: are put in a directory called "files", and the batch file script "edit-XMLStarlet.bat" is placed
:: in the parent directory of the "files" directory.  To run the script, type the following at the
:: command prompt:

::     edit-XMLStarlet.bat

rem Note: XMLStarlet must be installed; the XMLStarlet executable is called via the command "xml"

:: loop through the "files" directory
for /r files %%f in (*) do (

:: XML element text node value substitutions
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

:: XML element text node value substitutions, as well as XML node deletions
rem Optional additional play: 13*11; if "Y" then change to "Yes", else delete RESEARCHNOTE and its immediate sibling TEXTSCOPE
xml ed -L -u "/CWRC/ENTRY[RESEARCHNOTE/text()='Optional additional play: Y']/RESEARCHNOTE" -v "Optional additional play: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE[preceding-sibling::RESEARCHNOTE[1]/text()='Optional additional play: ']" %%f
xml ed -L -d "/CWRC/ENTRY[RESEARCHNOTE/text()='Optional additional play: ']" %%f
rem Regional playwright: 2d; if "Y" then change to "Yes", else delete ancestor PRODUCTION (Note: "Y " has a space after it, hence use of starts-with predicate)
xml ed -L -u "/CWRC/ENTRY/PRODUCTION/P[starts-with(PLITERARYMOVEMENTS,'Identify as a regional playwright: Y')]/PLITERARYMOVEMENTS" -v "Identify as a regional playwright: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/PRODUCTION[P/PLITERARYMOVEMENTS='Identify as a regional playwright:  ']" %%f
rem Complete or graduate from the program: 4*1a; if "Y" then change to "Completed", else change to "Incomplete"
xml ed -L -u "/CWRC/ENTRY/EDUCATION/CHRONSTRUCT[CHRONPROSE[descendant::RESEARCHNOTE[contains(.,'Did you complete or graduate from the program')]] and child::CHRONPROSE[contains(.,'Y.')]]/CHRONPROSE" -v "Completed." %%f

)