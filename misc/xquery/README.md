XQuery
------

Purpose: collect miscellaneous XQuery scripts

Details
-------

cw\_orlando\_helpers.xq - Orlando project specific handling functions that could be reused elsewhere

cw\_place\_helpers.xq - functions specific to "place" elements including API calles to lat/lng lookup services

cwrc\_place\_cache.xq - purpose: create a cache of geospatial information if not already present in BaseX to facilitate faster lookups 

cwrc\_place\_insert\_ref.xq - purpose: if a "place" element is missing a @ref attribute, attempt to lookup the text of the element in goenames and add a @ref attribute

cwrc\_PLOT-IT\_JSON.xq: purpose: output "events' in the PLOT-IT JSON format from select schemas.  Note: if cwrc\_place\_cache.xq is exectuted first then the JSON creation will execute faster because the geospacial lookup doesn't have access a remote server

2015-03-31 - How to build Plot-IT JSON file for the stand-alone Plot-IT
----------
(1) added XML to a BaseX database (turn-off "chop whitespace", use internal parser, and enable text-index)
(2) run  "cwrc\_place\_cache.xq" query to cache the non-local place entity information
(3) run "cwrc\_PLOT-IT\_JSON.xq" to generate the JSON and add to the stand-alone Plot-IT