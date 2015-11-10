(: 
* purpose: create a cache of geospatial information if not already present in BaseX to facilitate faster lookups
* iterate through a set of place elements 
* add a "ref" attribute if none exist via a cloud lookup 
* cache the GeoNames HTTP response to speed up future lookups by not having to go to the cloud
*
* V2 2015-11-10 - add more sophistication for Orlando docs
:)

xquery version "3.0" encoding "utf-8";

import module namespace cwPH="cwPlaceHelpers" at "./cw_place_helpers.xq";

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";

(:declare variable $cwPH:XMLDB_CACHE_NAME external := "x"; :)


(: Orlando schema: build place string form GEOG, REGION, SETTLEMENT, PLACENAME:)
declare function local:getOrlandoPlaceCountry($place)
{
   let $place_country := 
     if ($place/GEOG/@CURRENT) then
       $place/GEOG/@CURRENT/data()
     else if ($place/GEOG/@REG) then
       $place/GEOG/@REG/data()
     else  
       $place/GEOG/text()
     
   let $place_country :=    
     if ($place_country = ('England', 'Wales', 'Scotland', 'Northern Ireland') )  then
       "UK"
     else
       $place_country
     
   return $place_country
};
     
(: Orlando schema: build place string form GEOG, REGION, SETTLEMENT, PLACENAME:)
declare function local:getOrlandoPlaceRegion($place, $country)
{
   let $place_region :=
     if ($place/REGION/@CURRENT) then
       $place/REGION/@CURRENT/data()
     else if ($place/REGION/@REG) then
       $place/REGION/@REG/data()
     else if ($place/REGION/text()) then
       $place/REGION/text()
     else 
       ()

   let $place_region :=    
     if ($country = ('England', 'Wales', 'Scotland', 'Northern Ireland') )  then
       ()
     else
       $place_region
       
   return $place_region
};


(: Orlando schema: build place string form GEOG, REGION, SETTLEMENT, PLACENAME:)
declare function local:getOrlandoPlaceLocality($place)
{
   let $place_settlement := 
     if ($place/SETTLEMENT/@CURRENT) then
       $place/SETTLEMENT/@CURRENT/data()
     else if ($place/SETTLEMENT/@REG) then
       $place/SETTLEMENT/@REG/data()
     else if ($place/SETTLEMENT/text()) then
       $place/SETTLEMENT/text()
     else 
       ()
         
   let $place_placename :=
     if ($place/PLACENAME/@CURRENT) then
       $place/PLACENAME/@CURRENT/data()
     else if ($place/PLACENAME/@REG) then
       $place/PLACENAME/@REG/data()
     else if ($place/PLACENAME) then
       $place/PLACENAME/text()
     else
       ()
       
   let $concatPlace :=  fn:string-join(($place_placename, $place_settlement), ', ')    
   
   return   
     $concatPlace
};



(:
(
for $ref in //CHRONSTRUCT/CHRONPROSE/PLACE/@REF | //tei:event/tei:desc[1]/tei:placeName/@ref | //mods:place/@ref
group by $ref
order by $ref
return
  if ( not( db:open($cwPH:XMLDB_CACHE_NAME)/places/geonames/geoname[@geonameId = $ref]) and not(db:open($cwPH:XMLDB_CACHE_NAME)/places/cwrc_place_entities/entity[@uri = $ref]) and not (db:open($cwPH:XMLDB_CACHE_NAME)/places/google_geocode/entity[@uri = $ref]) )  then
  (
    
          switch ( cwPH:placeRefType($ref) )
          case $cwPH:geonames_str 
             return (
               let $tmp := cwPH:getGeoCodeByIDViaGeoNames($ref)
               return insert node (<geoname geonameId="{$ref}">{$tmp/geoname/*}</geoname>) as first into db:open($cwPH:XMLDB_CACHE_NAME)/places/geonames
             )
          case $cwPH:cwrc_str 
             return (
               let $tmp := cwPH:getGeoCodeByIDViaCWRC($ref)
               return insert node (<entity uri="{$ref}">{$tmp/entity/*}</entity>) as first into db:open($cwPH:XMLDB_CACHE_NAME)/places/cwrc_place_entities
             )
          case $cwPH:google_str 
             return 
             (
               let $tmp := cwPH:getGeoCodeByIDViaGoogle($ref)
               return insert node (<entity uri="{$ref}">{$tmp}</entity>) as first into db:open($cwPH:XMLDB_CACHE_NAME)/places/google_geocode
             )
           default
             return    
             (
             )
  )
  else
    ()
)
,
:)
(
(: if no @REF then attempt to lookup place text in geonames and if successful, add a @ref to the "place" element :)

for $placeNode in //PLACE[(not(@LAT) and not(@LNG)) and not(@REF)] | //tei:event/tei:desc[1]/tei:placeName[not(@ref)] | //mods:place[not(@ref)]
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
  let $orlandoPlaceMap :=
    map{
      'locality' : ( $placeNode/())
      
    }
    
    
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
    if ($ref) then
      let $refUri := "http://www.geonames.org/"||$ref||"/"
      return 
      (
        insert node (<geoname geonameId="{$refUri}">{$tmp/geonames/geoname/*}</geoname>) as first into db:open($cwPH:XMLDB_CACHE_NAME)/places/geonames
        ,
        insert node (attribute {$attrName} {$refUri} ) as last into $placeNode
      )
    else if ( not($placeNode/@failed_lookup_str) ) then
      (
        insert node (attribute {'failed_lookup_str'} {$placeStr} ) as last into $placeNode
      )
    else
      ()
  )

)

