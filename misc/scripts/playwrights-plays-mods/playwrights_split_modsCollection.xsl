<?xml version="1.0" encoding="UTF-8"?>
<!-- 
        * - MRB: Thu 07-Jan-2016
        * - Purpose: XSLT stylesheet file to split Playwrights MODS collection XML files into individual
        *   MODS bibliographic record files.
        *   Description: This stylesheet is run by running the batch file script
        *   "playwrights_split_modsCollection.cmd", which calls this
        *   "playwrights_split_modsCollection.xsl" XSLT file.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:mods="http://www.loc.gov/mods/v3">

    <xsl:output encoding="UTF-8" method="xml" indent="yes" omit-xml-declaration="no"/>

    <xsl:strip-space elements="*"/>

    <!-- set the output directory and file name prefix -->
    <xsl:variable name="VAR_FILENAME_PREFIX" select="'data/mods_'"/>
    <!-- set the file name of the current input file being processed -->
    <xsl:variable name="VAR_FILENAME" select="tokenize(base-uri(.), '/')[last()]"/>
    <!-- split the current input file being processed into a node set consisting of the file base name and the file extension -->
    <xsl:variable name="VAR_FILENAMEPART" select="tokenize($VAR_FILENAME, '\.')"/>

    <xsl:template match="/">
        <xsl:apply-templates select="mods:modsCollection/mods:mods"/>
    </xsl:template>

    <xsl:template match="mods:mods">
        <!-- set the output file name by concatenating the constituent parts that make up the file name -->
        <xsl:variable name="filename" select="concat($VAR_FILENAME_PREFIX, $VAR_FILENAMEPART[1], '_', format-number(position(),'000000') )"/>
        <xsl:result-document indent="yes" href="{$filename}.xml" omit-xml-declaration="no" encoding="UTF-8" method="xml">

            <!-- MRB: added @copy-namespaces attribute with a value of "no" -->
            <xsl:copy-of select="." copy-namespaces="no"/>

        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
