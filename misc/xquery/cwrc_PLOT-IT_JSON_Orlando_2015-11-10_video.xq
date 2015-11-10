(: output "events" in the PLOT-IT JSON format from different schemas :)

xquery version "3.0" encoding "utf-8";

import module namespace cwPH="cwPlaceHelpers" at "./helpers/cw_place_helpers.xq";
import module namespace cwOH="cwOrlandoHelpers" at "./helpers/cw_orlando_helpers.xq";

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

(: external variables :)
declare variable $FEDORA_PID external := "";
declare variable $BASE_URL external := "http://orlando.cambridge.org/public/svPeople?person_id=";
declare variable $PID_LIST external := ();
declare variable $PID_COLLECTION external := "";

(: internal constants :)
declare variable $TYPE_ORLANDO_CWRC := "CWRC / Orlando";
declare variable $TYPE_TEI := "TEI";
declare variable $TYPE_MODS := "MODS";

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

declare function local:outputJSONArrayNotNull  ($key as xs:string?, $value)
as xs:string?
{
  if ($value != "") then
    local:outputJSONArray($key, $value)
  else
    ()  
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


(: ***** collect JSON values ******* :)

(: build the "date" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_start_date ($src, $type)
as xs:string?
{
  let $tmp :=
  (
    if ( $type eq $TYPE_ORLANDO_CWRC) then
      (: Orlando XML :)
    ( 
      (: To do: If DATERANCE has not attribute value, determine how to interpret the decendant tags and test. :)
      let $dateAttr := ($src/descendant-or-self::CHRONSTRUCT/((DATE|DATERANGE|DATESTRUCT)[1]/(@VALUE|@FROM)))
      let $dateTxt := ($src/descendant-or-self::CHRONSTRUCT/((DATE|DATERANGE)[1]/text()))
      return
        if ($dateAttr) then
          fn:replace( ($dateAttr), '\-{1,2}$', '') (: Fix Orlando date format :)
        else if ( $dateTxt )  then
          fn:string-join(cwOH:parse-orlando-narrative-date($dateTxt),"-")
        else
          ()
    )
    else if ($type eq $TYPE_TEI) then
      (: TEI XML :)
      ( $src/descendant-or-self::tei:date[1]/(@when|@from|@notBefore) )
    else if ($type eq $TYPE_MODS) then
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
declare function local:get_end_date ($src, $type)
as xs:string?
{
  let $tmp :=
  (
    if ( $type eq $TYPE_ORLANDO_CWRC) then
    (: Orlando XML :)
    ( 
      fn:replace( ($src/descendant-or-self::CHRONSTRUCT/(DATERANGE[1]/@TO)) , '\-{1,2}$','') (: Fix Orlando date format :)
    )
    else if ($type eq $TYPE_TEI) then
    (: TEI XML :)
    ( $src/descendant-or-self::tei:date[1]/(@to|@notAfter) )
    else if ($type eq $TYPE_MODS) then
    (: MODS XML :)
      ()
    else
      ()
    )
  return fn:normalize-space(fn:string-join($tmp , ""))
};


(: build the "latLng" (latitude/Longitude) attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_lat_lng ($src, $type)
as xs:string?
{
  let $placeSeq :=
  (
    if ( $type eq $TYPE_ORLANDO_CWRC) then
    (: Orlando XML :)
    ( 
      (: Orlando Place :)
      for $placeNode in $src//CHRONPROSE//PLACE
      return
        cwPH:get_geo_code($placeNode/@LAT/data(),$placeNode/@LONG/data(),$placeNode/@REF/data(),fn:normalize-space(cwPH:getOrlandoPlaceString($placeNode)))
    )
    else if ($type eq $TYPE_TEI) then
    (: TEI XML :)
    ( 
      (: TEI Place :)
      for $placeNode in $src/tei:desc[1]/tei:placeName
      return 
        cwPH:get_geo_code("","",$placeNode/@ref/data(),fn:normalize-space($placeNode/text()))
    )
    else if ($type eq $TYPE_MODS) then
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
                ''
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
declare function local:get_event_type ($src, $type)
as xs:string?
{
  let $tmp :=
  (
    if ( $type eq $TYPE_ORLANDO_CWRC) then
    (: Orlando XML :)
    ( 
      switch ( $src/descendant-or-self::CHRONSTRUCT/@CHRONCOLUMN/data() )
        case "NATIONALINTERNATIONAL" return "political"
        case "BRITISHWOMENWRITERS" return "literary"
        case "WRITINGCLIMATE" return "literary"
        case "SOCIALCLIMATE" return "social"                 
        default return "unspecified"
    )
    else if ($type eq $TYPE_TEI) then
    (: TEI XML :)
    ( 
      let $eventType := $src/@type/data()
      return 
        if ($eventType) then
          $eventType
        else
          "unspecified"
    )
    else if ($type eq $TYPE_MODS) then
    (: MODS XML :)
    ( "literary" )
    else
      ( fn:name($src) )
    )
  return fn:normalize-space(fn:string-join($tmp , ""))
};




(: build the "label" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_label ($src, $type)
as xs:string?
{
  let $label_max_length := 40
  let $tmp := normalize-space($src/descendant-or-self::CHRONSTRUCT/CHRONPROSE)
  let $label :=
  (
    if ( $type eq $TYPE_ORLANDO_CWRC) then
    (: Orlando XML :)
    ( 
      fn:concat(
        (: MRB: Thu 09-Apr-2015: uncommented JCA's code to prepend date for Orlando event labels :)
        fn:string-join($src/descendant-or-self::CHRONSTRUCT/(DATE|DATERANGE|DATESTRUCT/descendant-or-self::*)/text())
        , ": ",
        substring($tmp, 1, $label_max_length + string-length(substring-before(substring($tmp, $label_max_length+1),' '))) 
        , '...'
      )
    )
    else if ($type eq $TYPE_TEI) then
      (: TEI XML :)
      ( $src//tei:label )
    else if ($type eq $TYPE_MODS) then
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
declare function local:get_description ($src, $type)
as xs:string?
{
  let $tmp :=
  (
    if ( $type eq $TYPE_ORLANDO_CWRC) then
    (: Orlando XML :)
    (
      let $shortprose := 
      (
        if ($src/descendant-or-self::SHORTPROSE) then
        (
        "<p>"
        ||
        fn:serialize($src/descendant-or-self::SHORTPROSE)
        ||
        "</p>"
        )
        else
        ()
      )
      return
        "<p>"
        ||
        fn:serialize($src/descendant-or-self::CHRONSTRUCT/CHRONPROSE)
        ||
        "</p>"
        ||
        $shortprose
    )
    else if ($type eq $TYPE_TEI) then
    (: TEI XML :)
    ( 
      for $tmp in $src//tei:desc
      return 
        fn:serialize(<p>{$tmp}</p>) 
    )
    else if ($type eq $TYPE_MODS) then
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

(: build the list of collections :)
declare function local:get_collections ($src)
{
  let $tmpStr :=
    for $tmp in  $src/ancestor::obj
    return
      fn:substring-after(fn:string($tmp), '/')
  return
    '"'||fn:string-join($tmpStr,'","')||'"'
};

(: build the "citation" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_citations ($src, $type)
as xs:string?
{

  let $tmp :=
  (
    switch ( $type )
      (: Orlando or CWRC XML :)
      case $TYPE_ORLANDO_CWRC 
        return cwOH:build_citation_sequence($src//BIBCITS/BIBCIT | $src/following-sibling::BIBCITS[position()=1]/BIBCIT)
      (: TEI XML :)
      case $TYPE_TEI 
        return 
          for $item in $src//tei:listBibl/tei:bibl
          return 
            ( "<div>"||fn:string-join($item, " ")||"</div>" )
      (: MODS XML :)
      case $TYPE_MODS
        return ()
      default
        return
          ( "ERROR: " || fn:name($src) )
  )
  return '"'||fn:normalize-space(fn:string-join($tmp , ""))||'"'
};


(: build the "contributors" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:get_contributors ($src, $type)
as xs:string?
{

  let $tmp :=
  (
    switch ( $type )
      (: Orlando or CWRC XML :)
      case $TYPE_ORLANDO_CWRC 
        return cwOH:build_contributors_sequence($src/ancestor-or-self::*/ORLANDOHEADER/FILEDESC/PUBLICATIONSTMT/AUTHORITY)
      (: TEI XML :)
      case "TEI"
        return cwOH:build_contributors_sequence($src/ancestor-or-self::*/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/(tei:persName || tei:name | tei:orgName))
      (: MODS XML :)
      case $TYPE_MODS 
        return cwOH:build_contributors_sequence($src/ancestor-or-self::*/mods:recordInfo/mods:recordContentSource)
      default
        return
          ( "ERROR: " || fn:name($src) )
  )
  return fn:normalize-space(fn:string-join($tmp , ""))
};


(: build the "citation" attribute from the different schemas: Orlando, TEI, MODS, and CWRC :)
declare function local:determineSchemaByRootElement($src)
as xs:string?
{
    if ( fn:name($src) eq 'EVENT' or fn:name($src) eq 'CHRONSTRUCT') then
      ( $TYPE_ORLANDO_CWRC )
    else if (fn:namespace-uri($src) eq 'http://www.tei-c.org/ns/1.0') then
      ( $TYPE_TEI )
    else if (fn:namespace-uri($src) eq 'http://www.loc.gov/mods/v3') then
      ( $TYPE_MODS )
    else
      ( "ERROR: " || fn:name($src) )
};


(: ***** MAIN ******* :)

let $ac := /*

(: the main section: define the set of elements that constitute an "event" and output as JSON :)
let $events_sequence := ($ac//tei:event | $ac/EVENT[position()<2] | $ac/*/EVENTS//((FREESTANDING_EVENT|HOSTED_EVENT)/CHRONSTRUCT) | $ac/*/(WRITING|BIOGRAPHY)//CHRONSTRUCT | $ac/*/mods:mods)

(: 1700-1799  and ( .//SETTLEMENT/text()='London' or .//@REG='London') :)
(:
let $groupStr := "1700-1799 London"
let $events_sequence := (
  //EVENT[@FILENAME = (
    'scudma-b.sgm', 'blauba-b.sgm', 'fellma-b.sgm', 'leadja-b.sgm', 'docwan-b.sgm', 'thoral-b.sgm', 'audlan-b.sgm', 'hoptsu-b.sgm', 'whitjo-b.sgm', 'drydjo-b.sgm', 'lockjo-b.sgm', 'alleha-b.sgm', 'stirel-b.sgm', 'hollca-b.sgm', 'russra-b.sgm', 'frekel-b.sgm', 'newtis-b.sgm', 'cowpsa-b.sgm', 'buryel-b.sgm', 'nortfr-b.sgm', 'morema-b.sgm', 'jameel-b.sgm', 'lamban-b.sgm', 'delae2-b.sgm', 'aulnma-b.sgm', 'barkja-b.sgm', 'beauag-b.sgm', 'chudma-b.sgm', 'norrjo-b.sgm', 'mashda-b.sgm', 'marsm_-b.sgm', 'defoda-b.sgm', 'fincan-b.sgm', 'burnel-b.sgm', 'fience-b.sgm', 'savasa-b.sgm', 'pix_ma-b.sgm', 'drakju-b.sgm', 'astema-b.sgm', 'piersa-b.sgm', 'swifjo-b.sgm', 'danval-b.sgm', 'weslsu-b.sgm', 'herblu-b.sgm', 'centsu-b.sgm', 'fygesa-b.sgm', 'wastel-b.sgm', 'manlde-b.sgm', 'stonsa-b.sgm', 'congwi-b.sgm', 'mandbe-b.sgm', 'boweba-b.sgm', 'dixosa-b.sgm', 'nithwi-b.sgm', 'steeri-b.sgm', 'addijo-b.sgm', 'wiseja-b.sgm', 'davyma-b.sgm', 'trotca-b.sgm', 'roweel-b.sgm', 'thomel-b.sgm', 'caesma-b.sgm', 'aubipe-b.sgm', 'curled-b.sgm', 'elstel-b.sgm', 'brerja-b.sgm', 'cairel-b.sgm', 'barbma-b.sgm', 'cowpma-b.sgm', 'squija-b.sgm', 'law_wi-b.sgm', 'chanma-b.sgm', 'popeal-b.sgm', 'collma-b.sgm', 'burtca-b.sgm', 'butls2-b.sgm', 'fowkma-b.sgm', 'montma-b.sgm', 'richsa-b.sgm', 'haywel-b.sgm', 'mastma-b.sgm', 'tollel-b.sgm', 'chesph-b.sgm', 'graffr-b.sgm', 'irwian-b.sgm', 'wrigme-b.sgm', 'wrigsu-b.sgm', 'coopel-b.sgm', 'cookan-b.sgm', 'hertfr-b.sgm', 'chapsa-b.sgm', 'delama-b.sgm', 'humeso-b.sgm', 'madaju-b.sgm', 'justel-b.sgm', 'grieco-b.sgm', 'willan-b.sgm', 'johnja-b.sgm', 'jonema-b.sgm', 'fielhe-b.sgm', 'glasha-b.sgm', 'pilkla-b.sgm', 'philte-b.sgm', 'johnsa-b.sgm', 'boydel-b.sgm', 'fielsa-b.sgm', 'rousje-b.sgm', 'ashbel-b.sgm', 'charch-b.sgm', 'sterla-b.sgm', 'caldma-b.sgm', 'collja-b.sgm', 'formch-b.sgm', 'collm2-b.sgm', 'palmma-b.sgm', 'grayth-b.sgm', 'garrda-b.sgm', 'steea2-b.sgm', 'walpho-b.sgm', 'cartel-b.sgm', 'peisma-b.sgm', 'montel-b.sgm', 'fishan-b.sgm', 'mccach-b.sgm', 'pennsa-b.sgm', 'scotsa-b.sgm', 'smytsu-b.sgm', 'smolto-b.sgm', 'talbca-b.sgm', 'lattma-b.sgm', 'leapma-b.sgm', 'teftel-b.sgm', 'niheel-b.sgm', 'sherfr-b.sgm', 'broofr-b.sgm', 'wartja-b.sgm', 'philca-b.sgm', 'grifha-b.sgm', 'grifel-b.sgm', 'chaphe-b.sgm', 'dubodo-b.sgm', 'halema-b.sgm', 'warrme-b.sgm', 'goldol-b.sgm', 'reevcl-b.sgm', 'lennch-b.sgm', 'reynfr-b.sgm', 'savama-b.sgm', 'devema-b.sgm', 'macaca-b.sgm', 'cowpwi-b.sgm', 'wheeag-b.sgm', 'jebban-b.sgm', 'wooda_-b.sgm', 'walkma-b.sgm', 'moodel-b.sgm', 'painth-b.sgm', 'fergel-b.sgm', 'coopma-b.sgm', 'darwma-b.sgm', 'butlel-b.sgm', 'parsel-b.sgm', 'fletma-b.sgm', 'dobssu-b.sgm', 'lucama-b.sgm', 'gibbph-b.sgm', 'candan-b.sgm', 'wallan-b.sgm', 'millan-b.sgm', 'trimsa-b.sgm', 'piozhe-b.sgm', 'kindje-b.sgm', 'adamab-b.sgm', 'pagais-b.sgm', 'sewaan-b.sgm', 'cowlha-b.sgm', 'barban-b.sgm', 'helmel-b.sgm', 'gildel-b.sgm', 'murrsa-b.sgm', 'cookc2-b.sgm', 'bonhel-b.sgm', 'marij2-b.sgm', 'barrma-b.sgm', 'equiol-b.sgm', 'gardsa-b.sgm', 'moreha-b.sgm', 'holcth-b.sgm', 'radcma-b.sgm', 'genlst-b.sgm', 'hawkca-b.sgm', 'handel-b.sgm', 'skinan-b.sgm', 'blamsu-b.sgm', 'gunnsu-b.sgm', 'hervel-b.sgm', 'minima-b.sgm', 'chamm2-b.sgm', 'strama-b.sgm', 'smitch-b.sgm', 'damean-b.sgm', 'lewial-b.sgm', 'huttlu-b.sgm', 'bennan-b.sgm', 'bowdhe-b.sgm', 'gomean-b.sgm', 'hersca-b.sgm', 'soutjo-b.sgm', 'lee_so-b.sgm', 'wakepr-b.sgm', 'barnan-b.sgm', 'scotma-b.sgm', 'batthe-b.sgm', 'murrju-b.sgm', 'craihe-b.sgm', 'sherri-b.sgm', 'burnfr-b.sgm', 'bleean-b.sgm', 'chatth-b.sgm', 'wheaph-b.sgm', 'yearan-b.sgm', 'inchel-b.sgm', 'deflma-b.sgm', 'huntra-b.sgm', 'elligr-b.sgm', 'jacsfr-b.sgm', 'branha-b.sgm', 'jacsma-b.sgm', 'granan-b.sgm', 'fay_el-b.sgm', 'huttca-b.sgm', 'godwwi-b.sgm', 'hamiel-b.sgm', 'robima-b.sgm', 'taylan-b.sgm', 'holfma-b.sgm', 'lee_ha-b.sgm', 'knigel-b.sgm', 'devoge-b.sgm', 'goocel-b.sgm', 'stualo-b.sgm', 'devoel-b.sgm', 'blakwi-b.sgm', 'larpan-b.sgm', 'bradm2-b.sgm', 'westja-b.sgm', 'fostha-b.sgm', 'leadma-b.sgm', 'burnro-b.sgm', 'wollma-b.sgm', 'haysma-b.sgm', 'kellis-b.sgm', 'willhe-b.sgm', 'hawkla-b.sgm', 'littja-b.sgm', 'mortsa-b.sgm', 'brooch-b.sgm', 'bryama-b.sgm', 'mackan-b.sgm', 'pluman-b.sgm', 'beckwi-b.sgm', 'wellhe-b.sgm', 'logade-b.sgm', 'meekel-b.sgm', 'rowssu-b.sgm', 'catcma-b.sgm', 'tennta-b.sgm', 'caveja-b.sgm', 'bailjo-b.sgm', 'simcel-b.sgm', 'bowlwi-b.sgm', 'starma-b.sgm', 'sumble-b.sgm', 'tatlel-b.sgm', 'palmal-b.sgm', 'tomlel-b.sgm', 'sleael-b.sgm', 'burkan-b.sgm', 'wolfel-b.sgm', 'rochre-b.sgm', 'cobbel-b.sgm', 'hattan-b.sgm', 'radcan-b.sgm', 'lambma-b.sgm', 'fansca-b.sgm', 'bannan-b.sgm', 'fenwel-b.sgm', 'staege-b.sgm', 'nairca-b.sgm', 'sykehe-b.sgm', 'bentel-b.sgm', 'corpha-b.sgm', 'gilba2-b.sgm', 'edgema-b.sgm', 'spenel-b.sgm', 'trenme-b.sgm', 'wattsu-b.sgm', 'parkma-b.sgm', 'gunnel-b.sgm', 'stocma-b.sgm', 'pluma2-b.sgm', 'marcja-b.sgm', 'falcan-b.sgm', 'opieam-b.sgm', 'heyrel-b.sgm', 'crisan-b.sgm', 'oneifr-b.sgm', 'pearsu-b.sgm', 'greesa-b.sgm', 'fletel-b.sgm', 'hoflba-b.sgm', 'wordwi-b.sgm', 'dacrch-b.sgm', 'harvja-b.sgm', 'scotwa-b.sgm', 'thome2-b.sgm', 'worddo-b.sgm', 'graych-b.sgm', 'mathel-b.sgm', 'burnsa-b.sgm', 'tighma-b.sgm', 'colesa-b.sgm', 'riddma-b.sgm', 'chamma-b.sgm', 'milnch-b.sgm', 'charma-b.sgm', 'kilhha-b.sgm', 'soutro-b.sgm', 'patrmr-b.sgm', 'younma-b.sgm', 'bethm2-b.sgm', 'kembma-b.sgm', 'burych-b.sgm', 'sherma-b.sgm', 'bengel-b.sgm', 'portja-b.sgm', 'austja-b.sgm', 'okeead-b.sgm', 'weetel-b.sgm', 'morgsy-b.sgm', 'smitel-b.sgm', 'showmr-b.sgm', 'crokma-b.sgm', 'downha-b.sgm', 'hazlwi-b.sgm', 'holfm2-b.sgm', 'brouhe-b.sgm', 'brunma-b.sgm', 'schima-b.sgm', 'trolfr-b.sgm', 'moorth-b.sgm', 'davese-b.sgm', 'wilksa-b.sgm', 'liddjs-b.sgm', 'cuthca-b.sgm', 'clarem-b.sgm', 'holcfr-b.sgm', 'bryam2-b.sgm', 'portan-b.sgm', 'crokjo-b.sgm', 'somema-b.sgm', 'johnch-b.sgm', 'aikilu-b.sgm', 'kingso-b.sgm', 'gilban-b.sgm', 'ferrsu-b.sgm', 'struel-b.sgm', 'brisam-b.sgm', 'taylja-b.sgm', 'ham_el-b.sgm', 'nootch-b.sgm', 'huntle-b.sgm', 'lickis-b.sgm', 'mosshe-b.sgm', 'clarol-b.sgm', 'wheean-b.sgm', 'woodso-b.sgm', 'callma-b.sgm', 'dequth-b.sgm', 'lambla-b.sgm', 'wilsha-b.sgm', 'cornca-b.sgm', 'bowlca-b.sgm', 'burkjo-b.sgm', 'clarch-b.sgm', 'mitfma-b.sgm', 'prinma-b.sgm', 'byroge-b.sgm', 'halesa-b.sgm', 'barhri-b.sgm', 'keltma-b.sgm', 'ellich-b.sgm', 'blesma-b.sgm', 'sedgca-b.sgm', 'byrome-b.sgm', 'parkem-b.sgm', 'beauam-b.sgm', 'crowca-b.sgm', 'tonnch-b.sgm', 'brayan-b.sgm', 'marsan-b.sgm', 'robeem-b.sgm', 'listan-b.sgm', 'sigoly-b.sgm', 'bellgi-b.sgm', 'bailma-b.sgm', 'shelpe-b.sgm', 'alisar-b.sgm', 'austsa-b.sgm', 'campdo-b.sgm', 'clarjo-b.sgm', 'hemafe-b.sgm', 'jamean-b.sgm', 'striel-b.sgm', 'lestel-b.sgm', 'pordel-b.sgm', 'jevoma-b.sgm', 'wrigfr-b.sgm', 'hamija-b.sgm', 'keatjo-b.sgm', 'carlth-b.sgm', 'elwoan-b.sgm', 'bohnhe-b.sgm', 'striag-b.sgm', 'trutso-b.sgm', 'abdyma-b.sgm', 'edenem-b.sgm', 'sewema-b.sgm', 'granel-b.sgm', 'shelma-b.sgm', 'comtau-b.sgm', 'rathha-b.sgm', 'beveel-b.sgm', 'costlo-b.sgm', 'ellisa-b.sgm', 'howima-b.sgm', 'atkian-b.sgm', 'balzho-b.sgm',
'scudma-w.sgm', 'blauba-w.sgm', 'fellma-w.sgm', 'leadja-w.sgm', 'docwan-w.sgm', 'thoral-w.sgm', 'audlan-w.sgm', 'hoptsu-w.sgm', 'whitjo-w.sgm', 'alleha-w.sgm', 'stirel-w.sgm', 'hollca-w.sgm', 'russra-w.sgm', 'frekel-w.sgm', 'cowpsa-w.sgm', 'buryel-w.sgm', 'nortfr-w.sgm', 'morema-w.sgm', 'jameel-w.sgm', 'lamban-w.sgm', 'delae2-w.sgm', 'aulnma-w.sgm', 'barkja-w.sgm', 'beauag-w.sgm', 'chudma-w.sgm', 'mashda-w.sgm', 'marsm_-w.sgm', 'fincan-w.sgm', 'burnel-w.sgm', 'fience-w.sgm', 'savasa-w.sgm', 'pix_ma-w.sgm', 'drakju-w.sgm', 'astema-w.sgm', 'piersa-w.sgm', 'danval-w.sgm', 'weslsu-w.sgm', 'herblu-w.sgm', 'centsu-w.sgm', 'fygesa-w.sgm', 'wastel-w.sgm', 'manlde-w.sgm', 'stonsa-w.sgm', 'boweba-w.sgm', 'dixosa-w.sgm', 'nithwi-w.sgm', 'wiseja-w.sgm', 'davyma-w.sgm', 'trotca-w.sgm', 'roweel-w.sgm', 'thomel-w.sgm', 'caesma-w.sgm', 'aubipe-w.sgm', 'elstel-w.sgm', 'brerja-w.sgm', 'cairel-w.sgm', 'barbma-w.sgm', 'cowpma-w.sgm', 'squija-w.sgm', 'chanma-w.sgm', 'popeal-w.sgm', 'collma-w.sgm', 'burtca-w.sgm', 'butls2-w.sgm', 'fowkma-w.sgm', 'montma-w.sgm', 'richsa-w.sgm', 'haywel-w.sgm', 'mastma-w.sgm', 'tollel-w.sgm', 'graffr-w.sgm', 'irwian-w.sgm', 'wrigme-w.sgm', 'wrigsu-w.sgm', 'coopel-w.sgm', 'euge__-w.sgm', 'cookan-w.sgm', 'hertfr-w.sgm', 'chapsa-w.sgm', 'delama-w.sgm', 'humeso-w.sgm', 'madaju-w.sgm', 'justel-w.sgm', 'grieco-w.sgm', 'willan-w.sgm', 'johnja-w.sgm', 'jonema-w.sgm', 'glasha-w.sgm', 'pilkla-w.sgm', 'philte-w.sgm', 'johnsa-w.sgm', 'boydel-w.sgm', 'fielsa-w.sgm', 'ashbel-w.sgm', 'charch-w.sgm', 'caldma-w.sgm', 'collja-w.sgm', 'formch-w.sgm', 'collm2-w.sgm', 'palmma-w.sgm', 'steea2-w.sgm', 'cartel-w.sgm', 'peisma-w.sgm', 'montel-w.sgm', 'fishan-w.sgm', 'mccach-w.sgm', 'pennsa-w.sgm', 'scotsa-w.sgm', 'smytsu-w.sgm', 'talbca-w.sgm', 'lattma-w.sgm', 'leapma-w.sgm', 'teftel-w.sgm', 'niheel-w.sgm', 'robeja-w.sgm', 'sherfr-w.sgm', 'broofr-w.sgm', 'wartja-w.sgm', 'herbma-w.sgm', 'philca-w.sgm', 'grifha-w.sgm', 'grifel-w.sgm', 'chaphe-w.sgm', 'dubodo-w.sgm', 'halema-w.sgm', 'warrme-w.sgm', 'reevcl-w.sgm', 'lennch-w.sgm', 'reynfr-w.sgm', 'savama-w.sgm', 'devema-w.sgm', 'macaca-w.sgm', 'wheeag-w.sgm', 'fide__-w.sgm', 'jebban-w.sgm', 'wooda_-w.sgm', 'walkma-w.sgm', 'moodel-w.sgm', 'fergel-w.sgm', 'coopma-w.sgm', 'darwma-w.sgm', 'butlel-w.sgm', 'parsel-w.sgm', 'fletma-w.sgm', 'dobssu-w.sgm', 'lucama-w.sgm', 'gibbph-w.sgm', 'candan-w.sgm', 'wallan-w.sgm', 'millan-w.sgm', 'trimsa-w.sgm', 'piozhe-w.sgm', 'kindje-w.sgm', 'adamab-w.sgm', 'pagais-w.sgm', 'sewaan-w.sgm', 'cowlha-w.sgm', 'barban-w.sgm', 'helmel-w.sgm', 'gildel-w.sgm', 'murrsa-w.sgm', 'cookc2-w.sgm', 'bonhel-w.sgm', 'marij2-w.sgm', 'barrma-w.sgm', 'equiol-w.sgm', 'gardsa-w.sgm', 'moreha-w.sgm', 'radcma-w.sgm', 'genlst-w.sgm', 'hawkca-w.sgm', 'handel-w.sgm', 'skinan-w.sgm', 'blamsu-w.sgm', 'gunnsu-w.sgm', 'hervel-w.sgm', 'minima-w.sgm', 'chamm2-w.sgm', 'strama-w.sgm', 'smitch-w.sgm', 'damean-w.sgm', 'lewial-w.sgm', 'huttlu-w.sgm', 'bennan-w.sgm', 'bowdhe-w.sgm', 'gomean-w.sgm', 'hersca-w.sgm', 'soutjo-w.sgm', 'lee_so-w.sgm', 'wakepr-w.sgm', 'barnan-w.sgm', 'scotma-w.sgm', 'batthe-w.sgm', 'murrju-w.sgm', 'craihe-w.sgm', 'burnfr-w.sgm', 'bleean-w.sgm', 'wheaph-w.sgm', 'yearan-w.sgm', 'inchel-w.sgm', 'deflma-w.sgm', 'huntra-w.sgm', 'elligr-w.sgm', 'jacsfr-w.sgm', 'branha-w.sgm', 'jacsma-w.sgm', 'granan-w.sgm', 'fay_el-w.sgm', 'huttca-w.sgm', 'hamiel-w.sgm', 'robima-w.sgm', 'taylan-w.sgm', 'holfma-w.sgm', 'lee_ha-w.sgm', 'knigel-w.sgm', 'devoge-w.sgm', 'goocel-w.sgm', 'stualo-w.sgm', 'devoel-w.sgm', 'larpan-w.sgm', 'bradm2-w.sgm', 'westja-w.sgm', 'fostha-w.sgm', 'leadma-w.sgm', 'wollma-w.sgm', 'haysma-w.sgm', 'kellis-w.sgm', 'willhe-w.sgm', 'hawkla-w.sgm', 'littja-w.sgm', 'mortsa-w.sgm', 'brooch-w.sgm', 'bryama-w.sgm', 'mackan-w.sgm', 'pluman-w.sgm', 'wellhe-w.sgm', 'logade-w.sgm', 'meekel-w.sgm', 'rowssu-w.sgm', 'catcma-w.sgm', 'tennta-w.sgm', 'caveja-w.sgm', 'bailjo-w.sgm', 'simcel-w.sgm', 'starma-w.sgm', 'sumble-w.sgm', 'tatlel-w.sgm', 'palmal-w.sgm', 'tomlel-w.sgm', 'sleael-w.sgm', 'burkan-w.sgm', 'wolfel-w.sgm', 'rochre-w.sgm', 'cobbel-w.sgm', 'hattan-w.sgm', 'radcan-w.sgm', 'lambma-w.sgm', 'fansca-w.sgm', 'bannan-w.sgm', 'fenwel-w.sgm', 'staege-w.sgm', 'nairca-w.sgm', 'sykehe-w.sgm', 'bentel-w.sgm', 'corpha-w.sgm', 'gilba2-w.sgm', 'edgema-w.sgm', 'spenel-w.sgm', 'trenme-w.sgm', 'wattsu-w.sgm', 'parkma-w.sgm', 'gunnel-w.sgm', 'stocma-w.sgm', 'pluma2-w.sgm', 'marcja-w.sgm', 'falcan-w.sgm', 'opieam-w.sgm', 'heyrel-w.sgm', 'crisan-w.sgm', 'oneifr-w.sgm', 'pearsu-w.sgm', 'greesa-w.sgm', 'fletel-w.sgm', 'hoflba-w.sgm', 'montm2-w.sgm', 'dacrch-w.sgm', 'harvja-w.sgm', 'scotwa-w.sgm', 'thome2-w.sgm', 'worddo-w.sgm', 'graych-w.sgm', 'mathel-w.sgm', 'burnsa-w.sgm', 'tighma-w.sgm', 'riddma-w.sgm', 'chamma-w.sgm', 'milnch-w.sgm', 'charma-w.sgm', 'kilhha-w.sgm', 'soutro-w.sgm', 'patrmr-w.sgm', 'younma-w.sgm', 'bethm2-w.sgm', 'kembma-w.sgm', 'burych-w.sgm', 'sherma-w.sgm', 'bengel-w.sgm', 'portja-w.sgm', 'austja-w.sgm', 'okeead-w.sgm', 'weetel-w.sgm', 'morgsy-w.sgm', 'smitel-w.sgm', 'showmr-w.sgm', 'crokma-w.sgm', 'downha-w.sgm', 'holfm2-w.sgm', 'brunma-w.sgm', 'schima-w.sgm', 'trolfr-w.sgm', 'davese-w.sgm', 'wilksa-w.sgm', 'liddjs-w.sgm', 'cuthca-w.sgm', 'clarem-w.sgm', 'holcfr-w.sgm', 'bryam2-w.sgm', 'portan-w.sgm', 'somema-w.sgm', 'johnch-w.sgm', 'aikilu-w.sgm', 'kingso-w.sgm', 'gilban-w.sgm', 'ferrsu-w.sgm', 'struel-w.sgm', 'brisam-w.sgm', 'taylja-w.sgm', 'ham_el-w.sgm', 'nootch-w.sgm', 'lickis-w.sgm', 'mosshe-w.sgm', 'clarol-w.sgm', 'wheean-w.sgm', 'woodso-w.sgm', 'callma-w.sgm', 'lambla-w.sgm', 'wilsha-w.sgm', 'cornca-w.sgm', 'bowlca-w.sgm', 'mitfma-w.sgm', 'prinma-w.sgm', 'halesa-w.sgm', 'keltma-w.sgm', 'ellich-w.sgm', 'blesma-w.sgm', 'sedgca-w.sgm', 'byrome-w.sgm', 'parkem-w.sgm', 'beauam-w.sgm', 'crowca-w.sgm', 'tonnch-w.sgm', 'brayan-w.sgm', 'marsan-w.sgm', 'robeem-w.sgm', 'listan-w.sgm', 'sigoly-w.sgm', 'bailma-w.sgm', 'shelpe-w.sgm', 'austsa-w.sgm', 'campdo-w.sgm', 'hemafe-w.sgm', 'jamean-w.sgm', 'striel-w.sgm', 'lestel-w.sgm', 'pordel-w.sgm', 'jevoma-w.sgm', 'wrigfr-w.sgm', 'hamija-w.sgm', 'elwoan-w.sgm', 'striag-w.sgm', 'trutso-w.sgm', 'abdyma-w.sgm', 'edenem-w.sgm', 'sewema-w.sgm', 'granel-w.sgm', 'shelma-w.sgm', 'rathha-w.sgm', 'martmr-w.sgm', 'beveel-w.sgm', 'costlo-w.sgm', 'ellisa-w.sgm', 'howima-w.sgm', 'atkian-w.sgm' 

  )  and ( .//SETTLEMENT/text()='London' or .//@REG='London')]
)
:)

(: 1800-1899 :)
(::)
let $groupStr := "1800-1899"
let $events_sequence := (
  //EVENT[@FILENAME = (
'cartel-w.sgm', 'montel-w.sgm', 'wartja-w.sgm', 'grifha-w.sgm', 'chaphe-w.sgm', 'halema-w.sgm', 'warrme-w.sgm', 'reevcl-w.sgm', 'lennch-w.sgm', 'reynfr-w.sgm', 'wheeag-w.sgm', 'jebban-w.sgm', 'walkma-w.sgm', 'moodel-w.sgm', 'fergel-w.sgm', 'coopma-w.sgm', 'darwma-w.sgm', 'butlel-w.sgm', 'parsel-w.sgm', 'fletma-w.sgm', 'lucama-w.sgm', 'gibbph-w.sgm', 'candan-w.sgm', 'trimsa-w.sgm', 'piozhe-w.sgm', 'kindje-w.sgm', 'adamab-w.sgm', 'pagais-w.sgm', 'sewaan-w.sgm', 'cowlha-w.sgm', 'barban-w.sgm', 'helmel-w.sgm', 'murrsa-w.sgm', 'cookc2-w.sgm', 'bonhel-w.sgm', 'gardsa-w.sgm', 'moreha-w.sgm', 'radcma-w.sgm', 'genlst-w.sgm', 'hawkca-w.sgm', 'handel-w.sgm', 'gunnsu-w.sgm', 'hervel-w.sgm', 'chamm2-w.sgm', 'strama-w.sgm', 'smitch-w.sgm', 'damean-w.sgm', 'lewial-w.sgm', 'bennan-w.sgm', 'bowdhe-w.sgm', 'gomean-w.sgm', 'hersca-w.sgm', 'soutjo-w.sgm', 'lee_so-w.sgm', 'wakepr-w.sgm', 'barnan-w.sgm', 'batthe-w.sgm', 'murrju-w.sgm', 'craihe-w.sgm', 'burnfr-w.sgm', 'yearan-w.sgm', 'inchel-w.sgm', 'huntra-w.sgm', 'elligr-w.sgm', 'jacsfr-w.sgm', 'branha-w.sgm', 'jacsma-w.sgm', 'granan-w.sgm', 'fay_el-w.sgm', 'huttca-w.sgm', 'hamiel-w.sgm', 'robima-w.sgm', 'taylan-w.sgm', 'holfma-w.sgm', 'lee_ha-w.sgm', 'knigel-w.sgm', 'devoge-w.sgm', 'goocel-w.sgm', 'stualo-w.sgm', 'devoel-w.sgm', 'larpan-w.sgm', 'bradm2-w.sgm', 'westja-w.sgm', 'fostha-w.sgm', 'leadma-w.sgm', 'haysma-w.sgm', 'kellis-w.sgm', 'willhe-w.sgm', 'hawkla-w.sgm', 'littja-w.sgm', 'mortsa-w.sgm', 'bryama-w.sgm', 'mackan-w.sgm', 'pluman-w.sgm', 'wellhe-w.sgm', 'logade-w.sgm', 'meekel-w.sgm', 'rowssu-w.sgm', 'catcma-w.sgm', 'tennta-w.sgm', 'caveja-w.sgm', 'bailjo-w.sgm', 'simcel-w.sgm', 'starma-w.sgm', 'sumble-w.sgm', 'tatlel-w.sgm', 'palmal-w.sgm', 'tomlel-w.sgm', 'sleael-w.sgm', 'burkan-w.sgm', 'wolfel-w.sgm', 'rochre-w.sgm', 'cobbel-w.sgm', 'hattan-w.sgm', 'radcan-w.sgm', 'lambma-w.sgm', 'fansca-w.sgm', 'bannan-w.sgm', 'fenwel-w.sgm', 'staege-w.sgm', 'nairca-w.sgm', 'sykehe-w.sgm', 'bentel-w.sgm', 'corpha-w.sgm', 'gilba2-w.sgm', 'edgema-w.sgm', 'spenel-w.sgm', 'trenme-w.sgm', 'wattsu-w.sgm', 'gunnel-w.sgm', 'stocma-w.sgm', 'pluma2-w.sgm', 'marcja-w.sgm', 'falcan-w.sgm', 'opieam-w.sgm', 'heyrel-w.sgm', 'crisan-w.sgm', 'oneifr-w.sgm', 'pearsu-w.sgm', 'greesa-w.sgm', 'fletel-w.sgm', 'hoflba-w.sgm', 'dacrch-w.sgm', 'harvja-w.sgm', 'scotwa-w.sgm', 'thome2-w.sgm', 'worddo-w.sgm', 'graych-w.sgm', 'mathel-w.sgm', 'burnsa-w.sgm', 'tighma-w.sgm', 'riddma-w.sgm', 'chamma-w.sgm', 'milnch-w.sgm', 'charma-w.sgm', 'kilhha-w.sgm', 'soutro-w.sgm', 'younma-w.sgm', 'bethm2-w.sgm', 'kembma-w.sgm', 'burych-w.sgm', 'sherma-w.sgm', 'bengel-w.sgm', 'portja-w.sgm', 'austja-w.sgm', 'okeead-w.sgm', 'weetel-w.sgm', 'morgsy-w.sgm', 'smitel-w.sgm', 'showmr-w.sgm', 'crokma-w.sgm', 'downha-w.sgm', 'holfm2-w.sgm', 'brunma-w.sgm', 'schima-w.sgm', 'trolfr-w.sgm', 'davese-w.sgm', 'wilksa-w.sgm', 'liddjs-w.sgm', 'cuthca-w.sgm', 'clarem-w.sgm', 'holcfr-w.sgm', 'bryam2-w.sgm', 'portan-w.sgm', 'somema-w.sgm', 'johnch-w.sgm', 'aikilu-w.sgm', 'kingso-w.sgm', 'gilban-w.sgm', 'ferrsu-w.sgm', 'struel-w.sgm', 'brisam-w.sgm', 'taylja-w.sgm', 'ham_el-w.sgm', 'nootch-w.sgm', 'lickis-w.sgm', 'mosshe-w.sgm', 'clarol-w.sgm', 'wheean-w.sgm', 'woodso-w.sgm', 'callma-w.sgm', 'lambla-w.sgm', 'wilsha-w.sgm', 'cornca-w.sgm', 'bowlca-w.sgm', 'mitfma-w.sgm', 'prinma-w.sgm', 'halesa-w.sgm', 'keltma-w.sgm', 'ellich-w.sgm', 'blesma-w.sgm', 'sedgca-w.sgm', 'byrome-w.sgm', 'parkem-w.sgm', 'beauam-w.sgm', 'crowca-w.sgm', 'tonnch-w.sgm', 'brayan-w.sgm', 'marsan-w.sgm', 'robeem-w.sgm', 'listan-w.sgm', 'sigoly-w.sgm', 'bailma-w.sgm', 'shelpe-w.sgm', 'austsa-w.sgm', 'campdo-w.sgm', 'hemafe-w.sgm', 'jamean-w.sgm', 'striel-w.sgm', 'lestel-w.sgm', 'pordel-w.sgm', 'jevoma-w.sgm', 'wrigfr-w.sgm', 'hamija-w.sgm', 'elwoan-w.sgm', 'striag-w.sgm', 'trutso-w.sgm', 'abdyma-w.sgm', 'edenem-w.sgm', 'sewema-w.sgm', 'granel-w.sgm', 'shelma-w.sgm', 'rathha-w.sgm', 'martmr-w.sgm', 'beveel-w.sgm', 'costlo-w.sgm', 'ellisa-w.sgm', 'howima-w.sgm', 'atkian-w.sgm', 'goreca-w.sgm', 'hallan-w.sgm', 'sincca-w.sgm', 'hillis-w.sgm', 'jewsma-w.sgm', 'newmjo-w.sgm', 'clivca-w.sgm', 'carlja-w.sgm', 'woodem-w.sgm', 'bunbse-w.sgm', 'traica-w.sgm', 'chilly-w.sgm', 'martha-w.sgm', 'lel___-w.sgm', 'lyttro-w.sgm', 'coles2-w.sgm', 'mozlha-w.sgm', 'trisfl-w.sgm', 'stonel-w.sgm', 'bulwed-w.sgm', 'moodsu-w.sgm', 'fentel-w.sgm', 'sandge-w.sgm', 'pardju-w.sgm', 'seacma-w.sgm', 'adamsa-w.sgm', 'collm3-w.sgm', 'willja-w.sgm', 'browel-w.sgm', 'milljo-w.sgm', 'chatge-w.sgm', 'wilsh2-w.sgm', 'mannan-w.sgm', 'hamie2-w.sgm', 'taylha-w.sgm', 'tautje-w.sgm', 'jenkhe-w.sgm', 'tinsan-w.sgm', 'nortca-w.sgm', 'chisca-w.sgm', 'balfcl-w.sgm', 'gattma-w.sgm', 'clarmc-w.sgm', 'mozlan-w.sgm', 'rigbel-w.sgm', 'kembfa-w.sgm', 'fullma-w.sgm', 'gaskel-w.sgm', 'boylma-w.sgm', 'stowha-w.sgm', 'fernfa-w.sgm', 'housma-w.sgm', 'rossmr-w.sgm', 'hawkan-w.sgm', 'dickch-w.sgm', 'sandma-w.sgm', 'browro-w.sgm', 'guesch-w.sgm', 'crosca-w.sgm', 'merelo-w.sgm', 'jewsge-w.sgm', 'fullge-w.sgm', 'browma-w.sgm', 'streju-w.sgm', 'cookel-w.sgm', 'smytha-w.sgm', 'robiis-w.sgm', 'swanan-w.sgm', 'jacoha-w.sgm', 'robiem-w.sgm', 'woodel-w.sgm', 'kingfa-w.sgm', 'shirem-w.sgm', 'seweel-w.sgm', 'reidma-w.sgm', 'martma-w.sgm', 'kembad-w.sgm', 'byroau-w.sgm', 'browfr-w.sgm', 'greyma-w.sgm', 'bronch-w.sgm', 'aguigr-w.sgm', 'meteel-w.sgm', 'taylma-w.sgm', 'lewege-w.sgm', 'blagis-w.sgm', 'tindhe-w.sgm', 'montc2-w.sgm', 'alexce-w.sgm', 'hubbca-w.sgm', 'bronem-w.sgm', 'mossce-w.sgm', 'lothro-w.sgm', 'victqu-w.sgm', 'howeju-w.sgm', 'elioge-w.sgm', 'shorma-w.sgm', 'bronan-w.sgm', 'munrge-w.sgm', 'ingeje-w.sgm', 'sewean-w.sgm', 'nighfl-w.sgm', 'evanan-w.sgm', 'haysm2-w.sgm', 'smedme-w.sgm', 'notlfr-w.sgm', 'kortfa-w.sgm', 'burtri-w.sgm', 'bankis-w.sgm', 'tuckch-w.sgm', 'skenfe-w.sgm', 'dufflu-w.sgm', 'mossma-w.sgm', 'godlch-w.sgm', 'greedo-w.sgm', 'wildja-w.sgm', 'shorar-w.sgm', 'ogilel-w.sgm', 'lintel-w.sgm', 'cobbfr-w.sgm', 'warian-w.sgm', 'yongch-w.sgm', 'caryma-w.sgm', 'kavaju-w.sgm', 'collwi-w.sgm', 'howian-w.sgm', 'macqka-w.sgm', 'hardma-w.sgm', 'shorlo-w.sgm', 'lewisa-w.sgm', 'humema-w.sgm', 'kearan-w.sgm', 'worbem-w.sgm', 'alexmr-w.sgm', 'harpfr-w.sgm', 'procad-w.sgm', 'boucje-w.sgm', 'craidi-w.sgm', 'beckly-w.sgm', 'tytlsa-w.sgm', 'leakca-w.sgm', 'bodiba-w.sgm', 'pfeiem-w.sgm', 'charel-w.sgm', 'ibsehe-w.sgm', 'olipma-w.sgm', 'butljo-w.sgm', 'marsem-w.sgm', 'tytlha-w.sgm', 'chanch-w.sgm', 'parkbe-w.sgm', 'siddel-w.sgm', 'dubefr-w.sgm', 'hoeyfr-w.sgm', 'daviem-w.sgm', 'rossch-w.sgm', 'dickem-w.sgm', 'craige-w.sgm', 'barkma-w.sgm', 'davire-w.sgm', 'edwaam-w.sgm', 'taylhe-w.sgm', 'birdis-w.sgm', 'craiis-w.sgm', 'leonan-w.sgm', 'oglean-w.sgm', 'marije-w.sgm', 'strehe-w.sgm', 'clapja-w.sgm', 'riddch-w.sgm', 'alcolo-w.sgm', 'longma-w.sgm', 'robema-w.sgm', 'fortma-w.sgm', 'wedgju-w.sgm', 'cullha-w.sgm', 'middje-w.sgm', 'johnel-w.sgm', 'dempch-w.sgm', 'pearfr-w.sgm', 'faitem-w.sgm', 'trolfe-w.sgm', 'bradma-w.sgm', 'walkan-w.sgm', 'bethma-w.sgm', 'beetis-w.sgm', 'bramch-w.sgm', 'havefr-w.sgm', 'veitso-w.sgm', 'machag-w.sgm', 'websau-w.sgm', 'ritcan-w.sgm', 'harwis-w.sgm', 'marrfl-w.sgm', 'smitlu-w.sgm', 'ouid__-w.sgm', 'molema-w.sgm', 'lewis2-w.sgm', 'ellic2-w.sgm', 'brasan-w.sgm', 'stopch-w.sgm', 'kingha-w.sgm', 'hardth-w.sgm', 'carero-w.sgm', 'clerel-w.sgm', 'brourh-w.sgm', 'steean-w.sgm', 'linsma-w.sgm', 'willsa-w.sgm', 'blinma-w.sgm', 'ewinju-w.sgm', 'barrem-w.sgm', 'spenem-w.sgm', 'clerag-w.sgm', 'blache-w.sgm', 'dougge-w.sgm', 'fanevi-w.sgm', 'jamehe-w.sgm', 'velema-w.sgm', 'meadlt-w.sgm', 'despch-w.sgm', 'hopkge-w.sgm', 'simced-w.sgm', 'cadeje-w.sgm', 'phelel-w.sgm', 'cambad-w.sgm', 'brooem-w.sgm', 'hickem-w.sgm', 'walflu-w.sgm', 'bevils-w.sgm', 'dillea-w.sgm', 'lawlem-w.sgm', 'frerma-w.sgm', 'baldlo-w.sgm', 'knoxlu-w.sgm', 'gibeag-w.sgm', 'obrich-w.sgm', 'mullhe-w.sgm', 'greeka-w.sgm', 'kingan-w.sgm', 'fielmi-w.sgm', 'cornbl-w.sgm', 'steefl-w.sgm', 'bouldo-w.sgm', 'fawcmi-w.sgm', 'besaan-w.sgm', 'meynal-w.sgm', 'plumce-w.sgm', 'frasch-w.sgm', 'blaceo-w.sgm', 'chanla-w.sgm', 'parkel-w.sgm', 'laffma-w.sgm', 'geraem-w.sgm', 'colefr-w.sgm', 'jewesa-w.sgm', 'burnf2-w.sgm', 'russje-w.sgm', 'chopka-w.sgm', 'harrja-w.sgm', 'hardiz-w.sgm', 'wilcel-w.sgm', 'humpce-w.sgm', 'fothje-w.sgm', 'wardma-w.sgm', 'mathhe-w.sgm', 'gregau-w.sgm', 'malelu-w.sgm', 'shawfl-w.sgm', 'caffka-w.sgm', 'blaccl-w.sgm', 'frazja-w.sgm', 'harkma-w.sgm', 'cairmo-w.sgm', 'gransa-w.sgm', 'wildos-w.sgm', 'schrol-w.sgm', 'corema-w.sgm', 'fordis-w.sgm', 'dixifl-w.sgm', 'gerado-w.sgm', 'wintjo-w.sgm', 'duttto-w.sgm', 'shawge-w.sgm', 'lee_ve-w.sgm', 'jay_ha-w.sgm', 'robiam-w.sgm', 'lyaled-w.sgm', 'dixoel-w.sgm', 'campco-w.sgm', 'conrjo-w.sgm', 'webbbe-w.sgm', 'nadeco-w.sgm', 'ramapa-w.sgm', 'smytet-w.sgm', 'someed-w.sgm', 'robifm-w.sgm', 'pankem-w.sgm', 'nesbe_-w.sgm', 'tynaka-w.sgm', 'housae-w.sgm', 'doylar-w.sgm', 'bakeel-w.sgm', 'cholma-w.sgm', 'swana2-w.sgm', 'franju-w.sgm', 'egerge-w.sgm', 'barrjm-w.sgm', 'gilmch-w.sgm', 'farrfl-w.sgm', 'pastge-w.sgm', 'watsro-w.sgm', 'ros_am-w.sgm', 'johnp2-w.sgm', 'colema-w.sgm', 'levyam-w.sgm', 'kendma-w.sgm', 'garnco-w.sgm', 'duncsa-w.sgm', 'whared-w.sgm', 'bannhe-w.sgm', 'rossm2-w.sgm', 'robiel-w.sgm', 'billma-w.sgm', 'huntvi-w.sgm', 'levead-w.sgm', 'kingma-w.sgm', 'gravcl-w.sgm', 'sincma-w.sgm', 'ecclch-w.sgm', 'harrbe-w.sgm', 'glynel-w.sgm', 'lytte2-w.sgm', 'saviet-w.sgm', 'hopela-w.sgm', 'yeatwi-w.sgm', 'bussdo-w.sgm', 'almala-w.sgm', 'scotc_-w.sgm', 'scotca-w.sgm', 'orczem-w.sgm', 'kiplru-w.sgm', 'ginghe-w.sgm', 'delael-w.sgm', 'whitro-w.sgm', 'dowime-w.sgm', 'pottbe-w.sgm', 'sigedo-w.sgm', 'arniel-w.sgm', 'wellhg-w.sgm', 'fry_ro-w.sgm', 'gonnma-w.sgm', 'klicfl-w.sgm', 'bennar-w.sgm', 'galsjo-w.sgm', 'glaska-w.sgm', 'pethem-w.sgm', 'hobbjo-w.sgm', 'markco-w.sgm', 'bellge-w.sgm', 'lownma-w.sgm', 'crosvi-w.sgm', 'lyttco-w.sgm', 'sharev-w.sgm', 'mew_ch-w.sgm', 'gidean-w.sgm', 'brazan-w.sgm', 'craied-w.sgm', 'richhe-w.sgm', 'goreev-w.sgm', 'bensin-w.sgm', 'syngjm-w.sgm', 'prouma-w.sgm', 'moored-w.sgm', 'stjoch-w.sgm', 'rathel-w.sgm', 'hamici-w.sgm', 'leggma-w.sgm', 'mordel-w.sgm', 'cole__-w.sgm', 'colech-w.sgm', 'richdo-w.sgm', 'morrot-w.sgm', 'cathwi-w.sgm', 'fordfo-w.sgm', 'glovev-w.sgm', 'steige-w.sgm', 'montlm-w.sgm', 'thurka-w.sgm', 'roydna-w.sgm', 'buchjo-w.sgm', 'undeev-w.sgm', 'bakee2-w.sgm', 'smedco-w.sgm', 'weavha-w.sgm', 'sowegi-w.sgm', 'barnna-w.sgm', 'roydma-w.sgm', 'thomfl-w.sgm', 'sidget-w.sgm', 'wentpa-w.sgm', 'fryeka-w.sgm', 'murreu-w.sgm', 'cablmi-w.sgm', 'ruckbe-w.sgm', 'forsem-w.sgm', 'naidsa-w.sgm', 'carsca-w.sgm', 'youneh-w.sgm', 'hallra-w.sgm', 'hullem-w.sgm', 'pankch-w.sgm', 'holmco-w.sgm', 'stopma-w.sgm', 'gawtma-w.sgm', 'ayreru-w.sgm', 'farjel-w.sgm', 'webbma-w.sgm', 'macaro-w.sgm', 'dellet-w.sgm', 'sackma-w.sgm', 'woolvi-w.sgm', 'joycja-w.sgm', 'marsdo-w.sgm', 'panksy-w.sgm', 'bottph-w.sgm', 'tweesu-w.sgm', 'hamima-w.sgm', 'lewiwy-w.sgm', 'peckwi-w.sgm', 'loy_mi-w.sgm', 'inneka-w.sgm', 'wickan-w.sgm', 'rhonma-w.sgm', 'edgima-w.sgm', 'compiv-w.sgm', 'jacona-w.sgm', 'schugl-w.sgm', 'treevi-w.sgm', 'uttlal-w.sgm', 'dineis-w.sgm', 'lawrdh-w.sgm', 'meynvi-w.sgm', 'pounez-w.sgm', 'bowema-w.sgm', 'cornfr-w.sgm', 'hd____-w.sgm', 'daryel-w.sgm', 'kayesh-w.sgm', 'trouun-w.sgm', 'beacsy-w.sgm', 'mirrho-w.sgm', 'strara-w.sgm', 'reevam-w.sgm', 'brooru-w.sgm', 'sitwed-w.sgm', 'asqucy-w.sgm', 'barche-w.sgm', 'moorma-w.sgm', 'wilset-w.sgm', 'danecl-w.sgm', 'jessft-w.sgm', 'milesu-w.sgm', 'eliots-w.sgm', 'manska-w.sgm', 'waddhe-w.sgm', 'akhman-w.sgm', 'welldo-w.sgm', 'lawrma-w.sgm', 'bridan-w.sgm', 'bagnen-w.sgm', 'forbro-w.sgm', 'allaro-w.sgm', 'thiran-w.sgm', 'hamnni-w.sgm', 'muirwi-w.sgm', 'delaem-w.sgm', 'stergb-w.sgm', 'rhysje-w.sgm', 'chriag-w.sgm', 'cromri-w.sgm', 'buttma-w.sgm', 'hurszo-w.sgm', 'jamest-w.sgm', 'wilsro-w.sgm', 'bensst-w.sgm', 'milled-w.sgm', 'sackvi-w.sgm', 'napiel-w.sgm', 'jaegmu-w.sgm', 'barndj-w.sgm', 'bostlu-w.sgm', 'westre-w.sgm', 'starfr-w.sgm', 'whipdo-w.sgm', 'carrdo-w.sgm', 'joneeb-w.sgm', 'sayedo-w.sgm', 'cannma-w.sgm', 'warnsy-w.sgm', 'britve-w.sgm', 'russdo-w.sgm', 'willam-w.sgm', 'trefvi-w.sgm', 'huxlal-w.sgm', 'bryh__-w.sgm', 'bentph-w.sgm', 'boweli-w.sgm', 'streno-w.sgm', 'cunana-w.sgm', 'kennma-w.sgm', 'smitdo-w.sgm', 'cannjo-w.sgm', 'tey_jo-w.sgm', 'treeir-w.sgm', 'omanca-w.sgm', 'walldo-w.sgm', 'blyten-w.sgm', 'coople-w.sgm', 'mitcna-w.sgm', 'pittru-w.sgm', 'obrika-w.sgm', 'holtwi-w.sgm', 'whitan-w.sgm', 'boweel-w.sgm', 'travpl-w.sgm', 'bellfr-w.sgm',
'cartel-b.sgm', 'montel-b.sgm', 'wartja-b.sgm', 'grifha-b.sgm', 'chaphe-b.sgm', 'halema-b.sgm', 'warrme-b.sgm', 'reevcl-b.sgm', 'lennch-b.sgm', 'reynfr-b.sgm', 'cowpwi-b.sgm', 'wheeag-b.sgm', 'jebban-b.sgm', 'walkma-b.sgm', 'moodel-b.sgm', 'painth-b.sgm', 'fergel-b.sgm', 'coopma-b.sgm', 'darwma-b.sgm', 'butlel-b.sgm', 'parsel-b.sgm', 'fletma-b.sgm', 'lucama-b.sgm', 'gibbph-b.sgm', 'candan-b.sgm', 'trimsa-b.sgm', 'piozhe-b.sgm', 'kindje-b.sgm', 'adamab-b.sgm', 'pagais-b.sgm', 'sewaan-b.sgm', 'cowlha-b.sgm', 'barban-b.sgm', 'helmel-b.sgm', 'murrsa-b.sgm', 'cookc2-b.sgm', 'bonhel-b.sgm', 'gardsa-b.sgm', 'moreha-b.sgm', 'holcth-b.sgm', 'radcma-b.sgm', 'genlst-b.sgm', 'hawkca-b.sgm', 'handel-b.sgm', 'gunnsu-b.sgm', 'hervel-b.sgm', 'chamm2-b.sgm', 'strama-b.sgm', 'smitch-b.sgm', 'damean-b.sgm', 'lewial-b.sgm', 'bennan-b.sgm', 'bowdhe-b.sgm', 'gomean-b.sgm', 'hersca-b.sgm', 'soutjo-b.sgm', 'lee_so-b.sgm', 'wakepr-b.sgm', 'barnan-b.sgm', 'batthe-b.sgm', 'murrju-b.sgm', 'craihe-b.sgm', 'sherri-b.sgm', 'burnfr-b.sgm', 'yearan-b.sgm', 'inchel-b.sgm', 'huntra-b.sgm', 'elligr-b.sgm', 'jacsfr-b.sgm', 'branha-b.sgm', 'jacsma-b.sgm', 'granan-b.sgm', 'fay_el-b.sgm', 'huttca-b.sgm', 'godwwi-b.sgm', 'hamiel-b.sgm', 'robima-b.sgm', 'taylan-b.sgm', 'holfma-b.sgm', 'lee_ha-b.sgm', 'knigel-b.sgm', 'devoge-b.sgm', 'goocel-b.sgm', 'stualo-b.sgm', 'devoel-b.sgm', 'blakwi-b.sgm', 'larpan-b.sgm', 'bradm2-b.sgm', 'westja-b.sgm', 'fostha-b.sgm', 'leadma-b.sgm', 'haysma-b.sgm', 'kellis-b.sgm', 'willhe-b.sgm', 'hawkla-b.sgm', 'littja-b.sgm', 'mortsa-b.sgm', 'bryama-b.sgm', 'mackan-b.sgm', 'pluman-b.sgm', 'beckwi-b.sgm', 'wellhe-b.sgm', 'logade-b.sgm', 'meekel-b.sgm', 'rowssu-b.sgm', 'catcma-b.sgm', 'tennta-b.sgm', 'caveja-b.sgm', 'bailjo-b.sgm', 'simcel-b.sgm', 'bowlwi-b.sgm', 'starma-b.sgm', 'sumble-b.sgm', 'tatlel-b.sgm', 'palmal-b.sgm', 'tomlel-b.sgm', 'sleael-b.sgm', 'burkan-b.sgm', 'wolfel-b.sgm', 'rochre-b.sgm', 'cobbel-b.sgm', 'hattan-b.sgm', 'radcan-b.sgm', 'lambma-b.sgm', 'fansca-b.sgm', 'bannan-b.sgm', 'fenwel-b.sgm', 'staege-b.sgm', 'nairca-b.sgm', 'sykehe-b.sgm', 'bentel-b.sgm', 'corpha-b.sgm', 'gilba2-b.sgm', 'edgema-b.sgm', 'spenel-b.sgm', 'trenme-b.sgm', 'wattsu-b.sgm', 'gunnel-b.sgm', 'stocma-b.sgm', 'pluma2-b.sgm', 'marcja-b.sgm', 'falcan-b.sgm', 'opieam-b.sgm', 'heyrel-b.sgm', 'crisan-b.sgm', 'oneifr-b.sgm', 'pearsu-b.sgm', 'greesa-b.sgm', 'fletel-b.sgm', 'hoflba-b.sgm', 'wordwi-b.sgm', 'dacrch-b.sgm', 'harvja-b.sgm', 'scotwa-b.sgm', 'thome2-b.sgm', 'worddo-b.sgm', 'graych-b.sgm', 'mathel-b.sgm', 'burnsa-b.sgm', 'tighma-b.sgm', 'colesa-b.sgm', 'riddma-b.sgm', 'chamma-b.sgm', 'milnch-b.sgm', 'charma-b.sgm', 'kilhha-b.sgm', 'soutro-b.sgm', 'younma-b.sgm', 'bethm2-b.sgm', 'kembma-b.sgm', 'burych-b.sgm', 'sherma-b.sgm', 'bengel-b.sgm', 'portja-b.sgm', 'austja-b.sgm', 'okeead-b.sgm', 'weetel-b.sgm', 'morgsy-b.sgm', 'smitel-b.sgm', 'showmr-b.sgm', 'crokma-b.sgm', 'downha-b.sgm', 'hazlwi-b.sgm', 'holfm2-b.sgm', 'brouhe-b.sgm', 'brunma-b.sgm', 'schima-b.sgm', 'trolfr-b.sgm', 'moorth-b.sgm', 'davese-b.sgm', 'wilksa-b.sgm', 'liddjs-b.sgm', 'cuthca-b.sgm', 'clarem-b.sgm', 'holcfr-b.sgm', 'bryam2-b.sgm', 'portan-b.sgm', 'crokjo-b.sgm', 'somema-b.sgm', 'johnch-b.sgm', 'aikilu-b.sgm', 'kingso-b.sgm', 'gilban-b.sgm', 'ferrsu-b.sgm', 'struel-b.sgm', 'brisam-b.sgm', 'taylja-b.sgm', 'ham_el-b.sgm', 'nootch-b.sgm', 'huntle-b.sgm', 'lickis-b.sgm', 'mosshe-b.sgm', 'clarol-b.sgm', 'wheean-b.sgm', 'woodso-b.sgm', 'callma-b.sgm', 'dequth-b.sgm', 'lambla-b.sgm', 'wilsha-b.sgm', 'cornca-b.sgm', 'bowlca-b.sgm', 'burkjo-b.sgm', 'clarch-b.sgm', 'mitfma-b.sgm', 'prinma-b.sgm', 'byroge-b.sgm', 'halesa-b.sgm', 'barhri-b.sgm', 'keltma-b.sgm', 'ellich-b.sgm', 'blesma-b.sgm', 'sedgca-b.sgm', 'byrome-b.sgm', 'parkem-b.sgm', 'beauam-b.sgm', 'crowca-b.sgm', 'tonnch-b.sgm', 'brayan-b.sgm', 'marsan-b.sgm', 'robeem-b.sgm', 'listan-b.sgm', 'sigoly-b.sgm', 'bellgi-b.sgm', 'bailma-b.sgm', 'shelpe-b.sgm', 'alisar-b.sgm', 'austsa-b.sgm', 'campdo-b.sgm', 'clarjo-b.sgm', 'hemafe-b.sgm', 'jamean-b.sgm', 'striel-b.sgm', 'lestel-b.sgm', 'pordel-b.sgm', 'jevoma-b.sgm', 'wrigfr-b.sgm', 'hamija-b.sgm', 'keatjo-b.sgm', 'carlth-b.sgm', 'elwoan-b.sgm', 'bohnhe-b.sgm', 'striag-b.sgm', 'trutso-b.sgm', 'abdyma-b.sgm', 'edenem-b.sgm', 'sewema-b.sgm', 'granel-b.sgm', 'shelma-b.sgm', 'comtau-b.sgm', 'rathha-b.sgm', 'beveel-b.sgm', 'costlo-b.sgm', 'ellisa-b.sgm', 'howima-b.sgm', 'atkian-b.sgm', 'balzho-b.sgm', 'goreca-b.sgm', 'hallan-b.sgm', 'sincca-b.sgm', 'hillis-b.sgm', 'jewsma-b.sgm', 'macath-b.sgm', 'newmjo-b.sgm', 'clivca-b.sgm', 'carlja-b.sgm', 'bradge-b.sgm', 'woodem-b.sgm', 'bunbse-b.sgm', 'traica-b.sgm', 'chilly-b.sgm', 'martha-b.sgm', 'dumaal-b.sgm', 'lel___-b.sgm', 'lyttro-b.sgm', 'coles2-b.sgm', 'mozlha-b.sgm', 'hornri-b.sgm', 'trisfl-b.sgm', 'stonel-b.sgm', 'bulwed-b.sgm', 'emerra-b.sgm', 'moodsu-b.sgm', 'fentel-b.sgm', 'sandge-b.sgm', 'pardju-b.sgm', 'disrbe-b.sgm', 'seacma-b.sgm', 'ainsha-b.sgm', 'adamsa-b.sgm', 'andeha-b.sgm', 'collm3-b.sgm', 'willja-b.sgm', 'browel-b.sgm', 'milljo-b.sgm', 'chatge-b.sgm', 'wilsh2-b.sgm', 'mannan-b.sgm', 'hamie2-b.sgm', 'taylha-b.sgm', 'tautje-b.sgm', 'jenkhe-b.sgm', 'tinsan-b.sgm', 'nortca-b.sgm', 'chisca-b.sgm', 'balfcl-b.sgm', 'poe_ed-b.sgm', 'darwch-b.sgm', 'fitzed-b.sgm', 'gattma-b.sgm', 'clarmc-b.sgm', 'tennal-b.sgm', 'mozlan-b.sgm', 'rigbel-b.sgm', 'kembfa-b.sgm', 'fullma-b.sgm', 'browjo-b.sgm', 'gaskel-b.sgm', 'boylma-b.sgm', 'stowha-b.sgm', 'fernfa-b.sgm', 'thacwi-b.sgm', 'housma-b.sgm', 'gautth-b.sgm', 'hawkan-b.sgm', 'dickch-b.sgm', 'forsjo-b.sgm', 'sandma-b.sgm', 'browro-b.sgm', 'guesch-b.sgm', 'crosca-b.sgm', 'merelo-b.sgm', 'jewsge-b.sgm', 'fullge-b.sgm', 'browma-b.sgm', 'streju-b.sgm', 'mayhhe-b.sgm', 'cookel-b.sgm', 'smytha-b.sgm', 'robiis-b.sgm', 'aytowi-b.sgm', 'swanan-b.sgm', 'jacoha-b.sgm', 'robiem-b.sgm', 'woodel-b.sgm', 'kingfa-b.sgm', 'shirem-b.sgm', 'seweel-b.sgm', 'reidma-b.sgm', 'martma-b.sgm', 'kembad-b.sgm', 'byroau-b.sgm', 'browfr-b.sgm', 'greyma-b.sgm', 'bronch-b.sgm', 'aguigr-b.sgm', 'meteel-b.sgm', 'taylma-b.sgm', 'lewege-b.sgm', 'blagis-b.sgm', 'tindhe-b.sgm', 'montc2-b.sgm', 'burcja-b.sgm', 'alexce-b.sgm', 'frouja-b.sgm', 'marxka-b.sgm', 'hubbca-b.sgm', 'bronem-b.sgm', 'clouar-b.sgm', 'mossce-b.sgm', 'lothro-b.sgm', 'ruskjo-b.sgm', 'victqu-b.sgm', 'howeju-b.sgm', 'melvhe-b.sgm', 'elioge-b.sgm', 'shorma-b.sgm', 'bronan-b.sgm', 'munrge-b.sgm', 'ingeje-b.sgm', 'sewean-b.sgm', 'spenhe-b.sgm', 'nighfl-b.sgm', 'evanan-b.sgm', 'haysm2-b.sgm', 'smedme-b.sgm', 'boucdi-b.sgm', 'notlfr-b.sgm', 'kortfa-b.sgm', 'burtri-b.sgm', 'bankis-b.sgm', 'baudch-b.sgm', 'tuckch-b.sgm', 'skenfe-b.sgm', 'dufflu-b.sgm', 'amiehe-b.sgm', 'mossma-b.sgm', 'dostfy-b.sgm', 'godlch-b.sgm', 'buckhe-b.sgm', 'greedo-b.sgm', 'flaugu-b.sgm', 'wildja-b.sgm', 'shorar-b.sgm', 'ogilel-b.sgm', 'lintel-b.sgm', 'cobbfr-b.sgm', 'arnoma-b.sgm', 'warian-b.sgm', 'patmco-b.sgm', 'yongch-b.sgm', 'caryma-b.sgm', 'kavaju-b.sgm', 'collwi-b.sgm', 'howian-b.sgm', 'macqka-b.sgm', 'hardma-b.sgm', 'shorlo-b.sgm', 'alliwi-b.sgm', 'lewisa-b.sgm', 'dobesy-b.sgm', 'humema-b.sgm', 'kearan-b.sgm', 'worbem-b.sgm', 'ballrm-b.sgm', 'blacrd-b.sgm', 'alexmr-b.sgm', 'harpfr-b.sgm', 'procad-b.sgm', 'boucje-b.sgm', 'bagewa-b.sgm', 'craidi-b.sgm', 'beckly-b.sgm', 'tytlsa-b.sgm', 'leakca-b.sgm', 'bodiba-b.sgm', 'pfeiem-b.sgm', 'charel-b.sgm', 'merege-b.sgm', 'ibsehe-b.sgm', 'olipma-b.sgm', 'butljo-b.sgm', 'rossda-b.sgm', 'marsem-b.sgm', 'tytlha-b.sgm', 'chanch-b.sgm', 'parkbe-b.sgm', 'siddel-b.sgm', 'dubefr-b.sgm', 'hoeyfr-b.sgm', 'daviem-b.sgm', 'rossch-b.sgm', 'dickem-b.sgm', 'craige-b.sgm', 'barkma-b.sgm', 'davire-b.sgm', 'edwaam-b.sgm', 'taylhe-b.sgm', 'birdis-b.sgm', 'craiis-b.sgm', 'leonan-b.sgm', 'lytted-b.sgm', 'oglean-b.sgm', 'carrle-b.sgm', 'marije-b.sgm', 'strehe-b.sgm', 'clapja-b.sgm', 'riddch-b.sgm', 'alcolo-b.sgm', 'longma-b.sgm', 'fortma-b.sgm', 'robema-b.sgm', 'doregu-b.sgm', 'wedgju-b.sgm', 'cullha-b.sgm', 'diltwi-b.sgm', 'middje-b.sgm', 'morrwi-b.sgm', 'johnel-b.sgm', 'dempch-b.sgm', 'pearfr-b.sgm', 'faitem-b.sgm', 'trolfe-b.sgm', 'bradma-b.sgm', 'walkan-b.sgm', 'bethma-b.sgm', 'beetis-b.sgm', 'besawa-b.sgm', 'bramch-b.sgm', 'havefr-b.sgm', 'veitso-b.sgm', 'machag-b.sgm', 'websau-b.sgm', 'swinal-b.sgm', 'ritcan-b.sgm', 'harwis-b.sgm', 'marrfl-b.sgm', 'adamhe-b.sgm', 'smitlu-b.sgm', 'ouid__-b.sgm', 'molema-b.sgm', 'ellic2-b.sgm', 'patewa-b.sgm', 'brasan-b.sgm', 'stopch-b.sgm', 'kingha-b.sgm', 'hardth-b.sgm', 'carero-b.sgm', 'clerel-b.sgm', 'brourh-b.sgm', 'steean-b.sgm', 'linsma-b.sgm', 'willsa-b.sgm', 'blinma-b.sgm', 'ewinju-b.sgm', 'buchro-b.sgm', 'barrem-b.sgm', 'spenem-b.sgm', 'clerag-b.sgm', 'blache-b.sgm', 'courwi-b.sgm', 'dougge-b.sgm', 'fanevi-b.sgm', 'jamehe-b.sgm', 'velema-b.sgm', 'meadlt-b.sgm', 'despch-b.sgm', 'hopkge-b.sgm', 'simced-b.sgm', 'cadeje-b.sgm', 'phelel-b.sgm', 'nietfr-b.sgm', 'cambad-b.sgm', 'brooem-b.sgm', 'hickem-b.sgm', 'walflu-b.sgm', 'bevils-b.sgm', 'dillea-b.sgm', 'lawlem-b.sgm', 'frerma-b.sgm', 'baldlo-b.sgm', 'knoxlu-b.sgm', 'gibeag-b.sgm', 'obrich-b.sgm', 'mullhe-b.sgm', 'greeka-b.sgm', 'kingan-b.sgm', 'fielmi-b.sgm', 'cornbl-b.sgm', 'steefl-b.sgm', 'bouldo-b.sgm', 'fawcmi-b.sgm', 'besaan-b.sgm', 'meynal-b.sgm', 'plumce-b.sgm', 'frasch-b.sgm', 'allegr-b.sgm', 'blaceo-b.sgm', 'chanla-b.sgm', 'parkel-b.sgm', 'laffma-b.sgm', 'geraem-b.sgm', 'colefr-b.sgm', 'jewesa-b.sgm', 'burnf2-b.sgm', 'russje-b.sgm', 'chopka-b.sgm', 'harrja-b.sgm', 'hardiz-b.sgm', 'wilcel-b.sgm', 'humpce-b.sgm', 'fothje-b.sgm', 'wardma-b.sgm', 'mathhe-b.sgm', 'gregau-b.sgm', 'malelu-b.sgm', 'shawfl-b.sgm', 'caffka-b.sgm', 'blaccl-b.sgm', 'frazja-b.sgm', 'harkma-b.sgm', 'cairmo-b.sgm', 'gransa-b.sgm', 'wildos-b.sgm', 'schrol-b.sgm', 'corema-b.sgm', 'fordis-b.sgm', 'dixifl-b.sgm', 'gerado-b.sgm', 'wintjo-b.sgm', 'duttto-b.sgm', 'shawge-b.sgm', 'lee_ve-b.sgm', 'jay_ha-b.sgm', 'robiam-b.sgm', 'lyaled-b.sgm', 'dixoel-b.sgm', 'campco-b.sgm', 'conrjo-b.sgm', 'webbbe-b.sgm', 'nadeco-b.sgm', 'ramapa-b.sgm', 'smytet-b.sgm', 'someed-b.sgm', 'robifm-b.sgm', 'pankem-b.sgm', 'nesbe_-b.sgm', 'tynaka-b.sgm', 'housae-b.sgm', 'doylar-b.sgm', 'bakeel-b.sgm', 'cholma-b.sgm', 'swana2-b.sgm', 'franju-b.sgm', 'egerge-b.sgm', 'chekan-b.sgm', 'barrjm-b.sgm', 'gilmch-b.sgm', 'farrfl-b.sgm', 'pastge-b.sgm', 'watsro-b.sgm', 'ros_am-b.sgm', 'johnp2-b.sgm', 'colema-b.sgm', 'levyam-b.sgm', 'kendma-b.sgm', 'garnco-b.sgm', 'duncsa-b.sgm', 'whared-b.sgm', 'bannhe-b.sgm', 'rossm2-b.sgm', 'robiel-b.sgm', 'billma-b.sgm', 'huntvi-b.sgm', 'levead-b.sgm', 'kingma-b.sgm', 'gravcl-b.sgm', 'sincma-b.sgm', 'ecclch-b.sgm', 'harrbe-b.sgm', 'glynel-b.sgm', 'lytte2-b.sgm', 'saviet-b.sgm', 'hopela-b.sgm', 'yeatwi-b.sgm', 'bussdo-b.sgm', 'almala-b.sgm', 'scotca-b.sgm', 'scotc_-b.sgm', 'orczem-b.sgm', 'kiplru-b.sgm', 'ginghe-b.sgm', 'delael-b.sgm', 'whitro-b.sgm', 'dowime-b.sgm', 'pottbe-b.sgm', 'sigedo-b.sgm', 'arniel-b.sgm', 'wellhg-b.sgm', 'fry_ro-b.sgm', 'gonnma-b.sgm', 'klicfl-b.sgm', 'bennar-b.sgm', 'galsjo-b.sgm', 'glaska-b.sgm', 'pethem-b.sgm', 'hobbjo-b.sgm', 'markco-b.sgm', 'bellge-b.sgm', 'lownma-b.sgm', 'crosvi-b.sgm', 'lyttco-b.sgm', 'sharev-b.sgm', 'mew_ch-b.sgm', 'gidean-b.sgm', 'brazan-b.sgm', 'craied-b.sgm', 'richhe-b.sgm', 'goreev-b.sgm', 'bensin-b.sgm', 'syngjm-b.sgm', 'prouma-b.sgm', 'moored-b.sgm', 'stjoch-b.sgm', 'rathel-b.sgm', 'hamici-b.sgm', 'leggma-b.sgm', 'mordel-b.sgm', 'colech-b.sgm', 'cole__-b.sgm', 'richdo-b.sgm', 'morrot-b.sgm', 'cathwi-b.sgm', 'fordfo-b.sgm', 'glovev-b.sgm', 'steige-b.sgm', 'montlm-b.sgm', 'thurka-b.sgm', 'roydna-b.sgm', 'buchjo-b.sgm', 'undeev-b.sgm', 'bakee2-b.sgm', 'smedco-b.sgm', 'weavha-b.sgm', 'sowegi-b.sgm', 'barnna-b.sgm', 'roydma-b.sgm', 'thomfl-b.sgm', 'sidget-b.sgm', 'wentpa-b.sgm', 'fryeka-b.sgm', 'murreu-b.sgm', 'cablmi-b.sgm', 'ruckbe-b.sgm', 'forsem-b.sgm', 'naidsa-b.sgm', 'carsca-b.sgm', 'youneh-b.sgm', 'hallra-b.sgm', 'hullem-b.sgm', 'pankch-b.sgm', 'holmco-b.sgm', 'stopma-b.sgm', 'gawtma-b.sgm', 'ayreru-b.sgm', 'farjel-b.sgm', 'webbma-b.sgm', 'macaro-b.sgm', 'dellet-b.sgm', 'sackma-b.sgm', 'woolvi-b.sgm', 'joycja-b.sgm', 'marsdo-b.sgm', 'panksy-b.sgm', 'bottph-b.sgm', 'tweesu-b.sgm', 'hamima-b.sgm', 'lewiwy-b.sgm', 'peckwi-b.sgm', 'loy_mi-b.sgm', 'inneka-b.sgm', 'wickan-b.sgm', 'rhonma-b.sgm', 'edgima-b.sgm', 'compiv-b.sgm', 'jacona-b.sgm', 'schugl-b.sgm', 'treevi-b.sgm', 'uttlal-b.sgm', 'dineis-b.sgm', 'lawrdh-b.sgm', 'meynvi-b.sgm', 'pounez-b.sgm', 'bowema-b.sgm', 'cornfr-b.sgm', 'hd____-b.sgm', 'daryel-b.sgm', 'kayesh-b.sgm', 'trouun-b.sgm', 'beacsy-b.sgm', 'mirrho-b.sgm', 'strara-b.sgm', 'reevam-b.sgm', 'brooru-b.sgm', 'sitwed-b.sgm', 'asqucy-b.sgm', 'barche-b.sgm', 'moorma-b.sgm', 'wilset-b.sgm', 'danecl-b.sgm', 'jessft-b.sgm', 'milesu-b.sgm', 'eliots-b.sgm', 'manska-b.sgm', 'waddhe-b.sgm', 'akhman-b.sgm', 'welldo-b.sgm', 'lawrma-b.sgm', 'bridan-b.sgm', 'bagnen-b.sgm', 'forbro-b.sgm', 'allaro-b.sgm', 'thiran-b.sgm', 'hamnni-b.sgm', 'muirwi-b.sgm', 'delaem-b.sgm', 'stergb-b.sgm', 'rhysje-b.sgm', 'chriag-b.sgm', 'cromri-b.sgm', 'buttma-b.sgm', 'hurszo-b.sgm', 'jamest-b.sgm', 'wilsro-b.sgm', 'bensst-b.sgm', 'milled-b.sgm', 'sackvi-b.sgm', 'napiel-b.sgm', 'jaegmu-b.sgm', 'barndj-b.sgm', 'bostlu-b.sgm', 'westre-b.sgm', 'starfr-b.sgm', 'whipdo-b.sgm', 'carrdo-b.sgm', 'joneeb-b.sgm', 'sayedo-b.sgm', 'cannma-b.sgm', 'warnsy-b.sgm', 'britve-b.sgm', 'russdo-b.sgm', 'willam-b.sgm', 'trefvi-b.sgm', 'huxlal-b.sgm', 'bryh__-b.sgm', 'bentph-b.sgm', 'boweli-b.sgm', 'streno-b.sgm', 'cunana-b.sgm', 'kennma-b.sgm', 'smitdo-b.sgm', 'cannjo-b.sgm', 'tey_jo-b.sgm', 'treeir-b.sgm', 'omanca-b.sgm', 'walldo-b.sgm', 'blyten-b.sgm', 'coople-b.sgm', 'mitcna-b.sgm', 'pittru-b.sgm', 'obrika-b.sgm', 'holtwi-b.sgm', 'whitan-b.sgm', 'boweel-b.sgm', 'travpl-b.sgm', 'bellfr-b.sgm' 
  )]
)
(::)

(: 1800-1899 and (.//SETTLEMENT/text()='London' or .//@REG='London') :)
(:
let $groupStr := "1800-1899 London"
let $events_sequence := $events_sequence[.//SETTLEMENT/text()='London' or .//@REG='London'] 
 :)

(: 1500-1599:)
(:
let $groupStr := "1500-1599"
let $events_sequence := (
  //EVENT[@FILENAME = (
    'ropema-w.sgm', 'askean-w.sgm', 'parrka-w.sgm', 'margna-w.sgm', 'bassma-w.sgm', 'aberfr-w.sgm', 'tylema-w.sgm', 'tyrwel-w.sgm', 'lumlja-w.sgm', 'wheaan-w.sgm', 'angeja-w.sgm', 'whitis-w.sgm', 'elizqu-w.sgm', 'grymel-w.sgm', 'lockan-w.sgm', 'bulsci-w.sgm', 'bacoan-w.sgm', 'dowran-w.sgm', 'hickro-w.sgm', 'stuaar-w.sgm', 'leigdo-w.sgm', 'wenmag-w.sgm', 'pembma-w.sgm', 'joscel-w.sgm', 'cunnma-w.sgm', 'lincel-w.sgm', 'hobyma-w.sgm', 'falkel-w.sgm', 'melvel-w.sgm', 'shirel-w.sgm', 'harlbr-w.sgm', 'wardm2-w.sgm', 'lanyae-w.sgm', 'moulma-w.sgm', 'wrotma-w.sgm', 'richel-w.sgm', 'dougel-w.sgm', 'chidka-w.sgm', 'averel-w.sgm', 'shawhe-w.sgm', 'spegra-w.sgm', 'clifan-w.sgm'
, 'ropema-b.sgm', 'askean-b.sgm', 'parrka-b.sgm', 'margna-b.sgm', 'bassma-b.sgm', 'aberfr-b.sgm', 'tylema-b.sgm', 'tyrwel-b.sgm', 'lumlja-b.sgm', 'sidnph-b.sgm', 'angeja-b.sgm', 'marlch-b.sgm', 'spened-b.sgm', 'whitis-b.sgm', 'elizqu-b.sgm', 'grymel-b.sgm', 'lockan-b.sgm', 'bulsci-b.sgm', 'bacoan-b.sgm', 'dowran-b.sgm', 'hickro-b.sgm', 'stuaar-b.sgm', 'leigdo-b.sgm', 'shakwi-b.sgm', 'wenmag-b.sgm', 'pembma-b.sgm', 'joscel-b.sgm', 'cunnma-b.sgm', 'lincel-b.sgm', 'donnjo-b.sgm', 'hobyma-b.sgm', 'falkel-b.sgm', 'melvel-b.sgm', 'shirel-b.sgm', 'harlbr-b.sgm', 'wardm2-b.sgm', 'lanyae-b.sgm', 'moulma-b.sgm', 'wrotma-b.sgm', 'richel-b.sgm', 'dougel-b.sgm', 'chidka-b.sgm', 'averel-b.sgm', 'shawhe-b.sgm', 'spegra-b.sgm', 'clifan-b.sgm'
  )]
)
:)

(:
let $groupStr := "Isabella Bird"
let $events_sequence := (
  //EVENT[@FILENAME = (
    'birdis-b.sgm', 'birdis-w.sgm'
  )]
)
:)
(:
let $groupStr := "Dervla Murphy"
let $events_sequence := (
  //EVENT[@FILENAME = (
    'murpde-b.sgm', 'murpde-w.sgm'
  )]
)
:)
(:
let $groupStr := "Mary Ward"
let $events_sequence := (
  //EVENT[@FILENAME = (
    'wardm2-b.sgm', 'wardm2-w.sgm'
  ) ]
)
:)

let $ret :=
(
'{ "items": [&#10;'
,
(
  let $retSeq :=
    for $event_item as element() at $n in $events_sequence
      let $type := local:determineSchemaByRootElement($event_item)
      return
        "{"
        ||
        (: build sequence and join as a string therefore no need to deal with "," in JSON :)
        fn:string-join( 
          (
          local:outputJSON( "schemaType", string( $type ) )
          (: , local:outputJSON( "schema", string(fn:node-name($event_item)) ) :)
          , local:outputJSON("startDate", local:get_start_date($event_item,$type) ) 
          , local:outputJSONNotNull("endDate", local:get_end_date($event_item,$type) )
          , local:get_lat_lng($event_item, $type) 
          (:, local:outputJSONArray("group", local:get_collections($event_item) ) :)
          , local:outputJSON("group", $groupStr ) 
          , local:outputJSON("eventType", local:get_event_type($event_item, $type) )
          , local:outputJSON("label", local:get_label($event_item, $type) )
          , local:outputJSON("description", local:get_description($event_item, $type) )
          , local:outputJSONArrayNotNull( "citations", local:get_citations($event_item, $type) )
          , local:outputJSONNotNull( "contributors", local:get_contributors($event_item, $type) )
          , local:outputJSONNotNull( "link", $BASE_URL||$event_item/fn:substring(@FILENAME, 1, 6) )
          )
          , ","
        )
        || "}&#10;"
  return
    fn:string-join($retSeq, ',')  
)
,
']}'
)

return
  

  $ret
  (: 
    file:write('Desktop\'||$groupStr||'.json', $ret) 
    
  :)