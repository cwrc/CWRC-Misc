<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:title="org.ualberta.arc.mergecwrc.xslt.XSLTTitle"
                version="2.0"
                exclude-result-prefixes="fn">
    
    <xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>    
    
    <xsl:template match="/canwwrfrom1950_production">
        <modsCollectionDefinition>
            <xsl:for-each select="works">
                <xsl:variable name="allTitles" select="title:extractTitles(name)"/>
                <xsl:variable name="category_id" select="category_id"/>
                <xsl:variable name="creator_id" select="creator_id"/>
                
                <mods>
                    <genre authority="cwrc:entity">work</genre>
                    <genre authority="canwwr">
                        <xsl:value-of select="/canwwrfrom1950_production/categories[id = $category_id]/name"/>
                    </genre>
                    <xsl:for-each select="title:groupByGenre($allTitles/genre)">
                        <genre authority="tei:level">
                            <xsl:value-of select="."/>
                        </genre>
                    </xsl:for-each>
                    
                    <titleInfo>
                        <xsl:for-each select="$allTitles">
                            <xsl:choose>
                                <xsl:when test="@isAlternative = 'true'">
                                
                                    <title type="alternative">
                                        <xsl:value-of select="title"/>
                                    </title>
                                
                                </xsl:when>
                                <xsl:otherwise>
                                    <title>
                                        <xsl:value-of select="title"/>
                                    </title>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </titleInfo>
                    <name>
                        <namePart>
                            <xsl:value-of select="/canwwrfrom1950_production/creators[id = $creator_id]/name"/>
                        </namePart>
                    </name>
                
                    <originInfo>
                        <dateIssued>
                            <xsl:value-of select="year"/>
                        </dateIssued>
                    </originInfo>
                   
                   <recordInfo>
                       <recordOrigin>Canadian Women Writers from 1950</recordOrigin>
                       <recordOrigin>canwwr</recordOrigin>
                       <recordIdentifier source="canwwr"><xsl:value-of select="id"/></recordIdentifier>
                   </recordInfo>
                   
                    <xsl:for-each select="$allTitles">
                        <xsl:for-each select="notes/note">
                            <note>
                                <xsl:value-of select="."/>
                            </note>
                        </xsl:for-each>
                    </xsl:for-each>
                </mods>
            </xsl:for-each>
            <xsl:for-each select="criticalstudies">
                <xsl:variable name="allCritics" select="title:extractCriticNames(criticname)"/>
                
                <mods>
                    <genre authority="cwrc:entity">work</genre>
                    <genre authority="canwwr">critical study</genre>
                    <genre authority="tei:level">a</genre>
                    <xsl:if test="articletitle != ''">
                        <titleInfo>
                            <title>
                                <xsl:value-of select="title:removeItalic(articletitle)"/>
                            </title>
                        </titleInfo>
                    </xsl:if>
                    <xsl:if test="book_periodical_title != ''">
                        <xsl:choose>
                            <xsl:when test="articletitle != ''">
                                <relatedItem type="host">
                                    <titleInfo>
                                        <title>
                                            <xsl:value-of select="title:addToTitleList(title:removeItalic(book_periodical_title))"/>
                                        </title>
                                    </titleInfo>
                                </relatedItem>
                            </xsl:when>
                            <xsl:otherwise>
                                <titleInfo>
                                    <title>
                                        <xsl:value-of select="title:removeItalic(book_periodical_title)"/>
                                    </title>
                                </titleInfo>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:for-each select="$allCritics">
                        <name>
                            <namePart>
                                <xsl:value-of select="namePart"/>
                            </namePart>
                            <xsl:if test="role">
                                <role>
                                    <roleTerm>
                                        <xsl:value-of select="role/roleTerm"/>
                                    </roleTerm>
                                </role>
                            </xsl:if>
                        </name>
                    </xsl:for-each>
                    <originInfo>
                        <dateIssued>
                            <xsl:value-of select="year"/>
                        </dateIssued>
                        <place>
                            <placeTerm>
                                <xsl:value-of select="title:getPlace(publishing_information)"/>
                            </placeTerm>
                        </place>
                    </originInfo>
                    
                    <recordInfo>
                       <recordOrigin>Canadian Women Writers from 1950</recordOrigin>
                       <recordOrigin>canwwr</recordOrigin>
                       <recordIdentifier source="canwwr"><xsl:value-of select="id"/></recordIdentifier>
                   </recordInfo>
                </mods>
            </xsl:for-each>
            <xsl:for-each select="periodsandthemes">
                <mods>
                    <genre authority="cwrc:entity">work</genre>
                    <genre authority="tei:level">m</genre>
                    <titleInfo>
                        <title>
                            <xsl:value-of select="title:removeItalic(name)"/>
                        </title>
                    </titleInfo>
                    
                    <recordInfo>
                       <recordOrigin>Canadian Women Writers from 1950</recordOrigin>
                       <recordOrigin>canwwr</recordOrigin>
                       <recordIdentifier source="canwwr"><xsl:value-of select="id"/></recordIdentifier>
                   </recordInfo>
                </mods>
            </xsl:for-each>
            <xsl:variable name="host_works" select="title:getTitleList()"/>
            <xsl:for-each select="$host_works">
                <mods>
                    <genre authority="cwrc:entity">work</genre>
                    <genre authority="tei:level">m</genre>
                    <titleInfo>
                        <title>
                            <xsl:value-of select="."/>
                        </title>
                    </titleInfo>
                    
                    <recordInfo>
                       <recordOrigin>Canadian Women Writers from 1950</recordOrigin>
                       <recordOrigin>canwwr</recordOrigin>
                   </recordInfo>
                </mods>
            </xsl:for-each>
        </modsCollectionDefinition>
    </xsl:template>
</xsl:stylesheet>