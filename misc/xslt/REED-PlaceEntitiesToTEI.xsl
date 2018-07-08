<?xml version="1.0" encoding="UTF-8"?>

<!--

    In order to convert the place entities to TEI, the command line can be used. 
    Instructions for macOS:
    1) Download saxon9he.jar from https://sourceforge.net/projects/saxon/?source=typ_redirect. Put it in a place that is easy to reference like your
       document folder.
    2) Unzip the file from above.
    3) Enclose the entire source .csv in <root> tags like below.
            
            __before__
            File ID #,Standard Name,Full Name,Variant Name 1
            place_0001.xml,Antelope Inn,Antelope Inn,Antilopp Inn
            
            __after__
            <root>
            File ID #,Standard Name,Full Name,Variant Name 1
            place_0001.xml,Antelope Inn,Antelope Inn,Antilopp Inn
            </root>
    4) Run the following command.
    
        java -jar dir/saxon9he.jar -s:sourceFile -xsl:xslFile -o:outputFile.extension
        
        where:
            dir/saxon9he.jar    = the file path to the saxon9he.jar file
            -s                  = the source csv file
            -xsl                = the .xsl file
            -o                  = specify the output file.
            
        since this .xsl creates multiple files, the output argument works differently. Below is the command I run:
        
        java -jar ~/Downloads/SaxonHE9-8-0-12J/saxon9he.jar -s:"REED London Inns places.csv" -xsl:REED-PlaceEntitiesToTEI.xsl -o:myResults/.nothing
        
        since there are 116 files to be created through the <xsl:result-document> tag, the myResults directory will be created and the files will be 
        placed in there. the reason the output ends with .nothing is because in order for the output to go to the folder, the path has to end in a 
        file extension. if <xsl:result-document> was not used and only 1 output file was to be created then something like -o:myResults/output.xml 
        would work.
        
        if you were to run the command above using this .xsl and -o:myResults/output.xml then it would still create the 116 files but also an extra
        file called ouput.xml that would have a blank TEI. the -o:myResults/.nothing just prevents the extra file from being created while also
        directing output to the folder.
        
-->



