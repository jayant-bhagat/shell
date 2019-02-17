#!/bin/bash

cat /var/log/apache2/access.log | awk '{print $1}' > ips.txt
uniq ips.txt > uniqips.txt
IPS=`cat uniqips.txt`
for i in $IPS
do
  echo "$i,`geoiplookup $i | cut -d "," -f2 | sed -e 's/^[\t]//'`" >> ipinfo.csv
done
