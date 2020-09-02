# bulk download archival packages

cd ${DATA_HOME}
mkdir ${DUMP_DIR};
pushd .; 
cd ${DUMP_DIR}; 
while read line; do CMD="curl -sS -b ${AUTH_TOKEN} -O -J -X GET ${BAG_SERVER}/islandora/object/${line}/manage/bagit_extension"; eval ${CMD}; done < ../../lists/${DUMP_DIR}; 
popd;