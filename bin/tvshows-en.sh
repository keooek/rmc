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
for j in $(find $base_hd_input/TVSHOWS-EN -type f -size +100M) ; do
 cd /opt/share/filebot/bin; ./filebot.sh -non-strict --log all --log-file $logs/tvshowsen_rename_${date_str}.txt --lang en --format "$base_hd_output/TVSHOWS-EN/{n}/T{s}/{n}-{s00e00}-{t}" -rename "$j" --conflict override --db TheTVDB
done
unset IFS
# if [[ "$(grep MOVE $logs/tvshowsen_rename_${date_str}.txt)" == *MOVE* ]] ; then

cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "$base_hd_input/TVSHOWS-EN" --log all --log-file $logs/tvshowsen_clean_$(date +%Y%m%d-%H_%M_%S).txt
cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "$base_hd_output/TVSHOWS-EN" --log all --log-file $logs/tvshowsen_clean_library_$(date +%Y%m%d-%H_%M_%S).txt
#mv $base_hd_input/TVSHOWS-EN/* $base_hd_input/SKIPPED
lsA="$(ls -A $base_hd_input/SKIPPED)"
( egrep -i '(MOVE|Skipped)' $logs/tvshowsen_rename_${date_str}.txt; echo "SKIPPED"; ls -1rt $base_hd_input/SKIPPED; ) | mail -s "$(egrep -i '(MOVE|Skipped)' $logs/tvshowsen_rename_${date_str}.txt| wc -l)-$([[ $lsA ]] && echo "SK-")TV-EN $(basename "$j")" $notify_mail
#cd /opt/share/filebot/bin; ./filebot.sh -get-missing-subtitles --lang en --log all --log-file $logs/tvshowsen_subs_$(date +%Y%m%d-%H_%M_%S).txt $base_hd_output/TVSHOWS-EN/Justified/T6/
mv $base_hd_input/TVSHOWS-EN/* $base_hd_input/SKIPPED/
if [[ "$(grep MOVE $logs/tvshowsen_rename_${date_str}.txt)" == *MOVE* ]] ; then
 curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://192.168.1.7:8080/jsonrpc
fi
