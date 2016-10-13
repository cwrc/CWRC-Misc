(:
: create a whitelist file for NERVE using the place entities
: basexclient -o /tmp/z cwrc_all_place_entities_NERVE_whitelist.xq
:)

declare option output:method "csv";
declare option output:encoding "UTF-8";
declare option output:csv "quotes=yes, header=no, separator=comma, backslashes=no";

declare function local:name($base_node)
{

  if ($base_node/namePart/@partType = ('family', "given")) then
    $base_node/namePart[@partType = 'given']
    || ' '
    || $base_node/namePart[@partType = 'family']
  else
    $base_node/namePart
};


<csv>
{
for $entity in db:open('cwrc_main')/obj/PLACE_DS/entity/place[recordInfo/originInfo/projectId/text()='GeoNames']
  let $geonamesId := $entity/recordInfo/originInfo/recordIdentifier/data()
  let $uri := 'http://geonames.org/'||$geonamesId
  return
  if ($geonamesId) then
    for $name in $entity[description/countryName/text()='Canada']/identity/(preferredForm|variantForms/variant)
    let $tmp := normalize-space(local:name($name))
    group by $tmp
    return
        if ($name) then
            <record>
                <name>{$tmp}</name>
                <entityType>PLACE</entityType>
                <uri>{$uri}</uri>
                <project>{$entity/recordInfo/originInfo/projectId/text()}</project>
            </record>
        else
        ()
  else
    ()
}
</csv>


(:  
  return
    if ($name/*) then 
    fn:concat(
      '"'
      ,  normalize-space(local:name($name))
      , '"'
      , ','
      , '"PERSON"'
      , ',"'
      , $uri
      , '"'
      ,','
      , '"ceww"'
    )
    else
    ()
:)
