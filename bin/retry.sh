#!/bin/bash -xv
#Reorg downloaded mixed torrents in ALL y AMULE folder
#MP3
find $base_hd_input/SKIPPED -maxdepth 1 -regex '.*\(MP3\|mp3\).*' -exec mv {} $base_hd_input/MP3 \;
#PS3
find $base_hd_input/SKIPPED -maxdepth 1 -regex '.*\(PS3\|ps3\).*' -exec mv {} $base_hd_input/PS3 \;
#TVShows EN
find $base_hd_input/SKIPPED -maxdepth 1 -regex '.*S[0-3][0-9]E[0-3][0-9].*' -exec mv {} $base_hd_input/TVSHOWS-EN \;
#TVShows SP
find $base_hd_input/SKIPPED -maxdepth 1 -regex '.*[0-2]?[0-9]x[0-2][0-9].*' -exec mv {} $base_hd_input/TVSHOWS-SP \;
find $base_hd_input/SKIPPED -maxdepth 1 -regex '.*[^0-9][0-9]x?[0-2][0-9][^0-9].*' -exec mv {} $base_hd_input/TVSHOWS-SP \;
#Movies ES
find $base_hd_input/SKIPPED -maxdepth 1 -regex '.*\(panish\|astellano\|spa.ol\|PANISH\|ASTELLANO\|SPA.OL\).*' -exec mv {} $base_hd_input/MOVIES-SP \;
#Movies EN
find $base_hd_input/SKIPPED -maxdepth 1 -regex '.*\(1080p\|720p\).*' -exec mv {} $base_hd_input/MOVIES-EN \;

#Purgar el lock por si se queda pillado
rm -f /home/pi/.flexget/.config-lock

exit 0
