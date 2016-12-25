#!/bin/bash -xv

#Proteger que se lanzen simultaneamente varias ejecuciones
pids_old=`ps ax |grep "/filebot.sh"|grep -v grep | grep -v $$ | awk '{print $1}'`
if [ -n "$pids_old" ]; then
#kill $pids_old
 echo "Proceso filebot.sh en ejecucion"
 exit 0
fi

date_str="$(date +%Y%m%d-%H_%M_%S)"
cd /opt/share/filebot/bin; ./filebot.sh -r -rename "/media/MULTIMEDIA/TORRENT/MOVIES-EN" -non-strict --conflict override --db TheMovieDB --lang en --output "/media/MULTIMEDIA/VIDEO/MOVIES-EN" --log all --log-file /home/pi/bin/log/moviesen_rename_${date_str}.txt
cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "/media/MULTIMEDIA/TORRENT/MOVIES-EN" --log all --log-file /home/pi/bin/log/moviesen_clean_$(date +%Y%m%d-%H_%M_%S).txt
cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "/media/MULTIMEDIA/VIDEO/MOVIES-EN" --log all --log-file /home/pi/bin/log/moviesen_clean_$(date +%Y%m%d-%H_%M_%S).txt
rm /media/MULTIMEDIA/VIDEO/MOVIES--EN/{*.sub,*.srt,*.url,*.idx,*.nfo,*.rar}
#cd /opt/share/filebot/bin; ./filebot.sh -script fn:artwork.tmdb "/media/MULTIMEDIA/VIDEO/MOVIES-EN"
lsA="$(ls -A /media/MULTIMEDIA/TORRENT/SKIPPED)"
( egrep -i '(MOVE|Skipped)' /home/pi/bin/log/moviesen_rename_${date_str}.txt; echo "SKIPPED"; ls -1rt /media/MULTIMEDIA/TORRENT/SKIPPED; ) | mail -s "$(egrep -i '(MOVE|Skipped)' /home/pi/bin/log/moviesen_rename_${date_str}.txt| wc -l)-$([[ $lsA ]] && echo "SK-")MV-EN $(basename "$j")" casape.tv1@gmail.com
mv /media/MULTIMEDIA/TORRENT/MOVIES-EN/* /media/MULTIMEDIA/TORRENT/SKIPPED
if [[ "$(grep MOVE /home/pi/bin/log/moviesen_rename_${date_str}.txt)" == *MOVE* ]] ; then
 curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://192.168.1.7:8080/jsonrpc
fi
