#!/bin/bash

cd $rmc_base/bin

while true; do

 # find pid
 var=$(/usr/bin/pgrep -c amuled)

 if [ $? -ne 0 ] # if not running
 then
  echo "$(date): Reinicio amule" > $rmc_logs/forever_amuled_$(date +%Y%m%d-%H_%M_%S).txt 2>&1
  cd /home/pi/.aMule/
  wget http://upd.emule-security.org/nodes.dat
  wget http://upd.emule-security.org/server.met
  killall amuled
  killall amuleweb
  rm /home/pi/.aMule/{muleLock,statistics.dat}
  nohup /usr/bin/amuled &
 fi

 sleep 60

 # find pid
 var=$(/usr/bin/pgrep -c amuleweb)

 if [ $? -ne 0 ] # if not running
 then
  echo "$(date): Reinicio amule" > $rmc_logs/forever_amuleweb_$(date +%Y%m%d-%H_%M_%S).txt 2>&1
  cd /home/pi/.aMule/
  #killall amuled
  killall amuleweb
  #rm /home/pi/.aMule/{muleLock,statistics.dat}
  nohup amuleweb --amule-config-file=/home/pi/.aMule/amule.conf &
 fi

done
