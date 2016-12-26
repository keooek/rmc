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


#Reorg downloaded mixed torrents in ALL y AMULE folder
#TVShows EN
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*[sS][0-3][0-9][eE][0-3][0-9].*' -exec mv -vf {} $base_hd_input/TVSHOWS-EN \;
#Books
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*mobi' -o -regex '.*epub' -exec mv -vf {} $base_hd_input/BOOKS \;
#Custom
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*\($others_filter\).*' -exec mv -vf {} $base_hd_input/OTHERS \;
#MP3
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*\(MP3\|mp3\).*' ! -name "*.avi" ! -name "*.mkv" -exec mv -vf {} $base_hd_input/MP3 \;
#PS3
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*\(PS3\|ps3\).*' -exec mv -vf {} $base_hd_input/PS3 \;
#TVShows SP
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*[0-2]?[0-9]x[0-2][0-9].*' -exec mv -vf {} $base_hd_input/TVSHOWS-SP \;
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*[Cc]ap.*[^0-9][0-9]x?[0-2][0-9][^0-9].*' -exec mv -vf {} $base_hd_input/TVSHOWS-SP \;
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*[^0-9][0-9]x*[0-2][0-9][^0-9].*' -exec mv -vf {} $base_hd_input/TVSHOWS-SP \;
#find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*[^0-9][0-9]x?[0-2][0-9][^0-9].*' -exec mv {} $base_hd_input/TVSHOWS-SP \;
#find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*emporada.*' -exec mv -vf {} $base_hd_input/TVSHOWS-SP \;
#TVShows EN
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*S[0-3][0-9]E[0-3][0-9].*' -exec mv -vf {} $base_hd_input/TVSHOWS-EN \;
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*eason.*' -exec mv -vf {} $base_hd_input/TVSHOWS-EN \;
#Movies ES
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*\(panish\|astellano\|spa.ol\|PANISH\|ASTELLANO\|SPA.OL\).*' -exec mv -vf {} $base_hd_input/MOVIES-SP \;
#Movies EN
find $base_hd_input/ALL $base_hd_input/AMULE -maxdepth 1 -regex '.*\(1080p\|720p\).*' -exec mv -vf {} $base_hd_input/MOVIES-EN \;
#If not match move to SKIPPED
mv -vf $base_hd_input/AMULE/* $base_hd_input/SKIPPED
mv -vf $base_hd_input/ALL/* $base_hd_input/SKIPPED

#Filebot processing
[[ $(find $base_hd_input/TVSHOWS-EN -type f -size +100M) ]] && $base_bin/tvshows-en.sh
[[ $(find $base_hd_input/MOVIES-EN -type f -size +150M) ]] && $base_bin/movies-en.sh
[[ $(find $base_hd_input/TVSHOWS-SP -type f -size +100M) ]] && $base_bin/tvshows-sp.sh
[[ $(find $base_hd_input/MOVIES-SP -type f -size +150M) ]] && $base_bin/movies-sp.sh
[[ $(find $base_hd_input/BOOKS -type f -size -20M ) ]] && $base_bin/books.sh
#[[ $(find $base_hd_input/BOOKS -type f -mmin +10 -size -20M ) ]] && $base_bin/books.sh
#[[ $(ls -A $base_hd_input/MOVIES-SP ) || $(ls -A $base_hd_input/AMULE ) ]] && $base_bin/movies-sp.sh

find $logs -type f -mtime +5 -exec rm {} \;
find /home/pi/.flexget/log -mtime +15 -exec rm {} \;

#flexget series forget "The Strain"

#Delete old lock files flexget
find /home/pi/.flexget/ -name ".config-sp-lock" -mmin +100 -exec rm -f {} \;
find /home/pi/.flexget/ -name ".config-en-lock" -mmin +100 -exec rm -f {} \;

#Copy youtube videos
find ~pi -maxdepth 1 -name "*mp4" -exec mv -v {} $base_hd_output/YOUTUBE-MUSIC \;
find ~pi -maxdepth 1 -name "*webm" -exec mv -v {} $base_hd_output/YOUTUBE-MUSIC \;
sudo chown pi:pi ~yola/*mp4 ~yola/*webm
sudo find ~yola -maxdepth 1 -name "*mp4" -exec mv -v {} $base_hd_output/YOUTUBE-MUSIC \;
sudo find ~yola -maxdepth 1 -name "*webm" -exec mv -v {} $base_hd_output/YOUTUBE-MUSIC \;

exit 0
