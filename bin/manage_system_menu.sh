#!/bin/bash

while true; do
 echo -e "Select: \n 1)Amule_Restart \n 2)Transmission_Restart \n 3)Kodi_Restart \n 4)Kodi_Stop \n 5)Kodi_Start \n 6)Init_0 \n 7)Init_6 \n 8)List automated tvshows spanish \n 9)List automated tvshows english \n a)Manage_tvshows.sh \n b)Manage_tvshows_not_delete.sh \n c)Wifi Scan \n d)Wifi connect \n g)AndReceiver start \n m)Local Menu \n q)quit \n s)Samba stop \n t)Samba start \n x)Logout "
 read n
 case $n in
    1) cd /home/pi/.aMule/;killall amuled;killall amuleweb;rm /home/pi/.aMule/{muleLock,statistics.dat};nohup /usr/bin/amuled & ;;
    2) killall transmission-daemon; /usr/bin/transmission-daemon -g $rmc_base/sw/transmission --log-debug -e $rmc_logs/transmission.log ;;
    3) killall kodi kodi_v7.bin ; sudo /etc/init.d/lightdm stop ; sudo /etc/init.d/lightdm start ;;
    4) killall kodi kodi_v7.bin ; mv /home/pi/.config/autostart/kodi.desktop /home/pi/.config/ ;sudo /etc/init.d/lightdm stop ; sudo /etc/init.d/lightdm start ;;
    5) mv /home/pi/.config/kodi.desktop /home/pi/.config/autostart/kodi.desktop ; sudo /etc/init.d/lightdm stop ; sudo /etc/init.d/lightdm start ;;
    6) sudo init 0;;
    7) sudo init 6;;
    8) grep "    - " $rmc_base/sw/flexget/tvshows_spanish.yml ;;
    9) grep "    - " $rmc_base/sw/flexget/tvshows_english.yml ;;
    a) echo "select action 1) Add 2) Remove"; read a; case $a in 1) action="Add";; 2) action="Remove";; esac
       echo "select language 1) English 2) Spanish"; read l; case $l in 1) language="English";; 2) language="Spanish";; esac
       echo "Enter TvShow: "; read tvshow
       $rmc_base/bin/manage_tvshows.sh $action $language $tvshow;;
    b) echo "select action 1) Add 2) Remove"; read a; case $a in 1) action="Add";; 2) action="Remove";; esac
       echo "select language 1) English 2) Spanish"; read l; case $l in 1) language="English";; 2) language="Spanish";; esac
       echo "Enter TvShow: "; read tvshow
       $rmc_base/bin/manage_tvshows_not_delete.sh $action $language $tvshow;;
    c) sudo iwlist wlan0 scan |grep ESSID ;;
    d) echo ;;
    g) /opt/andReceiver/start-andReceiver.sh ;;
    m) /home/pi/bin/local_system_menu.sh;;
    q) exit;;
    s) sudo /etc/init.d/samba stop;;
    t) sudo /etc/init.d/samba start;;
    x) pkill -9 -t $(echo $SSH_TTY|cut -d/ -f3,4);;
    *) invalid option;;
 esac
done

