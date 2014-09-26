@echo off
setlocal

rem MRB -- Fri 29-Aug-2014

:: Purpose: Batch file to edit nodes in Playwrights XML files using XMLStarlet

:: Description: Batch file script to call the XMLStarlet command line XML utility to search and
:: replace text node values, and delete nodes, using defined XPaths and conditional text patterns,
:: in the Playwrights CWRC entry XML files.  All file edits are performed "in place" in the source
:: XML files by the utility XMLStarlet.  The Playwrights files to be batch processed are put in a
:: directory called "files", and the batch file script "edit-XMLStarlet.bat" is placed in the
:: parent directory of the "files" directory.  To run the script, type the following at the
:: command prompt:

::     edit-XMLStarlet.bat

rem Note: XMLStarlet must be installed; the XMLStarlet executable is called via the command "xml"

rem loop through the "files" directory
for /r files %%f in (*) do (

rem XML text node value substitutions
rem Gender: 1b1
xml ed -L -u "/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[1]/SEXUALIDENTITY[1][GENDER[1]='2']/GENDER[1]" -v "Female" %%f
xml ed -L -u "/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[1]/SEXUALIDENTITY[1][GENDER[1]='3']/GENDER[1]" -v "Male" %%f
xml ed -L -u "/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[1]/SEXUALIDENTITY[1][GENDER[1]='4']/GENDER[1]" -v "Transgendered Female to Male" %%f
xml ed -L -u "/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[1]/SEXUALIDENTITY[1][GENDER[1]='5']/GENDER[1]" -v "Transgendered Male to Female" %%f
rem Sexual orientation: 1b2
xml ed -L -u "/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[2][SEXUALIDENTITY='Sexual Identity: 1']/SEXUALIDENTITY[1]" -v "Sexual Identity: Heterosexual" %%f
xml ed -L -u "/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[2][SEXUALIDENTITY='Sexual Identity: 2']/SEXUALIDENTITY[1]" -v "Sexual Identity: Homosexual" %%f
xml ed -L -u "/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[2][SEXUALIDENTITY='Sexual Identity: 3']/SEXUALIDENTITY[1]" -v "Sexual Identity: Bisexual" %%f
rem Relationship status: 3a
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]='Relationship Status: 1']/P[1]" -v "Relationship Status: single" %%f
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]='Relationship Status: 2']/P[1]" -v "Relationship Status: married" %%f
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]='Relationship Status: 4']/P[1]" -v "Relationship Status: separated" %%f
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]='Relationship Status: 5']/P[1]" -v "Relationship Status: divorced" %%f
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]='Relationship Status: 6']/P[1]" -v "Relationship Status: widowed" %%f
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]='Relationship Status: 7']/P[1]" -v "Relationship Status: common-law partner" %%f
rem Marital relationship: 3a1
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1][P[2]='Marital Relationship: 1']/P[2]" -v "Marital Relationship: Different sex partner" %%f
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1][P[2]='Marital Relationship: 2']/P[2]" -v "Marital Relationship: Same sex partner" %%f
rem Common-law relationship: 3a2
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1][P[3]='Commonlaw Relationship: 1']/P[3]" -v "Commonlaw Relationship: Different sex partner" %%f
xml ed -L -u "/CWRC/ENTRY[1]/FAMILY[1][P[3]='Commonlaw Relationship: 2']/P[3]" -v "Commonlaw Relationship: Same sex partner" %%f
rem Religious affiliation: 1b3; if blank (i.e., "") then change to "[None given]"
xml ed -L -u "/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[4][DENOMINATION[1]='']/DENOMINATION[1]" -v "None given" %%f
rem Historical period: 13*3_[*]; if value then remove comma and blank space (i.e., ", ") at end of string
xml ed -L -u "/CWRC/ENTRY[1]/TEXTSCOPE/TEXTUALFEATURES[1][P[2]/text()[2]!='Historical Period: ']/P[2]/text()[2]" -x "substring(.,1,string-length(.)-2)" %%f
rem Genre/Form of play: 13*4_[*]; if value then remove comma and blank space (i.e., ", ") at end of string
xml ed -L -u "/CWRC/ENTRY[1]/TEXTSCOPE/TEXTUALFEATURES[1][P[2]/text()[3]!='Genre/Form of Play: ']/P[2]/text()[3]" -x "substring(.,1,string-length(.)-2)" %%f

