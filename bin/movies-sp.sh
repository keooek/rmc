#!/bin/bash -xv

#Proteger que se lanzen simultaneamente varias ejecuciones
pids_old=`ps ax |grep "/filebot.sh"|grep -v grep | grep -v $$ | awk '{print $1}'`
if [ -n "$pids_old" ]; then
#kill $pids_old
 echo "Proceso filebot.sh en ejecucion"
 exit 0
fi

date_str="$(date +%Y%m%d-%H_%M_%S)"
filebot.sh -r -rename "$rmc_base_hd_input/MOVIES-SP" -non-strict --conflict override --db TheMovieDB --lang es --output "$rmc_base_hd_video/MOVIES-SP" --log all --log-file $rmc_logs/moviessp_rename_${date_str}.txt
filebot.sh -r -script fn:cleaner "$rmc_base_hd_input/MOVIES-SP" --log all --log-file $rmc_logs/moviessp_clean_$(date +%Y%m%d-%H_%M_%S).txt
filebot.sh -r -script fn:cleaner "$rmc_base_hd_video/MOVIES-SP" --log all --log-file $rmc_logs/moviessp_clean_$(date +%Y%m%d-%H_%M_%S).txt
rm $rmc_base_hd_video/MOVIES-SP/{*.sub,*.srt,*.url,*.idx,*.nfo,*.rar}
#filebot.sh -script fn:artwork.tmdb "$rmc_base_hd_video/MOVIES-SP"
lsA="$(ls -A $rmc_base_hd_input/SKIPPED)"
( egrep -i '(MOVE|Skipped)' $rmc_logs/moviessp_rename_${date_str}.txt; echo "SKIPPED"; ls -1rt $rmc_base_hd_input/SKIPPED; ) | mail -s "$(egrep -i '(MOVE|Skipped)' $rmc_logs/moviessp_rename_${date_str}.txt| wc -l)-$([[ $lsA ]] && echo "SK-")MV-SP $(basename "$j")" $rmc_notify_mail
mv $rmc_base_hd_input/MOVIES-SP/* $rmc_base_hd_input/SKIPPED
if [[ "$(grep MOVE $rmc_logs/moviessp_rename_${date_str}.txt)" == *MOVE* ]] ; then
 curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://$rmc_kodi_ip/jsonrpc
fi
