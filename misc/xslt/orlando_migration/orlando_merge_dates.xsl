<?xml version="1.0" encoding="UTF-8"?>

<!--
    MRB: Wed 14-Jan-2015
    - XSLT to merge dates information (birth date and death date) for an individual in the Orlando catalog XML file with the matching
    individual in the Orlando authority XML file.
    - Two input XML files: catalog-output.xml, and authorities-output.xml.  Both input files were created using Mark McKellar's XSLT
    conversion files from his conversion-merging application, and the source files for the Orlando authorities file and catalog file were
    obtained from the CWRC GPU account; there are three source authority files, and one source catalog file.
    - The three source authority files were concatenated into one file, and 20 duplicate names were removed.  After conversion of
    the authority file into an authority person entity file, the one-tailed <existDates/> tags were removed.
    - To run this XSLT, open authorities-output.xml in Oxygen, and then apply this XSLT (orlando_merge_dates.xsl) transformation
    scenario.  The resulting output file will have 6 validation errors.  These six validation errors are caused by records with two
    <existDates> elements, one supplied by the authorities-output.xml file, and the other supplied by the catalog-output.xml file;
    delete the 6 <existDates> supplied by the catalog-output.xml file, i.e., the second <existDates> element in the affected records.
-->

<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="file2" select="'catalog-output.xml'"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="description">
        <xsl:variable name="variantNameFile1" select="../identity/variantForms/variant[authorizedBy/projectId/text()='orlando']/namePart/text()"/>
        <xsl:copy>
            <xsl:copy-of select="document($file2)/cwrc/entity/person[$variantNameFile1=identity/variantForms/variant[authorizedBy/projectId/text()='orlando']/namePart/text()]/description/existDates"/>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:transform>
