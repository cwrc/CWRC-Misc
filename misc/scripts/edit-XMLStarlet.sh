#!/bin/sh

# MRB -- Fri 29-Aug-2014

# Purpose: Shell script to edit nodes in Playwrights XML files using XMLStarlet

# Description: Shell script to call the XMLStarlet command line XML utility to search and
# replace text node values, and delete nodes, using defined XPaths and conditional text patterns,
# in the Playwrights CWRC entry XML files.  All file edits are performed 'in place' in the source
# XML files by the utility XMLStarlet.  The Playwrights files to be batch processed are put in a
# directory called 'files', and the shell file script 'edit-XMLStarlet.sh' is placed in the
# parent directory of the 'files' directory.  To run the script, type the following at the
# command prompt:

#     sh edit-XMLStarlet.sh

# Note: XMLStarlet must be installed; the XMLStarlet binary is called via the command 'xml'

# count the number of files in the "files" directory and put this total in the TOTAL_FILES variable
TOTAL_FILES=`ls -1 ./files | wc -l`

# echo beginning processing statement
echo 'Processing' $TOTAL_FILES 'Playwrights CWRC entry XML files . . .'

# loop through the 'files' directory
for FILE in ./files/*; do

# echo file processing statement
echo 'Processing the file' $FILE '. . .'

# **XML text node value substitutions**
# Gender: 1b1; change numeric values to the appropriate label equivalents
xml ed -L -u '/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[1]/SEXUALIDENTITY[1][GENDER[1]="2"]/GENDER[1]' -v 'Female' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[1]/SEXUALIDENTITY[1][GENDER[1]="3"]/GENDER[1]' -v 'Male' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[1]/SEXUALIDENTITY[1][GENDER[1]="4"]/GENDER[1]' -v 'Transgendered Female to Male' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[1]/SEXUALIDENTITY[1][GENDER[1]="5"]/GENDER[1]' -v 'Transgendered Male to Female' $FILE
# Sexual orientation: 1b2; change numeric values to the appropriate label equivalents
xml ed -L -u '/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[2][SEXUALIDENTITY="Sexual Identity: 1"]/SEXUALIDENTITY[1]' -v 'Sexual Identity: Heterosexual' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[2][SEXUALIDENTITY="Sexual Identity: 2"]/SEXUALIDENTITY[1]' -v 'Sexual Identity: Homosexual' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[2][SEXUALIDENTITY="Sexual Identity: 3"]/SEXUALIDENTITY[1]' -v 'Sexual Identity: Bisexual' $FILE
# Relationship status: 3a; change numeric values to the appropriate label equivalents
xml ed -L -u '/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]="Relationship Status: 1"]/P[1]' -v 'Relationship Status: single' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]="Relationship Status: 2"]/P[1]' -v 'Relationship Status: married' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]="Relationship Status: 4"]/P[1]' -v 'Relationship Status: separated' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]="Relationship Status: 5"]/P[1]' -v 'Relationship Status: divorced' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]="Relationship Status: 6"]/P[1]' -v 'Relationship Status: widowed' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/FAMILY[1]/MARRIAGE[1][P[1]="Relationship Status: 7"]/P[1]' -v 'Relationship Status: common-law partner' $FILE
# Regional playwright: 2d; if 'Y' then change to 'Yes', and if 'N' then change to 'No'
xml ed -L -u '/CWRC/ENTRY[1]/PRODUCTION[1]/P[1][starts-with(PLITERARYMOVEMENTS[1],"Identify as a regional playwright: Y ")]/PLITERARYMOVEMENTS[1]' -v 'Identify as a regional playwright: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/PRODUCTION[1]/P[1][starts-with(PLITERARYMOVEMENTS[1],"Identify as a regional playwright: N ")]/PLITERARYMOVEMENTS[1]' -v 'Identify as a regional playwright: No' $FILE
# Religious affiliation: 1b3; if blank (i.e., '') then change to 'None given'
xml ed -L -u '/CWRC/ENTRY[1]/CULTURALFORMATION[1]/P[4][DENOMINATION[1]=""]/DENOMINATION[1]' -v 'None given' $FILE
# Complete or graduate from the program: 4*1a, 9*2; if 'Y.' then change to 'Completed.', and if 'N.' then change to 'Incomplete.'
xml ed -L -u '/CWRC/ENTRY[1]/EDUCATION[1]/CHRONSTRUCT[CHRONPROSE[1]/text()[3]="Y."]/CHRONPROSE[1]/text()[3]' -v 'Completed.' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/EDUCATION[1]/CHRONSTRUCT[CHRONPROSE[1]/text()[3]="N."]/CHRONPROSE[1]/text()[3]' -v 'Incomplete.' $FILE
# Optional additional program: 4*1b; if 'Y' then change to 'Yes', and if 'N' then change to 'No'
xml ed -L -u '/CWRC/ENTRY[1]/EDUCATION[1]/CHRONSTRUCT/CHRONPROSE[1][RESEARCHNOTE[5]="Optional additional program: Y"]/RESEARCHNOTE[5]' -v 'Optional additional program: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/EDUCATION[1]/CHRONSTRUCT/CHRONPROSE[1][RESEARCHNOTE[5]="Optional additional program: N"]/RESEARCHNOTE[5]' -v 'Optional additional program: No' $FILE
# Optional additional playwriting award(s); 5b; if 'Y' then change to 'Yes', and if 'N' then change to 'No'
xml ed -L -u '/CWRC/ENTRY[1]/RECEPTION[3][RESEARCHNOTE[2]="Optional additional playwriting award(s): Y"]/RESEARCHNOTE[2]' -v 'Optional additional playwriting award(s): Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/RECEPTION[3][RESEARCHNOTE[2]="Optional additional playwriting award(s): N"]/RESEARCHNOTE[2]' -v 'Optional additional playwriting award(s): No' $FILE
# Optional additional award(s): 8a6, 8a7, 11f, 11k; if 'Y' then change to 'Yes', and if 'N' then change to 'No'
xml ed -L -u '/CWRC/ENTRY[1]/OTHERLIFEEVENT[2]/CHRONSTRUCT[10]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional award(s): Y"]/RESEARCHNOTE[2]' -v 'Optional additional award(s): Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OTHERLIFEEVENT[2]/CHRONSTRUCT[10]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional award(s): N"]/RESEARCHNOTE[2]' -v 'Optional additional award(s): No' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OTHERLIFEEVENT[2]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional award(s): Y"]/RESEARCHNOTE[2]' -v 'Optional additional award(s): Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OTHERLIFEEVENT[2]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional award(s): N"]/RESEARCHNOTE[2]' -v 'Optional additional award(s): No' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/RECEPTION[2]/CHRONSTRUCT[10]/CHRONPROSE[1][RESEARCHNOTE[3]="Optional additional award(s): Y"]/RESEARCHNOTE[3]' -v 'Optional additional award(s): Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/RECEPTION[2]/CHRONSTRUCT[10]/CHRONPROSE[1][RESEARCHNOTE[3]="Optional additional award(s): N"]/RESEARCHNOTE[3]' -v 'Optional additional award(s): No' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/RECEPTION[2]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[3]="Optional additional award(s): Y"]/RESEARCHNOTE[3]' -v 'Optional additional award(s): Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/RECEPTION[2]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[3]="Optional additional award(s): N"]/RESEARCHNOTE[3]' -v 'Optional additional award(s): No' $FILE
# Optional additional career highlight: 6f, 6k, 7f, 7l, 10f, 10k; if 'Y' then change to 'Yes', and if 'N' then change to 'No'
xml ed -L -u '/CWRC/ENTRY[1]/OTHERLIFEEVENT[1]/CHRONSTRUCT[10]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional career highlight: Y"]/RESEARCHNOTE[2]' -v 'Optional additional career highlight: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OTHERLIFEEVENT[1]/CHRONSTRUCT[10]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional career highlight: N"]/RESEARCHNOTE[2]' -v 'Optional additional career highlight: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OTHERLIFEEVENT[1]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional career highlight: Y"]/RESEARCHNOTE[2]' -v 'Optional additional career highlight: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OTHERLIFEEVENT[1]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional career highlight: N"]/RESEARCHNOTE[2]' -v 'Optional additional career highlight: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OCCUPATION[3]/CHRONSTRUCT[10][RESEARCHNOTE[1]="Optional additional career highlight: Y"]/RESEARCHNOTE[1]' -v 'Optional additional career highlight: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OCCUPATION[3]/CHRONSTRUCT[10][RESEARCHNOTE[1]="Optional additional career highlight: N"]/RESEARCHNOTE[1]' -v 'Optional additional career highlight: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OCCUPATION[3]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional career highlight: Y"]/RESEARCHNOTE[2]' -v 'Optional additional career highlight: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OCCUPATION[3]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[2]="Optional additional career highlight: N"]/RESEARCHNOTE[2]' -v 'Optional additional career highlight: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OCCUPATION[2]/CHRONSTRUCT[10]/CHRONPROSE[1][RESEARCHNOTE[4]="Optional additional career highlight: Y"]/RESEARCHNOTE[4]' -v 'Optional additional career highlight: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OCCUPATION[2]/CHRONSTRUCT[10]/CHRONPROSE[1][RESEARCHNOTE[4]="Optional additional career highlight: N"]/RESEARCHNOTE[4]' -v 'Optional additional career highlight: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OCCUPATION[2]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[4]="Optional additional career highlight: Y"]/RESEARCHNOTE[4]' -v 'Optional additional career highlight: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/OCCUPATION[2]/CHRONSTRUCT[5]/CHRONPROSE[1][RESEARCHNOTE[4]="Optional additional career highlight: N"]/RESEARCHNOTE[4]' -v 'Optional additional career highlight: No' $FILE
# Optional additional first production: 14*3; if 'Y' then change to 'Yes', and if 'N' then change to 'No'
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[32]="Optional additional first production: Y"]/RESEARCHNOTE[32]' -v 'Optional additional first production: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[32]="Optional additional first production: N"]/RESEARCHNOTE[32]' -v 'Optional additional first production: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[31]="Optional additional first production: Y"]/RESEARCHNOTE[31]' -v 'Optional additional first production: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[31]="Optional additional first production: N"]/RESEARCHNOTE[31]' -v 'Optional additional first production: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[30]="Optional additional first production: Y"]/RESEARCHNOTE[30]' -v 'Optional additional first production: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[30]="Optional additional first production: N"]/RESEARCHNOTE[30]' -v 'Optional additional first production: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[29]="Optional additional first production: Y"]/RESEARCHNOTE[29]' -v 'Optional additional first production: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[29]="Optional additional first production: N"]/RESEARCHNOTE[29]' -v 'Optional additional first production: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[28]="Optional additional first production: Y"]/RESEARCHNOTE[28]' -v 'Optional additional first production: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[28]="Optional additional first production: N"]/RESEARCHNOTE[28]' -v 'Optional additional first production: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[27]="Optional additional first production: Y"]/RESEARCHNOTE[27]' -v 'Optional additional first production: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[27]="Optional additional first production: N"]/RESEARCHNOTE[27]' -v 'Optional additional first production: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[26]="Optional additional first production: Y"]/RESEARCHNOTE[26]' -v 'Optional additional first production: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[26]="Optional additional first production: N"]/RESEARCHNOTE[26]' -v 'Optional additional first production: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[25]="Optional additional first production: Y"]/RESEARCHNOTE[25]' -v 'Optional additional first production: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[25]="Optional additional first production: N"]/RESEARCHNOTE[25]' -v 'Optional additional first production: No' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[24]="Optional additional first production: Y"]/RESEARCHNOTE[24]' -v 'Optional additional first production: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[24]="Optional additional first production: N"]/RESEARCHNOTE[24]' -v 'Optional additional first production: No' $FILE
# Optional additional play: 5d; if 'Y' then change to 'Yes', and if 'N' then change to 'No'
xml ed -L -u '/CWRC/ENTRY[1]/RECEPTION[3][RESEARCHNOTE[4]="Optional additional play: Y"]/RESEARCHNOTE[4]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1]/RECEPTION[3][RESEARCHNOTE[4]="Optional additional play: N"]/RESEARCHNOTE[4]' -v 'Optional additional play: No' $FILE

# **XML text node value substitutions, as well as XML element and text node deletions**
# Suitable for young actors: 13*8; if 'Y' then change to 'Yes', if 'N' then change to 'No', else delete P
xml ed -L -u '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES[P[33]/text()[1]="Does this play include monologues that are suitable for young actors: Y"]/P[33]/text()[1]' -v 'Does this play include monologues that are suitable for young actors: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES[P[33]/text()[1]="Does this play include monologues that are suitable for young actors: N"]/P[33]/text()[1]' -v 'Does this play include monologues that are suitable for young actors: No' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[33][self::P/text()[1]="Does this play include monologues that are suitable for young actors: "]' $FILE
# Actors who are auditioning: 13*7; if 'Y' then change to 'Yes', if 'N' then change to 'No', else delete P
xml ed -L -u '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES[P[32]/text()[1]="Does this play include monologues that are suitable for actors who are auditioning: Y "]/P[32]/text()[1]' -v 'Does this play include monologues that are suitable for actors who are auditioning: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES[P[32]/text()[1]="Does this play include monologues that are suitable for actors who are auditioning: N "]/P[32]/text()[1]' -v 'Does this play include monologues that are suitable for actors who are auditioning: No' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[32][self::P/text()[1]="Does this play include monologues that are suitable for actors who are auditioning:  "]' $FILE
# Does this play have any specific casting requirements: 13*6_*; if no value, delete P
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[31][self::P/text()[1]="Requirement:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[30][self::P/text()[1]="Gender:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[29][self::P/text()[1]="Age:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[28][self::P/text()[1]="Requirement:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[27][self::P/text()[1]="Gender:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[26][self::P/text()[1]="Age:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[25][self::P/text()[1]="Requirement:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[24][self::P/text()[1]="Gender:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[23][self::P/text()[1]="Age:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[22][self::P/text()[1]="Requirement:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[21][self::P/text()[1]="Gender:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[20][self::P/text()[1]="Age:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[19][self::P/text()[1]="Requirement:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[18][self::P/text()[1]="Gender:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[17][self::P/text()[1]="Age:  "]' $FILE
# Does this play have any specific casting requirements: 13b6, 13*51; if 'Y' then change to 'Yes', if 'N' then change to 'No', else delete P
xml ed -L -u '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES[P/text()[1]="Does this play have any specific casting requirements: Y"]/P[16]/text()[1]' -v 'Does this play have any specific casting requirements: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES[P/text()[1]="Does this play have any specific casting requirements: N"]/P[16]/text()[1]' -v 'Does this play have any specific casting requirements: No' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[16][self::P/text()[1]="Does this play have any specific casting requirements: "]' $FILE
# General description of performers in play: 13*5_[*_SQ00*]; if no value, delete P
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[15][self::P/text()[1]="Number of Female Seniors:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[14][self::P/text()[1]="Number of Male Seniors:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[13][self::P/text()[1]="Number of Female Adults:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[12][self::P/text()[1]="Number of Male Adults:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[11][self::P/text()[1]="Number of Female Young Adults:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[10][self::P/text()[1]="Number of Male Young Adults:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[9][self::P/text()[1]="Number of Female Teens:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[8][self::P/text()[1]="Number of Male Teens:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[7][self::P/text()[1]="Number of Female Children:  "]' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/TEXTUALFEATURES/P[6][self::P/text()[1]="Number of Male Children:  "]' $FILE
# Genre/Form of play: 13*4_[*]; if value then remove comma and blank space (i.e., ', ') at end of string
xml ed -L -u '/CWRC/ENTRY[1]/TEXTSCOPE/TEXTUALFEATURES[1][P[5]/text()[1]!="Genre/Form of Play: "]/P[5]/text()[1]' -x 'substring(.,1,string-length(.)-2)' $FILE
# Historical period: 13*3_[*]; if value then remove comma and blank space (i.e., ', ') at end of string
xml ed -L -u '/CWRC/ENTRY[1]/TEXTSCOPE/TEXTUALFEATURES[1][P[4]/text()[1]!="Historical Period: "]/P[4]/text()[1]' -x 'substring(.,1,string-length(.)-2)' $FILE
# Published in any format: 13*9; if 'Y' then change to 'Yes', else delete parent PRODUCTION
xml ed -L -u '/CWRC/ENTRY/TEXTSCOPE/PRODUCTION[RESEARCHNOTE/text()="Has the play been published for distribution to the public in any format: Y"]/RESEARCHNOTE/text()' -v 'Has the play been published for distribution to the public in any format: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY/TEXTSCOPE/PRODUCTION[RESEARCHNOTE[1]/text()="Has the play been published for distribution to the public in any format: N"]/RESEARCHNOTE[1]/text()' -v 'Has the play been published for distribution to the public in any format: ' $FILE
xml ed -L -d '/CWRC/ENTRY/TEXTSCOPE/PRODUCTION[RESEARCHNOTE[1]="Has the play been published for distribution to the public in any format: "]' $FILE
# Previous partner(s): 3c; if no value then delete P element node and its immediate preceding sibling element node RESEARCHNOTE
xml ed -L -d '/CWRC/ENTRY/FAMILY/RESEARCHNOTE[6][following-sibling::P[1]/text()="Previous Partner(s): "]' $FILE
xml ed -L -d '/CWRC/ENTRY/FAMILY/P[4][self::P/text()="Previous Partner(s): "]' $FILE
# Commonlaw relationship: 3a2; if '1' then change to 'Different sex partner', if '2' then change to 'Same sex partner', and if no value then delete P element node
xml ed -L -u '/CWRC/ENTRY/FAMILY[P[3]="Commonlaw Relationship: 1"]/P[3]' -v 'Commonlaw Relationship: Different sex partner' $FILE
xml ed -L -u '/CWRC/ENTRY/FAMILY[P[3]="Commonlaw Relationship: 2"]/P[3]' -v 'Commonlaw Relationship: Same sex partner' $FILE
xml ed -L -d '/CWRC/ENTRY/FAMILY/P[3][self::P/text()="Commonlaw Relationship: "]' $FILE
# Marital relationship: 3a1; if '1' then change to 'Different sex partner', if '2' then change to 'Same sex partner', and if no value then delete P element node
xml ed -L -u '/CWRC/ENTRY/FAMILY[P[2]="Marital Relationship: 1"]/P[2]' -v 'Marital Relationship: Different sex partner' $FILE
xml ed -L -u '/CWRC/ENTRY/FAMILY[P[2]="Marital Relationship: 2"]/P[2]' -v 'Marital Relationship: Same sex partner' $FILE
xml ed -L -d '/CWRC/ENTRY/FAMILY/P[2][self::P/text()="Marital Relationship: "]' $FILE
# Region(s): 2e; if no value then delete P element node and its immediate preceding sibling element node RESEARCHNOTE
xml ed -L -d '/CWRC/ENTRY/PRODUCTION/RESEARCHNOTE[1][following-sibling::P[1]/text()="Region(s): "]' $FILE
xml ed -L -d '/CWRC/ENTRY/PRODUCTION/P[2][self::P/text()="Region(s): "]' $FILE
# Optional additional play: 13*11; if 'Y' then change to 'Yes', if 'N' or blank then delete RESEARCHNOTE and its immediate following sibling TEXTSCOPE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[22]/text()="Optional additional play: Y"]/RESEARCHNOTE[22]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[22]/text()="Optional additional play: N"]/RESEARCHNOTE[22]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[15][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[22][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[21]/text()="Optional additional play: Y"]/RESEARCHNOTE[21]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[21]/text()="Optional additional play: N"]/RESEARCHNOTE[21]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[14][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[21][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[20]/text()="Optional additional play: Y"]/RESEARCHNOTE[20]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[20]/text()="Optional additional play: N"]/RESEARCHNOTE[20]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[13][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[20][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[19]/text()="Optional additional play: Y"]/RESEARCHNOTE[19]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[19]/text()="Optional additional play: N"]/RESEARCHNOTE[19]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[12][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[19][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[18]/text()="Optional additional play: Y"]/RESEARCHNOTE[18]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[18]/text()="Optional additional play: N"]/RESEARCHNOTE[18]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[11][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[18][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[17]/text()="Optional additional play: Y"]/RESEARCHNOTE[17]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[17]/text()="Optional additional play: N"]/RESEARCHNOTE[17]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[10][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[17][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[16]/text()="Optional additional play: Y"]/RESEARCHNOTE[16]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[16]/text()="Optional additional play: N"]/RESEARCHNOTE[16]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[9][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[16][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[15]/text()="Optional additional play: Y"]/RESEARCHNOTE[15]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[15]/text()="Optional additional play: N"]/RESEARCHNOTE[15]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[8][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[15][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[14]/text()="Optional additional play: Y"]/RESEARCHNOTE[14]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[14]/text()="Optional additional play: N"]/RESEARCHNOTE[14]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[7][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[14][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[13]/text()="Optional additional play: Y"]/RESEARCHNOTE[13]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[13]/text()="Optional additional play: N"]/RESEARCHNOTE[13]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[6][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[13][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[12]/text()="Optional additional play: Y"]/RESEARCHNOTE[12]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[12]/text()="Optional additional play: N"]/RESEARCHNOTE[12]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[5][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[12][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[11]/text()="Optional additional play: Y"]/RESEARCHNOTE[11]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[11]/text()="Optional additional play: N"]/RESEARCHNOTE[11]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[4][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[11][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[10]/text()="Optional additional play: Y"]/RESEARCHNOTE[10]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[10]/text()="Optional additional play: N"]/RESEARCHNOTE[10]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[3][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[10][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[9]/text()="Optional additional play: Y"]/RESEARCHNOTE[9]' -v 'Optional additional play: Yes' $FILE
xml ed -L -u '/CWRC/ENTRY[1][RESEARCHNOTE[9]/text()="Optional additional play: N"]/RESEARCHNOTE[9]' -v 'Optional additional play: ' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/TEXTSCOPE[2][preceding-sibling::RESEARCHNOTE[1]/text()="Optional additional play: "]' $FILE
xml ed -L -d '/CWRC/ENTRY[1]/RESEARCHNOTE[9][self::RESEARCHNOTE/text()="Optional additional play: "]' $FILE

done

# echo ending processing statement
echo 'Processing of' $TOTAL_FILES 'Playwrights CWRC entry XML files is now finished.'
