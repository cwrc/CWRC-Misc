(: output "events" in the PLOT-IT JSON format from different schemas :)

xquery version "3.0" encoding "utf-8";

import module namespace cwPH="cwPlaceHelpers" at "./cw_place_helpers.xq";
import module namespace cwOH="cwOrlandoHelpers" at "./cw_orlando_helpers.xq";

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
(: declare option output:method   "xml"; :)
declare option output:method "text";
declare option output:encoding "UTF-8";
declare option output:indent   "no";
(: declare option output:parameter-document "file:///home/me/serialization-parameters.xml"; :)

(: declare boundary-space preserve; :)
(: database must be imported with the following option otherwise text nodes have the begining and ending whitespace "chopped off" which is undesireable for mixed content:)
declare option db:chop 'false';

declare variable $user_external external := "anonymous";
declare variable $role_external external := ( "anonymous" );

declare variable $role_seq := $role_external;

(: escape double quotes (") within a JSON value :)
declare function local:escapeJSON ($str as xs:string?)
{
  (: XQuery 3.1 doesn't support look-behinds so need extra replace for case where " is the first character :)
  fn:replace( fn:replace($str, '^["]', '\\"') , '([^\\])["]', '$1\\"')
};


(: if value is empty then do not output JSON key/value :)
declare function local:outputJSONNotNull ($key as xs:string?, $value as xs:string?)
as xs:string?
{
  (
  if ($value != "") then
    local:outputJSON ($key, $value)
  else
    ()
  )
};

declare function local:outputJSON ($key as xs:string?, $value as xs:string?)
as xs:string?
{
  let $tmp := string('"'||$key||'": "'||local:escapeJSON($value)||'"')
  return $tmp
};

declare function local:outputJSONArray ($key as xs:string?, $value)
as xs:string?
{
  let $tmp := string('"'||$key||'": ['||$value||']')
  return $tmp
};


declare function local:modsBiblType($src)
{
  if ( $src/mods:originInfo/mods:issuance/text() eq "monographic" ) then
    "monographic"
  else if ( $src/mods:relatedItem/mods:originInfo/mods:issuance/text() eq "monographic" ) then
    "monographic part"
  else if ( $src/mods:relatedItem/mods:originInfo/mods:issuance/text() eq "continuing" ) then
    "continuing"
  else
    ()
};

declare function local:modsFormatDescription($src) 
{
  "<div>Author: "||fn:string-join($src/mods:name/mods:namePart, " ")||"</div>"
  ||
  "<div>Title: "||fn:string-join($src/mods:titleInfo/mods:title, " ")||"</div>"
  ||
  "<div>Place: "||fn:string-join($src/mods:originInfo/mods:place/mods:placeTerm[not(@authority eq "marccountry")], " ")||"</div>"
  ||
  "<div>Publisher: "||fn:string-join($src/mods:originInfo/mods:publisher, " ")||"</div>"
  ||
  "<div>Year: "||fn:string-join($src/(mods:originInfo/mods:dateIssued|mods:part/mods:date), " ")||"</div>"
};


(: build the "date" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_start_date ($src)
as xs:string?
{
  let $tmp :=
  (
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
      (: Orlando XML :)
    ( 
      let $dateAttr := ($src/descendant-or-self::CHRONSTRUCT/((DATE|DATERANGE)[1]/(@VALUE|@FROM)))
      let $dateTxt := ($src/descendant-or-self::CHRONSTRUCT/((DATE|DATERANGE)[1]/text()))
      return
        if ($dateAttr) then
          fn:replace( ($dateAttr), '\-{1,2}$', '') (: Fix Orlando date format :)
        else if ( $dateTxt )  then
          fn:string-join(cwOH:parse-orlando-narrative-date($dateTxt),"-")
        else
          ()
    )
    else if (fn:name($src) eq 'event') then
      (: TEI XML :)
      ( $src/descendant-or-self::tei:date[1]/(@when|@from|@notBefore) )
    else if (fn:name($src) eq 'mods') then
      (: MODS XML :)
      ( 
        let $dateTxt :=
          switch ( local:modsBiblType($src) )
            case "monographic" return $src/mods:originInfo/(mods:dateIssued|mods:copyrightDate)/text()
            case "monographic part" return $src/mods:relatedItem/mods:originInfo/(mods:dateIssued|mods:copyrightDate)/text()
            case "continuing" return $src/mods:relatedItem/mods:part/mods:date/text()
            default return $src/mods:originInfo/mods:dateIssued/text()
        return
          fn:string-join(cwOH:parse-orlando-narrative-date($dateTxt),"-")
      )
    else
      ( )
    )
  return fn:normalize-space(fn:string-join($tmp , ""))
};



(: build the "end date" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_end_date ($src)
as xs:string?
{
  let $tmp :=
  (
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
    (: Orlando XML :)
    ( 
      fn:replace( ($src/descendant-or-self::CHRONSTRUCT/(DATERANGE[1]/@TO)) , '\-{1,2}$','') (: Fix Orlando date format :)
    )
    else if (fn:name($src) eq 'event') then
    (: TEI XML :)
    ( $src/descendant-or-self::tei:date[1]/(@to|@notAfter) )
    else if (fn:name($src) eq 'mods') then
    (: MODS XML :)
      ()
    else
      ()
    )
  return fn:normalize-space(fn:string-join($tmp , ""))
};


(: build the "latLng" (latitude/Longitude) attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_lat_lng ($src)
as xs:string?
{
  let $placeSeq :=
  (
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
    (: Orlando XML :)
    ( 
      (: Orlando Place :)
      for $placeNode in $src//CHRONPROSE//PLACE
      return
        cwPH:get_geo_code($placeNode/@LAT/data(),$placeNode/@LONG/data(),$placeNode/@REF/data(),fn:normalize-space(cwPH:getOrlandoPlaceString($placeNode)))
    )
    else if (fn:name($src) eq 'event') then
    (: TEI XML :)
    ( 
      (: TEI Place :)
      for $placeNode in $src/tei:desc[1]/tei:placeName
      return 
        cwPH:get_geo_code("","",$placeNode/@ref/data(),fn:normalize-space($placeNode/text()))
    )
    else if (fn:name($src) eq 'mods') then
    (: MODS XML :)
    ( 
      (: MODS Place :)
      let $tmp :=
      (
          switch ( local:modsBiblType($src) )
          case "monographic" return $src/mods:originInfo/mods:place
          case "monographic part" return $src/mods:relatedItem/mods:originInfo/mods:place
          case "continuing" return $src/mods:originInfo/mods:place
          default return ()
      )
      for $placeNode in $tmp
      return
        cwPH:get_geo_code("","",$placeNode/@ref/data(),fn:normalize-space(fn:string-join($placeNode/mods:placeTerm[not(@authority eq "marccountry")]/text(), " ")) )
    )
    else
      ( fn:name($src) )
  )
  let $latLngStr :=
    (
    for $placeMap at $i in $placeSeq
        return
          (
            try {
              if ($placeMap('lat')) then
                '"' || local:escapeJSON($placeMap('lat') || "," || $placeMap('lng')) || '"'
              else
                ()
            }
            catch *
            {
              (: if issue in lookup then return North Pole :)
              ""
            }
          )
  )
  let $placeNameStr :=
    (
    for $placeMap at $i in $placeSeq
        return
          (
            try {
              '"' || local:escapeJSON($placeMap('placeStr')) || '"'
            }
            catch *
            {
              ""
            }
          )
  ) 
  let $placeRefStr :=
    (
    for $placeMap at $i in $placeSeq
        return
          (
            try {
              '"' || local:escapeJSON($placeMap('countryName')) || '"'
            }
            catch *
            {
              ""
            }
          )
  ) 
  return 
    local:outputJSONArray( "latLng", fn:string-join($latLngStr, ","))
    ||
    ","
    ||
    local:outputJSONArray( "location", fn:string-join($placeNameStr, ","))
    ||
    ","
    ||
    local:outputJSONArray( "countryName", fn:string-join($placeRefStr, ","))
};

(: build the "eventType" (event type) attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_event_type ($src)
as xs:string?
{
  let $tmp :=
  (
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
    (: Orlando XML :)
    ( 
      switch ( $src/descendant-or-self::CHRONSTRUCT/@CHRONCOLUMN/data() )
        case "NATIONALINTERNATIONAL" return "political"
        case "BRITISHWOMENWRITERS" return "literary"
        case "WRITINGCLIMATE" return "literary"
        case "SOCIALCLIMATE" return "social"                 
        default return "unspecified"
    )
    else if (fn:name($src) eq 'event') then
    (: TEI XML :)
    ( 
      let $eventType := $src/@type/data()
      return 
        if ($eventType) then
          $eventType
        else
          "unspecified"
    )
    else if (fn:name($src) eq 'mods') then
    (: MODS XML :)
    ( "literary" )
    else
      ( fn:name($src) )
    )
  return fn:normalize-space(fn:string-join($tmp , ""))
};




(: build the "label" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_label ($src)
as xs:string?
{
  let $label_max_length := 40
  let $tmp := normalize-space($src/descendant-or-self::CHRONSTRUCT/CHRONPROSE)
  let $label :=
  (
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
    (: Orlando XML :)
    ( 
      fn:concat(
        (: MRB: Thu 09-Apr-2015: uncommented JCA's code to prepend date for Orlando event labels :)
        $src/descendant-or-self::CHRONSTRUCT/(DATE|DATERANGE|DATESTRUCT)/text()
        , ": ",
        substring($tmp, 1, $label_max_length + string-length(substring-before(substring($tmp, $label_max_length+1),' '))) 
        , '...'
      )
    )
    else if (fn:name($src) eq 'event') then
    (: TEI XML :)
    ( $src//tei:label )
    else if (fn:name($src) eq 'mods') then
    (: MODS XML :)
    (
      switch ( local:modsBiblType($src) )
      case "monographic" return $src/mods:titleInfo/mods:title/text() 
      case "monographic part" return $src/mods:relatedItem/mods:titleInfo/mods:title/text() 
      case "continuing" return $src/mods:titleInfo/mods:title/text() 
      default return $src/mods:titleInfo/mods:title/text()
    )
    else
      ( )
    )
  return fn:normalize-space(fn:string-join($label , ""))
};

(: build the "description" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_description ($src)
as xs:string?
{

  let $tmp :=
  (
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
    (: Orlando XML :)
    (
      let $shortprose := 
      (
        if ($src/descendant-or-self::SHORTPROSE) then
        (
        "<p>"
        ||
        $src/descendant-or-self::SHORTPROSE
        ||
        "</p>"
        )
        else
        ()
      )
      return
        "<p>"
        ||
        $src/descendant-or-self::CHRONSTRUCT/CHRONPROSE
        ||
        "</p>"
        ||
        $shortprose
    )
    else if (fn:name($src) eq 'event') then
    (: TEI XML :)
    ( 
      (: MRB: Thu 09-Apr-2015: changed so that description for TEI event is only second desc element :)
      for $tmp in $src//tei:desc[2]
      return 
        '<p>'
        ||
        $tmp 
        ||
        '</p>'
    )
    else if (fn:name($src) eq 'mods') then
    (: MODS XML :)
    (
      switch ( local:modsBiblType($src) )
      case "monographic" return local:modsFormatDescription($src) 
      case "monographic part" return local:modsFormatDescription($src/mods:relatedItem) 
      case "continuing" return local:modsFormatDescription($src)       
      default return local:modsFormatDescription($src)
    )
    else
      ( fn:name($src) )
    )
  return fn:normalize-space(fn:string-join($tmp , ""))
};




(: build the "citation" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:determineSchemaByRootElement($src)
as xs:string?
{
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
      ( "Orlando / CWRC")
    else if (fn:name($src) eq 'event') then
      ( "TEI" )
    else if (fn:name($src) eq 'mods') then
      ( "MODS" )
    else
      ( "" )
};

(: build the "citation" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_citations ($src, $type)
as xs:string?
{

  let $tmp :=
  (
    switch ( $type )
      (: Orlando or CWRC XML :)
      case "Orlando / CWRC"
        return cwOH:build_citation_sequence($src//BIBCITS/BIBCIT)
      (: TEI XML :)
      case "TEI"
        return 
          for $item in $src//tei:listBibl/tei:bibl
          return 
            ( "<div>"||fn:string-join($item/text() , " ")||"</div>" )
      (: MODS XML :)
      case "MODS"
        return ()
      default
        return
          ( fn:name($src) )
  )
  return fn:normalize-space(fn:string-join($tmp , ""))
};



(: build the "contributors" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_contributors ($src, $type)
as xs:string?
{

  let $tmp :=
  (
    switch ( $type )
      (: Orlando or CWRC XML :)
      case "Orlando / CWRC"
        return cwOH:build_contributors_sequence($src/ancestor-or-self::*/ORLANDOHEADER/FILEDESC/PUBLICATIONSTMT/AUTHORITY)
      (: TEI XML :)
      case "TEI"
        return cwOH:build_contributors_sequence($src/ancestor-or-self::*/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/(tei:persName || tei:name | tei:orgName))
      (: MODS XML :)
      case "MODS"
        return cwOH:build_contributors_sequence($src/ancestor-or-self::*/mods:recordInfo/mods:recordContentSource)
      default
        return
          ( )
  )
  return fn:normalize-space(fn:string-join($tmp , ""))
};





(: the main section: define the set of elements that constitute an "event" and output as JSON :)
let $events_sequence := (//tei:event | /EVENT | /EVENTS//(FREESTANDING_EVENT/CHRONSTRUCT) | (WRITING|BIOGRAPHY)//CHRONSTRUCT | //mods:mods)
return
(
'{ "items": [&#10;'
,
  for $event_item as element() at $n in $events_sequence
    let $type := local:determineSchemaByRootElement($event_item)
    return
      "&#123;"
      ||
      (: build sequence and join as a string therefore no need to deal with "," in JSON :)
      fn:string-join( 
        (
        local:outputJSON( "schemaType", string( $type ) )
        (: , local:outputJSON( "schema", string(fn:node-name($event_item)) ) :)
        , local:outputJSON( "startDate", local:get_start_date($event_item) ) 
        , local:outputJSONNotNull( "endDate", local:get_end_date($event_item) )
        , local:get_lat_lng($event_item)
        , local:outputJSON("eventType", local:get_event_type($event_item) )
        , local:outputJSON("label", local:get_label($event_item) )
        , local:outputJSON( "description", local:get_description($event_item) )
        , local:outputJSON( "citations", local:get_citations($event_item, $type) )
        , local:outputJSONNotNull( "contributors", local:get_contributors($event_item, $type) )
        )
        ,
        ","
      )
      || "&#125;,&#10;"
        ,
      ""
    
,
']}'
)
