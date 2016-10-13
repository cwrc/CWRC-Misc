(:
: create a whitelist file for NERVE using the CEWW Person entities
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
for $entity in db:open('cwrc_main')/obj[PERSON_DS/entity/person/recordInfo/originInfo/projectId/text()='ceww']
let $uri := "http://commons.cwrc.ca/" || $entity/@pid/data()
return
  for $name in $entity/PERSON_DS/entity/person/identity/(preferredForm|variantForms/variant)
  return
    if ($name/*) then
        <record>
            <name>{normalize-space(local:name($name))}</name>
            <entityType>PERSON</entityType>
            <uri>{$uri}</uri>
            <project>ceww</project>
        </record>
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
