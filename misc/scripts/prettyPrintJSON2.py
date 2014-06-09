#!/usr/bin/env python
"""
Purpose:
    Pretty print (format and indent) a JSON data file (reads from stdin and writes to stdout).
Usage:
    cat input.json | prettyPrintJSON2.py > output.json
  Note:
	Can also use this command: python -mjson.tool input.json > output.json
"""

import sys
import simplejson as json

print json.dumps(json.loads(sys.stdin.read()), indent=4)
sys.exit(0)