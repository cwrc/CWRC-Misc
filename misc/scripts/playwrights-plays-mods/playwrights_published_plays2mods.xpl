<?xml version="1.0" encoding="UTF-8"?>
<!-- 
        * - MRB: Thu 07-Jan-2016
        * - Purpose: XProc pipeline file to apply an XSLT stylesheet on a source directory of
        *   Playwrights entry files and output them as published plays MODS files in a destination
        *   directory.
        *   Description: Before running this pipeline file which calls the
        *   "playwrights_published_plays2mods.xsl" stylesheet file, you need to ensure that there
        *   are no spaces in the names of the source files.  The following commands will convert
        *   any spaces in filenames to underscores:
        *        * Windows Command Prompt one-liner commands and Windows PowerShell command:
        *             - cmd /e:on /v:on /c "for %f in ("* *.xml") do (set "n=%~nxf" & set "n=!n: =_!" & ren "%~ff" "!n!" )"
        *             - forfiles /m *.xml /C "cmd /e:on /v:on /c set \"Phile=@file\" & if @ISDIR==FALSE ren @file !Phile: =_!"
        *             - powershell -command "Dir | Rename-Item –NewName { $_.name –replace \" \",\"_\" }"
        *        * Unix one-liner commands:
        *             - rename 'y/ /_/' *
        *             - rename 's/ /_/g' *
        *             - ls -1 | while read file; do new_file=$(echo $file | sed s/\ /_/g); mv "$file" "$new_file"; done
        *   As well, ensure that the following conditions have been met in the Playwrights entry BIBCIT XML blocks:
        *        * that monograph chapter titles have a LEVEL attribute value of "ANALYTIC"; some BIBCITs erroneously
        *           had the monograph chapter title with a "MONOGRAPHIC" LEVEL attribute value
        *        * that monograph titles have a LEVEL attribute value of "MONOGRAPHIC"; some BIBCITs erroneously
        *           had the monograph title with an "ANALYTIC" LEVEL attribute value
        *        * that there are no embedded titles within titles (i.e., /TITLE/TITLE); some files had BIBCITs with marked
        *           up titles within titles
        *   After the Playwrights MODS collection XML files have been created, these files will be split into individual MODS
        *   records using either the batch file script "playwrights_split_modsCollection.cmd" (Windows OS) or the shell
        *   script ""playwrights_split_modsCollection.sh" (Unix-like OS), both of which call the XSLT file
        *   "playwrights_split_modsCollection.xsl".
-->

<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">

    <!-- Playwrights CWRC entry source directory -->
    <p:variable name="src_dir" select="'./playwrights_entries/'"/>
    <!-- Playwrights MODS destination directory -->
    <p:variable name="dest_dir" select="'./published_plays_mods/'"/>

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
                <p:document href="playwrights_published_plays2mods.xsl"/>
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
