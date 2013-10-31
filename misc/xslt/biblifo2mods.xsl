<?xml version="1.0" encoding="UTF-8"?>
<!-- 
        * - Coder: MRB
        * - Created: Fri 03-May-2013
        * - Modified: Wed 22-May-2013
        * - Last modified: Fri 26-Jul-2013
        * - Purpose: XSLT stylesheet to transform the BIBLIFO FileMaker Pro database data dump to MODS bibliographic records
        * - BIBLIFO database characteristics: 3,444 bibliographic records, contained in 14,248 database record entries
        *   (over 10,000 of these database records are just two fields: a subject term field, and a subject term indentification number field; there
        *   are 13,552 subject heading entries [not unique subject headings, just subject heading entries], and 13,870 subject heading number references)
        * - Notes:
        *     * Some of the 20 MODS top-level elements were not used: <abstract>, <tableOfContents>, <classification>, <identifier>,
        *       <location>, and <extension> were not used; as this is just a bibliographic database, many of these
        *       elements do not apply, as they relate to the resource being described, and these resources are not in the repository
        *     * There are four basic bibliographic record formats: monograph, monograph chapter, periodical, and periodical article.  The BIBLIFO database
        *       contains monographs, monograph chapters, and periodical articles (there are no references to an entire periodical issue, i.e., every periodical
        *       title has an associated periodical article title).
        *           - individually authored monograph chapters often have an editor associated with the monograph; some of the periodical articles also have
        *             guest editors for a special periodical issue
        *           - some monographs are part of a series; some BIBLIFO records have a Collection field, which functions in a manner somewhat similar to
        *             a series ==> the Collection field, if an entry is present, is included as a <note> element with a @collection attribute
-->

