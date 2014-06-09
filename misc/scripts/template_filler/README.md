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

