# import from a given source fedora repository all
# Objects in the given directory
#
#Steps
#
# 1. Run: fedora-archive-export-by-list.sh
#
# 2. use the output directory as input to this script
#
# may need to create the directory for the logfile:
#  $FEDORA_HOME/client/logs/

base_bin=/usr/local/fedora/client/bin
export FEDORA_HOME=/usr/local/fedora


echo enter SOURCE directory
read source_dir


echo "enter DESTINATION repository [localhost:8080]"
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


echo -e "$line"
#https://wiki.duraspace.org/display/FEDORA35/fedora-ingest
# fedora-ingest r $fedora_src_repo_name $fedora_src_repo_user $fedora_src_repo_password $line $fedora_dest_repo_name $fedora_dest_repo_user $fedora_dest_repo_password https https
# /data/opt/fedora/client/bin/fedora-export.sh localhost:8080 fedoraAdmin dfZSG4gJAqABbdf55BEBVQ islandora:4ae6cb3e-9ac3-48a3-9078-9c12ec29227f  info:fedora/fedora-system:FOXML-1.1  migrate tmp/ http fedora

tmp="$base_bin/fedora-ingest.sh dir $source_dir info:fedora/fedora-system:FOXML-1.1 $fedora_dest_repo_name $fedora_dest_repo_user $fedora_dest_repo_password http '' "

echo $tmp
$tmp

