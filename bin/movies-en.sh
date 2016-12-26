#!/bin/bash -xv

#Proteger que se lanzen simultaneamente varias ejecuciones
pids_old=`ps ax |grep "/filebot.sh"|grep -v grep | grep -v $$ | awk '{print $1}'`
if [ -n "$pids_old" ]; then
#kill $pids_old
 echo "Proceso filebot.sh en ejecucion"
 exit 0
fi

date_str="$(date +%Y%m%d-%H_%M_%S)"
cd /opt/share/filebot/bin; ./filebot.sh -r -rename "$base_hd_input/MOVIES-EN" -non-strict --conflict override --db TheMovieDB --lang en --output "$base_hd_output/MOVIES-EN" --log all --log-file $logs/moviesen_rename_${date_str}.txt
cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "$base_hd_input/MOVIES-EN" --log all --log-file $logs/moviesen_clean_$(date +%Y%m%d-%H_%M_%S).txt
cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "$base_hd_output/MOVIES-EN" --log all --log-file $logs/moviesen_clean_$(date +%Y%m%d-%H_%M_%S).txt
rm $base_hd_output/MOVIES--EN/{*.sub,*.srt,*.url,*.idx,*.nfo,*.rar}
#cd /opt/share/filebot/bin; ./filebot.sh -script fn:artwork.tmdb "$base_hd_output/MOVIES-EN"
lsA="$(ls -A $base_hd_input/SKIPPED)"
( egrep -i '(MOVE|Skipped)' $logs/moviesen_rename_${date_str}.txt; echo "SKIPPED"; ls -1rt $base_hd_input/SKIPPED; ) | mail -s "$(egrep -i '(MOVE|Skipped)' $logs/moviesen_rename_${date_str}.txt| wc -l)-$([[ $lsA ]] && echo "SK-")MV-EN $(basename "$j")" $notify_mail
mv $base_hd_input/MOVIES-EN/* $base_hd_input/SKIPPED
if [[ "$(grep MOVE $logs/moviesen_rename_${date_str}.txt)" == *MOVE* ]] ; then
 curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://$kodi_ip/jsonrpc
fi