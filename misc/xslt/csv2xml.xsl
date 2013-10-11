<?xml version="1.0"?>

<!-- MRB: Fri 11-Oct-2013
	
	The original standalone XSLT stylesheet CSV to XML converter can be found here:
	http://andrewjwelch.com/code/xslt/csv/csv-to-xml_v2.html
	
	Modified the XSLT stylesheet csv2xml.xsl (the original file was named xsv-to-xml_v2.xslt) in the following ways:
	
	(1) Changed the character encoding from "US-ASCII" to "UTF-8".
	(2) Changed the path to the source CSV file from "file:///c:/csv.csv" to
	"file:///c:/users/brundin/temp/geonames/places.csv".
	(3) Changed the CSV field delimiter marker from a "," (which is "&#44;", but "," was used in
	the original code) to "&#x9;", i.e., a "tab" character.
	(4) Changed the newline, line break, or end-of line (EOL) marker from a Unix, Linux, BSD, Mac OS X line feed
	"&#xA;" LF, '\n') to a Microsoft Windows carriage return and line feed sequence "&#xD;&#xA;" (CR+LF, '\r\n').
	Note: the GeoNames data use a Unix newline character of line feed (&#xA;), but after downloading the data, I
	changed the GeoNames data from LF to CR-LF using the Vim editor.
	(5) Changed the references to header field names for each data cell from attributes (i.e.,
	<elem name="field-name">)to elements (i.e., <field-name>).
	
	To run the standalone csv-to-xml_v2.xslt stylesheet, do the following:
	
	(1) Set the character encoding (e.g., UTF-8, or ISO-8859-1).
	(2) Set the path to the source CSV file (e.g., file:///c:/users/brundin/temp/geonames/places.csv).
	(3) Set the CSV field delimiter character or character code (e.g., ",", or "&#x9;").
	(4) Set the newline marker as LF or CR+LF (i.e., "&#xA;", or "&#xD;&#xA;").
	(5) Set the header field name references for each data cell to either attributes (i.e., <elem name="field-name"> or elements (i.e., <field-name>).
	(6) From the Windows Command command prompt, type the following:
	
	java.exe -cp "C:\Program Files (x86)\Java\jre7\lib\saxon9he.jar" net.sf.saxon.Transform -o:c:/users/brundin/temp/geonames/output.xml -it:main csv2xml.xsl
	
	where the classpath to the Java JRE has already been set, the path to the Saxon XSLT processor jar file is provided, the path to the output.xml XML file is
	provided, and the standalone csv2xml.xsl XSLT stylesheet happens to be in the same directory that the Windows Command command is being run from.
-->

<!--
	A CSV to XML transform
	Version 2
	Andrew Welch
	http://andrewjwelch.com
	
	Modify or supply the $pathToCSV parameter and run the transform
	using "main" as the initial template.
	
	For bug reports or modification requests contact me at andrew.j.welch@gmail.com
-->
  		
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="fn"
	exclude-result-prefixes="xs fn">

<!-- MRB: (1) changed the character encoding from "US-ASCII" to "UTF-8" -->
<xsl:output indent="yes" encoding="utf-8"/>
	
	<!-- MRB: (2) changed the path to the source CSV file from "file:///c:/csv.csv" to
		"file:///c:/users/brundin/temp/geonames/places.csv" -->
	<xsl:param name="pathToCSV" select="'file:///c:/users/brundin/temp/geonames/places.csv'"/>

<xsl:function name="fn:getTokens" as="xs:string+">
	<xsl:param name="str" as="xs:string"/>
		<!-- MRB: (3) changed the CSV field delimiter marker from a "," to a "&#x9;" (i.e., a
		"tab" character -->
		<xsl:analyze-string select="concat($str, '&#x9;')" regex='(("[^"]*")+|[^&#x9;]*)&#x9;'>
			<xsl:matching-substring>
				<xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
			</xsl:matching-substring>
		</xsl:analyze-string>
</xsl:function>

<xsl:template match="/" name="main">
	<xsl:choose>
		<xsl:when test="unparsed-text-available($pathToCSV)">
			<xsl:variable name="csv" select="unparsed-text($pathToCSV)"/>
			<!-- MRB: (4) changed the newline marker from a Unix LF (&#xA;) to a Microsoft
			Windows CR+LF (&#xD;&#xA;) -->
			<xsl:variable name="lines" select="tokenize($csv, '&#xD;&#xA;')" as="xs:string+"/>
			<xsl:variable name="elemNames" select="fn:getTokens($lines[1])" as="xs:string+"/>
			<root>
				<xsl:for-each select="$lines[position() > 1]">
					<row>
						<xsl:variable name="lineItems" select="fn:getTokens(.)" as="xs:string+"/>

						<xsl:for-each select="$elemNames">
							<xsl:variable name="pos" select="position()"/>
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
							<xsl:element name="{.}">
								<xsl:value-of select="$lineItems[$pos]"/>
							</xsl:element>
						</xsl:for-each>
					</row>
				</xsl:for-each>
			</root>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Cannot locate : </xsl:text><xsl:value-of select="$pathToCSV"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>