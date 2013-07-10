#!/bin/bash

#FILES=./orlando_data/2013-01-17/original/*
FILES=./legacy_orlando_documentation/orlando-documentation/*

#DEST=./orlando_data/2013-01-17/with_header/
DEST=./legacy_orlando_documentation/orlando-documentation-header/

BASE_HEAD=./legacy_orlando_header
BIOGRAPHY_HEAD=$BASE_HEAD/header-b.xml
WRITING_HEAD=$BASE_HEAD/header-w.xml
EVENT_HEAD=$BASE_HEAD/header-e.xml
BIBLIOGRAPHY_HEAD=$BASE_HEAD/header-l.xml
DOCUMENTATION_HEAD=$BASE_HEAD/header-d.xml

shopt -s nullglob
for f in $FILES
do
    echo "Processing $f..."

    #echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    TMP="$DEST"
    TMP+=`basename $f`
    echo "    "$TMP
    if [[ $f =~ "-b.sgm" ]]
    then
        XML_HEAD=$BIOGRAPHY_HEAD
    elif [[ $f =~ "-w.sgm" ]]
    then
        XML_HEAD=$WRITING_HEAD
    elif [[ $f =~ "-e.sgm" ]]
    then
        XML_HEAD=$EVENT_HEAD
    elif [[ $f =~ "-l.sgm" ]]
    then
        XML_HEAD=$BIBLIOGRAPHY_HEAD
    elif [[ $f =~ "-d.sgm" ]]
    then
        XML_HEAD=$DOCUMENTATION_HEAD
    else
        XML_HEAD=""
    fi

    #echo $XML_HEAD
    `cat $XML_HEAD $f > $TMP`
    #echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
done

