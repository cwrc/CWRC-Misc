<?xml version="1.0" encoding="UTF-8"?>

<!--
    MRB: Tue 17-May-2016
    - XSLT to convert "TEI all" schema conformant documents to "CWRC TEI Lite"
    conformant documents.
    - Only the core elements and attributes that are typically present when a
    Project Gutenberg text is converted into a "TEI all" document using the Gutentag
    program are addressed, so some post-conversion tweaking of the document may be
    required, using the Oxygen XML Editor to find validation errors.
    - Run this XSLT using the Oxygen XML Editor on the source file to be converted. 
    - Ingest the file into the CWRC repository and into a collection that is associated
    with the CWRC Document CModel (i.e., cwrc:documentCModel).
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <!-- Remove any white-space-only text nodes -->
    <xsl:strip-space elements="*"/>

    <!-- Match the whole source document -->
    <xsl:template match="/">
        <!-- Add processing instruction statements -->
        <xsl:processing-instruction name="xml-model">
           <xsl:text>href="http://cwrc.ca/schemas/cwrc_tei_lite.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
        </xsl:processing-instruction>
        <xsl:processing-instruction name="xml-stylesheet">
        <xsl:text>type="text/css" href="http://cwrc.ca/templates/css/tei.css"</xsl:text>
        </xsl:processing-instruction>
        <!-- Call identity transform -->
        <xsl:call-template name="identity-transform"/>
    </xsl:template>

    <!-- Perform identity transform -->
    <xsl:template match="@*|node()" name="identity-transform">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Create and copy elements -->
    <xsl:template match="/TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/title">
        <titleStmt>
            <title>
                <xsl:apply-templates select="@*|node()"/>
            </title>
            <xsl:copy-of select="../author"/>
        </titleStmt>
    </xsl:template>

    <!-- Rename elements -->
    <xsl:template match="/TEI/teiHeader/fileDesc/titleStmt/respStmt/resp/link">
        <ref>
            <xsl:apply-templates select="@*|node()"/>
        </ref>
    </xsl:template>
    <xsl:template match="/TEI/teiHeader/fileDesc/sourceDesc/biblStruct">
        <biblFull>
            <xsl:apply-templates select="@*|node()"/>
        </biblFull>
    </xsl:template>
    <xsl:template match="/TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/imprint">
        <publicationStmt>
            <xsl:apply-templates select="@*|node()"/>
        </publicationStmt>
    </xsl:template>

    <!-- Delete element tag but keep descendant nodes -->
    <xsl:template match="/TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>

    <!-- Delete element tag but keep text node -->
    <xsl:template match="/TEI/text/body/p/span">
        <xsl:apply-templates select="text()"/>
    </xsl:template>

    <!-- Delete elements and their descendants -->
    <xsl:template match="/TEI/teiHeader/profileDesc/particDesc"/>
    <xsl:template match="/TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/author"/>
    <xsl:template match="/TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/imprint/pubPlace"/>

</xsl:stylesheet>
