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
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*[sS][0-3][0-9][eE][0-3][0-9].*' -exec mv -vf {} $rmc_base_hd_input/TVSHOWS-EN \;
#Books
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*mobi' -o -regex '.*epub' -exec mv -vf {} $rmc_base_hd_input/BOOKS \;
#Custom
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*\($rmc_sed_others_filter\).*' -exec mv -vf {} $rmc_base_hd_input/OTHERS \;
#Audio
cd $rmc_base_hd_input/ALL/ ; rename 'y/A-Z/a-z/' *.RAR *.ZIP
for z in $(ls -1t $rmc_base_hd_input/ALL/*.rar 2> /dev/null|grep -v ":") ; do
 if [ ! -z $(unrar lt $rmc_base_hd_input/ALL/$z | egrep -i '(.mp3|.MP3)' ) ] ; then
  mkdir -p $rmc_base_hd_audio/$(basename $z)
  unrar x $rmc_base_hd_input/ALL/$z $rmc_base_hd_audio/$(basename $z)
  # If directory created has only one subdirectory and no other content, move the content one level before
  if [ "$(find $rmc_base_hd_audio/$(basename $z) -maxdepth 1 -type d -printf 1 | wc -m)" -eq 2 -a "$(find $rmc_base_hd_audio/$(basename $z) -maxdepth 1 ! -type d -printf 1 | wc -m)" -eq 0 ]; then
   mv $rmc_base_hd_audio/$(basename $z)/* $rmc_base_hd_audio
   #rm -rf $rmc_base_hd_audio/$(basename $z)/
  fi
 fi
done
for y in $(ls -1t $rmc_base_hd_input/ALL/*.zip 2> /dev/null|grep -v ":") ; do
 if [ ! -z $(unzip -l $rmc_base_hd_input/ALL/$y | egrep -i '(.mp3|.MP3)' ) ] ; then
  mkdir -p $rmc_base_hd_audio/$(basename $y)
  unzip $rmc_base_hd_input/ALL/$y -d $rmc_base_hd_audio/$(basename $y)
  # If directory created has only one subdirectory and no other content, move the content one level before
  if [ "$(find $rmc_base_hd_audio/$(basename $y) -maxdepth 1 -type d -printf 1 | wc -m)" -eq 2 -a "$(find $rmc_base_hd_audio/$(basename $y) -maxdepth 1 ! -type d -printf 1 | wc -m)" -eq 0 ]; then
   mv $rmc_base_hd_audio/$(basename $y)/* $rmc_base_hd_audio
   #rm -rf $rmc_base_hd_audio/$(basename $y)/
  fi
 fi
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*\(MP3\|mp3\).*' ! -name "*.avi" ! -name "*.mkv" -exec mv -vf {} $rmc_base_hd_input/AUDIO \;
done
#PS3
find $rmc_base_hd_input/ALL -maxdepth 1 -regex '.*\(PS3\|ps3\).*' -exec mv -vf {} $rmc_base_hd_input/PS3 \;
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
[[ $(find $rmc_base_hd_input/BOOKS -type f -size -20M ) ]] && $rmc_base/bin/books.sh

find $rmc_logs -type f -mtime +60 -exec rm {} \;

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
