<?xml version="1.0" encoding="UTF-8"?>

<!--
==> take a file with named character references and convert them into UTF-8
==> E.G. &zcaron;
-->

<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    >

    <xsl:output method="xml" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:copy-of select="node()" />
    </xsl:template>

</xsl:stylesheet>