<!-- Working notes: issues/problems:
    * Subject headings issue: database structure is strange; subject terms for a record follow the bibliographic record, each subject term
    taking up one record in the database.  Relevant fields: BiblifoSujets-_kp_BIBLIFOSujets (subject heading identification number); BiblifoSujets-Sujet
    (subject heading); and Z_Nb_Sujets (number of subject headings applied to that bibliographic record).  ==> Solved with Jeff's subject recursion function.
    * Are the subject headings developed from a controlled vocabulary? ==> Update: Yes, use Répertoire de vedettes-matière (RVM; Québec, Québec: Bibliothèque de
    l'Université Laval), supplemented with locally-developed subject headings
    * Some author-related fields have two entries, which appaar to be delimited by a hard return (carriage return); need to parse these author fields
    that have two author names.  Relevant fields: Auteurs; Auteurs_collectifs; Auteurs_secondaires; and Auteurs_secondaires_collectifs.  JCA suggests
    using an array, and separating each element in the array by the hard return delimiter. ==> Solved with use of the XSLT Tokenize function.
    * Last names of authors are in block capital letters ==> possibly change to initial letter capital letter, and the rest of the last name lowercase letters; if
    were really particular, could further parse author name into last name and first name, using the comma as the delimiter between last name and first name ==>
    decided to not worry about the block-letter capitalization of the last names issue
    * Appear to have three different bibliographic record control numbers, or record identification numbers: _kp_BIBLIFO; Numéro_notice; and Z_Get_IDEnregistrement
    ==> ask to see if one of the record ID numbers is preferred . . . am going to use Numéro_notice for now for the /recordInfo/recordIdentifier text node value;
    note: the MODS User Guidelines recommend that there should be only one <recordIdentifier> system control number in a record; however, having more than one
    <recordIdentifier> might be justified for local administrative reasons, and having more than one still produces a valid MODS XML document  ==> update: Lucie Hotte
    and Ghislain Thibault confirmed that the Numéro_notice field is their record control number, so we are using that field now for the <recordIdentifier> value, and
    not capturing the information in the other two control number fields (i.e., _kp_BIBLIFO and Z_Get_IDEnregistrement)
    * Inconsistent use of Titre_Collectif and Titre_Monographie fields for edited monographs with individually authored chapters, i.e., many times, instead of using
    Titre_Collectif for monographs with authored chapters the Titre_Monographie field is used instead (it should be noted that there are no records
    that use both the Titre_Collectif and Titre_Monographie fields at the same time, thankfully); however, am assuming that the Auteurs and Auteurs_secondaires fields
    are used correctly to refer to the authors of the monograph chapter, and Auteurs_collectifs and Auteurs_secondaires_collectifs are used correctly to refer to the
    editors of the monograph with authored chapters
    * Futher to the above bulleted point: Unclear from examining the returned result records on BIBLIFO Web site how Auteurs, Auteurs_collectifs, Auteurs_secondaires,
    and Auteurs_secondaires_collectifs fields are to be used (all four author fields appear in the returned record display as entries in one combined author field); the
    working assumption adopted is that Auteurs and Auteurs_secondaires are for the author of a monograph or periodical article, and Auteurs_collectifs and
    Auteurs_secondaires_collectifs are for the editors of a monograph with authored chapters or the editors of a special issue of a periodical
    * Some of the BIBLIFO database cleanup operations that were perfomed include the following:
        - rectified records that had both a Monograph title and a Periodical title ==> determined source of error, and corrected this
        - supplied missing periodical article titles for some records (every periodical title now has an associated periodical article title)
        - provided missing authors for some periodical article entries
        - changed some monograph titles that were incorrectly identified as periodical titles
        - changed some periodical titles that were incorrectly identified as monograph titles
    * Note: 696 bibliographic records do not have a subject heading (BiblifoSujets-Sujet) applied to the record
    -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fmp="http://www.filemaker.com/fmpdsoresult"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:template match="/">

        <modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd"
            xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:mods="http://www.loc.gov/mods/v3">

            <!-- Need to select only database entries with an entry in _kp_BIBLIFO, or Numéro_notice, or Z_Get_IDEnregistrement.  Any of those three
        fields can be used.  There are 3,444 valid bibliographic records that have a database record control number, or identification number.  There
        are 14,248 BIBLIFO database entries, with the vast majority of these database entries being subject terms with subject term numbers, i.e., fields
        BiblifoSujets-Sujet and BiblifoSujets-_kp_BIBLIFOSujets.  We need to filter out 14,248 - 3,444 = 10,804 database entries that only have the subject
        heading number and subject heading.
        Conditional operator here: if _kp_BIBLIFO has content, then process record
        -->
            <xsl:apply-templates select="fmp:FMPDSORESULT/fmp:ROW[normalize-space(fmp:_kp_BIBLIFO)]"/>

        </modsCollection>

    </xsl:template>

    <xsl:template match="fmp:ROW">

        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd"
            xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:mods="http://www.loc.gov/mods/v3">


            <!-- <titleInfo> element section -->
            <!-- Note: there are monograph, monograph chapter, and periodical article formats; no bibliographic records for an entire periodical issue -->
            <!-- monograph -->
            <!-- Need conditional statement with comparison and logical operators: if Titre_Article is empty AND Titre_Monographie has content, then -->
            <xsl:if
                test="normalize-space(fmp:Titre_Article) = '' and normalize-space(fmp:Titre_Monographie) != ''">
                <titleInfo>
                    <title>
                        <xsl:value-of select="normalize-space(fmp:Titre_Monographie)"/>
                    </title>
                </titleInfo>
            </xsl:if>

            <!-- Need conditional statement with comparison and logical operators: if Titre_Article is empty AND Titre_Monographie is empty AND Titre_Collectif has content, then -->
            <xsl:if
                test="normalize-space(fmp:Titre_Article) = '' and normalize-space(fmp:Titre_Monographie) = '' and normalize-space(fmp:Titre_Collectif) != ''">
                <titleInfo>
                    <title>
                        <xsl:value-of select="normalize-space(fmp:Titre_Collectif)"/>
                    </title>
                </titleInfo>
            </xsl:if>

            <!-- monograph chapter or periodical article -->
            <!-- Need conditional statement with comparison operator: if Titre_Article has content, then -->
            <xsl:if test="normalize-space(fmp:Titre_Article) != ''">
                <titleInfo>
                    <title>
                        <xsl:value-of select="normalize-space(fmp:Titre_Article)"/>
                    </title>
                </titleInfo>
            </xsl:if>


            <!-- <name> element section -->
            <!-- MRB: possible cleanup: need to transform last name in block capital letters to only initial letter capitalization for the last
                name, e.g., SMITH to Smith; update: decided not to worry about this -->
            <!-- monograph, monograph chapter, or periodical article -->
            <!-- Need conditional statement with comparison operator: if Auteurs has content, then -->
            <xsl:if test="normalize-space(fmp:Auteurs) != ''">
                <!-- Code to split multiple Auteurs entries on the carriage return delimiter -->
                <xsl:for-each select="tokenize(fmp:Auteurs, '&#10;')">
                    <!-- Need conditional statement with comparison operator: if Auteurs has content, then -->
                    <xsl:if test="normalize-space(.) != ''">
                        <name type="personal">
                            <namePart>
                                <xsl:value-of select="normalize-space(.)"/>
                            </namePart>
                            <role>
                                <roleTerm type="text" authority="marcrealtor">Author</roleTerm>
                            </role>
                        </name>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>

            <!-- Need conditional statement with comparison operator: if Auteurs_secondaires has content, then -->
            <xsl:if test="normalize-space(fmp:Auteurs_secondaires) != ''">
                <!-- Code to split multiple Auteurs_secondaires entries on the carriage return delimiter -->
                <xsl:for-each select="tokenize(fmp:Auteurs_secondaires, '&#10;')">
                    <!-- Need conditional statement with comparison operator: if Auteurs_secondaires has content, then -->
                    <xsl:if test="normalize-space(.) != ''">
                        <name type="personal">
                            <namePart>
                                <xsl:value-of select="normalize-space(.)"/>
                            </namePart>
                            <role>
                                <roleTerm type="text" authority="marcrealtor">Author</roleTerm>
                            </role>
                        </name>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>

            <!-- monograph (edited) -->
            <!-- Need conditional statement with comparison and logical operators: if Titre_Article is empty AND Auteurs_collectifs has content, then -->
            <xsl:if
                test="normalize-space(fmp:Titre_Article) = '' and normalize-space(fmp:Auteurs_collectifs) != ''">
                <!-- Code to split multiple Auteurs_collectifs entries on the carriage return delimiter -->
                <xsl:for-each select="tokenize(fmp:Auteurs_collectifs, '&#10;')">
                    <!-- Need conditional statement with comparison operator: if Auteurs_collectifs has content, then -->
                    <xsl:if test="normalize-space(.) != ''">
                        <name type="personal">
                            <namePart>
                                <xsl:value-of select="normalize-space(.)"/>
                            </namePart>
                            <role>
                                <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                            </role>
                        </name>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>

            <!-- Need conditional statement with comparison and logical operators: if Titre_Article is empty AND Auteurs_secondaires_collectifs has content, then -->
            <xsl:if
                test="normalize-space(fmp:Titre_Article) = '' and normalize-space(fmp:Auteurs_secondaires_collectifs) != ''">
                <!-- Code to split multiple Auteurs_secondaires_collectifs entries on the carriage return delimiter -->
                <xsl:for-each select="tokenize(fmp:Auteurs_secondaires_collectifs, '&#10;')">
                    <!-- Need conditional statement with comparison operator: if Auteurs_secondaires_collectifs has content, then -->
                    <xsl:if test="normalize-space(.) != ''">
                        <name type="personal">
                            <namePart>
                                <xsl:value-of select="normalize-space(.)"/>
                            </namePart>
                            <role>
                                <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                            </role>
                        </name>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>


            <!-- <typeOfResource> element section> -->
            <!-- monograph, monograph chapter, or periodical article -->
            <typeOfResource>text</typeOfResource>


            <!-- <genre> element section -->
            <!-- monograph, monograph chapter, periodical article -->
            <!-- Need conditional statement with comparison operator: if Type has content, then -->
            <xsl:if test="normalize-space(fmp:Type) != ''">
                <genre type="primaryGenre">
                    <xsl:value-of select="normalize-space(fmp:Type)"/>
                </genre>
            </xsl:if>


            <!-- <originInfo> element section -->
            <!-- monograph -->
            <!-- Need conditional statement with comparison and logical operators: if Titre_Article is empty AND (Titre_Monographie has content OR Titre_Collectif has content), then -->
            <xsl:if
                test="normalize-space(fmp:Titre_Article) = '' and (normalize-space(fmp:Titre_Monographie) != '' or normalize-space(fmp:Titre_Collectif) != '')">
                <originInfo>
                    <!-- Need conditional statement with comparison operator: if Lieu has content, then -->
                    <xsl:if test="normalize-space(fmp:Lieu) != ''">
                        <place>
                            <placeTerm type="text">
                                <xsl:value-of select="normalize-space(fmp:Lieu)"/>
                            </placeTerm>
                        </place>
                    </xsl:if>
                    <!-- Need conditional statement with comparison operator: if Éditeur has content, then -->
                    <xsl:if test="normalize-space(fmp:Éditeur) != ''">
                        <publisher>
                            <xsl:value-of select="normalize-space(fmp:Éditeur)"/>
                        </publisher>
                    </xsl:if>
                    <!-- Need conditional statement with comparison operator: if Date has content, then -->
                    <xsl:if test="normalize-space(fmp:Date) != ''">
                        <dateIssued keyDate="yes">
                            <xsl:value-of select="normalize-space(fmp:Date)"/>
                        </dateIssued>
                    </xsl:if>
                    <!-- Need conditional statement with comparison operator: if Édition has content, then -->
                    <xsl:if test="normalize-space(fmp:Édition) != ''">
                        <edition>
                            <xsl:value-of select="normalize-space(fmp:Édition)"/>
                        </edition>
                    </xsl:if>
                    <issuance>monographic</issuance>
                </originInfo>
            </xsl:if>


            <!-- <language> element section -->
            <!-- monograph, monograph chapter, or periodical article -->
            <language>
                <languageTerm type="text">French</languageTerm>
            </language>


            <!-- <physicalDescription> element section -->
            <!-- monograph, monograph chapter, or periodical article -->
            <physicalDescription>
                <form authority="marcform">print</form>
                <!-- Need conditional statement with comparison and logical operators: if Titre_Article is empty AND Collation has content AND (Titre_Monographie has content OR Titre_Collectif has content), then -->
                <!-- Note: MODS is inconsistent with <extent> element as a subelement within <physicalDescription>, because don't have @unit="pages" attribute defined, like do for <extent> as a subelement within <part> element -->
                <xsl:if
                    test="normalize-space(fmp:Titre_Article) = '' and normalize-space(fmp:Collation) != '' and (normalize-space(fmp:Titre_Monographie) != '' or normalize-space(fmp:Titre_Collectif) != '')">
                    <extent>
                        <xsl:value-of select="normalize-space(fmp:Collation)"/>
                    </extent>
                </xsl:if>
            </physicalDescription>


            <!-- <targetAudience> element section -->
            <!-- monograph, monograph chapter, or periodical article -->
            <targetAudience>Franco-Ontarian literature researchers and scholars</targetAudience>


            <!-- <note> element sections -->
            <!-- monograph, monograph chapter, or periodical article -->
            <!-- Need conditional statement with comparison operator: if Notes has content, then -->
            <xsl:if test="normalize-space(fmp:Notes) != ''">
                <note type="scholarNote" lang="fre">
                    <xsl:value-of select="normalize-space(fmp:Notes)"/>
                </note>
            </xsl:if>
            <!-- Need conditional statement with comparison and logical operators: if Remarques_catalogueur has content OR Remarques has content, then -->
            <xsl:if
                test="normalize-space(fmp:Remarques_catalogueur) != '' or normalize-space(fmp:Remarques) != ''">
                <note type="researchNote" lang="fre">
                    <!-- Need to concatenate text node for <Remarques_catalogueur> with text node for <Remarques> -->
                    <xsl:value-of
                        select="normalize-space(concat(fmp:Remarques_catalogueur, blank_space, fmp:Remarques))"
                    />
                </note>
            </xsl:if>
            <!-- Need conditional statement with comparison operator: if Collection has content, then -->
            <xsl:if test="normalize-space(fmp:Collection) != ''">
                <note type="collection">
                    <xsl:value-of select="normalize-space(fmp:Collection)"/>
                </note>
            </xsl:if>



            <!-- <subject> element section -->
            <!-- monograph, monograph chapter, or periodical article -->
            <!-- Note: some bibliographic records do not have a subject term applied to the record; also, some database entries have a subject term
                unique ID (BiblifoSujets-_kp_BIBLIFOSujets), but there is no corresponding subject term (BiblifoSujets-Sujet) -->
            <!-- Need conditional statement with comparison operator: if BiblifoSujets-Sujet has content, then -->
            <xsl:if test="normalize-space(fmp:BiblifoSujets-Sujet) != ''">
                <!-- The subject authority list is Répertoire de vedettes-matière (RVM; Québec, Québec: Bibliothèque de l'Université Laval), supplemented
                with locally-developed subject headings; this "rvm" value has been added to the @authority attribute of the <subject> element -->
                <subject authority="rvm" lang="fre">
                    <topic>
                        <xsl:value-of select="normalize-space(fmp:BiblifoSujets-Sujet)"/>
                    </topic>
                </subject>
            </xsl:if>

            <!-- call JCA's recursion function to add the rest of the subject headings to the record; see recursion function in the template at the bottom of this file -->
            <xsl:call-template name="biblifo_subject_recursion">
                <xsl:with-param name="subject_row" select="following-sibling::fmp:ROW[1]"/>
            </xsl:call-template>


            <!-- <relatedItem> element section -->
            <!-- monograph chapter -->
            <!-- Need conditional statement with comparison and logical operators: if Titre_Article has content AND (Titre_Monographie has content OR Titre_Collectif has content), then -->
            <xsl:if
                test="normalize-space(fmp:Titre_Article) != '' and (normalize-space(fmp:Titre_Monographie) != '' or normalize-space(fmp:Titre_Collectif) != '')">
                <relatedItem type="host">
                    <!-- Need conditional statement with comparison operator: if Titre_Monographie has content, then -->
                    <xsl:if test="normalize-space(fmp:Titre_Monographie) != ''">
                        <titleInfo>
                            <title>
                                <xsl:value-of select="normalize-space(fmp:Titre_Monographie)"/>
                            </title>
                        </titleInfo>
                    </xsl:if>

                    <!-- Need conditional statement with comparison and logical operators: if Titre_Monographie is empty AND Titre_Collectif has content, then -->
                    <xsl:if
                        test="normalize-space(fmp:Titre_Monographie) = '' and normalize-space(fmp:Titre_Collectif) != ''">
                        <titleInfo>
                            <title>
                                <xsl:value-of select="normalize-space(fmp:Titre_Collectif)"/>
                            </title>
                        </titleInfo>
                    </xsl:if>

                    <!-- Need conditional statement with comparison operator: if Auteurs_collectifs has content, then -->
                    <xsl:if test="normalize-space(fmp:Auteurs_collectifs) != ''">
                        <!-- Code to split multiple Auteurs_collectifs entries on the carriage return delimiter -->
                        <xsl:for-each select="tokenize(fmp:Auteurs_collectifs, '&#10;')">
                            <!-- Need conditional statement with comparison operator: if Auteurs_collectifs has content, then -->
                            <xsl:if test="normalize-space(.) != ''">
                                <name type="personal">
                                    <namePart>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </namePart>
                                    <role>
                                        <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                                    </role>
                                </name>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>

                    <!-- Need conditional statement with comparison operator: if Auteurs_secondaires_collectifs has content, then -->
                    <xsl:if test="normalize-space(fmp:Auteurs_secondaires_collectifs) != ''">
                        <!-- Code to split multiple Auteurs_collectifs entries on the carriage return delimiter -->
                        <xsl:for-each select="tokenize(fmp:Auteurs_secondaires_collectifs, '&#10;')">
                            <!-- Need conditional statement with comparison operator: if Auteurs_collectifs has content, then -->
                            <xsl:if test="normalize-space(.) != ''">
                                <name type="personal">
                                    <namePart>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </namePart>
                                    <role>
                                        <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                                    </role>
                                </name>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>

                    <originInfo>
                        <!-- Need conditional statement with comparison operator: if Lieu has content, then -->
                        <xsl:if test="normalize-space(fmp:Lieu) != ''">
                            <place>
                                <placeTerm type="text">
                                    <xsl:value-of select="normalize-space(fmp:Lieu)"/>
                                </placeTerm>
                            </place>
                        </xsl:if>
                        <!-- Need conditional statement with comparison operator: if Éditeur has content, then -->
                        <xsl:if test="normalize-space(fmp:Éditeur) != ''">
                            <publisher>
                                <xsl:value-of select="normalize-space(fmp:Éditeur)"/>
                            </publisher>
                        </xsl:if>
                        <!-- Need conditional statement with comparison operator: if Date has content, then -->
                        <xsl:if test="normalize-space(fmp:Date) != ''">
                            <dateIssued keyDate="yes">
                                <xsl:value-of select="normalize-space(fmp:Date)"/>
                            </dateIssued>
                        </xsl:if>
                        <!-- Need conditional statement with comparison operator: if Édition has content, then -->
                        <xsl:if test="normalize-space(fmp:Édition) != ''">
                            <edition>
                                <xsl:value-of select="normalize-space(fmp:Édition)"/>
                            </edition>
                        </xsl:if>
                        <issuance>monographic</issuance>
                    </originInfo>

                    <!-- Need conditional statement with comparison operator: if Collation has content, then -->
                    <xsl:if test="normalize-space(fmp:Collation) != ''">
                        <part>
                            <!-- Note: @unit attribute value is defined inconsistently in the MODS docmentation: sometimes have @unit="page", other times
                        have @unit="pages"; also, @unit attribute is not defined for <extent> subelement when used within the <physicalDescription> element -->
                            <extent unit="pages">
                                <list>
                                    <xsl:value-of select="normalize-space(fmp:Collation)"/>
                                </list>
                            </extent>
                        </part>
                    </xsl:if>

                </relatedItem>
            </xsl:if>

            <!-- periodical article -->
            <!-- Need conditional statement with comparison and logical operators: if Titre_Article has content AND Titre_Périodique has content, then -->
            <xsl:if
                test="normalize-space(fmp:Titre_Article) != '' and normalize-space(fmp:Titre_Périodique) != ''">
                <relatedItem type="host">
                    <!-- Know that Titre_Périodique has content -->
                    <titleInfo>
                        <title>
                            <xsl:value-of select="normalize-space(fmp:Titre_Périodique)"/>
                        </title>
                    </titleInfo>

                    <!-- Need conditional statement with comparison operator: if Auteurs_collectifs has content, then -->
                    <xsl:if test="normalize-space(fmp:Auteurs_collectifs) != ''">
                        <!-- Code to split multiple Auteurs_collectifs entries on the carriage return delimiter -->
                        <xsl:for-each select="tokenize(fmp:Auteurs_collectifs, '&#10;')">
                            <!-- Need conditional statement with comparison operator: if Auteurs_collectifs has content, then -->
                            <xsl:if test="normalize-space(.) != ''">
                                <name type="personal">
                                    <namePart>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </namePart>
                                    <role>
                                        <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                                    </role>
                                </name>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>

                    <!-- Need conditional statement with comparison operator: if Auteurs_secondaires_collectifs has content, then -->
                    <xsl:if test="normalize-space(fmp:Auteurs_secondaires_collectifs) != ''">
                        <!-- Code to split multiple Auteurs_collectifs entries on the carriage return delimiter -->
                        <xsl:for-each select="tokenize(fmp:Auteurs_secondaires_collectifs, '&#10;')">
                            <!-- Need conditional statement with comparison operator: if Auteurs_collectifs has content, then -->
                            <xsl:if test="normalize-space(.) != ''">
                                <name type="personal">
                                    <namePart>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </namePart>
                                    <role>
                                        <roleTerm type="text" authority="marcrealtor">Editor</roleTerm>
                                    </role>
                                </name>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>

                    <originInfo>
                        <issuance>continuing</issuance>
                    </originInfo>

                    <!-- Need conditional statement with comparison and logical operators: if Volume has content OR Numéro has content OR Collation has content OR Date has content, then -->
                    <xsl:if
                        test="normalize-space(fmp:Volume) != '' or normalize-space(fmp:Numéro) != '' or normalize-space(fmp:Collation) != '' or normalize-space(fmp:Date) != ''">
                        <part>
                            <!-- Need conditional statement with comparison operator: if Volume has content, then -->
                            <xsl:if test="normalize-space(fmp:Volume) != ''">
                                <detail type="volume">
                                    <number>
                                        <xsl:value-of select="normalize-space(fmp:Volume)"/>
                                    </number>
                                </detail>
                            </xsl:if>
                            <!-- Need conditional statement with comparison operator: if Numéro has content, then -->
                            <xsl:if test="normalize-space(fmp:Numéro) != ''">
                                <detail type="issue">
                                    <number>
                                        <xsl:value-of select="normalize-space(fmp:Numéro)"/>
                                    </number>
                                </detail>
                            </xsl:if>
                            <!-- Need conditional statement with comparison operator: if Collation has content, then -->
                            <xsl:if test="normalize-space(fmp:Collation) != ''">
                                <extent unit="pages">
                                    <list>
                                        <xsl:value-of select="normalize-space(fmp:Collation)"/>
                                    </list>
                                </extent>
                            </xsl:if>
                            <!-- Need conditional statement with comparison operator: if Date has content, then -->
                            <xsl:if test="normalize-space(fmp:Date) != ''">
                                <date>
                                    <xsl:value-of select="normalize-space(fmp:Date)"/>
                                </date>
                            </xsl:if>
                        </part>
                    </xsl:if>

                </relatedItem>
            </xsl:if>


            <!-- <accessCondition> element section -->
            <accessCondition type="use and reproduction">Use of this public-domain resource is governed by the <a rel="license" href="http://creativecommons.org/licenses/by-nc/3.0/">Creative Commons Attribution-NonCommercial 3.0 Unported License</a>.</accessCondition>


            <!-- <recordInfo> element section -->
            <!-- monograph, monograph chapter, or periodical article -->
            <!-- Note: there are 3,444 bibliographic records in the BIBLIFO database -->
            <recordInfo>
                <recordContentSource>Centre de recherche en civilisation canadienne-française CRCCF), Universite d'Ottawa</recordContentSource>
                <!-- Need conditional statement with comparison operator: if CreationDate has content, then -->
                <xsl:if test="normalize-space(fmp:CreationDate) != ''">
                    <recordCreationDate encoding="w3cdtf">
                        <xsl:value-of select="normalize-space(fmp:CreationDate)"/>
                    </recordCreationDate>
                </xsl:if>
                <!-- Need conditional statement with comparison operator: if ModificationDate has content, then -->
                <xsl:if test="normalize-space(fmp:ModificationDate) != ''">
                    <recordChangeDate encoding="w3cdtf">
                        <xsl:value-of select="normalize-space(fmp:ModificationDate)"/>
                    </recordChangeDate>
                </xsl:if>
                <!-- Need conditional statement with comparison operator: if Numéro_notice has content, then -->
                <xsl:if test="normalize-space(fmp:Numéro_notice) != ''">
                    <recordIdentifier source="CRCCF">
                        <xsl:value-of select="normalize-space(fmp:Numéro_notice)"/>
                    </recordIdentifier>
                </xsl:if>
                <recordOrigin>Record has been transformed into a MODS record from a FileMaker Pro record using an XSLT stylesheet.</recordOrigin>
                <languageOfCataloging usage="primary">
                    <languageTerm type="code" authority="iso639-2b">fre</languageTerm>
                    <languageTerm type="text">French</languageTerm>
                </languageOfCataloging>
                <languageOfCataloging>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                    <languageTerm type="text">English</languageTerm>
                </languageOfCataloging>
            </recordInfo>


        </mods>

        <!-- End bibliographic record template, i.e., end processing <ROW> element -->
    </xsl:template>


    <!-- JCA's recursion function to add the rest of the subject headings to the record -->
    <xsl:template name="biblifo_subject_recursion">

        <xsl:param name="subject_row" select="''"/>

        <!-- Need conditional statement with comparison and logical operators: if $subject_row exists AND _kp_BIBLIFO is empty, then -->
        <xsl:if test="$subject_row and normalize-space($subject_row/fmp:_kp_BIBLIFO)=''">
            <!-- Need conditional statement with comparison operator: if BiblifoSujets-Sujet has content, then -->
            <xsl:if test="normalize-space($subject_row/fmp:BiblifoSujets-Sujet) != ''">
                <!-- MRB: added xmlns attribute namespace references to eliminate the addition of a blank xmlns attribute in the <subject> element -->
                <subject authority="rvm" lang="fre"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink"
                    xmlns:mods="http://www.loc.gov/mods/v3">
                    <topic>
                        <xsl:value-of select="normalize-space($subject_row/fmp:BiblifoSujets-Sujet)"
                        />
                    </topic>
                </subject>
            </xsl:if>
            <xsl:call-template name="biblifo_subject_recursion">
                <xsl:with-param name="subject_row"
                    select="$subject_row/following-sibling::fmp:ROW[1]"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>


</xsl:stylesheet>
