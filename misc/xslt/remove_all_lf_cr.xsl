<?xml version="1.0" encoding="UTF-8"?>

<!-- 
* remove word-wrap (i.e. Oxygen Format and Indent) 
* not indenting afterwards
* used on a directory of files via the 'collection' function
* implemented for John Simpson's work - 2013
*
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:element name="CWRC-ORLANDO">
            <xsl:attribute name="date" select="current-dateTime()" />
            <xsl:text>&#10;</xsl:text>
            
            <xsl:for-each select="collection('.?select=*.xml')">
                <xsl:apply-templates  />
                <xsl:text>&#10;</xsl:text>        
            </xsl:for-each>
            
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="@* | node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- 
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space()" />
    </xsl:template>
     -->
    
    
    <!-- 
   * http://stackoverflow.com/questions/5737862/xslt-output-formatting-removing-line-breaks-and-blank-output-lines-from-remove 
    -->
    <xsl:template match=
        "text()[not(string-length(normalize-space()))]"/>
    
    <xsl:template match=
        "text()[string-length(normalize-space()) > 0]">
        <xsl:value-of select="translate(.,'&#xA;&#xD;', '  ')"/>
    </xsl:template>
    
</xsl:stylesheet>