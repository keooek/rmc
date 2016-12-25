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
for j in $(find /media/MULTIMEDIA/TORRENT/TVSHOWS-SP -type f -size +100M) ; do
 cd /opt/share/filebot/bin; ./filebot.sh -non-strict --log all --log-file /home/pi/bin/log/tvshowssp_rename_${date_str}.txt --lang es --format "/media/MULTIMEDIA/VIDEO/TVSHOWS-SP/{n}/T{s}/{n}-{s00e00}-{t}" -rename "$j" --conflict override --db TheTVDB -non-strict
done
unset IFS

cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "/media/MULTIMEDIA/TORRENT/TVSHOWS-SP" --log all --log-file /home/pi/bin/log/tvshowssp_clean_torrent_$(date +%Y%m%d-%H_%M_%S).txt
cd /opt/share/filebot/bin; ./filebot.sh -r -script fn:cleaner "/media/MULTIMEDIA/VIDEO/TVSHOWS-SP" --log all --log-file /home/pi/bin/log/tvshowssp_clean_library_$(date +%Y%m%d-%H_%M_%S).txt
lsA="$(ls -A /media/MULTIMEDIA/TORRENT/SKIPPED)"
( egrep -i '(MOVE|Skipped)' /home/pi/bin/log/tvshowssp_rename_${date_str}.txt; echo "SKIPPED"; ls -1rt /media/MULTIMEDIA/TORRENT/SKIPPED; ) | mail -s "$(egrep -i '(MOVE|Skipped)' /home/pi/bin/log/tvshowssp_rename_${date_str}.txt| wc -l)-$([[ $lsA ]] && echo "SK-")TV-SP $(basename "$j")" casape.tv1@gmail.com
mv /media/MULTIMEDIA/TORRENT/TVSHOWS-SP/* /media/MULTIMEDIA/TORRENT/SKIPPED

if [[ "$(grep MOVE /home/pi/bin/log/tvshowssp_rename_${date_str}.txt)" == *MOVE* ]] ; then
 curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://192.168.1.7:8080/jsonrpc
fi
