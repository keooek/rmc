#!/bin/bash -xv

sqlite3 ~/.kodi/userdata/Database/MyVideos93.db "select episode.c18 from episode, files where episode.idFile = files.idFile and files.playcount not null order by episode.c18;" > $base_tmp/tvshows_delete.tmp
grep -i -v -f $base_etc/tvshows_not_delete.txt $base_tmp/tvshows_delete.tmp > $base_tmp/tvshows_delete.final
while read line ; do
 rm -f "$line"
done < $base_tmp/tvshows_delete.final
