<x>{
for $z in data(doc("orlando_name_auth_h-m")/AUTHORITYLIST/AUTHORITYITEM/@STANDARD)
let $blah := data($z)
where
(
  not
  (
    db:open("person-2013-12-13")/cwrc/entity/person/identity/variantForms/variant[authorizedBy/projectId/text()="orlando"]/namePart[$blah=text()]/text()
)

 )
return
 <omitted>
 {$blah}
 </omitted>
}
</x>