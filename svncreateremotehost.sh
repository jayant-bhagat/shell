#!/bin/bash

cd /root/kk
if [ -d "$svn_project_name" ]; then
 echo " Svn Repo Name Already Exists , Please Enter Unic Name"
 exit 1  
 else
svnadmin create $svn_project_name
 fi

cd /root/pp
if [ -f "$svn_project_name" ]; then
 echo " Svn permission file already exit , Please Enter Unic Name"
 exit 1  
 else
touch $svn_project_name
 fi
echo '[/]' > /root/pp/$svn_project_name
set -x
OLD_IFS="$IFS"
IFS=$'\n'
for line in $user_name; do
echo "$line" = rw >> /root/pp/$svn_project_name
done
IFS="$OLD_IFS"
