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

cd $rmc_base_hd_input/ALL/ ; rename 's/ /_/g' *

#Reorg downloaded mixed torrents in ALL y AMULE folder
#Books
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*mobi' -o -regex '.*epub' -exec mv -vf {} $rmc_base_hd_input/BOOKS \;
#Custom
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*\($rmc_sed_others_filter\).*' -exec mv -vf {} $rmc_base_hd_input/OTHERS \;
#Audio
cd $rmc_base_hd_input/ALL/ ; rename 'y/A-Z/a-z/' *.RAR *.ZIP *.MP3 *.Mp3; rename 's/ /_/g' *.rar *.zip *.mp3
 ##Audio Rar files
for z in $(cd $rmc_base_hd_input/ALL/ ; ls -1t *.rar 2> /dev/null|grep -v ":") ; do
 mv $rmc_base_hd_input/ALL/$z $rmc_base_hd_input/AUDIO
 if [ "$(unrar lt "$rmc_base_hd_input/AUDIO/$z" | egrep -i '(.mp3|.MP3)'|wc -m)" -gt 0 ] ; then
  mkdir -p "$rmc_base_hd_input/AUDIO/$(basename $z .rar)"
  unrar x -y "$rmc_base_hd_input/AUDIO/$z" "$rmc_base_hd_input/AUDIO/$(basename $z .rar)"
  # If directory created has only one subdirectory and no other content, move the content one level before
  if [ "$(find "$rmc_base_hd_input/AUDIO/$(basename $z .rar)" -maxdepth 1 -type d -printf 1 | wc -m)" -eq 2 -a "$(find "$rmc_base_hd_input/AUDIO/$(basename $z .rar)" -maxdepth 1 ! -type d -printf 1 | wc -m)" -eq 0 ]; then
   mv "$rmc_base_hd_input/AUDIO/$(basename $z .rar)/*" $rmc_base_hd_input/AUDIO/ 
   #rm -rf "$rmc_base_hd_input/AUDIO/$(basename $z .rar)"
  fi
 fi
done
 ##Audio zip files
for y in $(cd $rmc_base_hd_input/ALL/ ; ls -1t *.zip 2> /dev/null|grep -v ":") ; do
 mv $rmc_base_hd_input/ALL/$z $rmc_base_hd_input/AUDIO
 if [ "$(unzip -l "$rmc_base_hd_input/AUDIO/$y" | egrep -i '(.mp3|.MP3)' )" -gt 0 ] ; then
  mkdir -p "$rmc_base_hd_input/AUDIO/$(basename $yi .zip)"
  unzip -o "$rmc_base_hd_input/AUDIO/$y" -d "$rmc_base_hd_input/AUDIO/$(basename $y .zip)"
  # If directory created has only one subdirectory and no other content, move the content one level before
  if [ "$(find "$rmc_base_hd_input/AUDIO/$(basename $y .zip)" -maxdepth 1 -type d -printf 1 | wc -m)" -eq 2 -a "$(find "$rmc_base_hd_input/AUDIO/$(basename $y .zip)" -maxdepth 1 ! -type d -printf 1 | wc -m)" -eq 0 ]; then
   mv "$rmc_base_hd_input/AUDIO/$(basename $z .zip)/*" $rmc_base_hd_input/AUDIO/
   #rm -rf "$rmc_base_hd_input/AUDIO/$(basename $y .zip)"
  fi
 fi
done
 ##Audio directories
for d in $(find $rmc_base_hd_input/ALL/ -mindepth 1 -maxdepth 1 -type d) ; do
 if [ "$(find "$d" -type f -name "*.mp3" -printf 1 | wc -m)" -gt 0 ]; then
   mv $d $rmc_base_hd_input/AUDIO/
 fi
done
 ##Audio files alone
