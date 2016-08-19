(:
* delete specific tags (not their contents) from a document at spots where they are 
schema invalid
*
* inputs:
*   a document 
*   the output of the CWRC-Validation service stored in a file

* The XQuery interprets the raw output of the validation service, filtering on specific messages. For each message, an XQuery update operation removes the specified invalid element as specified by the path while retaining its contents. Note: doesn't work with attributes.

Run multiple times if nested entities need deleting

Here is an example of the raw validation service output

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

* How to use:
*
* Start with the output file from NERVE and use as input for this process
* Open the CWRC-Validation service ("services/validator/index.html")
* Fill out the web form with:
** Schema attached to the doc (e.g., within the "?xml-model" processing instruction)
** Schema type: RNG_XML | RNG_COMP (no wsd at this time)
** Copy/paste the contents of the input document
* After running the service, the result will be an XML doc with schema validation errors (if any)
* Copy/paste this XML doc into a file and save alongside the output file from NERVE
* Save the XQuery file to remove the invalid elements - https://raw.githubusercontent.com/cwrc/CWRC-Misc/master/misc/xquery/remove_invalidly_placed_entity_elements_v2.xquery
* open Oxygen and create (or modify an existing) XQuery transformation scenario
** input doc: path to file from NERVE
** XQuery URI: path to the downloaded XQuery file
** transform: Saxon-EE XQuery
** advanced transform options (the yellow ball next to "transform") - uncheck "enable XQuery 3.0 support"
** parameters: add a parameter to point to where the validation errors were saved (e.g., VALIDATION_ERROR_FILE=file:///C:/Users/zzzzz/validation.xml)
* run transformation scenario
* output should appear in a panel at the bottom of Oxygen (where the validation errors appear)
* right-click in the panel and select "save as" (or one can specify the output file in the transformation
scenario
* open the newly saved file and test for validation errors
* double check: Oxygen=>Tools=>Compare Files to do a difference report against the before and after
:)

(:
ToDo: incorperate the CWRC-Validation service step into this script
http://expath.org/oxygen/
http://www.ibm.com/developerworks/library/x-expath/
import module namespace http = "http://expath.org/ns/http-client";
let $z := http:send-request(
<http:request href="service/validator/validate.html" method="post">
<http:body media-type="application/x-www-form-urlencoded" method="text">content=<WRITING></WRITING>&amp;type=RNG_XML&amp;sch=http://cwrc.ca/schemas/cwrc_entry.rng</http:body>
</http:request>
)
:)

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";

(: external variables :)
declare variable $VALIDATION_ERROR_FILE external;

(: only select validation errors - for safety :)
(: toDo: enhance list to include TEI :)
declare variable $LIST_ELEMENTS_REMOVE_IF_INVALID := '^element "(NAME|PLACE|PERSON|LOCATION|ORGANIZATION)" not allowed here;';

copy $c := .

modify
(
  let $validation_errors := doc($VALIDATION_ERROR_FILE)

  for $warning in $validation_errors/validation-result/warning
    return (
      (: only select validation errors - for safety :)
      (: matches(fn:normalize-space($warning/message/text()),'^element "[^"]+?" not allowed here;') :)
      if (
        matches(fn:normalize-space($warning/message/text()), $LIST_ELEMENTS_REMOVE_IF_INVALID)
      ) then
        let $path := $warning/path/text()
        let $tmp := $c/saxon:evaluate(fn:normalize-space($path)) (: :)
        return replace node $tmp with $tmp/node()
      else
      ()
    )
)

return $c

