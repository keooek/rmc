#!/bin/bash -xv

sqlite3 ~/.kodi/userdata/Database/MyVideos93.db "select episode.c18 from episode, files where episode.idFile = files.idFile and files.playcount not null order by episode.c18;" > $rmc_base/tmp/tvshows_delete.tmp
grep "TVSHOWS-SP" $rmc_base/tmp/tvshows_delete.tmp | grep -i -v -f $rmc_base/etc/tvshows_sp_not_delete.txt > $rmc_base/tmp/tvshows_delete.final
grep "TVSHOWS-EN" $rmc_base/tmp/tvshows_delete.tmp | grep -i -v -f $rmc_base/etc/tvshows_en_not_delete.txt >> $rmc_base/tmp/tvshows_delete.final
while read line ; do
 rm -f "$line"
done < $rmc_base/tmp/tvshows_delete.final
