#!/bin/bash -xv

action="copy" #fallo filebot, aunque este en copy siempre renombra contenido del directorio
date_str="$(date +%Y%m%d-%H_%M_%S)"

#For directories
for d in $(find $rmc_base_hd_input/AUDIO/ -mindepth 1 -maxdepth 1 -type d ! -name tmp ) ; do 
 rm -rf $rmc_base_hd_input/AUDIO/tmp/*
 filebot.sh --log all --log-file $rmc_logs/audio_dir_rename_${date_str}.txt --action $action --output "$rmc_base_hd_input/AUDIO/tmp" -script fn:amc $d --conflict override -non-strict --def music=y "musicFormat={artist}/{album}/{artist}-{album}-{media.TrackPosition.pad(2)}-{t}"
 if [[ "$(grep -i "Failed to identify or process any files" $rmc_logs/audio_dir_rename_${date_str}.txt)" != "" ]] ; then
  mv $d $rmc_base_hd_audio/UNCATALOGED/
  #filebot.sh --log all --log-file $rmc_logs/audio_acoustid_${date_str}.txt -rename --output "$rmc_base_hd_audio/UNCATALOGED/" --db AcoustID "musicFormat={artist}/{artist}-{media.TrackPosition.pad(2)}-{t}" 
  #Arreglar bug filebot para albumArtist https://raw.githubusercontent.com/cowmix88/Filebot-Scripts/master/lib/acoustid.groovy
  #filebot.sh --log all --log-file $rmc_logs/audio_acoustid_${date_str}.txt -rename --output "$rmc_base_hd_audio/UNCATALOGED/" --db AcoustID "musicFormat={artist}/{albumArtist}/{artist}-{albumArtist}-{media.TrackPosition.pad(2)}-{t}" 
  rm -rf $rmc_base_hd_input/AUDIO_PROCESSED/$(basename $d)*
  [ ! -f "$d.*" ] && mv -v ${d} $rmc_base_hd_input/AUDIO_PROCESSED
  rm -rf ${d} ; mv -v ${d}.* $rmc_base_hd_input/AUDIO_PROCESSED
  exit 0
 fi
 # If directory created has only one subdirectory and no other content, then it's a one artist album, if not it's a compilation
 if [ "$(find "$rmc_base_hd_input/AUDIO/tmp/" -mindepth 1 -maxdepth 2 -type d -printf 1 | wc -m)" -eq 2 -a "$(find "$rmc_base_hd_input/AUDIO/tmp/" -maxdepth 1 ! -type d -printf 1 | wc -m)" -eq 0 ]; then
  cp -vrf $rmc_base_hd_input/AUDIO/tmp/* "$rmc_base_hd_audio/UNCATALOGED/"
  rm -rf $rmc_base_hd_input/AUDIO/tmp/*
 else
  #rm -rf $rmc_base_hd_input/AUDIO/tmp/*
  filebot.sh -script fn:revert --action move $rmc_base_hd_input/AUDIO/tmp/*
  rm -rf $rmc_base_hd_input/AUDIO/tmp/*
  filebot.sh --log all --log-file $rmc_logs/audio_dir_va_rename_${date_str}.txt --action $action --output "$rmc_base_hd_input/AUDIO/tmp/" -script fn:amc $d --conflict override -non-strict --def music=y "musicFormat={album}/{media.TrackPosition.pad(2)}-{artist}-{t}"
  #Si aun asi no se organiza se para de intentar ya que no parece un album corriente o un recopilatorio reconocido
  if [ "$(find "$rmc_base_hd_input/AUDIO/tmp/" -mindepth 1 -maxdepth 2 -type d -printf 1 | wc -m)" -eq 2 -a "$(find "$rmc_base_hd_input/AUDIO/tmp/" -maxdepth 1 ! -type d -printf 1 | wc -m)" -eq 0 ]; then
   cp -vrf $rmc_base_hd_input/AUDIO/tmp/* "$rmc_base_hd_audio/UNCATALOGED/"
   rm -rf $rmc_base_hd_input/AUDIO/tmp/*
  else
   filebot.sh -script fn:revert --action move $rmc_base_hd_input/AUDIO/tmp/*
   rm -rf $rmc_base_hd_input/AUDIO/tmp/*
   cp -vrf $d $rmc_base_hd_audio/UNCATALOGED/
  fi
 fi
 rm -rf $rmc_base_hd_input/AUDIO_PROCESSED/$(basename $d)*
 [ ! -f "$d.*" ] && mv -v ${d} $rmc_base_hd_input/AUDIO_PROCESSED
 rm -rf ${d} ; mv -v ${d}.* $rmc_base_hd_input/AUDIO_PROCESSED
done

#For regular files
for f in $(find $rmc_base_hd_input/AUDIO/ -mindepth 1 -maxdepth 1 -type f -name "*.mp3") ; do
 filebot.sh --log all --log-file $rmc_logs/audio_file_rename_${date_str}.txt --action $action --output "$rmc_base_hd_audio/UNCATALOGED/" -script fn:amc $f --conflict override -non-strict --def music=y "musicFormat={artist}-{album}-{media.TrackPosition.pad(2)}-{t}"
 [ -f "$d" ] && mv $f $rmc_base_hd_input/AUDIO_PROCESSED
done
