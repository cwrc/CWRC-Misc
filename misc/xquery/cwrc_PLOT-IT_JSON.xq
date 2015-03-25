(: output "events" in the PLOT-IT JSON format from different schemas :)

xquery version "3.0" encoding "utf-8";

import module namespace cwPH="cwPlaceHelpers" at "./cw_place_helpers.xq";

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

declare function local:escapeJSON ($str as xs:string?)
{
  fn:replace($str, '[^""]""[^""]', '\\"')
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



(: build the "date" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_date ($src)
as xs:string?
{
  let $tmp :=
  (
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
    ( 
      fn:replace( ($src/descendant-or-self::CHRONSTRUCT/(DATE[1]/@VALUE) ), '\-{1,2}$','') (: Fix Orlando date format :)
    )
    else if (fn:name($src) eq 'event') then
      ( $src/descendant-or-self::tei:date[1]/@when )
    else if (fn:name($src) eq 'mods') then
      ( $src//mods:dateIssued/text() )
    else
      ( fn:name($src) )
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
    ( 
      (: Orlando Place :)
      for $placeNode in $src//CHRONPROSE//PLACE
      return
        cwPH:get_geo_code($placeNode/@LAT/data(),$placeNode/@LONG/data(),$placeNode/@REF/data(),cwPH:getOrlandoPlaceString($placeNode))
    )
    else if (fn:name($src) eq 'event') then
    ( 
      (: TEI Place :)
      for $placeNode in $src/desc/place
      return 
        cwPH:get_geo_code("","",$placeNode/@REF/data(),$placeNode/text())
    )
    else if (fn:name($src) eq 'mods') then
    ( 
      (: MODS Place :)
      for $placeNode in $src//mods:place/placeTerm/text() 
      return
        cwPH:get_geo_code("","",$placeNode/@REF/data(),$placeNode/text())
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
              '"' || local:escapeJSON($placeMap('lat') || "," || $placeMap('lng')) || '"'
            }
            catch *
            {
              (: if issue in lookup then return North Pole :)
              "0,90"
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
  return 
    local:outputJSONArray( "latLng", fn:string-join($latLngStr, ","))
    ||
    ","
    ||
    local:outputJSONArray( "location", fn:string-join($placeNameStr, ","))
};

(: build the "eventType" (event type) attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_event_type ($src)
as xs:string?
{
  let $tmp :=
  (
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
    ( 
      switch ( $src/descendant-or-self::CHRONSTRUCT/@CHRONCOLUMN/data() )
        case "NATIONALINTERNATIONAL" return "political"
        case "BRITISHWOMENWRITERS" return "literary"
        case "WRITINGCLIMATE" return "literary"
        case "SOCIALCLIMATE" return "social"                 
        default return "unspecified"
    )
    else if (fn:name($src) eq 'event') then
      ( 
        let $eventType := $src/@type/data()
        return 
          if ($eventType) then
            $eventType
          else
            "unspecified"
       )
    else if (fn:name($src) eq 'mods') then
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
    ( 
      fn:concat(
        (: $src/descendant-or-self::CHRONSTRUCT/(DATE|DATERANGE|DATESTRUCT)/text() :)
        (: , ": " :)
        substring($tmp, 1, $label_max_length + string-length(substring-before(substring($tmp, $label_max_length+1),' '))) 
        , '...'
      )
    )
    else if (fn:name($src) eq 'event') then
      ( $src//tei:label )
    else if (fn:name($src) eq 'mods') then
      ( $src//mods:title )
    else
      ( fn:name($src) )
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
    (
      let $shortprose := 
      (
        if ($src/descendant-or-self::CHRONSTRUCT/SHORTPROSE) then
        (
        "<p>"
        ||
        $src/descendant-or-self::CHRONSTRUCT/SHORTPROSE
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
      ( 
      for $tmp in $src//tei:desc
      return 
        '<p>'
        ||
        $tmp 
        ||
        '</p>'
    )
    else if (fn:name($src) eq 'mods') then
      ( $src//mods:title )
    else
      ( fn:name($src) )
    )
  return fn:normalize-space(fn:string-join($tmp , ""))
};





let $events_sequence := (//tei:event | /EVENT | /EVENTS//(FREESTANDING_EVENT/CHRONSTRUCT) | (WRITING|BIOGRAPHY)//CHRONSTRUCT | mods:mod)
return
(
'{ "items": [&#10;'
,
   for $event_item as element() at $n in $events_sequence

     
   return
    string( 
      "&#123;"
      || local:outputJSON( "schema", string(fn:node-name($event_item)) )
      || ","
      || local:outputJSON( "startDate", local:get_date($event_item) )
      || ","
      || local:get_lat_lng($event_item)
      || ","
      || local:outputJSON("eventType", local:get_event_type($event_item) )
      || ","      
      || local:outputJSON("label", local:get_label($event_item) )
      || ","
      || local:outputJSON( "description", local:get_description($event_item) )
      || ""
      || "&#125;,&#10;"
    )
,
']}'
)
