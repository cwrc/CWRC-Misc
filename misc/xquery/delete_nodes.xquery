(: Playwrights Project - remove empty textscopes defined by having a
immediately preceeding researchnote with "Optional additional play: " - no "Y"
:)

copy $c := .
modify
(
for $node in $c/CWRC/ENTRY/TEXTSCOPE[preceding-sibling::RESEARCHNOTE[1]/text()
= "Optional additional play: "]

return (
delete node $node
,
delete node $node/preceding-sibling::RESEARCHNOTE[1] 
)

)

return $c

