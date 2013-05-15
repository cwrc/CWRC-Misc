<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:mods="http://www.loc.gov/mods/v3">

    <!--
        * given a modsCollection, split it into several individual files and save to disk
        * with each file containing an individual <mods> element
        *
        * edit VAR_FILENAME_PREFIX to reflect the path to write the files
    -->

    <xsl:variable name="VAR_FILENAME_PREFIX" select="'data/mods_split_'" />

    <xsl:template match="/">
        <xsl:apply-templates select="mods:modsCollection/mods:mods"/>
    </xsl:template>

    <xsl:template match="mods:mods">
        <xsl:variable name="filename" select="concat($VAR_FILENAME_PREFIX, format-number(position(),'000000') )" />
        <xsl:result-document 
            indent="yes" 
            href="{$filename}.xml"
            >
            
            <xsl:copy-of select="."/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
