#!/usr/bin/env python

# MRB -- Sun 06-Apr-2014

# Purpose: Python script to geocode place names using the Google Geocoding API

# Description: Python script to geocode place name into their associated coordinates of
# latitude and longitude using the Google Geocoding API.  The input file consists of a CSV
# text file with two fields, place name and 2-letter province/territory code, separated
# by a comma, e.g., "Edmonton, AB", with each line in the text file containing these two
# data elements.  The resulting output file contains three comma-separated fields: place
# name and 2-letter province/territory code, latitude, and longitude.  To run the script,
# type the following at the command prompt:

#     python geocode-Google.py

# [This script adapted from a script located at this URL:
# http://fredgibbs.net/tutorials/extract-geocode-placenames-from-text-file/]

import requests
import csv

inputfile = open('input.csv','r')
outputfile = csv.writer(open('output.csv','wb'))

for row in inputfile:
    row = row.rstrip()
    url = 'http://maps.googleapis.com/maps/api/geocode/json'
    payload = {'address':row, 'sensor':'false'}
    r = requests.get(url, params=payload)
    json = r.json()

    lat = json['results'][0]['geometry']['location']['lat']
    lng = json['results'][0]['geometry']['location']['lng']

    newrow = [row,lat,lng]
    # print out place name, 2-letter province/territory code, latitude, and longitude
    outputfile.writerow(newrow)