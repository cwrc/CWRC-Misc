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
xml ed -L -d "/CWRC/ENTRY/RESEARCHNOTE[self::RESEARCHNOTE/text()='Optional additional play: ']" %%f
rem Regional playwright: 2d; if "Y" then change to "Yes", else delete ancestor PRODUCTION (Note: "Y " has a space after it, hence use of starts-with predicate)
xml ed -L -u "/CWRC/ENTRY/PRODUCTION/P[starts-with(PLITERARYMOVEMENTS,'Identify as a regional playwright: Y')]/PLITERARYMOVEMENTS" -v "Identify as a regional playwright: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/PRODUCTION[P/PLITERARYMOVEMENTS='Identify as a regional playwright:  ']" %%f
rem Complete or graduate from the program: 4*1a; if "Y" then change to "Completed", else change to "Incomplete"
xml ed -L -a "/CWRC/ENTRY/EDUCATION/CHRONSTRUCT[CHRONPROSE[descendant::RESEARCHNOTE[3]/text()[contains(.,'Did you complete or graduate from the program')]] and child::CHRONPROSE/text()[3]='Y.']/CHRONPROSE/text()[3]" -t text -n "text()" -v "Completed." %%f
xml ed -L -u "/CWRC/ENTRY/EDUCATION/CHRONSTRUCT[CHRONPROSE/text()[3]='Y.Completed.']/CHRONPROSE" -v "Completed." %%f
xml ed -L -a "/CWRC/ENTRY/EDUCATION/CHRONSTRUCT[CHRONPROSE[descendant::RESEARCHNOTE[3]/text()[contains(.,'Did you complete or graduate from the program')]] and child::CHRONPROSE/text()[3]='.']/CHRONPROSE/text()[3]" -t text -n "text()" -v "Incomplete." %%f
xml ed -L -u "/CWRC/ENTRY/EDUCATION/CHRONSTRUCT[CHRONPROSE/text()[3]='.Incomplete.']/CHRONPROSE" -v "Incomplete." %%f
rem Does this play have any specific casting requirements: 13b6, 13bb6_*, 13*51, 13*6_*
rem xml ed -L -a "/CWRC/ENTRY/TEXTSCOPE[1]/TEXTUALFEATURES[P[2]/text()[15][contains(.,'Does this play have any specific casting requirements: ')]]/P[2]/text()[15]" -t text -n "text()" -v "MRB" %%f
rem /CWRC/ENTRY[1]/TEXTSCOPE[1]/TEXTUALFEATURES[1]/P[2]/RESEARCHNOTE[16]
rem xml ed -L -u "/CWRC/ENTRY/TEXTSCOPE[1]/TEXTUALFEATURES[P[2]/text()[15][contains(.,'Does this play have any specific casting requirements: ')]]/P[2]/text()[15]" -v "MRB" %%f
xml ed -L -u "/CWRC/ENTRY/TEXTSCOPE[1]/TEXTUALFEATURES[P[2]/text()[15]='Does this play have any specific casting requirements: Y']/P[2]/text()[15]" -v "Does this play have any specific casting requirements: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE[1]/TEXTUALFEATURES/P[2]/RESEARCHNOTE[17][parent::P/text()[15]='Does this play have any specific casting requirements: ']" %%f
rem xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE[1]/TEXTUALFEATURES/P[2]/text()[16][preceding-sibling::text()[15]='Does this play have any specific casting requirements: ']" %%f


rem /*/bar[position() >= 100 and not(position() > 200)]
rem //foo/bar[100 <= position() and position() < 200]

rem Age, Gender

rem Actors who are auditioning
rem Young actors
rem Published in amy format
rem Previous partner; remove if empty (full paragraph P); also remove preceding sibling research note
rem Religious affiliation; if empty, insert "None given"
rem Historical period: remove period at end of list of items
rem Genre: remove period at end of list of items
)