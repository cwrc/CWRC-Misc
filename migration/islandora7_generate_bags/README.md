# Bulk download archive packages (aka. Bags) from Islandora 7

## To run

- set env variables
  - BAG_SERVER: Islandora 7 server FQDN
  - DATA_HOME: find lists of IDs to process and dump resulting archival packages (bags)
  - DUMP_DIR: sub idrectory to output archvie packages (bags)
  - AUTH_TOKEN: path to the stored authenication token

- acquire an auth token from Islandora
  - `curl -i -H "Content-type: application/json" -c ${AUTH_TOKEN} -X POST  -d '{"username":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx","password":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"}' ${BAG_SERVER}/rest/user/login`

- acquire list of ID's and store in the `list` directory. The `DUMP_DIR` must match the filename of the list of PIDs

- run `get_bag.sh` to read the `list\$DUMP_DIR}` file and create a new directory named ${DUMP_DIR} that contains the resulting archival package for each ID in the list

