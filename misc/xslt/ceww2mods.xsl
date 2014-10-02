<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# MRB: Wed 01-Oct-2014

# Purpose: XSLT stylesheet to transform CEWW basic XML format bibliographic records to MODS records

# Notes:
#
# Various preprocessing operations were performed on the data before the XSLT operation was
# run:
#
# (1) Data cleanup of the original Microsoft Excel spreadsheet:
# * A few Microsoft Excel formulas were used in preprocessing operations to make the data
# amenable to the XSLT transformation.  For example,  to add the string "personal" to the
# "Type2" field if the "Family_name2" field had text, the following formula was used:
# =IF(ISTEXT(AQ2),"personal","")  The formula was autopopulated in each cell in the column by
# copying the formula using Ctrl-c, navigating to the bottom of the spreadsheet, then holding
# down the shift key, then clicking on the last cell in the column, and then pasting the formulas
# in by using Ctrl-v.  The column was then highlighted, copied, and then pasted over using
# Paste Special > Paste Values > Values.
# * However, most cleanup operations had to be performed manually, such as parsing out the
# second and third authors text strings, changing the country field to a MARC country field, etc.
#
# (2) After the data cleanup operations were finished, the data were imported from the Microsoft
# Excel spreadsheet to a Google Sheet by copying and pasting the data from Excel to a Google
# Sheet document; the data were then exported from the Google Sheet document as a tab-
# delimited TSV file.  This was a workaround to address the inability of Microsoft Excel to export
# UTF-8 encoded characters as a CSV or TSV file.  Another workaround that was tested and that
# worked well was importing the Excel data file into the Gnumeric spreadsheet program, and then
# exporting the data as a tab-delimited file; to export the data as a tab-delimited file in Gnumeric,
# select Data, then Export Data, then Export as Text File ..., then Text (configurable), and then
# select the appropriate settings in the dialog box that will pop up after you select the option to
# save the file.
#
# (3) The tab-delimited TSV file was then converted into a basic XML file using the AWK script
# csv2xml.awk; one can also use csv2xml.pl or csv2xml.xsl to do the conversion.  This results in
# an XML file where each line in the input CSV file becomes a record element in the output XML
# file, and the header field names are used for the child element names for each data cell in a
# field in a record.  This produces a basic well-formed XML file.
#
# (4) This XSLT stylesheet file, ceww2mods.xsl, was then used to transform the basic XML file
# into an XML file containing MODS records.
# 
# (5) The final step was to use the XSLT stylesheet split_modsCollection.xsl to split the single
# XML file containing the MODS records into individual MODS record XML files.
#
# * Source Microsoft Excel spreadsheet characteristics:
# - 67 columns or variables in the header row; and
# - 298 data rows or records.
#
# MODS record mappings:
# - The CEWW bibliographic records were mapped to 10 top-level elements in MODS:
# titleInfo, name, typeOfResource, genre, originInfo, language, note, location, accessCondition,
# and recordInfo.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:template match="/">

        <modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- conditional operator here: if Book_title element has content, then process record -->
            <xsl:apply-templates select="root/record[normalize-space(Book_title)]"/>

        </modsCollection>

    </xsl:template>

    <xsl:template match="record">

        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- titleInfo element information -->
            <xsl:if test="normalize-space(Book_title) != '' and normalize-space(Alternative_title) = ''">
                <titleInfo>
                    <title>
                        <xsl:value-of select="normalize-space(Book_title)"/>
                    </title>
                    <xsl:if test="normalize-space(Subtitle) != ''">
                        <subTitle>
                            <xsl:value-of select="normalize-space(Subtitle)"/>
                        </subTitle>
                    </xsl:if>
                </titleInfo>
            </xsl:if>
            <xsl:if test="normalize-space(Book_title) != '' and normalize-space(Alternative_title) != ''">
                <titleInfo usage="primary">
                    <title>
                        <xsl:value-of select="normalize-space(Book_title)"/>
                    </title>
                    <xsl:if test="normalize-space(Subtitle) != ''">
                        <subTitle>
                            <xsl:value-of select="normalize-space(Subtitle)"/>
                        </subTitle>
                    </xsl:if>
                </titleInfo>
                <titleInfo type="alternative">
                    <title>
                        <xsl:value-of select="normalize-space(Alternative_title)"/>
                    </title>
                    <xsl:if test="normalize-space(Subtitle) != ''">
                        <subTitle>
                            <xsl:value-of select="normalize-space(Subtitle)"/>
                        </subTitle>
                    </xsl:if>
                </titleInfo>
            </xsl:if>

            <!-- name element information -->
            <name type="personal">
                <namePart type="given">
                    <xsl:value-of select="normalize-space(Given_name)"/>
                </namePart>
                <namePart type="family">
                    <xsl:value-of select="normalize-space(Family_name)"/>
                </namePart>
                <xsl:if test="normalize-space(Pseudonym) != ''">
                    <namePart>
                        <xsl:value-of select="normalize-space(Pseudonym)"/>
                    </namePart>
                </xsl:if>
                <xsl:if test="normalize-space(Dates) != ''">
                    <namePart type="date">
                        <xsl:value-of select="normalize-space(Dates)"/>
                    </namePart>
                </xsl:if>
                <xsl:if test="normalize-space(Affiliation) != ''">
                    <affiliation>
                        <xsl:value-of select="normalize-space(Affiliation)"/>
                    </affiliation>
                </xsl:if>
                <xsl:if test="normalize-space(Role) != ''">
                    <role>
                        <roleTerm type="text" authority="marcrealtor">
                            <xsl:value-of select="normalize-space(Role)"/>
                        </roleTerm>
                    </role>
                </xsl:if>
            </name>
            <xsl:if test="normalize-space(Type2) != ''">
                <name type="personal">
                    <xsl:if test="normalize-space(Given_name2) != ''">
                        <namePart type="given">
                            <xsl:value-of select="normalize-space(Given_name2)"/>
                        </namePart>
                    </xsl:if>
                    <namePart type="family">
                        <xsl:value-of select="normalize-space(Family_name2)"/>
                    </namePart>
                    <xsl:if test="normalize-space(Role2) != ''">
                        <role>
                            <roleTerm type="text" authority="marcrealtor">
                                <xsl:value-of select="normalize-space(Role2)"/>
                            </roleTerm>
                        </role>
                    </xsl:if>
                </name>
            </xsl:if>
            <xsl:if test="normalize-space(Type3) != ''">
                <name type="personal">
                    <xsl:if test="normalize-space(Given_name3) != ''">
                        <namePart type="given">
                            <xsl:value-of select="normalize-space(Given_name3)"/>
                        </namePart>
                    </xsl:if>
                    <namePart type="family">
                        <xsl:value-of select="normalize-space(Family_name3)"/>
                    </namePart>
                    <xsl:if test="normalize-space(Role3) != ''">
                        <role>
                            <roleTerm type="text" authority="marcrealtor">
                                <xsl:value-of select="normalize-space(Role3)"/>
                            </roleTerm>
                        </role>
                    </xsl:if>
                </name>
            </xsl:if>
            <xsl:if test="normalize-space(Type4) != ''">
                <name type="personal">
                    <xsl:if test="normalize-space(Given_name4) != ''">
                        <namePart type="given">
                            <xsl:value-of select="normalize-space(Given_name4)"/>
                        </namePart>
                    </xsl:if>
                    <namePart type="family">
                        <xsl:value-of select="normalize-space(Family_name4)"/>
                    </namePart>
                    <xsl:if test="normalize-space(Role4) != ''">
                        <role>
                            <roleTerm type="text" authority="marcrealtor">
                                <xsl:value-of select="normalize-space(Role4)"/>
                            </roleTerm>
                        </role>
                    </xsl:if>
                </name>
            </xsl:if>

            <!-- typeOfResource element information -->
            <typeOfResource>text</typeOfResource>

            <!-- genre element information -->
            <xsl:if test="normalize-space(Format) != ''">
                <genre authority="cwrc" type="format">
                    <xsl:value-of select="normalize-space(Format)"/>
                </genre>
            </xsl:if>
            <xsl:if test="normalize-space(Primary_genres) != ''">
                <genre authority="cwrc" type="primaryGenre">
                    <xsl:value-of select="normalize-space(Primary_genres)"/>
                </genre>
            </xsl:if>
            <xsl:if test="normalize-space(Subgenres) != ''">
                <genre authority="cwrc" type="subGenre">
                    <xsl:value-of select="normalize-space(Subgenres)"/>
                </genre>
            </xsl:if>

            <!-- originInfo element information -->
            <xsl:if test="normalize-space(Place_of_publication_or_issuance) != '' or (normalize-space(Publishers) != '' or normalize-space(Date_published_or_issued) != '')">
                <originInfo eventType="publication">
                    <xsl:if test="normalize-space(Place_of_publication_or_issuance) != ''">
                        <place>
                            <placeTerm type="text">
                                <xsl:value-of select="normalize-space(Place_of_publication_or_issuance)"/>
                            </placeTerm>
                            <placeTerm type="code" authority="marccountry">
                                <xsl:value-of select="normalize-space(MARC_country_code)"/>
                            </placeTerm>
                        </place>
                    </xsl:if>
                    <xsl:if test="normalize-space(Publishers) != ''">
                        <publisher>
                            <xsl:value-of select="normalize-space(Publishers)"/>
                        </publisher>
                    </xsl:if>
                    <xsl:if test="normalize-space(Place_of_publication_or_issuance2) != ''">
                        <place>
                            <placeTerm type="text">
                                <xsl:value-of select="normalize-space(Place_of_publication_or_issuance2)"/>
                            </placeTerm>
                            <placeTerm type="code" authority="marccountry">
                                <xsl:value-of select="normalize-space(MARC_country_code2)"/>
                            </placeTerm>
                        </place>
                    </xsl:if>
                    <xsl:if test="normalize-space(Publishers2) != ''">
                        <publisher>
                            <xsl:value-of select="normalize-space(Publishers2)"/>
                        </publisher>
                    </xsl:if>
                    <xsl:if test="normalize-space(Place_of_publication_or_issuance3) != ''">
                        <place>
                            <placeTerm type="text">
                                <xsl:value-of select="normalize-space(Place_of_publication_or_issuance3)"/>
                            </placeTerm>
                            <placeTerm type="code" authority="marccountry">
                                <xsl:value-of select="normalize-space(MARC_country_code3)"/>
                            </placeTerm>
                        </place>
                    </xsl:if>
                    <xsl:if test="normalize-space(Publishers3) != ''">
                        <publisher>
                            <xsl:value-of select="normalize-space(Publishers3)"/>
                        </publisher>
                    </xsl:if>
                    <xsl:if test="normalize-space(Date_published_or_issued) != '' and (normalize-space(Date_issued_qualifier) = '' and normalize-space(Copyright_date) = '')">
                        <dateIssued encoding="w3cdtf">
                            <xsl:value-of select="normalize-space(Date_published_or_issued)"/>
                        </dateIssued>
                    </xsl:if>
                    <xsl:if test="normalize-space(Date_published_or_issued) != '' and (normalize-space(Date_issued_qualifier) != '')">
                        <dateIssued encoding="w3cdtf" qualifier="questionable">
                            <xsl:value-of select="normalize-space(Date_published_or_issued)"/>
                        </dateIssued>
                    </xsl:if>
                    <xsl:if test="normalize-space(Date_published_or_issued) != '' and (normalize-space(Copyright_date) != '')">
                        <dateIssued encoding="w3cdtf" keyDate="yes">
                            <xsl:value-of select="normalize-space(Date_published_or_issued)"/>
                        </dateIssued>
                        <copyrightDate encoding="w3cdtf">
                            <xsl:value-of select="normalize-space(Copyright_date)"/>
                        </copyrightDate>
                    </xsl:if>
                    <xsl:if test="normalize-space(Edition) != ''">
                        <edition>
                            <xsl:value-of select="normalize-space(Edition)"/>
                        </edition>
                    </xsl:if>
                    <issuance>monographic</issuance>
                </originInfo>
            </xsl:if>

            <!-- language element information -->
            <language>
                <languageTerm type="text">English</languageTerm>
                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                <scriptTerm type="text">Latin</scriptTerm>
                <scriptTerm type="code" authority="iso15924">Latn</scriptTerm>
            </language>

            <!-- note element information -->
            <xsl:if test="normalize-space(Scholar_note) != ''">
                <note type="scholarNote">
                    <xsl:value-of select="normalize-space(Scholar_note)"/>
                </note>
            </xsl:if>
            <xsl:if test="normalize-space(Research_note) != ''">
                <note type="researchNote">
                    <xsl:value-of select="normalize-space(Research_note)"/>
                </note>
            </xsl:if>

            <!-- location element information -->
            <xsl:if test="normalize-space(Web_address) != ''">
                <location>
                    <url>
                        <xsl:value-of select="normalize-space(Web_address)"/>
                    </url>
                </location>
            </xsl:if>

            <!-- accessCondition element information -->
            <accessCondition type="use and reproduction">This work is licensed under a
                <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">Creative Commons Attribution-NonCommercial-ShareAlike 
                    4.0 International License</a> (CC BY-NC-SA 4.0).</accessCondition>

            <!-- recordInfo element information -->
            <recordInfo>
                <recordContentSource>Canada's Early Women Writers, Simon Fraser University; 
                    Canadian Writing Research Collaboratory</recordContentSource>
                <recordCreationDate encoding="w3cdtf">2014-10-01</recordCreationDate>
                <recordOrigin>Record has been transformed into a MODS record from an Excel 
                    spreadsheet record using an XSLT stylesheet.</recordOrigin>
                <languageOfCataloging>
                    <languageTerm type="text">English</languageTerm>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                    <scriptTerm type="text">Latin</scriptTerm>
                    <scriptTerm type="code" authority="iso15924">Latn</scriptTerm>
                </languageOfCataloging>
            </recordInfo>

        </mods>

    </xsl:template>

</xsl:stylesheet>
