<?php

// given a csv file as input
// where the first row is a list of unique tokens which match tokens located strategically
// in a template file for replacement
// where the second row is blank or contains a simple meta language to allow a more complex
// replacement (with added text for example)
// The second input is a template file containing tokens for replacement from the csv data
// file
// 
// excute:
//          php template_filler.php template_sample_2.xml source_sample_2.csv 

define ("DEBUG", 0);

$filename_template = $argv[1];
$filename_source = $argv[2];


print "template file: $filename_template\n";

if(!file_exists($filename_template) || !is_readable($filename_template))
return FALSE;

print "source file: $filename_source\n";

if(!file_exists($filename_source) || !is_readable($filename_source))
return FALSE;

$handle_template = NULL;
$handle_source = NULL;


$handle_template = fopen($filename_template, 'r');
$handle_source = fopen($filename_source, 'r');


if ($handle_template && $handle_source)
{
    $data = csv_to_array($handle_source, $filename_template);
    
    fclose($handle_source);
    fclose($handle_template);
}

/**
 *
 * 
 *
 **/
function array_to_template($filename_template, $rules)
{

    $template_str = file_get_contents($filename_template);

    if (DEBUG) {
      print "====== BEFORE \n";
      echo $template_str;
    }


    foreach ( $rules['data'] as $key => $value )
    {
        $tmp = NULL;
        if ( $rules['substitutions'][$key] )
        {
            $tmp = $rules['substitutions'][$key] ;
            $replace_str = preg_quote("{$key}");
            $tmp = preg_replace ( "/\{$key\}/", $value, $tmp); 
        }
        else
        {
            $tmp = $value;
        }

        if ($tmp) 
        {
            //echo preg_replace ( "($key)", $tmp, $template_str); 
            $tmp_reg_ex = "/\{$key\}/";
            if ( preg_match($tmp_reg_ex, $template_str) === 1 )
            {
                $template_str = preg_replace ($tmp_reg_ex, $tmp, $template_str); 
            }
            else 
            {
                print ("ERROR: Key [$key] not found in template\n");
            }
        }
    }

    if (DEBUG) {
      print "====== AFTER \n";
      echo $template_str;
    }

    return $template_str;
}

/**
 *
 *
 *
 */
function csv_to_array($handle_source, $filename_template, $delimiter=',')
{
    $header = NULL;
    $substitutions = NULL;
    $tmp = array();
    $data = array();
    $rules = array();

    while (($row = fgetcsv($handle_source, 10000000, $delimiter)) !== FALSE)
    {
        if(!$header)
        {
            $header = $row;
        }
        elseif (!$substitutions)
        {
            $substitutions = $row;
        }
        else
        {
            $rules['data'] = array_combine($header, $row);
            $rules['substitutions'] = array_combine($header, $substitutions);
            if (DEBUG) {
              print_r($rules);
            }

            echo array_to_template($filename_template, $rules);
        }
    }
    return $rules;
}

?>
