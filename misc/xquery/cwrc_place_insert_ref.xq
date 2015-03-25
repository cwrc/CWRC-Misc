(: Given a source document, iterate through all the "place" elements and add a "ref" attribute :)

xquery version "3.0" encoding "utf-8";

import module namespace cwPH="cwPlaceHelpers" at "./cw_place_helpers.xq";

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";

(
(: for $placeNode in //CHRONSTRUCT/CHRONPROSE/PLACE[(not(@LT) and not(@LNG)) and not(@REF)] | //event/desc[1]/place[not(@ref)] :)
for $placeNode in //CHRONSTRUCT/CHRONPROSE/PLACE | //event/desc[1]/place
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
  let $placeMap := cwPH:parse_geo_code_return($placeStr,$tmp)
  let $ref := $placeMap('geonameId')
  let $attrName :=
  (
    if ( fn:name($placeNode) eq 'PLACE' ) then
      "REF8"
    else
      "ref8"
  )
  return 
  (
    
    insert node (<geoname geonamesId="{$ref}">{$tmp/geoname/*}</geoname>) as first into /places/geonames
    ,
    
    insert node (attribute {$attrName} {$placeStr} ) as last into $placeNode
  )
)

