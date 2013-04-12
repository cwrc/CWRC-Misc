# export from a given source fedora repository all
# Objects in the given list of PIDs
# and migrate into the specificed destination Fedora repository
#
#Steps
#
# 1. determine PID of the collection you want to migrate
# 2. use "fedora/risearch" to output a list of PIDs
# ------------------------
# language = itql; response: CSV; limit: unlimited
# list the PIDs within the given collection and the collection PID
#
# select $identifier from <#ri>
# where (
#  $object <dc:identifier> $identifier
#  and
#  (
#    $object <fedora-rels-ext:isMemberOfCollection>
#      <info:fedora/COLLECTION:PID>
#    or
#    $object <dc:identifier>
#      'COLLECTION:PID'
#  )
#  and
#  $object <fedora-model:state>
#    <info:fedora/fedora-system:def/model#Active>
#)
#order by $identifier
#
# --------------------
#
# 3. create a CSV file from #2, one PID per line (delete "doi:", "uri:", and not PIDs
# 4. run this file
#
# May need to enable firewall - if managed datastream
# the target contacts the source to get the contents of
# a managed datastream
# E.G. http://cwrc-apps-06.srv.ualberta.ca:8080/fedora/get/islandora:a9014e9f-d796-4219-8717-3c1e949c5e81/TN/2012-09-24T18:32:11.048Z 
# Look in the fedora.log file for errors
# - Caused by: org.fcrepo.server.errors.GeneralException: Error getting
# - Caused by: java.net.NoRouteToHostException: No route to host
# sudo iptables --insert INPUT 11  -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT -s cwrc-apps-09.srv.ualberta.ca
#
# Or disable API-A authentication as ingest of managed datastreams
# does seem to us the credentials to access the source server
#
# FEDORA_HOME/server/config/spring/web/web.properties
# ==> security.fesl.authN.jaas.apia.enabled=true
# change to false
#
# E.g. fedora.log
# - Caused by: java.io.IOException: Request failed [401 Unauthorized] 
#


base_bin=/data/opt/fedora/client/bin
export FEDORA_HOME=/data/opt/fedora


echo enter PID list file name
read fedora_pid_list_fn 

echo "enter SOURCE repository [localhost:8080]"
read fedora_src_repo_name

read -p "username: " fedora_src_repo_user                                    
 
read -s -p "password: " fedora_src_repo_password
echo ''

echo enter DESTINATION repository 
read fedora_dest_repo_name

read -p "username: " fedora_dest_repo_user                                    
 
read -s -p "password: " fedora_dest_repo_password
echo ''


echo "Are you sure want to write to \"$fedora_dest_repo_name\" [Y/N]?"
read a
if [[ $a != "Y" && $a != "y" ]]; then
    echo "quit";
    exit 1;
fi


while read line
do
    echo -e "$line"
    #https://wiki.duraspace.org/display/FEDORA35/fedora-ingest
    # fedora-ingest r $fedora_src_repo_name $fedora_src_repo_user $fedora_src_repo_password $line $fedora_dest_repo_name $fedora_dest_repo_user $fedora_dest_repo_password https https 
    # /data/opt/fedora/client/bin/fedora-export.sh localhost:8080 fedoraAdmin dfZSG4gJAqABbdf55BEBVQ islandora:4ae6cb3e-9ac3-48a3-9078-9c12ec29227f  info:fedora/fedora-system:FOXML-1.1  migrate tmp/ http fedora
    tmp="$base_bin/fedora-ingest.sh r $fedora_src_repo_name $fedora_src_repo_user $fedora_src_repo_password $line $fedora_dest_repo_name $fedora_dest_repo_user $fedora_dest_repo_password http http "
    #echo $tmp
    $tmp
done < $fedora_pid_list_fn 
