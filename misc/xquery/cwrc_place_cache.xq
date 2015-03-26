(: 
* iterate through a set of place elements 
* add a "ref" attribute if none exist via a cloud lookup 
* cache the GeoNames HTTP response to speed up future lookups by not having to go to the cloud
:)

xquery version "3.0" encoding "utf-8";

import module namespace cwPH="cwPlaceHelpers" at "./cw_place_helpers.xq";

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";

(
for $ref in //CHRONSTRUCT/CHRONPROSE/PLACE[not(@LAT) and not(@LNG)]/@REF | //tei:event/tei:desc[1]/tei:placeName/@ref
group by $ref
order by $ref
return
  if ( not( /places/geonames/geoname[@geonameId = $ref])) then
  (
    let $tmp := cwPH:getGeoCodeByIDViaGeoNames($ref)
     
    return 
    (
      insert node (<geoname geonameId="{$ref}">{$tmp/geoname/*}</geoname>) as first into /places/geonames
     (:
      ,
      insert node (attribute {'geonameId'} {$ref} ) as last into /places/geonames/geoname[last()]
      :)
    )
  )
  else
    ()
)
,
(
for $placeNode in //CHRONSTRUCT/CHRONPROSE/PLACE[(not(@LT) and not(@LNG)) and not(@REF)] | //tei:event/tei:desc[1]/tei:placeName[not(@ref)]
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
  let $placeMap := cwPH:parse_geo_code_return($placeStr,$tmp/geonames/geoname[1])
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
    let $refUri := "http://www.geonames.org/"||$ref||"/"
    return 
    (
      insert node (<geoname geonameId="{$refUri}">{$tmp/geonames/geoname/*}</geoname>) as first into /places/geonames
      ,
      insert node (attribute {$attrName} {$refUri} ) as last into $placeNode
    )
  )
)

