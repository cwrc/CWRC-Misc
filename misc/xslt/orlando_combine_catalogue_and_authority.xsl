<?xml version="1.0" encoding="UTF-8"?>

<!-- A list of Orlando's British women writers, ideally the authority list version complete with the variant names and birth and death dates. -->

<!-- 
* input - concatentated file of the Orlando DeliverySystem catalogue and the Orlando authority lists

* input file format

<orlando>
   <catalogue>
   </catalogue>
   <AUTHORITYLIST>
   </AUTHORITYLIST>
</orlando
-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="/">
        <xsl:element name="orlando">
            <xsl:attribute name="date" select="current-dateTime()"/>
            <xsl:apply-templates select="orlando/catalogue/entry" />    
        </xsl:element>
    </xsl:template>
    
    
    <!-- each person - british wormen writer is stored in an entry element -->
    <xsl:template match="entry">
        <xsl:variable name="tmp_standard_name" select="@standard_name"></xsl:variable>
        <xsl:text>&#10;</xsl:text>
        <xsl:element name="entry">
            <xsl:copy-of select="@*" />
            <xsl:element name="varient_names">
                <xsl:apply-templates select="/orlando/AUTHORITYLIST/AUTHORITYITEM[@STANDARD=$tmp_standard_name]" />
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="AUTHORITYITEM">
        <xsl:copy-of select="*" />
        <xsl:apply-templates select="@DISPLAY" />
    </xsl:template>
    
    <xsl:template match="@DISPLAY">
        <xsl:element name="DISPLAY">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>