(:
 : MRB: Thu 07-May-2015
 : Purpose: XQuery script to insert strings in certain XML elements
 : Description: XQuery script to insert double quotation marks
 : within QUOTE elements, and insert double quotation marks or
 : placeholder strings within TITLE or title elements.  This script
 : is part of the Plot-It pipeline or workflow chain to process and
 : convert Orlando and TEI events into Plot-It-conformant JSON events,
 : and it is the first script run in the chain.  The three scripts are
 : run in the following order:
 :     - kluge_insert_strings.xq
 :     - cwrc_place_cache.xq
 :     - cwrc_PLOT-IT_JSON.xq
 : Note: three final processing operations need to be performed on the
 : resulting JSON data file using the Oxygen XML Editor application:
 : * (1) Run two find and replace operations (Ctrl-f) to substitute the
 :   italics placeholders with the HTML italics tag:
 :       - placeholderOpenItalics ==> <i>
 :       - placeholderCloseItalics ==> </i>
 : * (2) Delete the empty JSON citation variables using a regular
 :   expression find and replace operation (Ctrl-f):
 :       - ,\n\s*"citations": ""\n ==> [blank]
 : * (3) Do a final format and indent operation before saving the JSON
 :   data file:
 :   - Ctrl-Shift-p (to format and indent in Oxygen)
 :)

xquery version "3.0" encoding "utf-8";

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";

(: add double quotation marks around Orlando quote element strings :)
for $quote in //QUOTE
return (
    insert node '&quot;' as first into $quote,
    insert node  '&quot;' as last into $quote
),

(: add double quotation marks around Orlando analytic and unpublished title element strings :)
for $title in //TITLE[@TITLETYPE="ANALYTIC" or @TITLETYPE="UNPUBLISHED"]
return (
    insert node '&quot;' as first into $title,
    insert node  '&quot;' as last into $title
),

(: add italics placeholder around Orlando monographic, journal, and serial title element strings :)
for $title in //TITLE[@TITLETYPE="MONOGRAPHIC" or @TITLETYPE="JOURNAL" or @TITLETYPE="SERIAL"]
return (
    insert node 'placeholderOpenItalics' as first into $title,
    insert node  'placeholderCloseItalics' as last into $title
),

(: add double quotation marks around TEI analytic and unpublished title element strings :)
for $title in //title[@level="a" or @level="u"]
return (
    insert node '&quot;' as first into $title,
    insert node  '&quot;' as last into $title
),

(: add italics placeholder around TEI monographic, journal, and serial title element strings :)
for $title in //title[@level="m" or @level="j" or @level="s"]
return (
    insert node 'placeOpenItalics' as first into $title,
    insert node  'placeCloseItalics' as last into $title
)