find $rmc_base_hd_input/ALL -maxdepth 1 -name "*.mp3" -exec mv -vf {} $rmc_base_hd_input/AUDIO \;
#PS3
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*\(PS3\|ps3\).*' -exec mv -vf {} $rmc_base_hd_input/PS3 \;
#TVShows EN
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*[sS][0-3][0-9][eE][0-3][0-9].*' -exec mv -vf {} $rmc_base_hd_input/TVSHOWS-EN \;
#TVShows SP
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*[0-2]?[0-9]x[0-2][0-9].*' -exec mv -vf {} $rmc_base_hd_input/TVSHOWS-SP \;
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*[Cc]ap.*[^0-9][0-9]x?[0-2][0-9][^0-9].*' -exec mv -vf {} $rmc_base_hd_input/TVSHOWS-SP \;
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*[^0-9][0-9]x*[0-2][0-9][^0-9].*' -exec mv -vf {} $rmc_base_hd_input/TVSHOWS-SP \;
#find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*[^0-9][0-9]x?[0-2][0-9][^0-9].*' -exec mv {} $rmc_base_hd_input/TVSHOWS-SP \;
#find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*emporada.*' -exec mv -vf {} $rmc_base_hd_input/TVSHOWS-SP \;
#TVShows EN
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*S[0-3][0-9]E[0-3][0-9].*' -exec mv -vf {} $rmc_base_hd_input/TVSHOWS-EN \;
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*eason.*' -exec mv -vf {} $rmc_base_hd_input/TVSHOWS-EN \;
#Movies ES
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*\(panish\|astellano\|spa.ol\|PANISH\|ASTELLANO\|SPA.OL\).*' -exec mv -vf {} $rmc_base_hd_input/MOVIES-SP \;
#Movies EN
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*\(1080p\|720p\).*' -exec mv -vf {} $rmc_base_hd_input/MOVIES-EN \;
#If not match move to SKIPPED
mv -vf $rmc_base_hd_input/ALL/* $rmc_base_hd_input/SKIPPED

#Filebot processing
[[ $(find $rmc_base_hd_input/TVSHOWS-EN -type f -size +100M) ]] && $rmc_base/bin/tvshows-en.sh
[[ $(find $rmc_base_hd_input/MOVIES-EN -type f -size +150M) ]] && $rmc_base/bin/movies-en.sh
[[ $(find $rmc_base_hd_input/TVSHOWS-SP -type f -size +100M) ]] && $rmc_base/bin/tvshows-sp.sh
[[ $(find $rmc_base_hd_input/MOVIES-SP -type f -size +150M) ]] && $rmc_base/bin/movies-sp.sh
[[ $(find $rmc_base_hd_input/AUDIO -type f -size +1M) ]] && $rmc_base/bin/audio.sh
[[ $(find $rmc_base_hd_input/BOOKS -type f -size -20M ) ]] && $rmc_base/bin/books.sh

find $rmc_logs -type f -mtime +60 -exec rm {} \;
find $rmc_base_hd_input/AUDIO_PROCESSED -mtime +5 -exec rm -rf {} \;

#flexget series forget "The Strain"

#Delete old lock files flexget
find $rmc_base/sw/flexget/ -name ".config-sp-lock" -mmin +100 -exec rm -f {} \;
find $rmc_base/sw/flexget/ -name ".config-en-lock" -mmin +100 -exec rm -f {} \;

#Copy youtube videos
find ~pi -maxdepth 1 -name "*mp4" -exec mv -v {} $rmc_base_hd_video/YOUTUBE-MUSIC \;
find ~pi -maxdepth 1 -name "*webm" -exec mv -v {} $rmc_base_hd_video/YOUTUBE-MUSIC \;
sudo chown pi:pi ~yola/*mp4 ~yola/*webm
sudo find ~yola -maxdepth 1 -name "*mp4" -exec mv -v {} $rmc_base_hd_video/YOUTUBE-MUSIC \;
sudo find ~yola -maxdepth 1 -name "*webm" -exec mv -v {} $rmc_base_hd_video/YOUTUBE-MUSIC \;

exit 0
