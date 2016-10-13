(:
: create a whitelist file for NERVE using the CEWW Title entities
:)

(: declare namespaces used in the content :)
declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace fedora =  "info:fedora/fedora-system:def/relations-external#";
declare namespace fedora-model="info:fedora/fedora-system:def/model#"; 
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";

(: options :)
declare option output:method "csv";
declare option output:encoding "UTF-8";
declare option output:csv "quotes=yes, header=no, separator=comma, backslashes=no";


(: **** helper functions :)

(: **** main :)
<csv>
{
for $entity in db:open('cwrc_main')/obj[RELS-EXT_DS/rdf:RDF/rdf:Description/fedora:isMemberOfCollection/@rdf:resource=('info:fedora/islandora:d8259d46-dd57-4654-8081-f79fca45cb16','info:fedora/islandora:2d7da0e4-e719-4e52-8037-0c064132b4bf')]
let $uri := "http://commons.cwrc.ca/" || $entity/@pid/data()
return
  for $name in $entity/MODS_DS/mods:mods/mods:titleInfo/*:title
  return
    if ($name) then
        <record>
            <name>{normalize-space($name)}</name>
            <entityType>TITLE</entityType>
            <uri>{$uri}</uri>
            <project>ceww</project>
        </record>
    else
        <record>
            <name></name>
            <entityType>TITLE</entityType>
            <uri>{$uri}</uri>
            <project>ceww</project>
        </record>
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
