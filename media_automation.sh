#!/bin/bash -xv

#Proteger que se lanzen simultaneamente varias ejecuciones
#echo "Pid proceso: $$ $PPID"
##echo "$(ps -ef)"
#pids_old=`ps ax |grep "/media_automation.sh"|grep -v grep | grep -v $$ |grep -v $PPID | awk '{print $1}'`
#if [ -n "$pids_old" ]; then
##kill $pids_old
# echo "Proceso media_automation.sh en ejecucion"
# exit 0
#fi


#Clean ttorrent queue if all torrents are finished, not when playing kodi
#[[ $(find /media/data/data/hu.tagsoft.ttorrent.pro/shared_prefs -size +120c -name torrents.xml) && (! $(grep "is_finished&quot;:false" /media/data/data/hu.tagsoft.ttorrent.pro/shared_prefs/torrents.xml)) && (! $(ps -ef |egrep -i '(kodi|videoplayer)'|grep -v grep)) ]] && (/home/pi/bin/clean_ttorrent_queue.sh; rm /media/data/data/hu.tagsoft.ttorrent.pro/files/*fastresume)

#Reorg downloaded mixed torrents in ALL y AMULE folder
#TVShows EN
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*[sS][0-3][0-9][eE][0-3][0-9].*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/TVSHOWS-EN \;
#Books
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*mobi' -o -regex '.*epub' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/BOOKS \;
#XXX
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*\(XXX\|xxx\|anal\|Porno\|porno\|DAP|\Anal\).*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/OTHERS \;
#MP3
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*\(MP3\|mp3\).*' ! -name "*.avi" ! -name "*.mkv" -exec mv -vf {} /media/MULTIMEDIA/TORRENT/MP3 \;
#PS3
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*\(PS3\|ps3\).*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/PS3 \;
#TVShows SP
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*[0-2]?[0-9]x[0-2][0-9].*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/TVSHOWS-SP \;
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*[Cc]ap.*[^0-9][0-9]x?[0-2][0-9][^0-9].*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/TVSHOWS-SP \;
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*[^0-9][0-9]x*[0-2][0-9][^0-9].*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/TVSHOWS-SP \;
#find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*[^0-9][0-9]x?[0-2][0-9][^0-9].*' -exec mv {} /media/MULTIMEDIA/TORRENT/TVSHOWS-SP \;
#find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*emporada.*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/TVSHOWS-SP \;
#TVShows EN
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*S[0-3][0-9]E[0-3][0-9].*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/TVSHOWS-EN \;
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*eason.*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/TVSHOWS-EN \;
#Movies ES
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*\(panish\|astellano\|spa.ol\|PANISH\|ASTELLANO\|SPA.OL\).*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/MOVIES-SP \;
#Movies EN
find /media/MULTIMEDIA/TORRENT/ALL /media/MULTIMEDIA/AMULE -maxdepth 1 -regex '.*\(1080p\|720p\).*' -exec mv -vf {} /media/MULTIMEDIA/TORRENT/MOVIES-EN \;
#If not match move to SKIPPED
mv -vf /media/MULTIMEDIA/AMULE/* /media/MULTIMEDIA/TORRENT/SKIPPED
mv -vf /media/MULTIMEDIA/TORRENT/ALL/* /media/MULTIMEDIA/TORRENT/SKIPPED

#Filebot processing
[[ $(find /media/MULTIMEDIA/TORRENT/TVSHOWS-EN -type f -size +100M) ]] && /home/pi/bin/tvshows-en.sh
[[ $(find /media/MULTIMEDIA/TORRENT/MOVIES-EN -type f -size +150M) ]] && /home/pi/bin/movies-en.sh
[[ $(find /media/MULTIMEDIA/TORRENT/TVSHOWS-SP -type f -size +100M) ]] && /home/pi/bin/tvshows-sp.sh
[[ $(find /media/MULTIMEDIA/TORRENT/MOVIES-SP -type f -size +150M) ]] && /home/pi/bin/movies-sp.sh
[[ $(find /media/MULTIMEDIA/TORRENT/BOOKS -type f -size -20M ) ]] && /home/pi/bin/books.sh
#[[ $(find /media/MULTIMEDIA/TORRENT/BOOKS -type f -mmin +10 -size -20M ) ]] && /home/pi/bin/books.sh
#[[ $(ls -A /media/MULTIMEDIA/TORRENT/MOVIES-SP ) || $(ls -A /media/MULTIMEDIA/AMULE ) ]] && /home/pi/bin/movies-sp.sh

find /home/pi/bin/log -type f -mtime +5 -exec rm {} \;
find /home/pi/.flexget/log -mtime +15 -exec rm {} \;

#flexget series forget "The Strain"

#Delete old lock files flexget
find /home/pi/.flexget/ -name ".config-sp-lock" -mmin +100 -exec rm -f {} \;
find /home/pi/.flexget/ -name ".config-en-lock" -mmin +100 -exec rm -f {} \;

#Copy youtube videos
find ~pi -maxdepth 1 -name "*mp4" -exec mv -v {} /media/MULTIMEDIA/VIDEO/YOUTUBE-MUSIC \;
find ~pi -maxdepth 1 -name "*webm" -exec mv -v {} /media/MULTIMEDIA/VIDEO/YOUTUBE-MUSIC \;
sudo chown pi:pi ~yola/*mp4 ~yola/*webm
sudo find ~yola -maxdepth 1 -name "*mp4" -exec mv -v {} /media/MULTIMEDIA/VIDEO/YOUTUBE-MUSIC \;
sudo find ~yola -maxdepth 1 -name "*webm" -exec mv -v {} /media/MULTIMEDIA/VIDEO/YOUTUBE-MUSIC \;

exit 0
