#!/bin/bash -xv
cd $base ; cp templates/transmission_settings.json.template etc/transmission_settings.json
env|grep "rmc_"|sed 's/rmc_//' > tmp/trans.tmp
while read line ; do
 escaped_tmp=$(echo $line | cut -d'=' -f2)
 echo $escaped_tmp
 escaped=$(echo $escaped_tmp|sed 's/\//\\\//g')
 echo $escaped
 sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" etc/transmission_settings.json
done < tmp/trans.tmp

