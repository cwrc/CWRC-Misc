# purge from a given source fedora repository all
# Objects in the given list of PIDs
#
# create an input file as described in "fedora-export-by-list.sh"
#


base_bin=/data/opt/fedora/client/bin
export FEDORA_HOME=/data/opt/fedora


echo enter PID list file name
read fedora_pid_list_fn 

echo enter TARGET repository E.G "localhost:8080"
read fedora_target_repo_name


read -p "username: " fedora_target_repo_user
echo \n 

read -s -p "password: " fedora_target_repo_password
echo \n 



echo "Are you sure want to DELETE from \"$fedora_target_repo_name\" [Y/N]?"
read a
if [[ $a != "Y" && $a != "y" ]]; then
    echo "quit";
    exit 1;
fi


while read line
do
    echo -e "$line"
    #echo "$base_bin/fedora-purge.sh r $fedora_target_repo_name $fedora_target_repo_user $fedora_target_repo_password $line "
    tmp="$base_bin/fedora-purge.sh r $fedora_target_repo_name $fedora_target_repo_user $fedora_target_repo_password $line "
     $tmp
done < $fedora_pid_list_fn 
