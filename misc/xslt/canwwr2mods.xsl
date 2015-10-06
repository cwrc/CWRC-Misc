<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# MRB: Fri 02-Oct-2015

# Purpose: XSLT stylesheet to transform CanWWR Microsoft Excel bibliographic records to MODS records
#
# * Source Microsoft Excel spreadsheet characteristics:
# - 5 columns, fields, or variables in the header row; and
# - 16,859 data rows, lines, or records.
#
# MODS record top-level elements:
# - The CanWWR bibliographic records contain up to 7 top-level elements in MODS:
# titleInfo, name, typeOfResource, genre, originInfo, accessCondition, and recordInfo.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:template match="/">

        <modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- if title field has content, then process record -->
            <xsl:apply-templates select="root/record[normalize-space(title)]"/>

        </modsCollection>

    </xsl:template>

    <xsl:template match="record">

        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- titleInfo element -->
            <titleInfo>
                <title>
                    <xsl:value-of select="normalize-space(title)"/>
                </title>
            </titleInfo>

            <!-- name element -->
            <xsl:if test="normalize-space(preferred_name) != ''">
                <name type="personal">
                    <namePart>
                        <xsl:value-of select="normalize-space(preferred_name)"/>
                    </namePart>
                    <xsl:if test="normalize-space(known_alternate_names) != ''">
                        <!-- split multiple known_alternate_names entries on the comma delimiter -->
                        <xsl:for-each select="tokenize(known_alternate_names, ',')">
                            <xsl:if test="normalize-space(.) != ''">
                                <namePart>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </namePart>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    <role>
                        <roleTerm type="text" authority="marcrealtor">Author</roleTerm>
                    </role>
                </name>
            </xsl:if>

            <!-- typeOfResource element -->
            <typeOfResource>text</typeOfResource>

            <!-- genre element -->
            <xsl:if test="normalize-space(genre) != ''">
                <genre>
                    <xsl:value-of select="normalize-space(genre)"/>
                </genre>
            </xsl:if>

            <!-- originInfo element -->
            <xsl:if test="normalize-space(year) != ''">
                <originInfo>
                    <dateIssued encoding="w3cdtf" keyDate="yes">
                        <xsl:value-of select="normalize-space(year)"/>
                    </dateIssued>
                </originInfo>
            </xsl:if>

            <!-- accessCondition element -->
            <accessCondition type="use and reproduction">This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a> (CC BY-NC-SA 4.0).</accessCondition>

            <!-- recordInfo element -->
            <recordInfo>
                <recordContentSource>Canadian Women Writing and Reading from 1950, University of Alberta</recordContentSource>
                <recordContentSource>Canadian Writing Research Collaboratory</recordContentSource>
                <recordCreationDate encoding="w3cdtf">
                    <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                </recordCreationDate>
                <recordOrigin>Record has been transformed from a Microsoft Excel spreadsheet record to a MODS record by first using an AWK script,
                    and then by using two different XSLT stylesheets.</recordOrigin>
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
