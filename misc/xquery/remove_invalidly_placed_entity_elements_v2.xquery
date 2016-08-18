(:
* delete specific tags (not their contents)  from a document at spots where they are 
schema invalid
*
* given a document, apply it against the CWRC Validation service

Here is the partial raw output of the validation service

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

The next would be interpreting the raw output of the validation, filtering on specific messages. Then for each message, build an XQuery update operation to remove the specified element as specified by the path (there should be a way to delete the element while retaining their contents

Run multiple times if nested entities need deleting

:)

(:
ToDo: incorperate the CWRC-Validation service step into this script
http://expath.org/oxygen/
http://www.ibm.com/developerworks/library/x-expath/
import module namespace http = "http://expath.org/ns/http-client";
let $z := http:send-request(
<http:request href="service/validator/validate.html" method="post">

</http:request>
)
:)

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";

(: external variables :)
(: declare variable $VALIDATION_ERROR_FILE := './playwright_nerve_entry-test_results_5.xml.validation.xml'; :)
declare variable $VALIDATION_ERROR_FILE external;

copy $c := .

modify
(
  let $validation_errors := doc($VALIDATION_ERROR_FILE)

  for $path in $validation_errors//warning/path/text()
    let $tmp := $c/saxon:evaluate(fn:normalize-space($path)) (: :)
    return (
      replace node $tmp with $tmp/node()
    )
)

return $c

