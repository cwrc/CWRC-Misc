<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# MRB: Wed 18-Nov-2015

# Purpose: XSLT stylesheet to extract and create Middlebrow MODS records for issues
# Total number of article-level MODS records in the source file: 4,656
# Total number of issue-level MODS records that need to be created: 189
#
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0" xpath-default-namespace="http://www.loc.gov/mods/v3">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:template match="/">
        <modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3">

            <xsl:for-each-group select="modsCollection/mods" group-by="relatedItem/part/detail[@type='volume']/number/text()">

                <xsl:for-each-group select="current-group()" group-by="relatedItem/part/detail[@type='issue']/number/text()">

                    <mods xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd">
                        <xsl:copy-of select="current-group( )[1]/relatedItem[1]/*"/>
                    </mods>

                </xsl:for-each-group>

            </xsl:for-each-group>

        </modsCollection>
    </xsl:template>

</xsl:stylesheet>
