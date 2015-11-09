(: help speed up the addition of a REF attribute to an Orlando place by providing a mapping :)

import module namespace cwPH="cwPlaceHelpers" at "./cw_place_helpers.xq";

let $src := //PLACE[@REF]
let $tmp :=
    for $placeNode in $src
    let $placeMap := cwPH:get_geo_code("","",$placeNode/@REF/data(),"")
    return
      (
        '{'
        ||
        '"' || $placeNode/@REF/data() || '",'
        ||
        '"' || cwPH:getOrlandoPlaceString($placeNode) || '",'
   (:     ||
        '"' || $placeMap('placeName') || ' ' || $placeMap('countryName') || '"'
        :)
        ||
        '}&#10;'
     )
  
return
(
  '{ "items": [&#10;'
  ,
  (
    fn:string-join($tmp, ',')
  )
  ,
  ']}'
)