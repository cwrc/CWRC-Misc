(:
* delete specific tags (not their contents)  from a document at spots where they are 
schema invalid
*
* given a document, apply it against the CWRC Validation service

Here is the partial raw output of the validation service

<warning>
<line>210</line>
<column>62</column>
<message>element "span" not allowed anywhere; expected the element end-tag, text or element "abbr", "add", </message>
<element>span</element>
<path>/TEI/text[1]/body[1]/lg[7]/lg[3]/l[12]/span[1]</path>
</warning>

The next would be interpreting the raw output of the validation, filtering on specific messages. Then for each message, build an XQuery update operation to remove the specified element as specified by the path (there should be a way to delete the element while retaining their contents

Run multiple times if nested entities need deleting

:)


declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";


declare variable $validation_result := '
<validation-result>
<status>fail</status>
<warning>
<line>35</line>
<column>29</column>
<message>
element "NAME" not allowed here; expected the element end-tag or text
</message>
<element>NAME</element>
<path>
/BIOGRAPHY/ORLANDOHEADER[1]/REVISIONDESC[1]/RESPONSIBILITY[5]/ITEM[1]/NAME[1]
</path>
</warning>
</validation-result>
';

(: declare variable $validation_xml := fn:parse-xml($validation_result); 
for $i in $validation_xml//warning/path/text()
return 
  $i

let $tmp := doc('file:///C:/Users/jefferya.ARTSRN/Downloads/Untitled1.xml')

for $i in $tmp//warning/path/text()
return
    replace node $i with 'aaaa'
    
:)

(: 
test grab path from validation service and lookup in current doc :)
(:
let $validation_errors := doc('file:///C:/Users/jefferya.ARTSRN/Downloads/Untitled1.xml')

for $path in $validation_errors//warning/path/text()
  let $tmp := saxon:evaluate(fn:normalize-space($path))
  return (
    $tmp 
    )
:)


copy $c := .

modify
(

let $validation_errors := doc('file:///C:/Users/jefferya.ARTSRN/Downloads/Untitled1.xml')

for $path in $validation_errors//warning/path/text()
  let $tmp := $c/saxon:evaluate(fn:normalize-space($path))
  return (
    replace node $tmp with $tmp/node()
  )

)

return $c

(:
:)
