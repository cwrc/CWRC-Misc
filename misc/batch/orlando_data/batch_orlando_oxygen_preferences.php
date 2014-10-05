#!/usr/bin/php

<?php

// test a document versus the resulting files - crude, error-prone te
// to see if the Oxygen preferences have been properly set

date_default_timezone_set('America/Edmonton');


//$dir_name = './legacy_event/tmp_split/';
$dir_name = '/mnt/nifflheim.arts.ualberta.ca/orlando/www/wwp/data_mirror/';

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

    //
    $ext = preg_replace('/^.*\.([^.]+)$/D', '$1', $file_name);

    $file_name = $dir_name . $file_name;

    //
    if (
        is_file($file_name)
        &&
        ( $ext=="xml" || $ext=='sgm' )
        )
    {
        validate_file(
            $file_name
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
    )
{
    $tmp = file_get_contents( $file_name );

    if ( preg_match("/\/>/", $tmp) === 1 )
    {
        $result = "fail";
    }
    else
    {
        $result = "success";
    }
    print $result;


}

?>

