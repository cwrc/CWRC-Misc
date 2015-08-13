<?php

/**
 * MRB -- Wed 12-Aug-2015
 */

// Purpose: PHP script to run a local version of the CWRC XML Validation Service
 
/**
 * Description: MRB's modification of JCA's PHP script "batch_orlando_validation.php".
 * This PHP file can be used to run a local batch validation process, i.e., to validate
 * a collection of XML documents locally on a computer.  The batch validation process uses
 * the CWRC XML Validation Service, also known as the CWRC XML Validator API.  The
 * validation service is a Java Servlet application that runs inside Apache Tomcat.
 */

# *** Need to start Apache Tomcat to expose the local CWRC XML Validator API ***

# *** Provide the URL to the local CWRC XML Validation Service ***
$url = "http://localhost:8080/validator/validate.html";

# *** Provide the directory path to the source XML files to be validated ***
# $dir_name = 'file:///$HOME/Desktop/tmp/'; // *nix version
$dir_name = 'file:///%USERPROFILE%/Desktop/tmp/'; // Windows version

# *** Provide the directory path to the schema to be used for validating the XML files ***
# $schema = "file:///$HOME/Documents/GitHub/CWRC-Schema/schemas/orlando_event.rng"; // *nix version
$schema = "file:///%USERPROFILE%/Documents/GitHub/CWRC-Schema/schemas/orlando_event.rng"; // Windows version

# *** Provide the schema type: "RNG_XML" (RELAX NG) or "XSD_XML" (XML Schema) ***
$schema_type = "RNG_XML";

// Declare $schema_test variable to be true
$test_type = true;

$xml_pi = '<?xml version="1.0" encoding="UTF-8"?>';

date_default_timezone_set('America/Edmonton');

// Print out XML declaration statement
print $xml_pi . "\n";

// Get file list; use preg_grep to filter out dot files
$file_array = preg_grep('/^([^.])/', scandir( $dir_name ));

// Iterate through files
print "<validation>" ;
print "\n";
foreach ( $file_array as $file_name)
{
    print "<validation_item id=\"$file_name\" file_date=\"";
    print date('c', filemtime($dir_name . $file_name));
    print "\">" ;

    print "\n";

    $ext = preg_replace('/^.*\.([^.]+)$/D', '$1', $file_name);

    $file_name = $dir_name . $file_name;

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
            , $url
            , $schema
            , $schema_type
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
    , $url
    , $schema
    , $schema_type
    ) 
{
    $tmp = file_get_contents( $file_name );

    $fields = array (
            "content" => $tmp
            , "sch" =>  $schema
            , "type" => $schema_type 
            );

    $qry = http_build_query($fields, '');

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS	, $qry	);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER	, true	);
    curl_setopt($ch, CURLOPT_SSLVERSION	, 3 	);
    curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION , true	); // Follow redirects
    curl_setopt($ch, CURLOPT_ENCODING       , ""	); // Handle all encodings
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER , false	);

    $result = curl_exec($ch);

    if ($result === false)
    {
            print ( curl_error($ch) );
            print ("\n");
    }

    curl_close($ch);

    $result 
        = str_replace( 
            '<?xml version="1.0" encoding="UTF-8"?>'
            , ""
            , $result
            );
    print $result;

}

?>	
