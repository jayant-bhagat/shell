#!/bin/bash
# Starting of dbBackup..

year="$(date +"%Y")"

#month="$(date + "%B")"
day="$(date +"%A")"

month="$(date +"%B")"

name="$(date +"Date_%d_Time_%H_%M")"

datetime_var="$(date +"%d-%m-%y_%H_%M")"


truncate -s0 ~/.temp_dbbackup1.txt

truncate -s0 ~/.temp_dbbackup.txt

truncate -s0 ~/.temp_dbdirbackup.txt

ls /srv/svn > ~/.temp_dbbackup1.txt

sed -i -e "1d"  ~/.temp_dbbackup1.txt

mkdir -p /bkp/svndump/$year/$month/$name

while read line

 do #Reading ~/.temp_dbbackup1.txt line by line to get list of DBs available.
svnadmin dump /srv/svn/$line > /bkp/svndump/$year/$month/$name/$line.dump

gzip -v /bkp/svndump/$year/$month/$name/$line.dump

sleep 1

done <~/.temp_dbbackup1.txt

