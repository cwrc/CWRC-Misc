<?php

/*
 * Script to populate a template based on a CSV source file via tokens
 *
 * One creates a template (XML, JSON, or anything) populated with tokens and a csv file where the first row contains column names that match the tokens in the template.  The second row is a meta language that allows some fancier replacements (see samples for examples).  The third and subsequent rows contain the data.  Each cell in each data row is then matched via token to its indicated location in the template and thus the template is automatically populated.
 */

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

include "library/template_filler.php";



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

// 2014-08-11 - if CSV created on a Mac, may have Mac line ending
ini_set('auto_detect_line_endings', true);

$handle_template = fopen($filename_template, 'r');
$handle_source = fopen($filename_source, 'r');


if ($handle_template && $handle_source)
{
    $data = csv_to_array($handle_source, $filename_template);
    echo $data;
    
    fclose($handle_source);
    fclose($handle_template);
}


?>
