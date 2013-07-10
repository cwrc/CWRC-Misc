<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    version="1.0"
    >
    
 
    
    <!-- take an input directory defined by "src_dir", foreach file, run an XSL "xsl_name" and output
        * to the "dest_dir"
        *
        * assumes input either has a DOCTYPE or is in UTF-8 XML (i.e. no named entity references like zcaron
        *
        * XPROC script for use with Oxygen - see urls for instructions - add as a transform and
        * update directories below.
        *
        *
        * based on: 
        * oxygen setup: http://www.mail-archive.com/oxygen-user@oxygenxml.com/msg02298.html
        * xproc example: https://community.emc.com/docs/DOC-6157
        * xslt parameters: http://norman.walsh.name/2009/06/23/notXProc
        * http://www.data2type.de/en/xml-xslt-xslfo/xproc/xproc-reference/insert/
        *
        * note: if run across SAMBA connection, may recieve a too many open files error
    -->

    
    <!-- <p:variable name="src_dir" select="'orlando_original_1368553388597857000/'" /> -->
    <!-- <p:variable name="dest_dir" select="'orlando_after_mods_xsl/'" /> -->
    <p:variable name="src_dir" select="'file:///c:/Z_ARCHIVE/tmp/delete/tmp_split_format_orlando/'" /> 
    <p:variable name="dest_dir" select="'file:///c:/Z_ARCHIVE/tmp/delete/orlando_after_mods_xsl/'" />
     
    <p:directory-list>
        <p:with-option name="path" select="$src_dir" />
    </p:directory-list>
    
    <p:filter select="//c:file"/>
    <p:for-each name="iterate">
        
        <p:variable name="filename" select="string(/*/@name)" />
        
        <p:load>
            <p:with-option name="href" select="concat($src_dir, $filename)"/>
        </p:load>
        
        <!-- 
        <p:insert match="/" position="before">
            <p:input port="insertion">
                <p:inline>
                    <!DOCTYPE ORLANDO [ <!ENTITY % character_entities SYSTEM "http://cwrc.ca/schema/character_entities.dtd"> %character_entities; ]>
                </p:inline>
            </p:input>
        </p:insert>
         -->
        
        <p:xslt>
            <p:input port="parameters">
                <p:empty/>
            </p:input>
            <p:input port="stylesheet">
                <p:document href="orlando_bibl_to_mods.xsl"/>
            </p:input>
            <p:with-param name="param_original_filename" select="$filename" />
        </p:xslt>
        
        <p:store>
            <p:with-option name="href" select="concat($dest_dir, $filename)">
                <p:pipe port="current" step="iterate"/>
             </p:with-option>
        </p:store>
        
    </p:for-each>
    
</p:declare-step>