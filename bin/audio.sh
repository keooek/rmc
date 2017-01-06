#!/bin/bash -xv

action="copy"

#For directories
for d in $(find $rmc_base_hd_input/AUDIO/ -mindepth 1 -maxdepth 1 -type d ! -name tmp ) ; do 
 rm -rf $rmc_base_hd_input/AUDIO/tmp/*
 cd $rmc_base/sw/filebot ; filebot.sh --action $action --output "$rmc_base_hd_input/AUDIO/tmp" -script fn:amc $d --conflict override -non-strict --def music=y "musicFormat={artist}/{album}/{artist}-{album}-{media.TrackPosition.pad(2)}-{t}"
 # If directory created has only one subdirectory and no other content, then it's a one artist album, if not it's a compilation
 if [ "$(find "$rmc_base_hd_input/AUDIO/tmp/$(basename $d)" -maxdepth 1 -type d -printf 1 | wc -m)" -eq 2 -a "$(find "$rmc_base_hd_input/AUDIO/tmp/$(basename $d)" -maxdepth 1 ! -type d -printf 1 | wc -m)" -eq 0 ]; then
  mv $rmc_base_hd_input/AUDIO/tmp/* $rmc_base_hd_audio/UNCATALOGED
  mv ${d}* $rmc_base_hd_input/AUDIO_PROCESSED
 else
  rm -rf $rmc_base_hd_input/AUDIO/tmp/*
  cd $rmc_base/sw/filebot ; filebot.sh --action $action --output "$rmc_base_hd_audio/UNCATALOGED/" -script fn:amc $d --conflict override -non-strict --def music=y "musicFormat=/{album}/{media.TrackPosition.pad(2)}-{artist}-{t}"
 fi
 #[ -d "$d" ] && rm -rf $d
done

#For regular files
for f in $(find $rmc_base_hd_input/AUDIO/ -mindepth 1 -maxdepth 1 -type f -name "*.mp3") ; do
 cd $rmc_base/sw/filebot ; filebot.sh --action $action --output "$rmc_base_hd_audio/UNCATALOGED/" -script fn:amc $f --conflict override -non-strict --def music=y "musicFormat={artist}-{album}-{media.TrackPosition.pad(2)}-{t}"
 #[ -d "$d" ] && rm -rf $d
done

#Si es compilacion
#cd $rmc_base/sw/filebot ; filebot.sh --action test --output "$rmc_base_hd_audio/UNCATALOGED" -script fn:amc /media/MULTIMEDIA/RMC_INPUT/AUDIO/Indie_Bunch_11_\(2015\)_CD1_\(Various_Artists_Compilation\)_by_©SCA --conflict override -non-strict --def music=y "musicFormat=/{album}/{media.TrackPosition.pad(2)}-{artist}-{t}"

#./filebot.sh --log all --log-file out.log --db AcoustID -rename /media/MULTIMEDIA/TORRENT/MP3/Soulfly\ -\ Savages\ \(2013\)\ \[mp3@320\]/* --format "{n} - {y} - {id} - {music} - {t} - {d} - {pi} - {pn}"
#[MOVE] Rename [/media/MULTIMEDIA/TORRENT/MP3/Soulfly - Savages (2013) [mp3@320]/Soulfly - 2013 - - Soulfly - Ayatollah Of Rock 'N' Rolla - Ayatollah Of Rock 'N' Rolla - 2013-01-01 - 4 -.mp3] to [/media/MULTIMEDIA/TORRENT/MP3/Soulfly - Savages (2013) [mp3@320]/Soulfly - 2013 - 6207da94-d3a5-4b3f-be94-350135149487 - Soulfly - Ayatollah of Rock ‘n’ Rolla - Ayatollah of Rock ‘n’ Rolla - 2013-10-04 - 4 - 10.mp3]
