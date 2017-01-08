#!/bin/bash -xv

action="copy"

#For directories
for d in $(find $rmc_base_hd_input/AUDIO/ -mindepth 1 -maxdepth 1 -type d ! -name tmp ) ; do 
 rm -rf $rmc_base_hd_input/AUDIO/tmp/*
 filebot.sh --log all --log-file $rmc_logs/audio_dir_rename_${date_str}.txt --action $action --output "$rmc_base_hd_input/AUDIO/tmp" -script fn:amc $d --conflict override -non-strict --def music=y "musicFormat={artist}/{album}/{artist}-{album}-{media.TrackPosition.pad(2)}-{t}"
 # If directory created has only one subdirectory and no other content, then it's a one artist album, if not it's a compilation
 if [ "$(find "$rmc_base_hd_input/AUDIO/tmp/" -maxdepth 1 -type d -printf 1 | wc -m)" -eq 2 -a "$(find "$rmc_base_hd_input/AUDIO/tmp/" -maxdepth 1 ! -type d -printf 1 | wc -m)" -eq 0 ]; then
  mv $rmc_base_hd_input/AUDIO/tmp/* $rmc_base_hd_audio/UNCATALOGED
 else
  rm -rf $rmc_base_hd_input/AUDIO/tmp/*
  filebot.sh --log all --log-file $rmc_logs/audio_dir_va_rename_${date_str}.txt --action $action --output "$rmc_base_hd_audio/UNCATALOGED/" -script fn:amc $d --conflict override -non-strict --def music=y "musicFormat={album}/{media.TrackPosition.pad(2)}-{artist}-{t}"
 fi
 mv ${d}* $rmc_base_hd_input/AUDIO_PROCESSED
 #[ -d "$d" ] && rm -rf $d
done

#For regular files
for f in $(find $rmc_base_hd_input/AUDIO/ -mindepth 1 -maxdepth 1 -type f -name "*.mp3") ; do
 filebot.sh --log all --log-file $rmc_logs/audio_file_rename_${date_str}.txt --action $action --output "$rmc_base_hd_audio/UNCATALOGED/" -script fn:amc $f --conflict override -non-strict --def music=y "musicFormat={artist}-{album}-{media.TrackPosition.pad(2)}-{t}"
 mv $f $rmc_base_hd_input/AUDIO_PROCESSED
 #[ -d "$d" ] && rm -rf $d
done

