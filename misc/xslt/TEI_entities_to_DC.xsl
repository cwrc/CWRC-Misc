<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    >
    
    <!--
  * MVI
  * June 18, 2018
  * given a TEI entity - person, organization or place - output a DC format datastream
  * designed to work with 1 entity per file
  -->
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes" omit-xml-declaration="no" />
    
    
    <!--
  * PID value passed into the transform 
  -->
    <xsl:param name="PID_PARAM" select="'zzzz'"/>
    
    
    <!--
  * build DC
  -->
    <xsl:template match="/tei:TEI">
        <oai_dc:dc xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd" >
            <dc:title>
                <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
            </dc:title>
            <dc:identifier>
                <xsl:value-of select="$PID_PARAM" />
            </dc:identifier>
        </oai_dc:dc> 
    </xsl:template>
      
    
</xsl:stylesheet>