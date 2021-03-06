#!/bin/bash -xv

if [[ "$3" == "" ]] ; then
 echo "Please, select all parameters"
 exit 1
fi

action=$1
language=$2
shift 2
tvshow=$*
file_en="$rmc_base/etc/tvshows_en_not_delete.txt"
file_sp="$rmc_base/etc/tvshows_sp_not_delete.txt"

echo $action $language $tvshow
 
if [[ $action == "Add" && $language == "English" && "$(grep -i "$tvshow" $file_en)" == "" ]] ; then
 echo "$tvshow" >> $file_en
 cat $file_en
elif [[ $action == "Remove" && $language == "English" && "$(grep -i "$tvshow" $file_en)" != "" ]] ; then
 cp $file_en ${file_en}.bak
 grep -iv "$tvshow" ${file_en}.bak > $file_en
 cat $file_en
elif [[ $action == "Add" && $language == "Spanish" && "$(grep -i "$tvshow" $file_sp)" == "" ]] ; then
 echo "$tvshow" >> $file_sp
 cat $file_sp
elif [[ $action == "Remove" && $language == "Spanish" && "$(grep -i "$tvshow" $file_sp)" != "" ]] ; then
 cp $file_sp ${file_sp}.bak
 grep -iv "$tvshow" ${file_sp}.bak > $file_sp
 cat $file_sp
fi

scp $file_en pi@192.168.1.5:$file_en
scp $file_sp pi@192.168.1.5:$file_sp
