#!/bin/bash

while true; do
 echo -e "Select: \n 1)Amule_Restart \n 2)Qbittorrent_Restart \n 3)Transmission_Restart \n 4)Kodi_Restart \n 5)Kodi_Stop \n 6)Kodi_Start \n 8)Init_0 \n 9)Init_6 \n b)List automated tvshows spanish \n c)List automated tvshows english \n d)Manage_tvshows.sh \n e)Manage_tvshows_not_delete.sh \n q)quit"
 read n
 case $n in
    1) cd /home/pi/.aMule/;killall amuled;killall amuleweb;rm /home/pi/.aMule/{muleLock,statistics.dat};nohup /usr/bin/amuled & ;;
    3) killall transmission-daemon; /usr/bin/transmission-daemon -g $rmc_base/sw/transmission --log-debug -e $rmc_logs/transmission.log ;;
    4) killall kodi kodi.bin ; sudo /etc/init.d/lightdm stop ; sudo /etc/init.d/lightdm start ;;
    5) killall kodi kodi.bin ; mv /home/pi/.config/autostart/kodi.desktop /home/pi/.config/ ;sudo /etc/init.d/lightdm stop ; sudo /etc/init.d/lightdm start ;;
    6) mv /home/pi/.config/kodi.desktop /home/pi/.config/autostart/kodi.desktop ; sudo /etc/init.d/lightdm stop ; sudo /etc/init.d/lightdm start ;;
    8) sudo init 0;;
    9) sudo init 6;;
    b) grep "    - " $rmc_base/sw/flexget/tvshows_spanish.yml ;;
    c) grep "    - " $rmc_base/sw/flexget/tvshows_english.yml ;;
    d) echo "select action 1) Add 2) Remove"; read a; case $a in 1) action="Add";; 2) action="Remove";; esac
       echo "select language 1) English 2) Spanish"; read l; case $l in 1) language="English";; 2) language="Spanish";; esac
       echo "Enter TvShow: "; read tvshow
       $rmc_base/bin/manage_tvshows.sh $action $language $tvshow;;
    e) echo "select action 1) Add 2) Remove"; read a; case $a in 1) action="Add";; 2) action="Remove";; esac
       echo "select language 1) English 2) Spanish"; read l; case $l in 1) language="English";; 2) language="Spanish";; esac
       echo "Enter TvShow: "; read tvshow
       $rmc_base/bin/manage_tvshows_not_delete.sh $action $language $tvshow;;
    q) exit;;
    *) invalid option;;
 esac
done

