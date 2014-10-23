<?xml version="1.0" encoding="UTF-8"?>

<!--
    XSL to output XML text largely as is only removing certain unneccessary elements
-->

<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    >

    <xsl:output method="xml" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>

    
    <!--
    * consided all elements
    -->
    <xsl:template match="node()">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates select="child::node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!--
    * add all attributes
    -->
    <xsl:template match="@*">
        <xsl:copy />
    </xsl:template>
    

    <!--
    * remove these tags from any part of the xml
    -->
    <xsl:template match="tei:hi">
        <xsl:if test="@*">
            <xsl:copy>
                <xsl:copy-of select="@*" />
                <xsl:apply-templates />
            </xsl:copy>
        </xsl:if>
        <xsl:if test="not(@*)">
            <xsl:apply-templates select="node()"/>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>
