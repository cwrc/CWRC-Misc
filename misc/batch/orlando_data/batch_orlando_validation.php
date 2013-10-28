<?php
// test a document versus the CWRCvalidator
// // 2012-11-14 - test all Orlando docs versus the CWRC validator

$dir_name = './legacy_event/tmp_split/';

//$url = "http://localhost:4333/";
$url = "https://apps.testing.cwrc.ca/services/validator/validate.html";
$schema_writing         = "http://cwrc.ca/schema/writing";
$schema_bio             = "http://cwrc.ca/schema/biography";
$schema_event           = "http://cwrc.ca/schema/events.rng";
$schema_biblography     = "http://cwrc.ca/schema/bibliography";
$schema_documentation   = "http://cwrc.ca/schema/legacy_orlando_documentation.rng";
$schema_type = "RNG_XML";
$username = "";
$password = "";

$xml_pi = '<?xml version="1.0" encoding="UTF-8"?>';
$xml_docType= 
    '<!DOCTYPE AUTHORITYLIST[ <!ENTITY % character_entities SYSTEM "http://cwrc.ca/schema/character_entities.dtd"> %character_entities; ]>
        '
    ;

$xml_header = $xml_pi . $xml_docType;

date_default_timezone_set('America/Edmonton');

// Get username and password
echo "\n";
echo "url: ";
echo "$url \n";
echo "Username: ";
$username = trim(fgets(STDIN));
echo "Password: ";
system('stty -echo');
$password = trim(fgets(STDIN));
system('stty echo');
echo "\n";
echo "\n";


// Get file list
$file_array = scandir( $dir_name );

// iterate through files
print "<validation>" ;
print "\n";
foreach ( $file_array as $file_name)
{
    print "<validation_item id=\"$file_name\" file_date=\"";
    print date('c', filemtime($dir_name . $file_name));
    print "\">" ;

    print "\n";

    $ext = preg_replace('/^.*\.([^.]+)$/D', '$1', $file_name);

    // 
    $test_type = false; 
    if ( strpos( $file_name, '-b.sgm') !== false )
    {
        $test_type = true; 
        $schema = $schema_bio;
    }
    elseif ( strpos( $file_name, '-w.sgm') !== false )
    {
        $test_type = true; 
        $schema = $schema_writing;
    }
    elseif ( strpos( $file_name, '-e.sgm') !== false )
    {
        $test_type = false; 
        $schema = $schema_event;
    }
    elseif ( strpos( $file_name, '-l.sgm') !== false )
    {
        $test_type = false; 
        $schema = $schema_bibliography;
    }
    elseif ( strpos( $file_name, '-d.sgm') !== false )
    {
        $test_type = false; 
        $schema = $schema_documentation;
    }

    //
    $file_name = $dir_name . $file_name;

    // 
    if ( 
        is_file($file_name) 
        && 
        ( $ext=="xml" || $ext=='sgm' ) 
        && 
        $test_type !== false
        )
    {
        validate_file(
            $file_name
            , $username
            , $password
            , $url
            , $schema
            , $schema_type
            , $xml_header
        );
    }
    else
    {
        print ('invalid type');
    }
    print "</validation_item>" ;
    print "\n";
} 
print "</validation>" ;
print "\n";






function validate_file(
    $file_name
    , $username
    , $password
    , $url
    , $schema
    , $schema_type
    , $xml_header
    ) 
{
    $tmp = file_get_contents( $file_name );
    $tmp = $xml_header . $tmp;

    $fields = array (
            "content" => $tmp
            , "sch" =>  $schema
            , "type" => $schema_type 
            );

    $qry = http_build_query($fields, '');

    //print ($qry);
    //print "\n";

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS	, $qry	);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER	, true	);
    curl_setopt($ch, CURLOPT_SSLVERSION	, 3 	);
    curl_setopt($ch, CURLOPT_USERPWD, "$username:$password");
    curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION , true	); // follow redirects
    curl_setopt($ch, CURLOPT_ENCODING       , ""	); // handle all encodings
    //curl_setopt($ch, CURLOPT_CONNECTTIMEOUT , 120	); // timeout on connect
    //curl_setopt($ch, CURLOPT_TIMEOUT        , 120	); // timeout on response
    //curl_setopt($ch, CURLOPT_MAXREDIRS      , 10	); // stop after 10 redirects
    //curl_setopt($ch, CURLOPT_SSL_VERIFYHOST , 1	);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER , false	);

    $result = curl_exec($ch);

    /*
    print ("\n");
    print ('xxxx');
    print ("\n");
    //print ($result);
    print ("\n");
    print ('xxx');
    print ("\n");
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE); 
    print ($httpCode);
    print ("\n");
    print ('xxx');
    print ("\n");
     */

    if ($result === false)
    {
            print ( curl_error($ch) );
            print ("\n");
    }
    /*
    else
    {
            print ("ok");
            print ("\n");
    }
    */

    curl_close($ch);

    $result 
        = str_replace( 
            '<?xml version="1.0" encoding="UTF-8"?>'
            , ""
            , $result
            );
    print $result;
    //var_dump($result);

}

?>	
