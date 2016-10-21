<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# MRB: Fri 21-Oct-2016

# Purpose: XSLT stylesheet to transform CanWWR MySQL critical studies bibliographic data to MODS records
#
# * Source MySQL database characteristics:
# - 28 tables; and
# - 9 of these tables contain critical studies data.
#
# * Intermediate source Microsoft Excel spreadsheet characteristics:
# - 109 columns, fields, or variables in the header row; and
# - 2,082 data rows, lines, or records.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:template match="/">

        <modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- if id field has content, then process record -->
            <xsl:apply-templates select="root/record[normalize-space(id)]"/>

        </modsCollection>

    </xsl:template>

    <xsl:template match="record">

        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- titleInfo element -->
            <!-- book chapter, or periodical article -->
            <xsl:if test="normalize-space(articletitle) != '' and normalize-space(book_periodical_title) != ''">
                <titleInfo>
                    <title>
                        <xsl:value-of select="normalize-space(articletitle)"/>
                    </title>
                </titleInfo>
            </xsl:if>
            <!-- book -->
            <xsl:if test="normalize-space(articletitle) = '' and normalize-space(book_periodical_title) != ''">
                <titleInfo>
                    <title>
                        <xsl:value-of select="normalize-space(book_periodical_title)"/>
                    </title>
                </titleInfo>
            </xsl:if>

            <!-- name element -->
            <!-- book, book chapter, or periodical article -->
            <!-- first author -->
            <xsl:if test="normalize-space(criticname_surname_1) != ''">
                <name type="personal">
                    <namePart type="family">
                        <xsl:value-of select="normalize-space(criticname_surname_1)"/>
                    </namePart>
                    <xsl:if test="normalize-space(criticname_given_name_1) != ''">
                        <namePart type="given">
                            <xsl:value-of select="normalize-space(criticname_given_name_1)"/>
                        </namePart>
                    </xsl:if>
                    <xsl:if test="normalize-space(criticname_role_1) != ''">
                        <role>
                            <roleTerm type="text" authority="marcrealtor">
                                <xsl:value-of select="normalize-space(criticname_role_1)"/>
                            </roleTerm>
                        </role>
                    </xsl:if>
                </name>
            </xsl:if>
            <!-- second author -->
            <xsl:if test="normalize-space(criticname_surname_2) != ''">
                <name type="personal">
                    <namePart type="family">
                        <xsl:value-of select="normalize-space(criticname_surname_2)"/>
                    </namePart>
                    <xsl:if test="normalize-space(criticname_given_name_2) != ''">
                        <namePart type="given">
                            <xsl:value-of select="normalize-space(criticname_given_name_2)"/>
                        </namePart>
                    </xsl:if>
                    <xsl:if test="normalize-space(criticname_role_2) != ''">
                        <role>
                            <roleTerm type="text" authority="marcrealtor">
                                <xsl:value-of select="normalize-space(criticname_role_2)"/>
                            </roleTerm>
                        </role>
                    </xsl:if>
                </name>
            </xsl:if>
            <!-- third author -->
            <xsl:if test="normalize-space(criticname_surname_3) != ''">
                <name type="personal">
                    <namePart type="family">
                        <xsl:value-of select="normalize-space(criticname_surname_3)"/>
                    </namePart>
                    <xsl:if test="normalize-space(criticname_given_name_3) != ''">
                        <namePart type="given">
                            <xsl:value-of select="normalize-space(criticname_given_name_3)"/>
                        </namePart>
                    </xsl:if>
                    <xsl:if test="normalize-space(criticname_role_3) != ''">
                        <role>
                            <roleTerm type="text" authority="marcrealtor">
                                <xsl:value-of select="normalize-space(criticname_role_3)"/>
                            </roleTerm>
                        </role>
                    </xsl:if>
                </name>
            </xsl:if>

            <!-- typeOfResource element -->
            <!-- book, book chapter, or periodical article -->
            <typeOfResource>text</typeOfResource>

            <!-- genre element -->
            <!-- book, book chapter, or periodical article -->
            <xsl:if test="normalize-space(category_1) != ''">
                <genre authority="canwwr">
                    <xsl:value-of select="normalize-space(category_1)"/>
                </genre>
            </xsl:if>
            <xsl:if test="normalize-space(category_2) != ''">
                <genre authority="canwwr">
                    <xsl:value-of select="normalize-space(category_2)"/>
                </genre>
            </xsl:if>
            <xsl:if test="normalize-space(category_3) != ''">
                <genre authority="canwwr">
                    <xsl:value-of select="normalize-space(category_3)"/>
                </genre>
            </xsl:if>
            <xsl:if test="normalize-space(category_4) != ''">
                <genre authority="canwwr">
                    <xsl:value-of select="normalize-space(category_4)"/>
                </genre>
            </xsl:if>
            <xsl:if test="normalize-space(category_5) != ''">
                <genre authority="canwwr">
                    <xsl:value-of select="normalize-space(category_5)"/>
                </genre>
            </xsl:if>
            <xsl:if test="normalize-space(category_6) != ''">
                <genre authority="canwwr">
                    <xsl:value-of select="normalize-space(category_6)"/>
                </genre>
            </xsl:if>
            <xsl:if test="normalize-space(category_7) != ''">
                <genre authority="canwwr">
                    <xsl:value-of select="normalize-space(category_7)"/>
                </genre>
            </xsl:if>
            <xsl:if test="normalize-space(category_8) != ''">
                <genre authority="canwwr">
                    <xsl:value-of select="normalize-space(category_8)"/>
                </genre>
            </xsl:if>

            <!-- originInfo element -->
            <!-- book -->
            <xsl:if test="normalize-space(articletitle) = '' and normalize-space(book_periodical_title) != ''">
                <originInfo eventType="publication">
                    <!-- place of publication -->
                    <xsl:if test="normalize-space(place_of_publication) != ''">
                        <place>
                            <placeTerm type="text">
                                <xsl:value-of select="normalize-space(place_of_publication)"/>
                            </placeTerm>
                        </place>
                    </xsl:if>
                    <!-- publisher -->
                    <xsl:if test="normalize-space(publisher) != ''">
                        <publisher>
                            <xsl:value-of select="normalize-space(publisher)"/>
                        </publisher>
                    </xsl:if>
                    <!-- date of publication -->
                    <xsl:if test="normalize-space(year) != '' and normalize-space(year_range_end) = ''">
                        <dateIssued encoding="w3cdtf">
                            <xsl:value-of select="normalize-space(year)"/>
                        </dateIssued>
                    </xsl:if>
                    <xsl:if test="normalize-space(year) != '' and normalize-space(year_range_end) != ''">
                        <dateIssued encoding="w3cdtf" point="start">
                            <xsl:value-of select="normalize-space(year)"/>
                        </dateIssued>
                        <dateIssued encoding="w3cdtf" point="end">
                            <xsl:value-of select="normalize-space(year_range_end)"/>
                        </dateIssued>
                    </xsl:if>
                    <!-- edition -->
                    <xsl:if test="normalize-space(edition) != ''">
                        <edition>
                            <xsl:value-of select="normalize-space(edition)"/>
                        </edition>
                    </xsl:if>
                    <issuance>monographic</issuance>
                </originInfo>
            </xsl:if>

            <!-- subject element -->
            <!-- book, book chapter, or periodical article -->
            <!-- subject topic -->
            <xsl:if test="normalize-space(theme_1) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_1)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_2) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_2)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_3) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_3)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_4) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_4)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_5) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_5)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_6) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_6)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_7) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_7)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_8) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_8)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_9) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_9)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_10) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_10)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_11) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_11)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_12) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_12)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_13) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_13)"/>
                    </topic>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(theme_14) != ''">
                <subject authority="local">
                    <topic>
                        <xsl:value-of select="normalize-space(theme_14)"/>
                    </topic>
                </subject>
            </xsl:if>
            <!-- subject temporal -->
            <xsl:if test="normalize-space(period_1) != ''">
                <subject authority="local">
                    <temporal>
                        <xsl:value-of select="normalize-space(period_1)"/>
                    </temporal>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(period_2) != ''">
                <subject authority="local">
                    <temporal>
                        <xsl:value-of select="normalize-space(period_2)"/>
                    </temporal>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(period_3) != ''">
                <subject authority="local">
                    <temporal>
                        <xsl:value-of select="normalize-space(period_3)"/>
                    </temporal>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(period_4) != ''">
                <subject authority="local">
                    <temporal>
                        <xsl:value-of select="normalize-space(period_4)"/>
                    </temporal>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(period_5) != ''">
                <subject authority="local">
                    <temporal>
                        <xsl:value-of select="normalize-space(period_5)"/>
                    </temporal>
                </subject>
            </xsl:if>
            <!-- subject titleInfo -->
            <xsl:if test="normalize-space(text_1) != ''">
                <subject>
                    <titleInfo authority="local">
                        <title>
                            <xsl:value-of select="normalize-space(text_1)"/>
                        </title>
                    </titleInfo>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(text_2) != ''">
                <subject>
                    <titleInfo authority="local">
                        <title>
                            <xsl:value-of select="normalize-space(text_2)"/>
                        </title>
                    </titleInfo>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(text_3) != ''">
                <subject>
                    <titleInfo authority="local">
                        <title>
                            <xsl:value-of select="normalize-space(text_3)"/>
                        </title>
                    </titleInfo>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(text_4) != ''">
                <subject>
                    <titleInfo authority="local">
                        <title>
                            <xsl:value-of select="normalize-space(text_4)"/>
                        </title>
                    </titleInfo>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(text_5) != ''">
                <subject>
                    <titleInfo authority="local">
                        <title>
                            <xsl:value-of select="normalize-space(text_5)"/>
                        </title>
                    </titleInfo>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(text_6) != ''">
                <subject>
                    <titleInfo authority="local">
                        <title>
                            <xsl:value-of select="normalize-space(text_6)"/>
                        </title>
                    </titleInfo>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(text_7) != ''">
                <subject>
                    <titleInfo authority="local">
                        <title>
                            <xsl:value-of select="normalize-space(text_7)"/>
                        </title>
                    </titleInfo>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(text_8) != ''">
                <subject>
                    <titleInfo authority="local">
                        <title>
                            <xsl:value-of select="normalize-space(text_8)"/>
                        </title>
                    </titleInfo>
                </subject>
            </xsl:if>
            <!-- subject name -->
            <xsl:if test="normalize-space(creator_1) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_1)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_2) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_2)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_3) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_3)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_4) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_4)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_5) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_5)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_6) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_6)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_7) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_7)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_8) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_8)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_9) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_9)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_10) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_10)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_11) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_11)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_12) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_12)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_13) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_13)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_14) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_14)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_15) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_15)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_16) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_16)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_17) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_17)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_18) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_18)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_19) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_19)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_20) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_20)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_21) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_21)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_22) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_22)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_23) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_23)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_24) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_24)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_25) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_25)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_26) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_26)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_27) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_27)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_28) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_28)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_29) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_29)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_30) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_30)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_31) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_31)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_32) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_32)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_33) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_33)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_34) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_34)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_35) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_35)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>
            <xsl:if test="normalize-space(creator_36) != ''">
                <subject>
                    <name authority="local">
                        <namePart>
                            <xsl:value-of select="normalize-space(creator_36)"/>
                        </namePart>
                    </name>
                </subject>
            </xsl:if>

            <!-- relatedItem element -->
            <!-- book chapter -->
            <xsl:if test="normalize-space(articletitle) != '' and normalize-space(book_periodical_title) != '' and normalize-space(type_criticalstudy) = '0'">
                <relatedItem type="host">
                    <!-- book title -->
                    <xsl:if test="normalize-space(book_periodical_title) != ''">
                        <titleInfo>
                            <title>
                                <xsl:value-of select="normalize-space(book_periodical_title)"/>
                            </title>
                        </titleInfo>
                    </xsl:if>
                    <!-- first editor -->
                    <xsl:if test="normalize-space(book_editor_surname_1) != ''">
                        <name type="personal">
                            <namePart type="family">
                                <xsl:value-of select="normalize-space(book_editor_surname_1)"/>
                            </namePart>
                            <xsl:if test="normalize-space(book_editor_given_name_1) != ''">
                                <namePart type="given">
                                    <xsl:value-of select="normalize-space(book_editor_given_name_1)"/>
                                </namePart>
                            </xsl:if>
                            <role>
                                <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                            </role>
                        </name>
                    </xsl:if>
                    <!-- second editor -->
                    <xsl:if test="normalize-space(book_editor_surname_2) != ''">
                        <name type="personal">
                            <namePart type="family">
                                <xsl:value-of select="normalize-space(book_editor_surname_2)"/>
                            </namePart>
                            <xsl:if test="normalize-space(book_editor_given_name_2) != ''">
                                <namePart type="given">
                                    <xsl:value-of select="normalize-space(book_editor_given_name_2)"/>
                                </namePart>
                            </xsl:if>
                            <role>
                                <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                            </role>
                        </name>
                    </xsl:if>
                    <!-- third editor -->
                    <xsl:if test="normalize-space(book_editor_surname_3) != ''">
                        <name type="personal">
                            <namePart type="family">
                                <xsl:value-of select="normalize-space(book_editor_surname_3)"/>
                            </namePart>
                            <xsl:if test="normalize-space(book_editor_given_name_3) != ''">
                                <namePart type="given">
                                    <xsl:value-of select="normalize-space(book_editor_given_name_3)"/>
                                </namePart>
                            </xsl:if>
                            <role>
                                <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                            </role>
                        </name>
                    </xsl:if>
                    <!-- fourth editor -->
                    <xsl:if test="normalize-space(book_editor_surname_4) != ''">
                        <name type="personal">
                            <namePart type="family">
                                <xsl:value-of select="normalize-space(book_editor_surname_4)"/>
                            </namePart>
                            <xsl:if test="normalize-space(book_editor_given_name_4) != ''">
                                <namePart type="given">
                                    <xsl:value-of select="normalize-space(book_editor_given_name_4)"/>
                                </namePart>
                            </xsl:if>
                            <role>
                                <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                            </role>
                        </name>
                    </xsl:if>
                    <!-- origin information -->
                    <originInfo eventType="publication">
                        <!-- place of publication -->
                        <xsl:if test="normalize-space(place_of_publication) != ''">
                            <place>
                                <placeTerm type="text">
                                    <xsl:value-of select="normalize-space(place_of_publication)"/>
                                </placeTerm>
                            </place>
                        </xsl:if>
                        <!-- publisher -->
                        <xsl:if test="normalize-space(publisher) != ''">
                            <publisher>
                                <xsl:value-of select="normalize-space(publisher)"/>
                            </publisher>
                        </xsl:if>
                        <!-- date of publication -->
                        <xsl:if test="normalize-space(year) != '' and (normalize-space(year_range_end) = '')">
                            <dateIssued encoding="marc">
                                <xsl:value-of select="normalize-space(year)"/>
                            </dateIssued>
                        </xsl:if>
                        <xsl:if test="normalize-space(year) != '' and (normalize-space(year_range_end) != '')">
                            <dateIssued encoding="marc" point="start">
                                <xsl:value-of select="normalize-space(year)"/>
                            </dateIssued>
                            <dateIssued encoding="marc" point="end">
                                <xsl:value-of select="normalize-space(year_range_end)"/>
                            </dateIssued>
                        </xsl:if>
                        <!-- edition -->
                        <xsl:if test="normalize-space(edition) != ''">
                            <edition>
                                <xsl:value-of select="normalize-space(edition)"/>
                            </edition>
                        </xsl:if>
                        <!-- issuance -->
                        <issuance>monographic</issuance>
                    </originInfo>
                    <!-- enumeration -->
                    <xsl:if test="normalize-space(volume) != '' or normalize-space(page_numbers) != ''">
                        <part>
                            <!-- volume -->
                            <xsl:if test="normalize-space(volume) != ''">
                                <detail type="volume">
                                    <number>
                                        <xsl:value-of select="normalize-space(volume)"/>
                                    </number>
                                </detail>
                            </xsl:if>
                            <!-- pagination -->
                            <xsl:if test="normalize-space(page_numbers) != ''">
                                <extent unit="pages">
                                    <list>
                                        <xsl:value-of select="normalize-space(page_numbers)"/>
                                    </list>
                                </extent>
                            </xsl:if>
                        </part>
                    </xsl:if>
                </relatedItem>
            </xsl:if>
            <!-- periodical article -->
            <xsl:if test="normalize-space(articletitle) != '' and normalize-space(book_periodical_title) != '' and normalize-space(type_criticalstudy) = '1'">
                <relatedItem type="host">
                    <!-- periodical title -->
                    <xsl:if test="normalize-space(book_periodical_title) != ''">
                        <titleInfo>
                            <title>
                                <xsl:value-of select="normalize-space(book_periodical_title)"/>
                            </title>
                        </titleInfo>
                    </xsl:if>
                    <!-- origin information -->
                    <originInfo>
                        <!-- issuance -->
                        <issuance>continuing</issuance>
                    </originInfo>
                    <!-- enumeration -->
                    <xsl:if test="normalize-space(volume) != '' or normalize-space(issue) != '' or normalize-space(page_numbers) != ''">
                        <part>
                            <!-- volume -->
                            <xsl:if test="normalize-space(volume) != ''">
                                <detail type="volume">
                                    <number>
                                        <xsl:value-of select="normalize-space(volume)"/>
                                    </number>
                                </detail>
                            </xsl:if>
                            <!-- issue -->
                            <xsl:if test="normalize-space(issue) != ''">
                                <detail type="issue">
                                    <number>
                                        <xsl:value-of select="normalize-space(issue)"/>
                                    </number>
                                </detail>
                            </xsl:if>
                            <!-- pagination -->
                            <xsl:if test="normalize-space(page_numbers) != ''">
                                <extent unit="pages">
                                    <list>
                                        <xsl:value-of select="normalize-space(page_numbers)"/>
                                    </list>
                                </extent>
                            </xsl:if>
                            <!-- date -->
                            <xsl:if test="normalize-space(year) != '' and normalize-space(year_range_end) = ''">
                                <date encoding="w3cdtf">
                                    <xsl:value-of select="normalize-space(year)"/>
                                </date>
                            </xsl:if>
                            <xsl:if test="normalize-space(year) != '' and normalize-space(year_range_end) != ''">
                                <date encoding="w3cdtf" point="start">
                                    <xsl:value-of select="normalize-space(year)"/>
                                </date>
                                <date encoding="w3cdtf" point="end">
                                    <xsl:value-of select="normalize-space(year_range_end)"/>
                                </date>
                            </xsl:if>
                        </part>
                    </xsl:if>
                </relatedItem>
            </xsl:if>

            <!-- accessCondition element -->
            <!-- book, book chapter, or periodical article -->
            <accessCondition type="use and reproduction">This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">Creative Commons Attribution-NonCommercial-ShareAlike 4.0
                    International License</a> (CC BY-NC-SA 4.0).</accessCondition>

            <!-- recordInfo element -->
            <!-- book, book chapter, or periodical article -->
            <recordInfo>
                <recordContentSource>Canadian Women Writing and Reading from 1950, University of
                    Alberta</recordContentSource>
                <recordContentSource>Canadian Writing Research Collaboratory</recordContentSource>
                <recordCreationDate encoding="w3cdtf">
                    <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                </recordCreationDate>
                <recordOrigin>Bibliographic data were originally in a MySQL database; then converted
                    to a Microsoft Excel spreadsheet using a series of data processing operations;
                    then transformed into a basic XML file using an AWK script; then transformed
                    into a MODS XML collection file using an XSLT stylesheet; and then split into
                    individual MODS XML files using an XSLT stylesheet.</recordOrigin>
                <languageOfCataloging>
                    <languageTerm type="text">English</languageTerm>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                    <scriptTerm type="text">Latin</scriptTerm>
                    <scriptTerm type="code" authority="iso15924">Latn</scriptTerm>
                </languageOfCataloging>
            </recordInfo>

        </mods>

    </xsl:template>

</xsl:stylesheet>
