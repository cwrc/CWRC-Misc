(: Given a source document, iterate through all the "place" elements and add a "ref" attribute :)

xquery version "3.0" encoding "utf-8";

import module namespace cwPH="cwPlaceHelpers" at "./cw_place_helpers.xq";

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";

(

(:
for $placeNode in //CHRONSTRUCT/CHRONPROSE/PLACE | //event/desc[1]/placeName 
:)
(: if a "place" element is missing a @ref attribute, attempt to lookup the text of the element in goenames and add a @ref attribute :)
for $placeNode in //CHRONSTRUCT/CHRONPROSE/PLACE[(not(@LAT) and not(@LNG)) and not(@REF)] | //tei:event/tei:desc[1]/tei:placeName[not(@ref)]
return
  let $placeStr :=
  (
    if ( fn:name($placeNode) eq 'PLACE' ) then
      cwPH:getOrlandoPlaceString($placeNode)
    else if ( fn:name($placeNode) eq 'place' ) then
      $placeNode/text()
    else if ( fn:name($placeNode) eq 'placeTerm' ) then
      $placeNode/text()
    else
      ""    
  )
  let $tmp := cwPH:getGeoCodeByStrViaGeoNames($placeStr) 
  let $placeMap := cwPH:parse_geo_code_geonames($placeStr,$tmp/geonames/geoname[1])
  let $ref := $placeMap('geonameId')
  let $attrName :=
  (
    if ( fn:name($placeNode) eq 'PLACE' ) then
      "REF"
    else
      "ref"
  )
  return 
  (
    (:
    insert node (<geoname geonameId="{$ref}">{$tmp/geonames/geoname/*}</geoname>) as first into /places/geonames
    ,
    :)
    insert node (attribute {$attrName} {"http://www.geonames.org/"||$ref||"/"} ) as last into $placeNode
  )
)

