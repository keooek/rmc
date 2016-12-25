#!/bin/bash -xv

base="/home/pi/bin"
sqlite3 ~/.kodi/userdata/Database/MyVideos93.db "select episode.c18 from episode, files where episode.idFile = files.idFile and files.playcount not null order by episode.c18;" > $base/tvshows_delete.tmp
grep "TVSHOWS-SP" $base/tvshows_delete.tmp | grep -i -v -f $base/tvshows_sp_not_delete.txt > $base/tvshows_delete.final
grep "TVSHOWS-EN" $base/tvshows_delete.tmp | grep -i -v -f $base/tvshows_en_not_delete.txt >> $base/tvshows_delete.final
while read line ; do
 rm -f "$line"
done < $base/tvshows_delete.final
