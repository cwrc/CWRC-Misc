<?xml version="1.0" encoding="UTF-8"?>
<!-- 
        * - MRB: Wed 30-Sep-2015
        * - Purpose: XProc pipeline file to apply an XSLT stylesheet on a source directory of CEWW entry files
        *    and output them as MODS files in a destination directory.
-->

<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">

    <!-- CEWW entry source directory -->
    <p:variable name="src_dir" select="'./ceww_entries/'"/>
    <!-- MODS destination directory -->
    <p:variable name="dest_dir" select="'./mods/'"/>

    <p:directory-list>
        <p:with-option name="path" select="$src_dir"/>
    </p:directory-list>

    <p:filter select="//c:file"/>
    <p:for-each name="iterate">

        <p:variable name="filename" select="string(/*/@name)"/>

        <p:load>
            <p:with-option name="href" select="concat($src_dir, $filename)"/>
        </p:load>

        <p:xslt>
            <p:input port="parameters">
                <p:empty/>
            </p:input>
            <p:input port="stylesheet">
                <!-- name of stylesheet -->
                <p:document href="ceww_entry2mods.xsl"/>
            </p:input>
            <p:with-param name="param_original_filename" select="$filename"/>
        </p:xslt>

        <p:store>
            <p:with-option name="href" select="concat($dest_dir, $filename)">
                <p:pipe port="current" step="iterate"/>
            </p:with-option>
        </p:store>

    </p:for-each>

</p:declare-step>
