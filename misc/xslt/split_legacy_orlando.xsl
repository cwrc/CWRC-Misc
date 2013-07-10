<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:mods="http://www.loc.gov/mods/v3">

    <!--
        * given an Orlando legacy bibliograph or event database dump,
        * split it into several individual files and save to disk
        * with each file containing an individual item
        *
        * edit VAR_FILENAME_PREFIX to reflect the path to write the files
    -->

    <xsl:output encoding="UTF-8" method="xml" indent="yes" omit-xml-declaration="no" />
    
    <xsl:variable name="VAR_FILENAME_PREFIX" select="'file:///C:/Z_ARCHIVE/tmp/delete/tmp_split_format_orlando/'" />

    <xsl:template match="/">
         <xsl:apply-templates select="ORLANDO/*"/>
     </xsl:template>

    <xsl:template match="BIBLIOGRAPHY_ENTRY | FREESTANDING_EVENT">
        
        <xsl:variable name="VAR_FILENAME_SUFFIX">
            <xsl:choose>
                <xsl:when test="name()='BIBLIOGRAPHY_ENTRY'"><xsl:text>-l.xml</xsl:text></xsl:when>
                <xsl:when test="name()='FREESTANDING_EVENT'"><xsl:text>-e.xml</xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>-z.sgm</xsl:text></xsl:otherwise>
            </xsl:choose>   
        </xsl:variable>
        <xsl:variable name="filename" select="concat($VAR_FILENAME_PREFIX, (@EID | @BI_ID), $VAR_FILENAME_SUFFIX )" />


        <xsl:result-document 
            indent="yes" 
            href="{$filename}" 
            omit-xml-declaration="no" 
            encoding="UTF-8" 
            method="xml" 
            >
            <!-- MRB: added copy-namespacess="no" attribute -->
        
            <xsl:copy-of select="." copy-namespaces="no"/>
        
        </xsl:result-document>
        
    </xsl:template>

</xsl:stylesheet>
