#!/bin/bash -xv
#Reorg downloaded mixed torrents in ALL y AMULE folder
#MP3
find /media/MULTIMEDIA/TORRENT/SKIPPED -maxdepth 1 -regex '.*\(MP3\|mp3\).*' -exec mv {} /media/MULTIMEDIA/TORRENT/MP3 \;
#PS3
find /media/MULTIMEDIA/TORRENT/SKIPPED -maxdepth 1 -regex '.*\(PS3\|ps3\).*' -exec mv {} /media/MULTIMEDIA/TORRENT/PS3 \;
#TVShows EN
find /media/MULTIMEDIA/TORRENT/SKIPPED -maxdepth 1 -regex '.*S[0-3][0-9]E[0-3][0-9].*' -exec mv {} /media/MULTIMEDIA/TORRENT/TVSHOWS-EN \;
#TVShows SP
find /media/MULTIMEDIA/TORRENT/SKIPPED -maxdepth 1 -regex '.*[0-2]?[0-9]x[0-2][0-9].*' -exec mv {} /media/MULTIMEDIA/TORRENT/TVSHOWS-SP \;
find /media/MULTIMEDIA/TORRENT/SKIPPED -maxdepth 1 -regex '.*[^0-9][0-9]x?[0-2][0-9][^0-9].*' -exec mv {} /media/MULTIMEDIA/TORRENT/TVSHOWS-SP \;
#Movies ES
find /media/MULTIMEDIA/TORRENT/SKIPPED -maxdepth 1 -regex '.*\(panish\|astellano\|spa.ol\|PANISH\|ASTELLANO\|SPA.OL\).*' -exec mv {} /media/MULTIMEDIA/TORRENT/MOVIES-SP \;
#Movies EN
find /media/MULTIMEDIA/TORRENT/SKIPPED -maxdepth 1 -regex '.*\(1080p\|720p\).*' -exec mv {} /media/MULTIMEDIA/TORRENT/MOVIES-EN \;

#Purgar el lock por si se queda pillado
rm -f /home/pi/.flexget/.config-lock

exit 0
