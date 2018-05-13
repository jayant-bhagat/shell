#!/bin/bash
# Before wrting this script you must have knowladge of creating svn server and process.
# Going through root folder creating svn repo $svn_project_name
cd /root/kk
# To check if svn Dir already exists, "exit 1" has been used such that if it exist then build will be fail
if [ -d "$svn_project_name" ]; then
 echo " Svn Repo Name Already Exists , Please Enter Unic Name"
 exit 1  
 else
svnadmin create $svn_project_name
 fi
# To check if userpermission file already exist, "exit 1" has been used such that if it exist then build will be fail
cd /root/pp
if [ -f "$svn_project_name" ]; then
 echo " Svn permission file already exit , Please Enter Unic Name"
 exit 1  
 else
touch $svn_project_name
 fi
# Creating same file name as svn_project_name to provide user permission.
echo '[/]' > /root/pp/$svn_project_name

set -x
OLD_IFS="$IFS"
IFS=$'\n'
for line in $user_name; do
echo "$line" = rw >> /root/pp/$svn_project_name
done
IFS="$OLD_IFS"