<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="fn"
    exclude-result-prefixes="xs"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Functions   -->
    
    <xsl:function name="fn:getTokens" as="xs:string+">
        <xsl:param name="str" as="xs:string"/>
        <!-- MRB: (3) changed the CSV field delimiter marker from a "," to a "&#x9;" (i.e., a
		"tab" character) -->
        <xsl:analyze-string select="concat($str, ',')" regex='(("[^"]*")+|[^,;]*),'>
            <xsl:matching-substring>
                <xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    
    
    
    <xsl:variable name="intermediateXML">
        <xsl:call-template name="csvToIntermediateXML" />
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:for-each select="exsl:node-set($intermediateXML)/root/row">
            <xsl:variable name="fileName" select="translate(normalize-space(Standard_Name), ' ', '_')">
            </xsl:variable>
            <xsl:result-document method="xml" href="{$fileName}.xml">
                <!--<xsl:processing-instruction name="xml">
                    <xsl:text>version="1.0" encoding="UTF-8"</xsl:text>
                </xsl:processing-instruction>-->
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
                </xsl:processing-instruction>
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:text>
                </xsl:processing-instruction>
                
                <TEI xmlns="http://www.tei-c.org/ns/1.0">
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>
                                    <xsl:value-of select="Full_Name"/>
                                </title>
                            </titleStmt>
                            <publicationStmt>
                                <publisher>Canadian Writing Research Collaboratory (CWRC)</publisher>
                                <publisher>Records of Early English Drama - London</publisher>
                                <availability>
                                    <licence target="https://creativecommons.org/licenses/by/4.0/legalcode">
                                        <p></p>
                                    </licence>
                                </availability>
                            </publicationStmt>
                            <notesStmt>
                                <note>Place entity record</note>
                            </notesStmt>
                            <sourceDesc>
                                <p>born digital</p>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <listPlace>
                                <place>
                                    <placeName type="standard">
                                        <name>
                                            <xsl:value-of select="Standard_Name"/>
                                        </name>
                                    </placeName>
                                    <placeName type="preferred" xml:lang="ENG">
                                        <name type="full">
                                            <xsl:value-of select="Full_Name"/>
                                        </name>
                                    </placeName>
                                    <xsl:if test="Variant_Name_1 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_1"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Variant_Name_2 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_2"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Variant_Name_3 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_3"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Variant_Name_4 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_4"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Variant_Name_5 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_5"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Variant_Name_6 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_6"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Variant_Name_7 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_7"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Variant_Name_8 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_8"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Variant_Name_9 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_9"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Variant_Name_10 != ''">
                                        <placeName type="variant" xml:lang="ENG">
                                            <name>
                                                <xsl:value-of select="Variant_Name_10"/>
                                            </name>
                                        </placeName>
                                    </xsl:if>
                                    
                                    <location>
                                        <address>
                                            <country ref="ISO 3166-1">
                                                <xsl:choose>
                                                    <xsl:when test="Country = 'England'">
                                                        <xsl:text>GBR</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="Country"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </country>
                                            <region>
                                                <xsl:value-of select="Region"/>
                                            </region>
                                        </address>
                                        <geo decls="#WGS">
                                            <xsl:value-of select="LatLong"/>
                                        </geo>
                                    </location>
                                    <xsl:if test="Source != ''">
                                        <listBibl>
                                            <head>
                                                <xsl:text>Sources:</xsl:text>
                                            </head>
                                            <bibl>
                                                <title>
                                                    <xsl:value-of select="Source"/>
                                                </title>
                                                <xsl:if test="Source = 'Layers of London'">
                                                    <ref target="https://alpha.layersoflondon.org/"></ref>
                                                </xsl:if>
                                            </bibl>
                                        </listBibl>
                                    </xsl:if>
                                    <xsl:if test="same_as_1 != ''">
                                        <idno type="GeoNames" cert="high">
                                            <xsl:analyze-string select="same_as_1" regex="(http://www.geonames.org/)([a-z]|[0-9]|[A-Z])+">
                                                <xsl:matching-substring>
                                                    <xsl:value-of select="."/>
                                                </xsl:matching-substring>
                                            </xsl:analyze-string>
                                        </idno>
                                    </xsl:if>
                                    <xsl:if test="same_as_2 != ''">
                                        <idno type="WikiData" cert="high">
                                            <xsl:analyze-string select="same_as_2" regex="(https://www.wikidata.org/)(wiki)/([a-z]|[0-9]|[A-Z])+">
                                                <xsl:matching-substring>
                                                    <xsl:value-of select="."/>
                                                </xsl:matching-substring>
                                            </xsl:analyze-string>
                                        </idno>
                                    </xsl:if>
                                </place>
                            </listPlace>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
        <!--<xsl:apply-templates select="$intermediateXML"></xsl:apply-templates>-->
    </xsl:template>
    
    
    <xsl:template match="root" name="csvToIntermediateXML">
        <!--<xsl:choose>
      <xsl:when test="unparsed-text-available($pathToCSV)">-->
        <xsl:variable name="csv" select="."/>
        <!-- MRB: (4) changed the newline marker from a Unix LF ("&#xA;") to a Microsoft
			Windows CR+LF ("&#xD;&#xA;") -->
        <xsl:variable name="lines" select="tokenize($csv, '&#xA;')" as="xs:string+"/>
        <xsl:variable name="elemNames" select="fn:getTokens($lines[2])" as="xs:string+"/>
        <root>
            <xsl:for-each select="$lines[position() > 2]">
                <row>
                    <xsl:variable name="lineItems" select="fn:getTokens(.)" as="xs:string+"/>
                    
                    <xsl:for-each select="$elemNames">
                        
                        
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:variable name="elementName" select="translate(normalize-space($elemNames[$pos]), ' #', '_')"/>
                        
                        <!-- MRB: (5) changed the header field name references for each data
								cell from attributes (i.e., <elem name"field-name">) as in
								
								<elem name="{.}">
									<xsl:value-of select="$lineItems[$pos]"/>
								</elem>
								
								to elements (i.e., <field-name>) as in
								
								<xsl:element name="{.}">
									<xsl:value-of select="$lineItems[$pos]"/>
								</xsl:element>
								
							-->
                        <xsl:if test="$elementName != ''">
                            <xsl:element name="{$elementName}">
                                
                                <xsl:value-of select="$lineItems[$pos]"/>
                            </xsl:element>
                        </xsl:if>
                        
                    </xsl:for-each>
                </row>
            </xsl:for-each>
        </root>
        <!--</xsl:when>
      <xsl:otherwise>
        <xsl:text>Cannot locate : </xsl:text><xsl:value-of select="$pathToCSV"/>
      </xsl:otherwise>
    </xsl:choose>-->
    </xsl:template>
    
</xsl:stylesheet>