<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE ORLANDO [ <!ENTITY % character_entities SYSTEM "http://cwrc.ca/schemas/character_entities.dtd"> %character_entities; ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:include href="lib_orlando_date_helper.xsl"/>

    <!--
    * extract the MODS information section from an 
    * Orlando biography or writing document
    * 
    * specifications: https://docs.google.com/a/ualberta.ca/document/d/1aGHGOxxsR9w65GDlKdxWBnNF5Y3Jl2RYlbFms_8Iiyo/edit
    *
    * final version stored in Orlando Delivery System DB
    
    -->

    <!-- input parameter, the name of the original XML (SGML) file) --> 
    <xsl:param name="param_original_filename" select="'xxxxxx-x.sgm'"/>


    <!-- root element - assumes start with an Orlando bio or writing document -->
    <xsl:template match="/">
        <mods 
            xmlns="http://www.loc.gov/mods/v3" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd"
            >

            <identifier type="local">
                <xsl:value-of select="$param_original_filename"/>
            </identifier>

            <titleInfo>
                <title>
                    <xsl:value-of
                        select="/(BIOGRAPHY|WRITING)/ORLANDOHEADER/FILEDESC/TITLESTMT/DOCTITLE/text()"
                    />
                </title>
            </titleInfo>

            <language>
                <languageTerm authority="iso639-2b" type="text">English</languageTerm>
            </language>

            <relatedItem>
                <titleInfo>
                    <title>Orlando: Women's Writing in the British Isles from the Beginnings to the Present</title>
                </titleInfo>
                <name type="personal">
                    <namePart type="given">Susan</namePart>
                    <namePart type="family">Brown</namePart>
                    <role>
                        <roleTerm authority="marcrelator" type="text">Editor</roleTerm>
                    </role>
                </name>
                <name type="personal">
                    <namePart type="given">Patricia</namePart>
                    <namePart type="family">Clements</namePart>
                    <role>
                        <roleTerm authority="marcrelator" type="text">Editor</roleTerm>
                    </role>
                </name>
                <name type="personal">
                    <namePart type="given">Isobel</namePart>
                    <namePart type="family">Grundy</namePart>
                    <role>
                        <roleTerm authority="marcrelator" type="text">Editor</roleTerm>
                    </role>
                </name>
            </relatedItem>

            <originInfo>
                <dateIssued encoding="w3cdtf">
                    <xsl:call-template name="convert_mla_to_iso">
                        <xsl:with-param name="INPUT_DATE" select="/(BIOGRAPHY|WRITING)/ORLANDOHEADER/REVISIONDESC/(RESPONSIBILITY[@WORKSTATUS='PUB' and @WORKVALUE='C'])[1]/DATE/text()" />
                    </xsl:call-template>
                </dateIssued>
                <publisher>Cambridge University Press</publisher>
                <place>
                    <placeTerm type="text">Cambridge</placeTerm>
                </place>
                <place>
                    <placeTerm type="text">United Kingdom</placeTerm>
                </place>
            </originInfo>

            <note type="researchNote">
                <xsl:value-of select="/(BIOGRAPHY|WRITING)/DIV0/STANDARD"/>
            </note>

            <location>
                <url>http://orlando.cambridge.org/</url>
            </location>

        </mods>

    </xsl:template>








</xsl:stylesheet>
