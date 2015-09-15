<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:mods="http://www.loc.gov/mods/v3">

    <!--
        * given a collection of CWRC Orlando freestanding events 
        * split it into several individual files and save to disk
        * with each file containing an individual CWRC Orlando freestanding event
        *
        * edit VAR_FILENAME_PREFIX to reflect the path to write the files
    -->

    <xsl:output encoding="UTF-8" method="xml" indent="yes" omit-xml-declaration="no" xml:space="default"/>


    <xsl:strip-space elements="*"/>
    <!-- MRB: set prefix for Orlando event file name -->
    <xsl:variable name="VAR_FILENAME_PREFIX" select="'data/EID_'"/>

    <xsl:template match="/">
        <xsl:apply-templates select="eventsCollection/EVENT"/>
    </xsl:template>

    <xsl:template match="EVENT">


        <xsl:variable name="VAR_FILENAME_SUFFIX">
            <xsl:text>.xml</xsl:text>
        </xsl:variable>
        <!-- MRB: changed so that prints out EID number instead of sequential number -->
        <xsl:variable name="filename" select="concat($VAR_FILENAME_PREFIX, @EID, $VAR_FILENAME_SUFFIX )"/>


        <xsl:result-document indent="yes" href="{$filename}" omit-xml-declaration="no" encoding="UTF-8" method="xml">

            <!-- MRB: set Orlando event schema location -->
            <xsl:processing-instruction name="xml-model">href="http://cwrc.ca/schemas/orlando_event_v2.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
            <!-- MRB: set Orlando event stylesheet location -->
            <xsl:processing-instruction name="xml-stylesheet">type="text/css" href="http://cwrc.ca/templates/css/orlando.css"</xsl:processing-instruction>

            <!-- line feed character -->
            <xsl:text>&#x0A;</xsl:text>

            <xsl:copy-of select="." copy-namespaces="no"/>

        </xsl:result-document>

    </xsl:template>

</xsl:stylesheet>
