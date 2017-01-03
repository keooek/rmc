#!/bin/bash -xv
# force JVM language and encoding settings
#export LANG="es_ES.UTF-8"
#export LC_ALL="es_ES.UTF-8"

#Proteger que se lanzen simultaneamente varias ejecuciones
pids_old=`ps ax |grep "/filebot.sh"|grep -v grep | grep -v $$ | awk '{print $1}'`
if [ -n "$pids_old" ]; then
#kill $pids_old
 echo "Proceso filebot.sh en ejecucion"
 exit 0
fi

IFS=$'\n'
date_str="$(date +%Y%m%d-%H_%M_%S)"
for j in $(find $rmc_base_hd_input/TVSHOWS-SP -type f -size +100M) ; do
 filebot.sh -non-strict --log all --log-file $rmc_logs/tvshowssp_rename_${date_str}.txt --lang es --format "$rmc_base_hd_video/TVSHOWS-SP/{n}/T{s}/{n}-{s00e00}-{t}" -rename "$j" --conflict override --db TheTVDB -non-strict
done
unset IFS

filebot.sh -r -script fn:cleaner "$rmc_base_hd_input/TVSHOWS-SP" --log all --log-file $rmc_logs/tvshowssp_clean_torrent_$(date +%Y%m%d-%H_%M_%S).txt
filebot.sh -r -script fn:cleaner "$rmc_base_hd_video/TVSHOWS-SP" --log all --log-file $rmc_logs/tvshowssp_clean_library_$(date +%Y%m%d-%H_%M_%S).txt
lsA="$(ls -A $rmc_base_hd_input/SKIPPED)"
( egrep -i '(MOVE|Skipped)' $rmc_logs/tvshowssp_rename_${date_str}.txt; echo "SKIPPED"; ls -1rt $rmc_base_hd_input/SKIPPED; ) | mail -s "$(egrep -i '(MOVE|Skipped)' $rmc_logs/tvshowssp_rename_${date_str}.txt| wc -l)-$([[ $lsA ]] && echo "SK-")TV-SP $(basename "$j")" $notify_mail
mv $rmc_base_hd_input/TVSHOWS-SP/* $rmc_base_hd_input/SKIPPED

if [[ "$(grep MOVE $rmc_logs/tvshowssp_rename_${date_str}.txt)" == *MOVE* ]] ; then
 curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://$rmc_kodi_ip/jsonrpc
fi
