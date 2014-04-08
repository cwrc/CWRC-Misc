<?xml version="1.0" encoding="UTF-8"?>

<!-- Basic CWRC Entities - transform for Solr -->

<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:foxml="info:fedora/fedora-system:def/foxml#" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="mods"
    >

    <!-- this template used to help test  -->
    <!-- 
    <xsl:template match="/">
        <xsl:apply-templates select="/foxml:digitalObject/foxml:datastream[@ID='ORGANIZATION']/foxml:datastreamVersion[last()]/foxml:xmlContent"></xsl:apply-templates>
    </xsl:template>
    -->

    <!-- ********************************************************* -->
    <!-- CWRC ORGANIZATION Entity solr index Fedora Datastream -->
    <!-- ********************************************************* -->
    <xsl:template match="foxml:datastream[@ID='PLACE']/foxml:datastreamVersion[last()]" name="index_CWRC_PLACE_ENTITY">

        <xsl:param name="content" select="entity/place"></xsl:param>
        <xsl:param name="prefix" select="'cwrc_entity_'"></xsl:param>
        <xsl:param name="suffix" select="'_et'"></xsl:param>
        <!-- 'edged' (edge n-gram) text, for auto-completion -->

        <xsl:variable name="identity" select="$content/entity/place/identity" />
        <xsl:variable name="description" select="$content/entity/place/description" />
        <xsl:variable name="local_prefix" select="concat($prefix, 'place_')"></xsl:variable>

        <!-- ensure that the preferred name is first -->
        <xsl:apply-templates select="$identity/preferredForm">
            <xsl:with-param name="prefix" select="$local_prefix"></xsl:with-param>
            <xsl:with-param name="suffix" select="$suffix"></xsl:with-param>
        </xsl:apply-templates>

        <!-- Variant forms of the name -->
        <xsl:apply-templates select="$identity/variantForms">
            <xsl:with-param name="prefix" select="$local_prefix"></xsl:with-param>
            <xsl:with-param name="suffix" select="$suffix"></xsl:with-param>
        </xsl:apply-templates>

        <!-- Descriptive Geo Location - latitude and longitude -->
        <xsl:if test="$description/latitude and $description/longitude">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, 'geoloc', '_s')"></xsl:value-of>
                </xsl:attribute>

                <xsl:value-of select="concat($description/latitude, ',', $description/longitude)"></xsl:value-of>
            </field>
        </xsl:if>

        <!-- Descriptive Geo Location - country name -->
        <xsl:if test="$description/countryName">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, 'countryName', $suffix)"></xsl:value-of>
                </xsl:attribute>

                <xsl:value-of select="$description/countryName"></xsl:value-of>
            </field>
        </xsl:if>

        <!-- Descriptive Geo Location - first adminstrative division-->
        <xsl:if test="$description/firstAdministrativeDivision">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, 'firstAdministrativeDivision', $suffix)"></xsl:value-of>
                </xsl:attribute>

                <xsl:value-of select="$description/firstAdministrativeDivision"></xsl:value-of>
            </field>
        </xsl:if>

        <!-- Descriptive featureClass - -->
        <xsl:if test="$description/featureClass">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, 'featureClass', $suffix)"></xsl:value-of>
                </xsl:attribute>

                <xsl:value-of select="$description/featureClass"></xsl:value-of>
            </field>
        </xsl:if>

    </xsl:template>


    <!-- ********************************************************* -->
    <!-- CWRC ORGANIZATION Entity solr index Fedora Datastream -->
    <!-- ********************************************************* -->
    <xsl:template match="foxml:datastream[@ID='ORGANIZATION']/foxml:datastreamVersion[last()]" name="index_CWRC_ORGANIZATION_ENTITY">

        <xsl:param name="content" select="entity/organization"></xsl:param>
        <xsl:param name="prefix" select="'cwrc_entity_'"></xsl:param>
        <xsl:param name="suffix" select="'_et'"></xsl:param>
        <!-- 'edged' (edge n-gram) text, for auto-completion -->

        <xsl:variable name="identity" select="$content/entity/organization/identity" />
        <xsl:variable name="description" select="$content/entity/organization/description" />
        <xsl:variable name="local_prefix" select="concat($prefix, 'org_')"></xsl:variable>


        <!-- ensure that the preferred name is first -->
        <xsl:apply-templates select="$identity/preferredForm">
            <xsl:with-param name="prefix" select="$local_prefix"></xsl:with-param>
            <xsl:with-param name="suffix" select="$suffix"></xsl:with-param>
        </xsl:apply-templates>

        <!-- Variant forms of the name -->
        <xsl:apply-templates select="$identity/variantForms">
            <xsl:with-param name="prefix" select="$local_prefix"></xsl:with-param>
            <xsl:with-param name="suffix" select="$suffix"></xsl:with-param>
        </xsl:apply-templates>

    </xsl:template>



    <!-- ********************************************************* -->
    <!-- CWRC TITLE Entity solr index Fedora Datastream -->
    <!-- ********************************************************* -->
    <xsl:template match="foxml:datastream[@ID='TITLE']/foxml:datastreamVersion[last()]" name="index_CWRC_TITLE_ENTITY">

        <xsl:param name="content"></xsl:param> 
        <xsl:param name="prefix" select="'cwrc_entity_'"></xsl:param>
        <xsl:param name="suffix" select="'_et'"></xsl:param>
        <!-- 'edged' (edge n-gram) text, for auto-completion -->

        <xsl:variable name="identity" select="$content/mods:mods" />
        <xsl:variable name="local_prefix" select="concat($prefix, 'title_')"></xsl:variable>

        <!-- ensure that the preferred name is first -->
        <xsl:apply-templates select="$identity/mods:titleInfo">
            <xsl:with-param name="prefix" select="$local_prefix"></xsl:with-param>
            <xsl:with-param name="suffix" select="$suffix"></xsl:with-param>
        </xsl:apply-templates>

    </xsl:template>




    <!-- ********************************************************* -->
    <!-- CWRC PERSON Entity solr index Fedora Datastream -->
    <!-- ********************************************************* -->
    <xsl:template match="foxml:datastream[@ID='PERSON']/foxml:datastreamVersion[last()]" name="index_CWRC_PERSON_ENTITY">

        <xsl:param name="content" select="entity/person"></xsl:param>
        <xsl:param name="prefix" select="'cwrc_entity_'"></xsl:param>
        <xsl:param name="suffix" select="'_et'"></xsl:param>
        <!-- 'edged' (edge n-gram) text, for auto-completion -->

        <xsl:variable name="identity" select="$content/entity/person/identity" />
        <xsl:variable name="description" select="$content/entity/person/description" />
        <xsl:variable name="local_prefix" select="concat($prefix, 'name_')"></xsl:variable>

        <!-- ensure that the preferred name is first -->
        <xsl:apply-templates select="$identity/preferredForm">
            <xsl:with-param name="prefix" select="$local_prefix"></xsl:with-param>
            <xsl:with-param name="suffix" select="$suffix"></xsl:with-param>
        </xsl:apply-templates>

        <!-- Variant forms of the name -->
        <xsl:apply-templates select="$identity/variantForms">
            <xsl:with-param name="prefix" select="$local_prefix"></xsl:with-param>
            <xsl:with-param name="suffix" select="$suffix"></xsl:with-param>
        </xsl:apply-templates>

        <!-- Descriptive Birthdate -->
        <!-- assume all date types are Birth or Death -->
        <xsl:apply-templates select="$description/existDates">
            <xsl:with-param name="prefix" select="$local_prefix"></xsl:with-param>
            <xsl:with-param name="suffix" select="$suffix"></xsl:with-param>
        </xsl:apply-templates>

    </xsl:template>








    <!-- ********************************************************* -->
    <!-- HELPER Templates -->
    <!-- ********************************************************* -->

    <!-- CWRC Person perferred name forms -->
    <xsl:template match="preferredForm">
        <xsl:param name="prefix"></xsl:param>
        <xsl:param name="suffix"></xsl:param>

        <field>
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, 'preferredForm', $suffix)"></xsl:value-of>
            </xsl:attribute>

            <xsl:call-template name="assemble_cwrc_person_name"></xsl:call-template>
        </field>

    </xsl:template>


    <!-- CWRC Person variant name forms -->
    <xsl:template match="variantForms">
        <xsl:param name="prefix"></xsl:param>
        <xsl:param name="suffix"></xsl:param>

        <xsl:for-each select="variant">

            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, 'variantForm', $suffix)"></xsl:value-of>
                </xsl:attribute>

                <xsl:call-template name="assemble_cwrc_person_name"></xsl:call-template>
            </field>

        </xsl:for-each>

    </xsl:template>


    <!-- Descriptive Birthdate -->
    <!-- assume all date types are Birth or Death -->
    <xsl:template match="existDates">
        <xsl:param name="prefix"></xsl:param>
        <xsl:param name="suffix"></xsl:param>

        <!-- birth date -->
        <xsl:variable name="var_birthDate" select="(dateRange/fromDate|dateRange/toDate|dateSingle)[child::dateType/text()='birth']/standardDate"></xsl:variable>

        <xsl:if test="$var_birthDate">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, 'birthDate', '_s')"></xsl:value-of>
                </xsl:attribute>
                <xsl:value-of select="$var_birthDate"></xsl:value-of>
            </field>
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, 'birthDate', '_dt')"></xsl:value-of>
                </xsl:attribute>
                <xsl:value-of select="$var_birthDate"></xsl:value-of>
            </field>
        </xsl:if>

        <!-- death date -->
        <xsl:variable name="var_deathDate" select="(dateRange/fromDate|dateRange/toDate|dateSingle)[child::dateType/text()='death']/standardDate"></xsl:variable>

        <xsl:if test="$var_deathDate">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, 'deathDate', '_s')"></xsl:value-of>
                </xsl:attribute>
                <xsl:value-of select="$var_deathDate"></xsl:value-of>
            </field>
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, 'deathDate', '_dt')"></xsl:value-of>
                </xsl:attribute>
                <xsl:value-of select="$var_deathDate"></xsl:value-of>
            </field>
        </xsl:if>


    </xsl:template>


    <!-- assemble the person name from the component parts, if necessary -->
    <xsl:template name="assemble_cwrc_person_name">
        <!-- does a surname exist -->
        <xsl:variable name="is_surname_present" select="namePart/@partType='surname'"></xsl:variable>
        <!-- does a forename exist -->
        <xsl:variable name="is_forename_present" select="namePart/@partType='forename'"></xsl:variable>
        <xsl:variable name="is_display_label" select="identity/displayLabel"></xsl:variable>


        <xsl:choose>
            <!-- displayLabel -->
            <xsl:when test="$is_display_label">
                <xsl:value-of select="normalize-space($is_display_label)"></xsl:value-of>
            </xsl:when>
            <!-- surname and forename -->
            <xsl:when test="$is_surname_present or $is_forename_present">
                <xsl:if test="$is_forename_present">
                    <xsl:value-of select="normalize-space(namePart[@partType='forename']/text())"></xsl:value-of>
                </xsl:if>
                <xsl:if test="$is_forename_present and $is_surname_present">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:if test="$is_surname_present">
                    <xsl:value-of select="normalize-space(namePart[@partType='surname']/text())"></xsl:value-of>
                </xsl:if>
            </xsl:when>
            <!-- namePart -->
            <xsl:when test="namePart">
                <xsl:value-of select="normalize-space(namePart)"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- CWRC Person perferred name forms -->
    <xsl:template match="mods:titleInfo">
        <xsl:param name="prefix"></xsl:param>
        <xsl:param name="suffix"></xsl:param>

        <field>
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, 'preferredForm', $suffix)"></xsl:value-of>
            </xsl:attribute>

            <xsl:call-template name="assemble_cwrc_preferred_title"></xsl:call-template>
        </field>

    </xsl:template>



    <!-- assemble the preferred MODS TITLE -->
    <xsl:template name="assemble_cwrc_preferred_title">
        <xsl:choose>
        <xsl:when test="not(@type) and mods:title">
            <xsl:value-of select="mods:title"/>
        </xsl:when>
        <xsl:when test="not(@type) and @usage='primary' and mods:title ">
            <xsl:value-of select="mods:title"/>
        </xsl:when>
        <xsl:when test="@type='alternative' or @type='abbreviated' or @type='translated' or @type='uniform'">
            <!-- multiple titles, don't use type='alternative' -->
        </xsl:when>
        <xsl:otherwise> 
        </xsl:otherwise >
        </xsl:choose>
    </xsl:template>



</xsl:stylesheet>
