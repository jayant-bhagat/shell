#!/bin/bash

#read -p 'Enter the file name:' filename

#touch $filename

src="$1"
dest="$2"

echo " This is $src  folder you have entered and this is $dest  direcoty you have entered "

echo " if this is not please enter CTRL+C "

sleep 5


if [ $# -ne 2 ]
then

     echo "$(basename $0) dir1 dir2"
     exit
fi

if [ -d $src ]
then
     echo " Source Folder exist "
else
     echo " Source folder DIR1 not exist please recheck path"
 exit 1

fi

if [ -d "$dest" ]
then
     echo " Destination folder exist "
else
     echo " Destination folder DIR2 doesnot exist please recheck path"

fi

#for f in "$dest/*"

#do
# tFile="$src/$(basename $f)"

#    if [ -f $tFile ]

#   then
#   echo -n "File is same with 2nd Direcotory" 
#   else
##for j in $(find $src -type d -printf "%P\n" );do
#name=$(basename "$i")
##if [[ ! -e "$dest/$j" ]]; then
##echo $j not found in $dest directory
##fi
##done

for i in $(find $src -type f -printf "%P\n" );do
#name=$(basename "$i")
if [[ ! -e "$dest/$i" ]]; then
echo $i not found in $dest directory
fi
done

