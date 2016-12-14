<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# MRB: Wed 14-Dec-2016

# Purpose: XSLT stylesheet to transform CEWW Excel spreadsheet image file data records to MODS records
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:template match="/">

        <modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd"
            xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- conditional operator here: if image_title element has content, then process record -->
            <xsl:apply-templates select="root/record[normalize-space(image_title)]"/>

        </modsCollection>

    </xsl:template>

    <xsl:template match="record">

        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd"
            xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- titleInfo element -->
            <titleInfo>
                <title>
                    <xsl:value-of select="normalize-space(image_title)"/>
                </title>
            </titleInfo>

            <!-- note element -->
            <xsl:if test="normalize-space(note) != ''">
                <note>
                    <xsl:value-of select="normalize-space(note)"/>
                </note>
            </xsl:if>

            <!-- subject element -->
            <xsl:if test="normalize-space(name) != '' or normalize-space(name_uri) != ''">
                <subject>
                    <name>
                        <xsl:if test="normalize-space(name_uri) != ''">
                            <xsl:attribute name="valueURI">
                                <xsl:value-of select="normalize-space(name_uri)"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="normalize-space(name) != ''">
                            <xsl:element name="namePart">
                                <xsl:value-of select="normalize-space(name)"/>
                            </xsl:element>
                        </xsl:if>
                    </name>
                </subject>
            </xsl:if>

            <!-- accessCondition element -->
            <accessCondition type="use and reproduction">This work is licensed under a <a
                    rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"
                    target="_blank">Creative Commons Attribution-NonCommercial-ShareAlike 4.0
                    International License</a> (CC BY-NC-SA 4.0).</accessCondition>

            <!-- recordInfo element -->
            <recordInfo>
                <recordContentSource>Canada's Early Women Writers, Simon Fraser
                    University</recordContentSource>
                <recordContentSource>Canadian Writing Research Collaboratory</recordContentSource>
                <recordCreationDate encoding="w3cdtf">
                    <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                </recordCreationDate>
                <recordOrigin>Record has been transformed into a MODS record using the following
                    sequence of operations: Microsoft Excel record to a CSV record; CSV record to a
                    basic XML record; basic XML record to a MODS XML record.</recordOrigin>
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
