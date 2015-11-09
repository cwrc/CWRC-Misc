for $id in db:open('cwrc_cache')/places/geonames/geoname
let $tmp:=$id/@geonameId/data()
group by $tmp
order by $tmp
return
  (: $id[position() <= 1] :)

  (: count($tmp) :)
  delete node $id[position() > 1]
  
