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
for j in $(find /media/MULTIMEDIA/TORRENT/TVSHOWS-EN -type f -size +100M) ; do
 cd /opt/share/filebot/bin; ./filebot.sh -non-strict --log all --log-file /home/pi/bin/log/tvshowsen_rename_${date_str}.txt --lang en --format "/media/MULTIMEDIA/VIDEO/TVSHOWS-EN/{n}/T{s}/{n}-{s00e00}-{t}" -rename "$j" --conflict override --db TheTVDB
done
unset IFS
# if [[ "$(grep MOVE /home/pi/bin/log/tvshowsen_rename_${date_str}.txt)" == *MOVE* ]] ; then

cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "/media/MULTIMEDIA/TORRENT/TVSHOWS-EN" --log all --log-file /home/pi/bin/log/tvshowsen_clean_$(date +%Y%m%d-%H_%M_%S).txt
cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "/media/MULTIMEDIA/VIDEO/TVSHOWS-EN" --log all --log-file /home/pi/bin/log/tvshowsen_clean_library_$(date +%Y%m%d-%H_%M_%S).txt
#mv /media/MULTIMEDIA/TORRENT/TVSHOWS-EN/* /media/MULTIMEDIA/TORRENT/SKIPPED
lsA="$(ls -A /media/MULTIMEDIA/TORRENT/SKIPPED)"
( egrep -i '(MOVE|Skipped)' /home/pi/bin/log/tvshowsen_rename_${date_str}.txt; echo "SKIPPED"; ls -1rt /media/MULTIMEDIA/TORRENT/SKIPPED; ) | mail -s "$(egrep -i '(MOVE|Skipped)' /home/pi/bin/log/tvshowsen_rename_${date_str}.txt| wc -l)-$([[ $lsA ]] && echo "SK-")TV-EN $(basename "$j")" casape.tv1@gmail.com
#cd /opt/share/filebot/bin; ./filebot.sh -get-missing-subtitles --lang en --log all --log-file /home/pi/bin/log/tvshowsen_subs_$(date +%Y%m%d-%H_%M_%S).txt /media/MULTIMEDIA/VIDEO/TVSHOWS-EN/Justified/T6/
mv /media/MULTIMEDIA/TORRENT/TVSHOWS-EN/* /media/MULTIMEDIA/TORRENT/SKIPPED/
if [[ "$(grep MOVE /home/pi/bin/log/tvshowsen_rename_${date_str}.txt)" == *MOVE* ]] ; then
 curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://192.168.1.7:8080/jsonrpc
fi
