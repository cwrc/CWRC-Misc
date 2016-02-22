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
# creates a new directory with exported Fedora Objects in 'archive' format
#


base_bin=/data/opt/fedora/client/bin
export FEDORA_HOME=/data/opt/fedora
dest_dir=/tmp/fedora_archive




echo "enter DESTINATION directory [/tmp/fedora_archive]"
read dest_dir 

echo enter PID list file name
read fedora_pid_list_fn 

echo "enter SOURCE repository [localhost:8080]"
read fedora_src_repo_name

read -p "username: " fedora_src_repo_user                                    
 
read -s -p "password: " fedora_src_repo_password
echo ''

echo "Are you sure want to write to \"$dest_dir\" [Y/N]?"
read a
if [[ $a != "Y" && $a != "y" ]]; then
    echo "quit";
    exit 1;
fi


if [[ ! -e $dest_dir ]]; then
    mkdir $dest_dir
fi


while read line
do
    echo -e "$line"
    #https://wiki.duraspace.org/display/FEDORA35/fedora-ingest
    # fedora-ingest r $fedora_src_repo_name $fedora_src_repo_user $fedora_src_repo_password $line $fedora_dest_repo_name $fedora_dest_repo_user $fedora_dest_repo_password https https 
    # /data/opt/fedora/client/bin/fedora-export.sh localhost:8080 fedoraAdmin dfZSG4gJAqABbdf55BEBVQ islandora:4ae6cb3e-9ac3-48a3-9078-9c12ec29227f  info:fedora/fedora-system:FOXML-1.1  migrate tmp/ http fedora
    tmp="$base_bin/fedora-export.sh $fedora_src_repo_name $fedora_src_repo_user $fedora_src_repo_password $line  info:fedora/fedora-system:FOXML-1.1  archive $dest_dir http fedora "
    echo $tmp
    $tmp
done < $fedora_pid_list_fn 
