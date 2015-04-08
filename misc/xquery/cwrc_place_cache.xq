(: 
* purpose: create a cache of geospatial information if not already present in BaseX to facilitate faster lookups
* iterate through a set of place elements 
* add a "ref" attribute if none exist via a cloud lookup 
* cache the GeoNames HTTP response to speed up future lookups by not having to go to the cloud
:)

xquery version "3.0" encoding "utf-8";

import module namespace cwPH="cwPlaceHelpers" at "./cw_place_helpers.xq";

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";

(
(: for $ref in //CHRONSTRUCT/CHRONPROSE/PLACE[not(@LAT) and not(@LNG)]/@REF | //tei:event/tei:desc[1]/tei:placeName/@ref:)
(: if @ref then lookup @ref and add the record details to a BaseX cache to prevent having to access geonames.org an slow down a query (e.g. generate JSON :)  
for $ref in //CHRONSTRUCT/CHRONPROSE/PLACE/@REF | //tei:event/tei:desc[1]/tei:placeName/@ref | //mods:place/@ref
group by $ref
order by $ref
return
  if ( not( /places/geonames/geoname[@geonameId = $ref]) and not(/places/cwrc_place_entities/entity[@uri = $ref]) )  then
  (
    let $tmp := cwPH:getGeoCodeByIDViaGeoNames($ref)
     
    return 
    (
      insert node (<geoname geonameId="{$ref}">{$tmp/geoname/*}</geoname>) as first into /places/geonames
    )
  )
  else
    ()
)
,
(
(: if no @REF then attempt to lookup place text in geonames and if successful, add a @ref to the "place" element :)
for $placeNode in //CHRONSTRUCT/CHRONPROSE/PLACE[(not(@LAT) and not(@LNG)) and not(@REF)] | //tei:event/tei:desc[1]/tei:placeName[not(@ref)] | //mods:place[not(@ref)]
return
  let $placeStr :=
  (
    if ( fn:name($placeNode) eq 'PLACE' ) then
      cwPH:getOrlandoPlaceString($placeNode)
    else if ( fn:name($placeNode[child::placeTerm]) ) then
      $placeNode/text()
    else if ( fn:name($placeNode) eq 'place' ) then
      fn:string-join($placeNode/mods:placeTerm[not(@authority eq 'marccountry')]/text(), " ")
    else if ( fn:name($placeNode) eq 'placeTerm' ) then
      fn:string-join($placeNode/mods:placeTerm[not(@authority eq 'marccountry')]/text(), " ")
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
    if ($ref) then
      let $refUri := "http://www.geonames.org/"||$ref||"/"
      return 
      (
        insert node (<geoname geonameId="{$refUri}">{$tmp/geonames/geoname/*}</geoname>) as first into /places/geonames
        ,
        insert node (attribute {$attrName} {$refUri} ) as last into $placeNode
        (:
        ,
        insert node (attribute {'lookup_str'} {$placeStr} ) as last into $placeNode
        :)
      )
    else if ( not($placeNode/@failed_lookup_str) ) then
      (
        insert node (attribute {'failed_lookup_str'} {$placeStr} ) as last into $placeNode
      )
    else
      ()
  )
)

