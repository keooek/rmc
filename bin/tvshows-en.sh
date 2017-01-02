#!/bin/bash -xv

#Proteger que se lanzen simultaneamente varias ejecuciones
pids_old=`ps ax |grep "/filebot.sh"|grep -v grep | grep -v $$ | awk '{print $1}'`
if [ -n "$pids_old" ]; then
#kill $pids_old
 echo "Proceso filebot.sh en ejecucion"
 exit 0
fi

IFS=$'\n'
date_str="$(date +%Y%m%d-%H_%M_%S)"
for j in $(find $rmc_base_hd_input/TVSHOWS-EN -type f -size +100M) ; do
 filebot.sh -non-strict --log all --log-file $rmc_logs/tvshowsen_rename_${date_str}.txt --lang en --format "$rmc_base_hd_output/TVSHOWS-EN/{n}/T{s}/{n}-{s00e00}-{t}" -rename "$j" --conflict override --db TheTVDB
done
unset IFS

filebot.sh -r -script fn:cleaner "$rmc_base_hd_input/TVSHOWS-EN" --log all --log-file $rmc_logs/tvshowsen_clean_$(date +%Y%m%d-%H_%M_%S).txt
filebot.sh -r -script fn:cleaner "$rmc_base_hd_output/TVSHOWS-EN" --log all --log-file $rmc_logs/tvshowsen_clean_library_$(date +%Y%m%d-%H_%M_%S).txt
lsA="$(ls -A $rmc_base_hd_input/SKIPPED)"
( egrep -i '(MOVE|Skipped)' $rmc_logs/tvshowsen_rename_${date_str}.txt; echo "SKIPPED"; ls -1rt $rmc_base_hd_input/SKIPPED; ) | mail -s "$(egrep -i '(MOVE|Skipped)' $rmc_logs/tvshowsen_rename_${date_str}.txt| wc -l)-$([[ $lsA ]] && echo "SK-")TV-EN $(basename "$j")" $notify_mail
#cd /opt/share/filebot/bin; ./filebot.sh -get-missing-subtitles --lang en --log all --log-file $rmc_logs/tvshowsen_subs_$(date +%Y%m%d-%H_%M_%S).txt $rmc_base_hd_output/TVSHOWS-EN/Justified/T6/
mv $rmc_base_hd_input/TVSHOWS-EN/* $rmc_base_hd_input/SKIPPED/
if [[ "$(grep MOVE $rmc_logs/tvshowsen_rename_${date_str}.txt)" == *MOVE* ]] ; then
 curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://$rmc_kodi_ip/jsonrpc
fi
