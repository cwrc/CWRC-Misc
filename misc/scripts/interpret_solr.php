<?php

// template for interpreting a json Solr query result
//  
// given the json output of a solr query (circa 2014-04-10)
// interpret the results

//$contents = file_get_contents("mods.txt", true);
$contents = file_get_contents("test.json", true);

// allow php to use extra memory
ini_set("memory_limit","1G");

$solr_response_obj = json_decode($contents);

//var_dump($solr_response_obj);

foreach( $solr_response_obj->{"response"}->{"docs"} as $doc )
{
  if ( !isset($doc->RELS_EXT_hasModel_uri_ms) && !isset($doc->RELS_EXT_isMemberOfCollection_uri_ms)  )
  {
    echo $doc->PID;
    //var_dump( $doc->{"dc.title"});
    var_dump ($doc);
    //var_dump ($doc->RELS_EXT_hasModel_uri_ms);
    echo "\n";
  }
}

?>

