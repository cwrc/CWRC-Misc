<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# MRB: Fri 14-Nov-2014

# Purpose: XSLT stylesheet to transform RSC Expert Panel on libraries and archives Google
# Sheet bibliographic records for submissions PDF resources to MODS records
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:template match="/">

        <modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- conditional operator here: if Language element has content, then process record (all records have content in the Language element) -->
            <xsl:apply-templates select="root/record[normalize-space(Language)]"/>

        </modsCollection>

    </xsl:template>

    <xsl:template match="record">

        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- titleInfo element information -->
            <titleInfo>
                <title>
                    <xsl:text>Submission by&#160;</xsl:text>
                    <xsl:if test="normalize-space(Last) != ''">
                        <xsl:value-of select="normalize-space(First)"/>
                        <xsl:text>&#160;</xsl:text>
                        <xsl:value-of select="normalize-space(Last)"/>
                    </xsl:if>
                    <xsl:if test="normalize-space(Last2) != ''">
                        <xsl:text>&#160;and&#160;</xsl:text>
                        <xsl:value-of select="normalize-space(First2)"/>
                        <xsl:text>&#160;</xsl:text>
                        <xsl:value-of select="normalize-space(Last2)"/>
                    </xsl:if>
                    <xsl:if test="normalize-space(Last) != '' and normalize-space(Affiliation) != ''">
                        <xsl:text>,&#160;</xsl:text>
                    </xsl:if>
                    <xsl:if test="normalize-space(Affiliation) != ''">
                        <xsl:value-of select="normalize-space(Affiliation)"/>
                    </xsl:if>
                </title>
            </titleInfo>

            <!-- name element information -->
            <xsl:if test="normalize-space(Last) != ''">
                <name type="personal">
                    <namePart type="given">
                        <xsl:value-of select="normalize-space(First)"/>
                    </namePart>
                    <namePart type="family">
                        <xsl:value-of select="normalize-space(Last)"/>
                    </namePart>
                    <xsl:if test="normalize-space(Affiliation) != ''">
                        <affiliation>
                            <xsl:value-of select="normalize-space(Affiliation)"/>
                        </affiliation>
                    </xsl:if>
                </name>
            </xsl:if>
            <xsl:if test="normalize-space(Last2) != ''">
                <name type="personal">
                    <namePart type="given">
                        <xsl:value-of select="normalize-space(First2)"/>
                    </namePart>
                    <namePart type="family">
                        <xsl:value-of select="normalize-space(Last2)"/>
                    </namePart>
                    <xsl:if test="normalize-space(Affiliation) != ''">
                        <affiliation>
                            <xsl:value-of select="normalize-space(Affiliation)"/>
                        </affiliation>
                    </xsl:if>
                </name>
            </xsl:if>

            <!-- typeOfResource element information -->
            <typeOfResource>text</typeOfResource>

            <!-- originInfo element information -->
            <originInfo>
                <xsl:if test="normalize-space(Place) != ''">
                    <place>
                        <placeTerm type="text">
                            <xsl:value-of select="normalize-space(Place)"/>
                        </placeTerm>
                    </place>
                </xsl:if>
                <dateIssued>November 2014</dateIssued>
                <dateIssued encoding="w3cdtf">2014-11</dateIssued>
            </originInfo>

            <!-- language element information -->
            <xsl:if test="normalize-space(Language) = 'English'">
                <language>
                    <languageTerm type="text">English</languageTerm>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                    <scriptTerm type="text">Latin</scriptTerm>
                    <scriptTerm type="code" authority="iso15924">Latn</scriptTerm>
                </language>
            </xsl:if>
            <xsl:if test="normalize-space(Language) = 'French'">
                <language>
                    <languageTerm type="text">French</languageTerm>
                    <languageTerm type="code" authority="iso639-2b">fre</languageTerm>
                    <scriptTerm type="text">Latin</scriptTerm>
                    <scriptTerm type="code" authority="iso15924">Latn</scriptTerm>
                </language>
            </xsl:if>

            <!-- note element information -->
            <xsl:if test="normalize-space(Note) != ''">
                <note type="scholarNote">
                    <xsl:value-of select="normalize-space(Note)"/>
                </note>
            </xsl:if>

            <!-- location element information -->
            <location>
                <url access="object in context">http://cwrc.ca/rsc-src/submissions/</url>
            </location>

            <!-- accessCondition element information -->
            <accessCondition type="use and reproduction">Use of this public-domain resource is governed by the
                <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/" target="_blank">Creative Commons
                    Attribution-NonCommercial 4.0 International License</a>.</accessCondition>

            <!-- recordInfo element information -->
            <recordInfo>
                <recordContentSource>Royal Society of Canada’s Expert Panel on
                    The Status and Future of Canada’s Libraries and Archives</recordContentSource>
                <recordCreationDate encoding="w3cdtf">2014-11-17</recordCreationDate>
                <recordOrigin>Record has been transformed into a MODS record from a Google 
                    Sheet record using an XSLT stylesheet.</recordOrigin>
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
