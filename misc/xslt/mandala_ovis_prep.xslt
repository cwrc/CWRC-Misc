<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<!--
* prepare an orlando biography and writing dump for use with 
* ==> Mandala
* ==> Ovis
*
* XSL to preprocess the writing, biography
* * remove the specified tags from the items 
*
* see Orlando  development/doc/WORK-NOTES to describe how to produce input file - "make dm_files_analytics"
- java -Xmx512m -jar /home/tomcat/apache-tomcat/shared/lib/saxon8.jar  ./orlando_entries_test.xml mandala_ovis_prep.xslt
*
-->

<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:saxon="http://icl.com/saxon"
    extension-element-prefixes="saxon"
    exclude-result-prefixes="saxon"
    >


    <xsl:output 
        method="xhtml" 
        encoding="UTF-8" 
        saxon:character-representation="native;entity" 
        indent="no"
        />

    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="*">
        <xsl:if test="not(DIV0) and not(DIV1) and not(DIV2)">
                    <xsl:copy>
                            <!--<xsl:copy-of select="@*" /> -->
                            <xsl:apply-templates select="@*"/>
                            <xsl:apply-templates />
                    </xsl:copy>
        </xsl:if>
            <xsl:if test="DIV0 or DIV1 or DIV2">
                    <xsl:apply-templates />
        </xsl:if>
    </xsl:template>


    <!--
    * add all attributes except the new ones added by this XSLT
    -->
    <xsl:template match="@CT_ID | @CT_ISLINK | @SN_ID">
    </xsl:template>


    <xsl:template match="@*">
            <xsl:copy /> 
    </xsl:template>


    <!--
    * remove these tags from any part of the xml
    -->
    <xsl:template match="WORKSCITED | REVISIONDESC | BIBCITS">
    </xsl:template>

</xsl:stylesheet>
