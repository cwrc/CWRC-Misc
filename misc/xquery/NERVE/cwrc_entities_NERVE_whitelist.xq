(:
: create a whitelist file for NERVE using the CEWW ORG entities
: basexclient -o /tmp/z -bPROJECT_ID=GeoNames -bENTITY_NAME=PLACE cwrc_entities_NERVE_whitelist.xq
:)

declare option output:method "csv";
declare option output:encoding "UTF-8";
declare option output:csv "quotes=yes, header=no, separator=comma, backslashes=no";

(: external variables :)
declare variable $ENTITY_NAME external := "ORGANIZATION";
declare variable $PROJECT_ID external := "ceww";

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
for $entity in db:open('cwrc_main')/obj[node()[name()=concat($ENTITY_NAME,'_DS')]/entity/node()[name()=fn:lower-case($ENTITY_NAME)]/recordInfo/originInfo/projectId/text()=$PROJECT_ID]
let $uri := "http://commons.cwrc.ca/" || $entity/@pid/data()
return
  for $name in $entity/node()[name()=concat($ENTITY_NAME,'_DS')]/entity/node()[name()=fn:lower-case($ENTITY_NAME)]/identity/(preferredForm|variantForms/variant)
  return
    if ($name/*) then
        <record>
            <name>{normalize-space(local:name($name))}</name>
            <entityType>{$ENTITY_NAME}</entityType>
            <uri>{$uri}</uri>
            <project>{$PROJECT_ID}</project>
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
