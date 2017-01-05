#!/bin/bash -xv

for d in $(find $rmc_base_hd_input/AUDIO/ -mindepth 1 -maxdepth 1 -type d) ; do 
 cd $rmc_base/sw/filebot ; filebot.sh --action test --output "$rmc_base_hd_audio/UNCATALOGED" -script fn:amc $d --conflict override -non-strict --def music=y "musicFormat={artist}/{album}/{artist}-{album}-{pi}-{t}"
 #[ -d "$d" ] && rm -rf $d
done
for f in $(find $rmc_base_hd_input/AUDIO/ -mindepth 1 -maxdepth 1 -type f -name "*.mp3") ; do
 cd $rmc_base/sw/filebot ; filebot.sh --action test --output "$rmc_base_hd_audio/UNCATALOGED" -script fn:amc $f --conflict override -non-strict --def music=y "musicFormat={artist}-{album}-{pi}-{t}"
 #[ -d "$d" ] && rm -rf $d
done


#./filebot.sh --log all --log-file out.log --db AcoustID -rename /media/MULTIMEDIA/TORRENT/MP3/Soulfly\ -\ Savages\ \(2013\)\ \[mp3@320\]/* --format "{n} - {y} - {id} - {music} - {t} - {d} - {pi} - {pn}"
#[MOVE] Rename [/media/MULTIMEDIA/TORRENT/MP3/Soulfly - Savages (2013) [mp3@320]/Soulfly - 2013 - - Soulfly - Ayatollah Of Rock 'N' Rolla - Ayatollah Of Rock 'N' Rolla - 2013-01-01 - 4 -.mp3] to [/media/MULTIMEDIA/TORRENT/MP3/Soulfly - Savages (2013) [mp3@320]/Soulfly - 2013 - 6207da94-d3a5-4b3f-be94-350135149487 - Soulfly - Ayatollah of Rock ‘n’ Rolla - Ayatollah of Rock ‘n’ Rolla - 2013-10-04 - 4 - 10.mp3]
#./filebot.sh -script fn:amc /media/MULTIMEDIA/TORRENT/MP3/Soulfly\ -\ Savages\ \(2013\)\ \[mp3@320\]/Soulfly/Soulfly/Soulfly/ --conflict override -non-strict --def music=y "musicFormat={albumartist}/{album}/{t}"
