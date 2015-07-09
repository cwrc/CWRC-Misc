(:
 : MRB: Thu 07-May-2015
 : Purpose: XQuery script to insert strings in certain XML elements
 : Description: XQuery script to insert double quotation marks
 : within QUOTE elements, and insert double quotation marks or italics
 : placeholder strings within TITLE or title elements.  This script
 : is part of the Plot-It pipeline or workflow chain to process and
 : convert Orlando and TEI events into Plot-It-conformant JSON events,
 : and it is the first script run in the chain.  The three scripts are
 : run in the following order:
 :     - kluge_insert_strings.xq
 :     - cwrc_place_cache.xq
 :     - cwrc_PLOT-IT_JSON.xq
 : Note: four final processing operations need to be performed on the
 : resulting JSON data file using the Oxygen XML Editor application:
  : * (1) Do a format and indent operation before saving the JSON data
 :   file:
 :   - Ctrl-Shift-p (to format and indent in Oxygen)
 : * (2) Run two find and replace operations (Ctrl-f) to substitute the
 :   italics placeholders with the HTML italics tag:
 :       - placeholderOpenItalics ==> <i>
 :       - placeholderCloseItalics ==> </i>
 : * (3) After running the above operations, there will be four
     "widowed" <i> tags in the "label" property for the Orlando
 :   events, where the title was truncated and no closing </i>
 :   tag was added.  Use this regular expression search in the Oxygen
 :   Find dialog to find all label strings with an <i> tag, and
 :   just manually go through these to find the four that are
 :   missing the closing </i> tag:
 :       label:.*<i>
 : * (4) Do a search to find the 20 events that have earth as the lat
 :   and long, i.e.,  search for
 :       "latLng": \["0,0"\]
 :   and manually change the location property to
 :       Earth
 :   and the countryName property to
 :       (Earth)
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