rem XML text node value substitutions, as well as XML element and text node deletions
rem Optional additional play: 13*11; if "Y" then change to "Yes", else delete RESEARCHNOTE and its immediate following sibling TEXTSCOPE
xml ed -L -u "/CWRC/ENTRY[RESEARCHNOTE/text()='Optional additional play: Y']/RESEARCHNOTE" -v "Optional additional play: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE[preceding-sibling::RESEARCHNOTE[1]/text()='Optional additional play: ']" %%f
xml ed -L -d "/CWRC/ENTRY/RESEARCHNOTE[self::RESEARCHNOTE/text()='Optional additional play: ']" %%f
rem Regional playwright: 2d; if "Y" then change to "Yes", else delete ancestor PRODUCTION (Note: "Y " has a space after it, hence use of starts-with predicate)
xml ed -L -u "/CWRC/ENTRY/PRODUCTION/P[starts-with(PLITERARYMOVEMENTS,'Identify as a regional playwright: Y')]/PLITERARYMOVEMENTS" -v "Identify as a regional playwright: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/PRODUCTION[P/PLITERARYMOVEMENTS='Identify as a regional playwright:  ']" %%f
rem Complete or graduate from the program: 4*1a; if "Y" then change to "Completed", else change to "Incomplete"
xml ed -L -a "/CWRC/ENTRY/EDUCATION/CHRONSTRUCT[CHRONPROSE[descendant::RESEARCHNOTE[3]/text()[contains(.,'Did you complete or graduate from the program')]] and child::CHRONPROSE/text()[3]='1.']/CHRONPROSE/text()[3]" -t text -n "text()" -v "Completed." %%f
xml ed -L -u "/CWRC/ENTRY/EDUCATION/CHRONSTRUCT[CHRONPROSE/text()[3]='Y.Completed.']/CHRONPROSE" -v "Completed." %%f
xml ed -L -a "/CWRC/ENTRY/EDUCATION/CHRONSTRUCT[CHRONPROSE[descendant::RESEARCHNOTE[3]/text()[contains(.,'Did you complete or graduate from the program')]] and child::CHRONPROSE/text()[3]='.']/CHRONPROSE/text()[3]" -t text -n "text()" -v "Incomplete." %%f
xml ed -L -u "/CWRC/ENTRY/EDUCATION/CHRONSTRUCT[CHRONPROSE/text()[3]='.Incomplete.']/CHRONPROSE" -v "Incomplete." %%f
rem Suitable for young actors: 13*8; if "Y" then change to "Yes", else delete text node and its immediate preceding sibling element node RESEARCHNOTE
xml ed -L -u "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES[P[2]/text()[32]='Does this play include monologues that are suitable for young actors: Y']/P[2]/text()[32]" -v "Does this play include monologues that are suitable for young actors: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[32][parent::P/text()[32]='Does this play include monologues that are suitable for young actors: '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[33][parent::P/text()[32]='Does this play include monologues that are suitable for young actors: ']" %%f
rem Actors who are auditioning: 13*7; if "Y" then change to "Yes", else delete text node and its immediate preceding sibling element node RESEARCHNOTE
xml ed -L -u "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES[P[2]/text()[31]='Does this play include monologues that are suitable for actors who are auditioning: Y']/P[2]/text()[31]" -v "Does this play include monologues that are suitable for actors who are auditioning: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[31][parent::P/text()[31]='Does this play include monologues that are suitable for actors who are auditioning:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[32][parent::P/text()[31]='Does this play include monologues that are suitable for actors who are auditioning:  ']" %%f
rem Does this play have any specific casting requirements: 13*6_*; if no value, then delete text node and its immediate preceding sibling element node RESEARCHNOTE
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[30][parent::P/text()[30]='Requirement:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[31][parent::P/text()[30]='Requirement:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[29][parent::P/text()[29]='Gender:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[30][parent::P/text()[29]='Gender:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[28][parent::P/text()[28]='Age:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[29][parent::P/text()[28]='Age:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[27][parent::P/text()[27]='Requirement:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[28][parent::P/text()[27]='Requirement:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[26][parent::P/text()[26]='Gender:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[27][parent::P/text()[26]='Gender:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[25][parent::P/text()[25]='Age:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[26][parent::P/text()[25]='Age:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[24][parent::P/text()[24]='Requirement:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[25][parent::P/text()[24]='Requirement:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[23][parent::P/text()[23]='Gender:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[24][parent::P/text()[23]='Gender:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[22][parent::P/text()[22]='Age:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[23][parent::P/text()[22]='Age:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[21][parent::P/text()[21]='Requirement:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[22][parent::P/text()[21]='Requirement:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[20][parent::P/text()[20]='Gender:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[21][parent::P/text()[20]='Gender:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[19][parent::P/text()[19]='Age:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[20][parent::P/text()[19]='Age:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[18][parent::P/text()[18]='Requirement:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[19][parent::P/text()[18]='Requirement:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[17][parent::P/text()[17]='Gender:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[18][parent::P/text()[17]='Gender:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[16][parent::P/text()[16]='Age:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[17][parent::P/text()[16]='Age:  ']" %%f
rem Does this play have any specific casting requirements: 13b6, 13*51; if "Y" then change to "Yes", else delete text node and its immediate preceding sibling element node RESEARCHNOTE
xml ed -L -u "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES[P[2]/text()[15]='Does this play have any specific casting requirements: Y']/P[2]/text()[15]" -v "Does this play have any specific casting requirements: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[15][parent::P/text()[15]='Does this play have any specific casting requirements: '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[16][parent::P/text()[15]='Does this play have any specific casting requirements: ']" %%f
rem General description of performers in play: 13*5_[*_SQ00*]; if no value, then delete text node and its immediate preceding sibling element node RESEARCHNOTE
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[14][parent::P/text()[14]='Number of Female Seniors:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[15][parent::P/text()[14]='Number of Female Seniors:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[13][parent::P/text()[13]='Number of Male Seniors:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[14][parent::P/text()[13]='Number of Male Seniors:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[12][parent::P/text()[12]='Number of Female Adults:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[13][parent::P/text()[12]='Number of Female Adults:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[11][parent::P/text()[11]='Number of Male Adults:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[12][parent::P/text()[11]='Number of Male Adults:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[10][parent::P/text()[10]='Number of Female Young Adults:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[11][parent::P/text()[10]='Number of Female Young Adults:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[9][parent::P/text()[9]='Number of Male Young Adults:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[10][parent::P/text()[9]='Number of Male Young Adults:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[8][parent::P/text()[8]='Number of Female Teens:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[9][parent::P/text()[8]='Number of Female Teens:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[7][parent::P/text()[7]='Number of Male Teens:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[8][parent::P/text()[7]='Number of Male Teens:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[6][parent::P/text()[6]='Number of Female Children:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[7][parent::P/text()[6]='Number of Female Children:  ']" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/text()[5][parent::P/text()[5]='Number of Male Children:  '] | /CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[2]/RESEARCHNOTE[6][parent::P/text()[5]='Number of Male Children:  ']" %%f
rem Published in any format: 13*9; if "Y" then change to "Yes", else delete parent PRODUCTION
xml ed -L -u "/CWRC/ENTRY/TEXTSCOPE/PRODUCTION[RESEARCHNOTE[1]/text()='Has the play been published for distribution to the public in any format: Y']/RESEARCHNOTE[1]/text()" -v "Has the play been published for distribution to the public in any format: Yes" %%f
xml ed -L -d "/CWRC/ENTRY/TEXTSCOPE/PRODUCTION[RESEARCHNOTE[1]='Has the play been published for distribution to the public in any format: ']" %%f
rem Previous partner(s): 3c; if no value, then delete P element node and its immediate preceding sibling element node RESEARCHNOTE
xml ed -L -d "/CWRC/ENTRY/FAMILY/RESEARCHNOTE[following-sibling::P/text()='Previous Partner(s): ']" %%f
xml ed -L -d "/CWRC/ENTRY/FAMILY/P[self::P/text()='Previous Partner(s): ']" %%f

)