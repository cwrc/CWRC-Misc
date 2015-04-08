(: a set of helper functions work with "place" elements including geospatial lookups :)

xquery version "3.0" encoding "utf-8";

module namespace cwPH = "cwPlaceHelpers";

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";


(:
: give either a latitude/longitude pair, a uri reference, or a string to lookup
: then return a map
: with the lat/long, uri, string, and some geo code info from the service
:)

declare function cwPH:get_geo_code($lat, $lng, $ref, $placeStr)
{
  let $ret := map {}
  return 
  (: 2015-03-30: lat/lng removed to allow capture of the countryName when "ref" is dereferenced
    if ( $lat and $lng ) then
      map { 'lat': $lat, 'lng': $lng, 'ref': $ref, 'placeStr': $placeStr}
    else 
    :) 
    if ( $ref ) then
      (: lookup reference and get map :)
      cwPH:get_geo_code_by_ref($ref, $placeStr)
    else if ( $placeStr and $placeStr != '' ) then
      (: query string and get map :)
      cwPH:get_geo_code_by_str($placeStr)
    else
      ()
};

(: given a uri reference, lookup the geo code :)
declare function cwPH:get_geo_code_by_ref($ref, $placeStr)
{
  if ( fn:collection()/places/geonames/geoname[@geonameId/data() eq $ref][1] ) then
    cwPH:parse_geo_code_return($placeStr,fn:collection()/places/geonames/geoname[@geonameId/data() eq $ref][1])
  else if ( fn:collection()/places/cwrc_place_entities/entity[@uri/data() eq $ref][1] ) then
    cwPH:parse_geo_code_cwrc($placeStr,fn:collection()/places/cwrc_place_entities/entity[@uri/data() eq $ref][1]/place)
  else if ($ref != '') then
    let $tmp := cwPH:getGeoCodeByIDViaGeoNames($ref)
    return
      cwPH:parse_geo_code_return($placeStr,$tmp/geoname[1])
  else
    ()
};

(:given only a string, lookup the geo code :)
declare function cwPH:get_geo_code_by_str($placeStr)
{
  if ($placeStr != '') then
    let $tmp := cwPH:getGeoCodeByStrViaGeoNames($placeStr)
    return
      cwPH:parse_geo_code_return($placeStr,$tmp/geonames/geoname[1])
  else
    ()
};


(: given the result of a GeoNames lookup, parse and place into a map :)
declare function cwPH:parse_geo_code_return($placeStr, $geoCodeResult)
{
   let $ret := 
     try {
          map { 
            'lat': $geoCodeResult/lat/text()
            , 'lng': $geoCodeResult/lng/text()
            , 'ref': ''
            , 'placeStr': $placeStr
            , 'geonameId': $geoCodeResult/geonameId/text()
            , 'countryName': $geoCodeResult/countryName/text()
            , 'placeName': $geoCodeResult/name/text()
          }
     } catch * {
       map {
         'placeStr': $placeStr
       }
   }
   return
     $ret
};
   
   
(: given the result of a CWRC Place entity, parse and place into a map :)
declare function cwPH:parse_geo_code_cwrc($placeStr, $geoCodeResult)
{
   let $ret := 
     try {
          map { 
            'lat': $geoCodeResult/description/latitude/text()
            , 'lng': $geoCodeResult/description/longitude/text()
            , 'ref': ''
            , 'placeStr': $placeStr
            , 'geonameId': ''
            , 'countryName': $geoCodeResult/description/countryName/text()
            , 'placeName': fn:string-join($geoCodeResult/identity/prefferedform/namePart/text()) 
          }
     } catch * {
       map {
         'placeStr': $placeStr
       }
   }
   return
     $ret
};
      
   
   

(: do the geo code lookup given a query string :)   
(: href="http://api.geonames.org/search?q=fn:encode-for-uri($country||', '||$placename)"> :)
(: href="http://www.google.com" :)
(: href="http://api.geonames.org/search?q=England,%20London&amp;username=brundin&amp;maxRows=1" :)
declare function cwPH:getGeoCodeByStrViaGeoNames ($qryStr as xs:string?)
{
  let $qryEncoded := fn:encode-for-uri(string($qryStr))
  let $tmp := http:send-request(
    <http:request 
      method='get'
      href="http://api.geonames.org/search?q={$qryEncoded}&amp;username=brundin&amp;maxRows=1"
      >
    </http:request>
  )[2]
  return 
    $tmp
};
  
(: do the geo code lookup given a GeoNames ID :)   
(: href="http://api.geonames.org/search?q=fn:encode-for-uri($country||', '||$placename)"> :)
(: href="http://www.google.com" :)
(: href="http://api.geonames.org/search?q=England,%20London&amp;username=brundin&amp;maxRows=1" :)
declare function cwPH:getGeoCodeByIDViaGeoNames ($ref as xs:string?)
{
  let $geonameId := fn:replace($ref, 'http://www.geonames.org/(\d*)[/]?','$1')
  let $tmp := http:send-request(
    <http:request 
      method='get'
      href="http://ws.geonames.org/get?geonameId={$geonameId}&amp;username=brundin"
      >
    </http:request>
  )[2]
  return 
    $tmp
};
  
    
(: Orlando schema: build place string form GEOG, REGION, SETTLEMENT, PLACENAME:)
declare function cwPH:getOrlandoPlaceString($place)
{
   let $place_country := 
     if ($place/GEOG/@CURRENT) then
       $place/GEOG/@CURRENT/data()
     else if ($place/GEOG/@REG) then
       $place/GEOG/@REG/data()
     else  
       $place/GEOG/text()
       
   let $place_settlement := 
     if ($place/SETTLEMENT/@CURRENT) then
       $place/SETTLEMENT/@CURRENT/data()
     else if ($place/SETTLEMENT/@REG) then
       $place/SETTLEMENT/@REG/data()
     else if ($place/SETTLEMENT/text()) then
       $place/SETTLEMENT/text()
     else 
       ''  
   let $place_placename :=
     if ($place/PLACENAME/@CURRENT) then
       $place/PLACENAME/@CURRENT/data()
     else if ($place/PLACENAME/@REG) then
       $place/PLACENAME/@REG/data()
     else if ($place/PLACENAME) then
       $place/PLACENAME/text()
     else
       ''
   let $place_region :=
     if ($place/REGION/@CURRENT) then
       $place/REGION/@CURRENT/data()
     else if ($place/REGION/@REG) then
       $place/REGION/@REG/data()
     else if ($place/REGION) then
       $place/REGION
     else 
       ''
       
   let $placename := 
     if ($place_placename!='' and $place_settlement!='') then
       $place_settlement||', '||$place_placename
     else if ($place_placename) then
       $place_settlement
     else if ($place_settlement) then
       $place_settlement
     else if ($place_region) then
       $place_region
     else
       ''
     
   let $location :=
    if ($place_country != '' and $placename != '') then
      string($place_country||','||$placename)
    else if ($place_country != '') then
      string($place_country)
    else if ($placename != '') then
      string($placename)
    else
      '' 
       
   return   
     $location
};

    
      
(: proof-of-concept :)
declare %updating function cwPH:addPlaceRefToCache($ref)
{
  let $tmp := cwPH:getGeoCodeByIDViaGeoNames($ref) 
  return 
    insert node $ref into /
};