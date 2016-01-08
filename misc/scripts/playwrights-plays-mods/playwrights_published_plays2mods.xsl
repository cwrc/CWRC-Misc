<?xml version="1.0" encoding="UTF-8"?>
<!-- 
        * - MRB: Thu 07-Jan-2016
        * - Purpose: XSLT stylesheet file to extract published plays bibliographic information from the
        *   Playwrights entries and transform this bibliographic information into MODS bibliographic
        *   records.
        *   Description: This stylesheet is run by running the "playwrights_published_plays2mods.xpl"
        *   pipeline file, which calls this "playwrights_published_plays2mods.xsl" XSLT file.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:output encoding="UTF-8" method="xml" indent="yes" omit-xml-declaration="no"/>

    <!-- input parameter, the name of the original Playwrights entry file -->
    <xsl:param name="param_original_filename" select="'filename.xml'"/>

    <!-- match on the entire Playwrights entry document -->
    <xsl:template match="/">

        <modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- process each <BIBCIT> entry -->
            <xsl:for-each select="/CWRC/ENTRY/TEXTSCOPE/PRODUCTION/LISTBIBCIT/BIBCIT">
                <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

                    <!-- titleInfo element -->
                    <!-- monograph -->
                    <xsl:if test="normalize-space(TITLE[@LEVEL='MONOGRAPHIC']) != '' and normalize-space(TITLE[@LEVEL='ANALYTIC']) = ''">
                        <titleInfo>
                            <title>
                                <xsl:value-of select="normalize-space(TITLE[@LEVEL='MONOGRAPHIC'])"/>
                            </title>
                        </titleInfo>
                    </xsl:if>
                    <!-- monograph chapter -->
                    <xsl:if test="normalize-space(TITLE[@LEVEL='MONOGRAPHIC']) != '' and normalize-space(TITLE[@LEVEL='ANALYTIC']) != ''">
                        <titleInfo>
                            <title>
                                <xsl:value-of select="normalize-space(TITLE[@LEVEL='ANALYTIC'])"/>
                            </title>
                        </titleInfo>
                    </xsl:if>

                    <!-- name element -->
                    <xsl:if test="normalize-space(/CWRC/ENTRY[1]/HEADING[1][@SUBTYPE='1']) != ''">
                        <name type="personal">
                            <namePart>
                                <xsl:value-of select="normalize-space(/CWRC/ENTRY[1]/HEADING[1][@SUBTYPE='1'])"/>
                            </namePart>
                            <role>
                                <roleTerm type="text" authority="marcrealtor">Author</roleTerm>
                            </role>
                        </name>
                    </xsl:if>

                    <!-- typeOfResource element -->
                    <typeOfResource>text</typeOfResource>

                    <!-- genre element -->
                    <genre authority="cwrc" type="format">Book</genre>
                    <genre authority="cwrc" type="primaryGenre">Drama</genre>
                    <genre authority="cwrc" type="subGenre">Play</genre>

                    <!-- originInfo element -->
                    <!-- monograph -->
                    <xsl:if test="normalize-space(TITLE[@LEVEL='MONOGRAPHIC']) != '' and normalize-space(TITLE[@LEVEL='ANALYTIC']) = ''">
                        <xsl:if test="normalize-space(ORGNAME[1]) != '' or normalize-space(DATE) != ''">
                            <originInfo>
                                <xsl:if test="normalize-space(ORGNAME[1]) != ''">
                                    <publisher>
                                        <xsl:value-of select="normalize-space(ORGNAME[1])"/>
                                    </publisher>
                                </xsl:if>
                                <xsl:if test="normalize-space(DATE) != ''">
                                    <dateIssued encoding="w3cdtf" keyDate="yes">
                                        <xsl:value-of select="normalize-space(DATE)"/>
                                    </dateIssued>
                                </xsl:if>
                            </originInfo>
                        </xsl:if>
                    </xsl:if>

                    <!-- language element -->
                    <language>
                        <languageTerm type="text">English</languageTerm>
                        <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                        <scriptTerm type="text">Latin</scriptTerm>
                        <scriptTerm type="code" authority="iso15924">Latn</scriptTerm>
                    </language>

                    <!-- relatedItem element -->
                    <!-- monograph chapter's monograph title, name, originInfo, and identifier-->
                    <xsl:if test="normalize-space(TITLE[@LEVEL='MONOGRAPHIC']) != '' and normalize-space(TITLE[@LEVEL='ANALYTIC']) != ''">
                        <relatedItem type="host">
                            <titleInfo>
                                <title>
                                    <xsl:value-of select="normalize-space(TITLE[@LEVEL='MONOGRAPHIC'])"/>
                                </title>
                            </titleInfo>
                            <xsl:if test="normalize-space(NAME[1]) != ''">
                                <xsl:for-each select="NAME">
                                    <name type="personal">
                                        <namePart>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </namePart>
                                        <role>
                                            <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                                        </role>
                                    </name>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="normalize-space(ORGNAME[1]) != '' or normalize-space(DATE) != ''">
                                <originInfo>
                                    <xsl:if test="normalize-space(ORGNAME[1]) != ''">
                                        <publisher>
                                            <xsl:value-of select="normalize-space(ORGNAME[1])"/>
                                        </publisher>
                                    </xsl:if>
                                    <xsl:if test="normalize-space(DATE) != ''">
                                        <dateIssued encoding="w3cdtf" keyDate="yes">
                                            <xsl:value-of select="normalize-space(DATE)"/>
                                        </dateIssued>
                                    </xsl:if>
                                </originInfo>
                            </xsl:if>
                            <xsl:if test="contains('0123456789', substring(IDNO, 1, 1))">
                                <identifier type="isbn">
                                    <xsl:value-of select="normalize-space(IDNO)"/>
                                </identifier>
                            </xsl:if>
                        </relatedItem>
                    </xsl:if>

                    <!-- identifier element -->
                    <!-- monograph -->
                    <xsl:if test="normalize-space(TITLE[@LEVEL='MONOGRAPHIC']) != '' and normalize-space(TITLE[@LEVEL='ANALYTIC']) = ''">
                        <!-- Some IDNO element entries contain the value "Stage-ready script" instead of the correct ISBN number,
                                so perform a check to see if the first character in the string is a digit -->
                        <xsl:if test="contains('0123456789', substring(IDNO, 1, 1))">
                            <identifier type="isbn">
                                <xsl:value-of select="normalize-space(IDNO)"/>
                            </identifier>
                        </xsl:if>
                    </xsl:if>

                    <!-- accessCondition element -->
                    <accessCondition type="use and reproduction">This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a> (CC BY-NC-SA 4.0).</accessCondition>

                    <!-- recordInfo element -->
                    <recordInfo>
                        <recordContentSource>Biographies of Canadian Women Playwrights</recordContentSource>
                        <recordContentSource>Canadian Writing Research Collaboratory</recordContentSource>
                        <recordCreationDate encoding="w3cdtf">
                            <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                        </recordCreationDate>
                        <recordOrigin>Data were collected using a LimeSurvey questionnaire; survey responses were converted to
                CWRC entry XML files; and the published play references were extracted and transformed into MODS bibliographic
                records.
                </recordOrigin>
                        <languageOfCataloging>
                            <languageTerm type="text">English</languageTerm>
                            <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                            <scriptTerm type="text">Latin</scriptTerm>
                            <scriptTerm type="code" authority="iso15924">Latn</scriptTerm>
                        </languageOfCataloging>
                    </recordInfo>

                </mods>
            </xsl:for-each>

        </modsCollection>

    </xsl:template>

</xsl:stylesheet>
