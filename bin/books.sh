#!/bin/bash -xv

cd $base

IFS=$'\n'
date_str="$(date +%Y%m%d-%H_%M_%S)"
for j in $(find $base_books -type f -mmin +10 -size -20M -name "*epub") ; do
 xvfb-run ebook-convert "$j" "$base_books/$(basename "$j" .epub).mobi"
done
for j in $(find $base_books -type f -mmin +10 -size -20M -name "*mobi") ; do
 mpack -s "$(basename $j)" "$j" $kindle_mail > $logs/mail_books_${date_str}.txt 2>&1
 echo "BOOK $(basename $j) added" | mail -s "BOOK $(basename $j)" $notify_mail
 mv "$j" "$base_books/../BOOKS_PROCESSED/$(basename $j)"
done
for j in $(find $base_books -type f -mmin +10 -size -20M -name "*epub") ; do
 mv "$j" "$base_books/../BOOKS_PROCESSED/$(basename $j)"
done
unset IFS

#mpack -s "Hombres Buenos - Arturo Perez-Reverte" "$base_hd_input/BOOKS/Hombres Buenos - Arturo Perez-Reverte.mobi" $kindle_mail
#ebook-convert Mi\ karma\ y\ yo\ -\ Marian\ Keyes.epub Mi\ karma\ y\ yo\ -\ Marian\ Keyes.mobi

