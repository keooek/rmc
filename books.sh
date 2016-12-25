#!/bin/bash -xv

#[ -e /home/pi/bin/media-center-config ] && . /home/pi/bin/media-center-config

base_books="/media/MULTIMEDIA/TORRENT/BOOKS"
IFS=$'\n'
date_str="$(date +%Y%m%d-%H_%M_%S)"
#for j in $(find $base_books -type f -mmin +10 -size -20M -name "*epub") ; do
 #xvfb-run ebook-convert "$j" "$base_books/$(basename "$j" .epub).mobi"
#done
for j in $(find $base_books -type f -mmin +10 -size -20M -name "*mobi") ; do
 mpack -s "$(basename $j)" "$j" abadie25_51@kindle.com > /home/pi/bin/log/mail_books_${date_str}.txt 2>&1
 echo "BOOK $(basename $j) added" | mail -s "BOOK $(basename $j)" casape.tv1@gmail.com
 mv "$j" "$base_books/../BOOKS_PROCESSED/$(basename $j)"
done
for j in $(find $base_books -type f -mmin +10 -size -20M -name "*epub") ; do
 mv "$j" "$base_books/../BOOKS_PROCESSED/$(basename $j)"
done
unset IFS

#mpack -s "Hombres Buenos - Arturo Perez-Reverte" "/media/MULTIMEDIA/TORRENT/BOOKS/Hombres Buenos - Arturo Perez-Reverte.mobi" abadie25_51@kindle.com
#ebook-convert Mi\ karma\ y\ yo\ -\ Marian\ Keyes.epub Mi\ karma\ y\ yo\ -\ Marian\ Keyes.mobi

