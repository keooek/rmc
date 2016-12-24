#!/bin/bash -xv

base="/home/pi/bin"
sqlite3 ~/.kodi/userdata/Database/MyVideos93.db "select episode.c18 from episode, files where episode.idFile = files.idFile and files.playcount not null order by episode.c18;" > $base/tvshows_delete.tmp
grep -i -v -f $base/tvshows_not_delete.txt $base/tvshows_delete.tmp > $base/tvshows_delete.final
while read line ; do
 rm -f "$line"
done < $base/tvshows_delete.final
