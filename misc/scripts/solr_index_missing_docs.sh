#!/bin/bash

# compare a listing of all objects in Fedora and compare to doc within Solr
# (via PIDs) and index with Solr the missing objects
# ToDo: extend to compare modification dates 

# Server Info
echo -n "Enter your Fedora HOST and press [ENTER]: "
read FEDORA_HOST 
echo -n "Enter your Fedora PORT and press [ENTER]: "
read FEDORA_PORT 

# Authentication
echo -n "Enter username and press [ENTER]: "
read FEDORA_USER 
echo -n "Enter password and press [ENTER]: "
read -s FEDORA_PASS 
echo

#echo "$FEDORA_URL $FEDORA_USERNAME $FEDORA_PASSWORD"

# fedoragsearch location
FEDORAGSEARCH_LOC=fedoragsearch-2.8
SOLR_LOC="http://localhost:8983/solr/fedora_apachesolr"

# GLOBAL Settings
THREADS=10

# Temp Files
RI_PIDS=$(mktemp /tmp/RI-PIDS.XXXXXXXX)
SOLR_PIDS=$(mktemp /tmp/SOLR-PIDS.XXXXXXXX)
MISSING_PIDS=$(mktemp /tmp/MISSING-PIDS.XXXXXXXX)

# Remove temp files
function cleanup() {
    rm $RI_PIDS
    rm $SOLR_PIDS
    #rm $MISSING_PIDS
}

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT
function ctrl_c() {
    cleanup
    exit $?
}

function query_ri() {
    local TYPE="tuples"
    local QUERY_LANG="sparql"
    local FORMAT="CSV"
    local LIMIT=
    local DISTINCT="on"
    local DT="on"
    local QUERY="SELECT ?object WHERE {
 ?object <fedora-model:hasModel> <info:fedora/fedora-system:FedoraObject-3.0>
}";
    curl -s -u $FEDORA_USER:$FEDORA_PASS --data "lang=$QUERY_LANG&format=$FORMAT&limit=$LIMIT&distinct=$DISTINCT&dt=$DT&query=$QUERY" "$FEDORA_HOST:$FEDORA_PORT/fedora/risearch" \
        | tail -n +2 \
        | perl -pe 's/info:fedora\///' \
        | sort -u > $RI_PIDS
    echo "RIQuery discovered "$(wc -l $RI_PIDS)" PIDS"
}

function query_solr() {
    curl -s "$SOLR_LOC/select?q=PID%3A*&rows=1000000&fl=PID&wt=csv" \
        | tail -n +2 \
        | sort -u > $SOLR_PIDS
    echo "SOLR discovered "$(wc -l $SOLR_PIDS)" PIDS"
}

function diff_pids() {
    comm -23 $RI_PIDS $SOLR_PIDS > $MISSING_PIDS
    echo $(wc -l $MISSING_PIDS)" PIDS Need to be indexed by SOLR"
}

function optimize_index() {
    curl -s $SOLR_LOC/update -F stream.body=' <optimize />' 2>&1 > /dev/null
}

function index_missing() {
    local i=0
    local N=${THREADS}
    (
        while read pid; do
            ((0==i%N)) && wait
            ((0==i%10000)) && optimize_index
            OPEN_FILES=$(lsof -Fn -u fedora | wc -l)
            while [ $(lsof -Fn -u fedora | wc -l) -gt 3000 ]; do
                sleep 1
            done
            URL="$FEDORA_HOST:$FEDORA_PORT/$FEDORAGSEARCH_LOC/rest?operation=updateIndex&action=fromPid&value=$pid"
            (curl -s -m 15 -u $FEDORA_USER:$FEDORA_PASS $URL 2>&1 > /dev/null && echo "Indexed $pid") &
            ((i++))
        done <$MISSING_PIDS
    )
}

function main() {
    query_ri &
    query_solr &
    wait
    optimize_index &
    diff_pids &
    wait
    index_missing
    wait
}
main


