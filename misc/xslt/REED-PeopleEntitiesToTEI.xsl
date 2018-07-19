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
        
        java -jar ~/Downloads/SaxonHE9-8-0-12J/saxon9he.jar -s:"Inns of Court People.csv" -xsl:REED-PeopleEntitiesToTEI.xsl -o:ResultFiles/.nothing
        
        since there are 100s of files to be created through the <xsl:result-document> tag, the ResultFiles directory will be created and the files will be 
        placed in there. the reason the output ends with .nothing is because in order for the output to go to the folder, the path has to end in a 
        file extension. if <xsl:result-document> was not used and only 1 output file was to be created then something like -o:myResults/output.xml 
        would work.
        
        if you were to run the command above using this .xsl and -o:myResults/output.xml then it would still create the files but also an extra
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
            <xsl:variable name="fileNum" select="position()"/>
            <xsl:variable name="fileName">
                <xsl:choose>
                    <xsl:when test="contains(standard_name,'...') or contains(standard_name,'…')">
                        <xsl:value-of select="name_Last"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate(normalize-space(standard_name), ' ,?', '_')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:if test="standard_name != ''">
                <xsl:result-document method="xml" href="{$fileName}_{$fileNum}.xml"> 
                <!--<xsl:processing-instruction name="xml">
                    <xsl:text>version="1.0" encoding="UTF-8"</xsl:text>-->
                <!--</xsl:processing-instruction>-->
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
                </xsl:processing-instruction>
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:text>
                </xsl:processing-instruction>
                
                <TEI xmlns="http://www.tei-c.org/ns/1.0">
                    <!--<standard_name name="{standard_name}"> 
                        <xsl:value-of select="standard_name"/>
                    </standard_name>
                    <name_Last><xsl:value-of select="name_Last"/></name_Last>
                    <name_First><xsl:value-of select="name_First"/></name_First>
                    <roleName><xsl:value-of select="roleName"/></roleName>
                    <genName><xsl:value-of select="genName"/></genName>
                    <title2><xsl:value-of select="title2"/></title2>
                    <Relation><xsl:value-of select="Relation"/></Relation>
                    <Occupation><xsl:value-of select="Occupation"/></Occupation>
                    <Floruit><xsl:value-of select="Floruit"/></Floruit>
                    <Birth_Year><xsl:value-of select="Birth_Year"/></Birth_Year>
                    <Death_Year><xsl:value-of select="Death_Year"/></Death_Year>
                    <Affiliation><xsl:value-of select="Affiliation"/></Affiliation>
                    <Project_Note><xsl:value-of select="Project_Note"/></Project_Note>
                    <Source><xsl:value-of select="Source"/></Source>
                    <REED_ID><xsl:value-of select="REED_ID"/></REED_ID>
                    <VIAF_ID><xsl:value-of select="VIAF_ID"/></VIAF_ID>
                    <ODNB_DOI><xsl:value-of select="ODNB_DOI"/></ODNB_DOI>
                    <WIKIDATA><xsl:value-of select="WIKIDATA"/></WIKIDATA>
                    <Mentioned_in_Orlando><xsl:value-of select="Mentioned_in_Orlando"/></Mentioned_in_Orlando>
                    <KIMs_NOTES><xsl:value-of select="KIMs_NOTES"/></KIMs_NOTES>-->
                    <!--<filename>
                        <xsl:value-of select="concat($fileName,'.xml')"/>
                    </filename>-->
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title><xsl:value-of select="standard_name"/></title>
                            </titleStmt>
                            <publicationStmt>
                                <publisher>Canadian Writing Research Collaboratory (CWRC)</publisher>
                                <publisher>Records of Early English Drama - London</publisher>
                                <availability>
                                    <licence
                                        target="https://creativecommons.org/licenses/by/4.0/legalcode">
                                        <p/>
                                    </licence>
                                </availability>
                            </publicationStmt>
                            <notesStmt>
                                <note>Person entity record</note>
                            </notesStmt>
                            <sourceDesc>
                                <p>born digital</p>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <listPerson>
                                <person
                                    xml:id="PID_entity_record"
                                    sex="f">
                                    <xsl:if test="VAIF_ID != ''">
                                        <idno
                                            type="VIAF"
                                            cert="high">
                                            <xsl:text>https://viaf.org/viaf/</xsl:text>
                                            <xsl:value-of select="VIAF_ID"/>
                                        </idno>
                                    </xsl:if>
                                    <xsl:if test="ODNB_DOI != ''">
                                        <idno
                                            type="ODNB"
                                            cert="high">
                                            <xsl:text>https://doi.org/10.1093/ref:odnb/</xsl:text>
                                            <xsl:value-of select="ODNB_DOI"/>
                                        </idno>
                                    </xsl:if>
                                    <xsl:if test="WIKIDATA != ''">
                                        <idno
                                        type="WikiData"
                                        cert="high">
                                        <xsl:text>https://www.wikidata.org/wiki/</xsl:text>
                                        <xsl:value-of select="WIKIDATA"/>
                                    </idno>
                                    </xsl:if>
                                        
                                    
                                    <persName
                                        type="standard">
                                        <name><xsl:value-of select="standard_name"/></name>
                                    </persName>
                                    <persName
                                        type="prefered"
                                        xml:lang="ENG">
                                        <xsl:if test="name_First != '…' and name_First != '...'">
                                            <name
                                                type="forename"><xsl:value-of select="name_First"/></name>
                                            <!-- if the [name First] column contains "...", do not add the <name type="forename"> tag; it was just added to allow them to concatenate the standard name from the two name columns (first, last)] -->
                                            
                                        </xsl:if>
                                        <name
                                            type="surname"><xsl:value-of select="name_Last"/></name>
                                        <xsl:if test="genName != ''">
                                            <genName><xsl:value-of select="genName"/></genName>
                                        </xsl:if>
                                        <xsl:if test="roleName != ''">
                                            <roleName><xsl:value-of select="roleName"/></roleName>
                                        </xsl:if>
                                    </persName>
                                    <xsl:if test="Birth_Year != ''">
                                        <birth>
                                            <date cert="high" source="https://www.w3.org/TR/NOTE-datetime" when="{Birth_Year}"><xsl:value-of select="Birth_Year"/></date>
                                        </birth>
                                    </xsl:if>
                                    <xsl:if test="Death_Year != ''">
                                        <death>
                                            <date cert="high" when="{Death_Year}"><xsl:value-of select="Death_Year"/></date>
                                        </death>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="matches(Floruit,'(pre)-\d\d\d\d')">
                                            <floruit>
                                                <date>
                                                    <xsl:analyze-string select="Floruit" regex="\d\d\d\d">
                                                        <xsl:matching-substring>
                                                            <xsl:attribute name="notAfter"><xsl:value-of select="."/></xsl:attribute>
                                                        </xsl:matching-substring>
                                                    </xsl:analyze-string>
                                                    <xsl:value-of select="Floruit"/>
                                                </date>
                                                <!-- 
                  for pre-[year] use notBefore="[year]" for yyyy-yy use @from and @to,  for example, 1612-12 in text should be <date cert="high" from="1612" to="1613">1612-13</date>-->
                                            </floruit>
                                        </xsl:when>
                                        <xsl:when test="matches(Floruit,'\d\d\d\d-\d\d')">
                                            <floruit>
                                                <date>
                                                    <xsl:variable name="baseYear" select="substring(Floruit,1,2)"/>
                                                    <xsl:variable name="fromYear" select="substring-before(Floruit,'-')"/>
                                                    <xsl:variable name="toYear" select="substring-after(Floruit,'-')"/>
                                                    
                                                    <xsl:attribute name="from"><xsl:value-of select="$fromYear"/></xsl:attribute>
                                                    <xsl:attribute name="to"><xsl:value-of select="concat($baseYear,$toYear)"/></xsl:attribute>
                                                    <xsl:value-of select="Floruit"/>
                                                </date>
                                                
                                            </floruit>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="Floruit"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    
                                    <trait
                                        type="factuality"
                                        cert="high">
                                        <ab>real</ab>
                                    </trait>
                                    <xsl:if test="Occupation != ''">
                                        <occupation
                                            cert="high"><xsl:value-of select="Occupation"/>
                                        </occupation>
                                    </xsl:if>
                                   
                                   <xsl:if test="Affiliation != ''">
                                       <affiliation
                                           cert="high"><xsl:value-of select="Affiliation"/>
                                       </affiliation>
                                   </xsl:if>
                                    
                                    <note
                                        type="project-specific"
                                        xml:lang="ENG">
                                        <note><xsl:value-of select="Project_Note"/></note>
                                        <respons
                                            locus="value">
                                            <desc>
                                                <orgName
                                                    ref="https://cwrc.ca/node/131">REED London</orgName>
                                            </desc>
                                        </respons>
                                    </note>
                                </person>
                            </listPerson>
                        </body>
                    </text>
                    
                </TEI> 
            
             </xsl:result-document> 
            </xsl:if>
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
                        <xsl:variable name="elementName" select="translate(normalize-space($elemNames[$pos]), ' #?''', '_')"/>
                        
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