#!/usr/bin/python

"""
Purpose:
    Convert a CSV file to a JSON file.
Usage:
    python csv2json.py
"""

import csv
import json

# Open the CSV file
f = open( 'input_file.csv', 'rU' )
# Change each field name to the appropriate field name
reader = csv.DictReader( f, fieldnames = ( "fieldname1","fieldname2","fieldname3"))
# Parse the CSV into JSON
out = json.dumps( [ row for row in reader ] )
print "JSON parsed"
# Save the JSON
f = open( 'output_file.json', 'w')
f.write(out)
print "JSON saved"