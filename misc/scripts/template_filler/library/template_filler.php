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

define ("DEBUG", 0);

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
        $replace_str = NULL;

        // escape the "[]" characters in the key before a regular expersion
        // is run
        $replace_str = preg_quote("{$key}");

        if ($value == NULL && trim($value) === "") 
        {
            // if the cvs value is null then an empty string 
            $tmp = "";
            echo "zzzzzzzzzzzzzzzzzzz {".$key."}{".$value."}\n";
        } 
        elseif ( $rules['substitutions'][$key] )
        {
            // if the cvs value is not null and there is a substitution string
            // then use the substitution
            $tmp = $rules['substitutions'][$key] ;
            
            $tmp = preg_replace ( "/\{$replace_str\}/", $value, $tmp); 
        }
        else
        {
            // if the cvs value is not null
            // then use the csv value 
            $tmp = $value;
        }

        //if ($tmp !== NULL && $tmp!=="") 
        {
            //echo preg_replace ( "($key)", $tmp, $template_str); 
            $tmp_reg_ex = "/\{$replace_str\}/";
            if ( preg_match($tmp_reg_ex, $template_str) === 1 )
            {
                // if the key exists in the template 
                // then replace the key
                    $template_str = preg_replace ($tmp_reg_ex, $tmp, $template_str); 
            }
            else 
            {
                print ("ERROR: Key ". (string)$key . " not found in template\n");
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

    $result = "";

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

            $result .= array_to_template($filename_template, $rules);
        }
    }
    return $result;
}

?>
