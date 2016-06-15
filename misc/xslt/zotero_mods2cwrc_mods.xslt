<?xml version="1.0" encoding="UTF-8"?>

<!--
    MRB: Fri 16-Jan-2015
    - XSLT to add the MODS top-level elements of accessCondition and recordInfo
    containing CWRC-specified information to a Zotero MODS file.
    - Before running this XSLT, change the root element in the source file to be
    converted to <modsCollection>, i.e., remove the attributes and namespace
    from the root element.
    - Run this XSLT on the source file to be converted. 
    - In the converted file, add xmlns="http://www.loc.gov/mods/v3" to the
    modsCollection root element.
    - Use the XSLT split_modsCollection.xsl to split the converted XML file.
    - Zip the individual MODS files, and ingest into the CWRC repository.
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/*">
        <xsl:copy>
            <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd</xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mods">

        <xsl:copy>

            <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd</xsl:attribute>

            <xsl:apply-templates select="@*|node()"/>

            <accessCondition type="use and reproduction">Use of this public-domain resource is governed by the <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/" target="_blank">Creative Commons Attribution-NonCommercial 4.0 International License</a>.</accessCondition>

            <recordInfo>
                <recordContentSource>Canadian Writing Research Collaboratory</recordContentSource>
                <recordCreationDate encoding="w3cdtf">
                    <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                </recordCreationDate>
                <recordOrigin>The MODS record was exported from a Zotero database as part of collection of MODS records, all contained in one file;
                    the collection of Zotero MODS records were enhanced using an XSLT stylesheet, and then split into individual MODS records
                    using another XSLT stylesheet.</recordOrigin>
                <languageOfCataloging>
                    <languageTerm type="text">English</languageTerm>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                    <scriptTerm type="text">Latin</scriptTerm>
                    <scriptTerm type="code" authority="iso15924">Latn</scriptTerm>
                </languageOfCataloging>
            </recordInfo>

        </xsl:copy>

    </xsl:template>

</xsl:stylesheet>
